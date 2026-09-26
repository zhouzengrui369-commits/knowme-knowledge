import { common } from '@kit.AbilityKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { MicState, SpeakerState } from '../core/VoiceCore';
import { SessionPurpose, VoiceSessionController } from '../voice/VoiceSessionController';
import { SpeakerVerificationController, UnprovisionedSpeakerEngine } from '../voice/SpeakerVerificationController';
import { SherpaSpeakerEngine } from '../engine/SherpaSpeakerEngine';
import { AudioCaptureController } from '../voice/AudioCaptureController';
import { AgentContext, AgentMessage } from '../agent/AgentContext';
import { AgentContextStore } from '../agent/AgentContextStore';
import {
  CaptureItem, CaptureKind, TransferStatus, ProcessingStatus,
  newCaptureId, localIsoWithOffset, deviceTimezone,
  authorizeDraft, enqueue, makeCorrection, statusLabel
} from '../capture/CaptureCore';
import { CaptureStore } from '../capture/CaptureStore';
import { WavWriter } from '../capture/WavWriter';
import { LingxiBridgeClient } from '../bridge/LingxiBridgeClient';
import { SyncController } from '../bridge/SyncController';

/**
 * GOAL-KK-04 灵犀移动采集设备产品面。
 *
 * 产品定位（baseline v3，冻结）：手机是灵犀工作台的智能采集设备。
 * 首屏三区：①采集（文本/录音，先本地可靠保存）②采集箱（未同步与未整理
 * 状态分明，显式「交给灵犀」）③灵犀结果（工作台真实整理产物，同一
 * note_id，原始来源两次导航内可达）。声纹保留为可选来源识别（折叠），
 * 不作为采集/上传前置门槛；诊断与 TEST_FIXTURE 工具折叠次要。
 */
@Entry
@Component
struct Index {
  // ── 既有能力：权限/声纹（折叠区） ──
  @State session: VoiceSessionController =
    new VoiceSessionController(new SpeakerVerificationController(new UnprovisionedSpeakerEngine()));
  private sherpaEngine: SherpaSpeakerEngine = new SherpaSpeakerEngine();
  @State micState: string = MicState.IDLE;
  @State speakerState: string = SpeakerState.NOT_ENROLLED;
  @State engineInitText: string = '声纹引擎初始化中…';
  @State enrollmentText: string = '';
  @State showVoiceIdentity: boolean = false;
  @State showDiagnostics: boolean = false;

  // ── Agent 消息（操作反馈与历史分开呈现） ──
  @State agent: AgentContext = new AgentContext();
  private agentStore: AgentContextStore = new AgentContextStore();
  @State visibleMessages: AgentMessage[] = [];

  // ── KK-04 采集箱 ──
  private captureStore: CaptureStore = new CaptureStore();
  private bridge: LingxiBridgeClient = new LingxiBridgeClient();
  private syncCtl: SyncController = new SyncController(this.captureStore, this.bridge);
  private boxRecorder: AudioCaptureController = new AudioCaptureController();
  @State captureList: CaptureItem[] = [];
  @State textDraft: string = '';
  @State correctionOfId: string = '';
  @State recordingBox: boolean = false;
  @State boxElapsedSec: number = 0;
  private boxTimer: number = -1;
  private boxStartedAt: number = 0;
  private syncTimer: number = -1;

  // ── 连接工作台 ──
  @State connectUrl: string = '';
  @State connectState: string = '未连接';
  @State capsText: string = '';
  @State showConnect: boolean = true;
  @State deviceIdText: string = '';

  // ── 结果查看 ──
  @State resultFor: string = '';
  @State resultTitle: string = '';
  @State resultBody: string = '';
  @State provenanceFor: string = '';
  @State provenanceText: string = '';
  /** PX-KK04-02：每条采集「交给灵犀」的 in-flight guard。
   *  提交中的 captureId 置位期间，该条按钮禁用，防止连点在异步间隙二次入队。 */
  @State submittingId: string = '';
  /** PX-KK04-01：连接状态机上一次实测是否在线（用于「不可达」与「已连接」的真实区分）。 */
  @State connReachable: boolean = false;
  /** PX-KK04-01：来源面板当前展示内容对应的 revision。
   *  若与条目最新 revision 不一致，面板顶部明示「已过期，请刷新」，不继续把旧 revision 当当前事实。 */
  @State provenanceRev: number = 0;

  aboutToAppear(): void {
    this.agentStore.init(this.uiContext());
    const snap = this.agentStore.load();
    if (snap !== null && (snap.knowledge.length > 0 || snap.messages.length > 0)) {
      this.agent.restore(snap);
    } else {
      this.agent.ensureIntro();
    }
    this.agent.onChanged = () => {
      this.agentStore.save(this.agent);
    };

    this.captureStore.init(this.uiContext());
    this.syncCtl.setListener({ onChange: () => this.mirrorCaptures() });
    this.syncCtl.watchNetwork();
    this.session.speaker.initStorage(this.uiContext());
    this.session.onEvent(() => {
      this.refreshVoice();
    });
    this.session.refreshPermission();

    const sess = this.captureStore.loadSession();
    if (sess !== null && sess.token.length > 0) {
      this.connectUrl = sess.baseUrl;
      this.bridge.configure(sess.baseUrl, sess.deviceId, sess.token);
      this.bridgeConfigured = true;
      this.deviceIdText = sess.deviceId;
      // PX-KK04-01：冷启动只凭本地会话**不得**直接显示「已连接」。先置「待校验」，
      // 实测探活成功才转「已连接」；失败转「不可达」并给恢复动作，不伪造在线状态。
      this.connectState = '连接待校验…';
      this.showConnect = false;
      this.probeConnection();
    }

    this.mirrorCaptures();
    this.refreshVoice();
    this.syncTimer = setInterval(() => {
      this.syncCtl.tick();
      // PX-KK04-01：能力表面（含插件启停）不是启动一次性结果，周期实测补回，
      // 插件后台被停用时 UI 不再停在先前的「真能力」文案上。
      this.probeConnection();
    }, 5000);

    this.sherpaEngine.init(this.uiContext()).then((ok: boolean) => {
      if (ok) {
        this.session.speaker.setEngine(this.sherpaEngine);
        this.engineInitText = '声纹引擎就绪（本地 sherpa-onnx，可选能力）';
      } else {
        this.engineInitText = `声纹引擎不可用（可选能力，不影响采集）：${this.sherpaEngine.engineIdentity()}`;
      }
      this.refreshVoice();
    });
  }

  aboutToDisappear(): void {
    this.stopBoxTimer();
    if (this.syncTimer >= 0) {
      clearInterval(this.syncTimer);
      this.syncTimer = -1;
    }
  }

  onPageShow(): void {
    this.session.refreshPermission();
    this.refreshVoice();
  }

  private uiContext(): common.UIAbilityContext {
    return this.getUIContext().getHostContext() as common.UIAbilityContext;
  }

  private refreshVoice(): void {
    this.micState = this.session.micState;
    this.speakerState = this.session.speakerState;
  }

  private mirrorCaptures(): void {
    this.captureList = this.captureStore.listLatest();
    this.visibleMessages = this.agent.messages.slice(-5);
  }

  /**
   * D-KK04-06（本轮 ED 实操发现）：ForEach 行键必须同时满足两个硬约束——
   *  PX-KK04-02：对象身份稳定，列表顺序由 listLatest() 的稳定 capturedAt 排序保证，
   *              行位置不随同步/整理回写跳动，连点不会落到错的对象上；
   *  PX-KK04-01：状态必须真实刷新。ArkUI ForEach 对「键不变」的行复用旧子树，
   *              若键只含 captureId，后台同步把 DRAFT→RECEIVED→COMPLETED 写进 store 后
   *              行仍以旧 item 渲染（实测：磁盘 index.json 已 COMPLETED，UI 仍显示
   *              「草稿（未提交）/灵犀整理中」）。
   * 因此键 = 对象身份 + revision + 全部会被行内展示的瞬时状态；updatedAt 刻意不入键，
   * 纯时间戳变化的轮询不触发行重建。行重建只发生在展示内容真实变化时，且因排序稳定
   * 重建发生在原位，不会引起跳位。
   */
  private captureRowKey(item: CaptureItem): string {
    const note = item.noteId.length > 0 ? '1' : '0';
    const err = item.error.length > 0 ? '1' : '0';
    return `${item.captureId}-r${item.payloadRevision}-${item.transfer}-${item.processing}-n${note}-e${err}-q${item.qualityLevel ?? ''}`;
  }

  /** J09 保护：每条反馈带时间；非本次启动产生的消息显式标「历史」，不被误读为当前指令。 */
  private launchAt: number = Date.now();

  private formatMsg(msg: AgentMessage, idx: number): string {
    const d = new Date(msg.at);
    const hh = d.getHours().toString().padStart(2, '0');
    const mm = d.getMinutes().toString().padStart(2, '0');
    const tag = msg.at < this.launchAt ? '历史' : (idx === this.visibleMessages.length - 1 ? '当前' : '早前');
    return `[${hh}:${mm}·${tag}] ${msg.text}`;
  }

  private say(text: string): void {
    this.agent.say('system', text, false);
    this.mirrorCaptures();
  }

  // ── 连接（J01） ──────────────────────────────────────────────────────
  private async connectNow(): Promise<void> {
    const url = this.connectUrl.trim();
    if (url.length === 0) {
      this.connectState = '请先填写工作台地址';
      return;
    }
    this.connectState = '连接中…';
    const instanceId = `sim-${this.uiContext().applicationInfo.name}`;
    const r = await this.bridge.register(url, 'Mate60-模拟器', instanceId, '0.4.0-kk04');
    if (!r.ok) {
      this.connectState = `连接失败：${r.error || `HTTP ${r.status}`}`;
      return;
    }
    try {
      const body = JSON.parse(r.body) as Record<string, Object>;
      const token = String(body['device_token'] ?? '');
      const deviceId = String(body['device_id'] ?? '');
      this.bridge.configure(url, deviceId, token);
      this.bridgeConfigured = true;
      this.captureStore.saveSession(url, deviceId, token);
      this.deviceIdText = deviceId;
      this.connectState = '已连接';
      this.say('已连接灵犀工作台（隔离实例），可以开始采集并「交给灵犀」。');
      await this.refreshCapabilities();
      this.showConnect = false;
      this.syncCtl.kick();
    } catch (e) {
      this.connectState = `连接响应异常：${JSON.stringify(e)}`;
    }
  }

  /**
   * PX-KK04-01：实测探活 + 能力表面刷新（状态真实性的唯一来源）。
   *  每次真实探一次工作台；只在拿到服务端响应后才显示「已连接」，
   *  网络层失败显示「不可达」并保留恢复动作，凭证失效显示「凭证失效」。
   *  绝不凭本地会话或上一次缓存伪造在线状态。
   */
  private async probeConnection(): Promise<void> {
    if (!this.bridge.configured) {
      return;
    }
    const r = await this.bridge.capabilities();
    if (r.status === 0) {
      // 网络层失败：服务不可达
      this.connReachable = false;
      if (!this.connectState.includes('连接中') && !this.connectState.includes('失败')) {
        this.connectState = '不可达（点「设置」检查地址/服务后重试）';
      }
      this.capsText = this.capsText ? `${this.capsText}（最近一次探活失败，能力表面可能已过期）` : this.capsText;
      return;
    }
    this.connReachable = true;
    if (r.ok) {
      try {
        const c = JSON.parse(r.body) as Record<string, Object>;
        const asr = c['asr'] as Record<string, Object>;
        const org = c['organizer'] as Record<string, Object>;
        const plg = c['plugin'] as Record<string, Object>;
        const status = String(plg['status'] ?? '');
        this.capsText = `插件 ${plg['version']}（${status}）· ASR ${asr['engine']}/${asr['model']}` +
          ` · 整理 ${org['skill']} · 隔离环境不外发`;
        if (status !== 'enabled') {
          this.connectState = `已连接 · 插件已停用（到工作台启用后自动恢复）`;
        } else if (!this.connectState.includes('已连接') || this.connectState.includes('停用')) {
          this.connectState = '已连接';
        }
      } catch (e) {
        this.capsText = '能力查询成功（解析从略）';
        if (!this.connectState.includes('已连接')) {
          this.connectState = '已连接';
        }
      }
    } else if (r.status === 401) {
      this.connectState = '凭证失效，请重新连接';
      this.showConnect = true;
    }
  }

  private async refreshCapabilities(): Promise<void> {
    await this.probeConnection();
  }

  private async revokeNow(): Promise<void> {
    const r = await this.bridge.revoke();
    if (r.ok) {
      this.say('设备凭证已撤销：此后不能再上传或读取，重新连接才会签发新凭证。');
    }
    this.captureStore.clearSession();
    this.bridge.configure('', '', '');
    this.bridgeConfigured = false;
    this.connectState = '已撤销（未连接）';
    this.deviceIdText = '';
    this.capsText = '';
  }

  // ── 采集（J02/J03/J04） ──────────────────────────────────────────────
  private saveTextDraft(): void {
    const text = this.textDraft.trim();
    if (text.length === 0) {
      return;
    }
    const now = new Date();
    let item: CaptureItem;
    if (this.correctionOfId.length > 0) {
      const src = this.captureStore.get(this.correctionOfId);
      if (src !== null) {
        item = makeCorrection(src, text, now);
        item.contentHash = `sha256:${WavWriter.sha256Text(text)}`;
        this.say(`已生成「${src.titleHint || src.captureId}」的修正版（revision ${item.payloadRevision}），原文保持不变。`);
      } else {
        return;
      }
    } else {
      item = {
        captureId: newCaptureId(), payloadRevision: 1, kind: CaptureKind.TEXT,
        capturedAt: localIsoWithOffset(now), capturedTimezone: deviceTimezone(),
        titleHint: '', text: text,
        assetFile: '', assetSha256: '', assetSize: 0, assetDurationMs: 0,
        contentHash: `sha256:${WavWriter.sha256Text(text)}`,
        transfer: TransferStatus.DRAFT, processing: ProcessingStatus.NONE,
        taskId: '', noteId: '', noteRevision: 0,
        intent: 'note', correctionOf: '', contextRef: '',
        error: '', recoveryAction: '', attempts: 0, updatedAt: now.getTime()
      };
      this.say('已保存到采集箱（草稿，未提交）。点「交给灵犀」才会上传整理。');
    }
    this.captureStore.save(item);
    this.textDraft = '';
    this.correctionOfId = '';
    this.mirrorCaptures();
  }

  private async startBoxRecording(): Promise<void> {
    if (!this.session.permission.isGranted()) {
      await this.session.requestPermission(this.uiContext());
      this.refreshVoice();
      if (!this.session.permission.isGranted()) {
        this.say('麦克风权限未授予，无法录音；可以先用文字采集，不丢内容。');
        return;
      }
    }
    const ok = await this.boxRecorder.start();
    if (ok) {
      this.recordingBox = true;
      this.boxStartedAt = Date.now();
      this.boxElapsedSec = 0;
      this.boxTimer = setInterval(() => {
        this.boxElapsedSec = Math.floor((Date.now() - this.boxStartedAt) / 1000);
      }, 500);
    }
  }

  private async stopBoxRecording(): Promise<void> {
    this.stopBoxTimer();
    const pcm = await this.boxRecorder.stop();
    this.recordingBox = false;
    if (pcm.length === 0) {
      this.say('没有录到声音，未保存。');
      return;
    }
    const now = new Date();
    const cid = newCaptureId();
    const wav = WavWriter.wrap(pcm, 16000);
    const sha = WavWriter.sha256Hex(wav);
    const filename = `${cid}.wav`;
    const abs = `${this.captureStore.assetDirFor(cid, 1)}/${filename}`;
    try {
      WavWriter.writeFile(abs, wav);
    } catch (e) {
      this.say(`录音保存失败：${JSON.stringify(e)}`);
      return;
    }
    const item: CaptureItem = {
      captureId: cid, payloadRevision: 1, kind: CaptureKind.AUDIO,
      capturedAt: localIsoWithOffset(now), capturedTimezone: deviceTimezone(),
      titleHint: '', text: '',
      assetFile: filename, assetSha256: sha, assetSize: wav.length,
      assetDurationMs: Math.round(pcm.length / 32),
      contentHash: `sha256:${sha}`,
      transfer: TransferStatus.DRAFT, processing: ProcessingStatus.NONE,
      taskId: '', noteId: '', noteRevision: 0,
      intent: 'note', correctionOf: '', contextRef: '',
      error: '', recoveryAction: '', attempts: 0, updatedAt: now.getTime()
    };
    this.captureStore.save(item);
    this.say(`录音已保存到采集箱（${Math.round(pcm.length / 32000)} 秒，草稿未提交）。点「交给灵犀」上传工作台做真实转写与整理。`);
    this.mirrorCaptures();
  }

  private async cancelBoxRecording(): Promise<void> {
    this.stopBoxTimer();
    await this.boxRecorder.cancel();
    this.recordingBox = false;
    this.say('已取消录音，内容已丢弃。');
  }

  /**
   * J03/J07 受控替代：模拟器无真实麦克风（实测峰值为噪底）。
   * 从已连接的隔离工作台下载合成朗读 wav 入采集箱；内容与来源诚实标注，
   * ASR 与整理仍为真实链路。markYesterday=true 模拟「昨日采集今日上传」
   * 迟到场景（用户显式声明捕获时间，不修改系统时间）。
   */
  @State importingAudio: boolean = false;
  /** D-KK04-04：bridge.configured 是普通属性不参与状态驱动，撤销/重连后按钮态不刷新；
   *  用显式 @State 镜像，所有 configure 调用点同步维护。 */
  @State bridgeConfigured: boolean = false;

  private async importDemoAudio(markYesterday: boolean, demoName: string = 'kk04_reading_30s'): Promise<void> {
    if (this.importingAudio) {
      return;
    }
    this.importingAudio = true;
    try {
      const cid = newCaptureId();
      const filename = `${cid}.wav`;
      const dir = this.captureStore.assetDirFor(cid, 1);
      fs.mkdirSync(dir, true);
      const abs = `${dir}/${filename}`;
      const dl = await this.bridge.downloadDemoAudio(demoName, abs);
      if (!dl.ok) {
        this.say(`演示音频下载失败：${dl.error}`);
        return;
      }
      const fd = fs.openSync(abs, fs.OpenMode.READ_ONLY);
      const buf = new ArrayBuffer(dl.size);
      fs.readSync(fd.fd, buf);
      fs.closeSync(fd);
      const bytes = new Uint8Array(buf);
      const sha = WavWriter.sha256Hex(bytes);
      const durationMs = Math.round((dl.size - 44) / 32); // 16kHz/16bit/mono
      const captured = new Date();
      if (markYesterday) {
        captured.setDate(captured.getDate() - 1);
        captured.setHours(21, 0, 0, 0);
      }
      const now = new Date();
      const item: CaptureItem = {
        captureId: cid, payloadRevision: 1, kind: CaptureKind.AUDIO,
        capturedAt: localIsoWithOffset(captured), capturedTimezone: deviceTimezone(),
        titleHint: `导入演示音频(合成朗读${demoName.includes('5min') ? '·5分钟' : ''}${markYesterday ? '·昨日捕获' : ''})`, text: '',
        assetFile: filename, assetSha256: sha, assetSize: dl.size,
        assetDurationMs: durationMs,
        contentHash: `sha256:${sha}`,
        transfer: TransferStatus.DRAFT, processing: ProcessingStatus.NONE,
        taskId: '', noteId: '', noteRevision: 0,
        intent: 'note', correctionOf: '', contextRef: '',
        error: '', recoveryAction: '', attempts: 0, updatedAt: now.getTime()
      };
      this.captureStore.save(item);
      this.say(`演示音频已入采集箱（${Math.round(durationMs / 1000)} 秒，合成朗读，草稿未提交）` +
        `${markYesterday ? '，捕获时间显式标记为昨日 21:00（迟到采集场景）' : ''}。点「交给灵犀」走真实 ASR 与整理。`);
      this.mirrorCaptures();
    } finally {
      this.importingAudio = false;
    }
  }

  private stopBoxTimer(): void {
    if (this.boxTimer >= 0) {
      clearInterval(this.boxTimer);
      this.boxTimer = -1;
    }
  }

  private boxClock(): string {
    const mm = Math.floor(this.boxElapsedSec / 60).toString().padStart(2, '0');
    const ss = (this.boxElapsedSec % 60).toString().padStart(2, '0');
    return `${mm}:${ss}`;
  }

  // ── 采集箱动作 ────────────────────────────────────────────────────────
  private async handToLingxi(item: CaptureItem): Promise<void> {
    if (!this.bridge.configured) {
      // D-LE2-01：被拒必须原位可见（条目下方红字 + 恢复动作），不只写在底部消息区
      item.error = '未连接工作台，无法上传';
      item.recoveryAction = '请先在顶部「连接」区重新连接，连接成功后重新提交';
      item.updatedAt = Date.now();
      this.captureStore.save(item);
      this.say('尚未连接灵犀工作台：请先在顶部「连接」区配置地址并连接。');
      this.showConnect = true;
      return;
    }
    // PX-KK04-02：in-flight guard——同一 capture 提交尚未返回前禁止再次入队
    if (this.submittingId === item.captureId) {
      return;
    }
    if (authorizeDraft(item) || item.transfer === TransferStatus.FAILED) {
      this.submittingId = item.captureId;
      try {
        enqueue(item);
        this.captureStore.save(item);
        this.mirrorCaptures();
        this.say(`已交给灵犀：${item.kind === 'audio' ? '录音' : '文本'}进入同步队列，网络可用时自动上传。`);
        await this.syncCtl.kick();
      } finally {
        this.submittingId = '';
      }
    }
  }

  private startCorrection(item: CaptureItem): void {
    this.correctionOfId = item.captureId;
    this.say(`正在修正「${item.titleHint || item.capturedAt.slice(11, 16)} 的采集」：在上方文本框输入修正内容后保存，将作为新版本提交（原文不覆盖）。`);
  }

  private async viewResult(item: CaptureItem): Promise<void> {
    if (!item.noteId) {
      return;
    }
    const r = await this.bridge.result(item.noteId);
    if (r.ok) {
      try {
        const body = JSON.parse(r.body) as Record<string, Object>;
        this.resultFor = item.captureId;
        this.resultTitle = String(body['note_id'] ?? item.noteId);
        // PX-KK04-06：默认结果层先给可读正文；YAML frontmatter 属技术细节，
        // 不主导首屏（完整元数据仍可在「原始来源」面板查看）。
        this.resultBody = String(body['body_md'] ?? '')
          .replace(/^---\r?\n[\s\S]*?\r?\n---\r?\n?/, '')
          .trim();
      } catch (e) {
        this.say('结果解析失败。');
      }
    } else {
      this.say(`结果获取失败：HTTP ${r.status} ${r.error}`);
    }
  }

  private async viewProvenance(item: CaptureItem): Promise<void> {
    const lines: string[] = [
      `capture_id：${item.captureId}（revision ${item.payloadRevision}）`,
      `捕获时间：${item.capturedAt}（${item.capturedTimezone}）`,
      `内容哈希：${item.contentHash}`
    ];
    if (item.kind === CaptureKind.AUDIO) {
      lines.push(`原始录音：${item.assetFile} · ${item.assetSize}B · sha256 ${item.assetSha256.slice(0, 16)}…`);
      lines.push('原件保存在手机采集箱，工作台可靠接收后双端各保留一份。');
    } else {
      lines.push(`原始文本：「${item.text.slice(0, 120)}」`);
    }
    if (item.taskId) {
      const r = await this.bridge.getCapture(item.captureId);
      if (r.ok) {
        try {
          const v = JSON.parse(r.body) as Record<string, Object>;
          const prov = (v['provenance'] ?? {}) as Record<string, Object>;
          const transcript = String(prov['initial_transcript'] ?? '');
          if (transcript.length > 0) {
            lines.push(`工作台最初转写：「${transcript.slice(0, 200)}」`);
          }
          // PX-KK04-04：真实音频质量判定如实展示（静默/过短/转写循环），并给恢复路径。
          const refs = (v['result_refs'] ?? {}) as Record<string, Object>;
          const q = refs['audio_quality'] as Record<string, Object> | undefined;
          if (q) {
            const lvl = String(q['level'] ?? 'ok');
            const reasons = (q['reasons'] as string[] | undefined) ?? [];
            const qline = lvl === 'ok'
              ? `✓ 音频质量正常（peak=${String(q['peak'] ?? 0)} rms=${String(q['rms'] ?? 0)} 时长${String(q['duration_ms'] ?? 0)}ms）`
              : `⚠ 音频质量可疑（${lvl}）: ${reasons.join('；')}（peak=${String(q['peak'] ?? 0)} rms=${String(q['rms'] ?? 0)}）`;
            lines.push(qline);
            if (lvl !== 'ok') {
              lines.push('可重新录制、改用文字修正，或保留原件仅存档（不自动丢弃）。');
            }
          }
          lines.push(`接收时间：${String(v['received_at'] ?? '—')} · 整理时间：${String(v['organized_at'] ?? '—')}`);
          // J08 来源链：全部 revision 层分别可见（原始/修正/补充，原文不覆盖）
          const revs = v['revisions'];
          if (Array.isArray(revs) && revs.length > 0) {
            lines.push('—— 版本链（每层独立保存，原文不覆盖）——');
            (revs as Array<Record<string, Object>>).forEach((rv: Record<string, Object>) => {
              const rprov = (rv['provenance'] ?? {}) as Record<string, Object>;
              const intent = String(rprov['intent'] ?? 'note');
              const layer = intent === 'correction' ? '修正/补充' : '原始采集';
              const rtext = String(rv['text_body'] ?? '');
              const preview = rtext.length > 0 ? `「${rtext.slice(0, 60)}」` : '（音频资产）';
              const rnote = String(rv['note_id'] ?? '');
              lines.push(
                `r${String(rv['payload_revision'] ?? '?')} ${layer} ${preview}` +
                ` · ${String(rv['captured_at'] ?? '').slice(0, 16)}` +
                ` · ${String(rv['processing_status'] ?? '')}${rnote ? ` · 结果 ${rnote.slice(0, 24)}…` : ''}`
              );
            });
          }
        } catch (e) {
          // 忽略解析失败，本地信息已足够
        }
      }
    }
    this.provenanceFor = item.captureId;
    this.provenanceRev = item.payloadRevision;
    this.provenanceText = lines.join('\n');
  }

  private itemTitle(item: CaptureItem): string {
    if (item.titleHint) {
      return item.titleHint;
    }
    if (item.kind === CaptureKind.TEXT) {
      return item.text.length > 24 ? `${item.text.slice(0, 24)}…` : item.text;
    }
    return `录音 ${Math.round(item.assetDurationMs / 1000)} 秒`;
  }

  /** D-LE2-05：修正模式横幅显示目标条目名，键盘开合不丢失上下文。 */
  private correctionTargetTitle(): string {
    const src = this.captureStore.get(this.correctionOfId);
    if (src === null) {
      return this.correctionOfId.slice(0, 12);
    }
    return this.itemTitle(src);
  }

  private statusColor(item: CaptureItem): string {
    if (item.transfer !== TransferStatus.RECEIVED) {
      return item.transfer === TransferStatus.DRAFT ? '#888888' : '#B26A00';
    }
    if (item.processing === ProcessingStatus.COMPLETED) {
      return '#1B6E3C';
    }
    if (item.processing === ProcessingStatus.FAILED || item.processing === ProcessingStatus.NEEDS_INPUT) {
      return '#C62828';
    }
    return '#1B4F8A';
  }

  build() {
    Scroll() {
      Column({ space: 12 }) {
        // ── 头部：产品定位一眼可读 ──
        Row({ space: 8 }) {
          Text('灵')
            .fontSize(20)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .width(36)
            .height(36)
            .borderRadius(18)
            .backgroundColor('#5656D6')
          Column({ space: 2 }) {
            Text('灵犀 · 移动采集')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
            Text(`手机采集 · 离线不丢 · 联网交给灵犀整理 · ${this.connectState}`)
              .fontSize(11)
              .fontColor('#777777')
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')

        Text('KK-04 原型 · OpenHarmony 模拟器 · 只连你自己配置的隔离灵犀工作台 · 无任何对外发送')
          .fontSize(10)
          .fontColor('#A05000')
          .width('100%')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(6)
          .backgroundColor('#FFF3E0')

        // ── 连接区（连接后可折叠） ──
        Column({ space: 6 }) {
          Row({ space: 8 }) {
            Text(`连接：${this.connectState}`)
              .fontSize(12)
              .fontColor(this.connectState.includes('不可达') || this.connectState.includes('失效')
                ? '#C62828'
                : (this.connectState.includes('已连接') && !this.connectState.includes('停用') ? '#1B6E3C' : '#7A4A00'))
              .layoutWeight(1)
            Button(this.showConnect ? '收起' : '设置')
              .fontSize(11)
              .fontColor('#555555')
              .backgroundColor('#EFEFEF')
              .onClick(() => {
                this.showConnect = !this.showConnect;
              })
          }
          .width('100%')
          if (this.showConnect) {
            TextInput({ text: this.connectUrl, placeholder: '工作台地址，如 http://192.168.x.x:18231' })
              .onChange((v: string) => {
                this.connectUrl = v;
              })
            Row({ space: 8 }) {
              Button('连接灵犀工作台')
                .fontSize(13)
                .layoutWeight(1)
                .onClick(async () => {
                  await this.connectNow();
                })
              Button('撤销设备')
                .fontSize(13)
                .fontColor('#C62828')
                .backgroundColor('#F6E3E3')
                .enabled(this.bridgeConfigured)
                .onClick(async () => {
                  await this.revokeNow();
                })
            }
            .width('100%')
            if (this.capsText.length > 0) {
              Text(this.capsText)
                .fontSize(10)
                .fontColor('#555555')
                .width('100%')
            }
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(12)
        .borderRadius(12)
        .backgroundColor('#FFFFFF')
        .border({ width: 1, color: '#E4E4EE' })

        // ── ① 采集（主入口，首屏可达，1 秒内明确反馈） ──
        Column({ space: 8 }) {
          Text(this.correctionOfId.length > 0
            ? `① 采集（正在修正「${this.correctionTargetTitle()}」→ 保存为新版本，原文不覆盖）`
            : '① 采集')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.correctionOfId.length > 0 ? '#1B4F8A' : '#000000')
            .width('100%')
          TextArea({ text: this.textDraft, placeholder: '输入文字，先保存在本机采集箱；不会自动上传' })
            .height(80)
            .onChange((v: string) => {
              this.textDraft = v;
            })
          Row({ space: 8 }) {
            Button('保存到采集箱')
              .fontSize(13)
              .layoutWeight(1)
              .enabled(this.textDraft.trim().length > 0)
              .onClick(() => {
                this.saveTextDraft();
              })
            if (this.correctionOfId.length > 0) {
              Button('放弃修正')
                .fontSize(13)
                .fontColor('#555555')
                .backgroundColor('#E0E0E0')
                .onClick(() => {
                  this.correctionOfId = '';
                })
            }
          }
          .width('100%')

          if (this.recordingBox) {
            Text(`● 正在录音 ${this.boxClock()}`)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#C62828')
              .width('100%')
            Row({ space: 10 }) {
              Button('停止并保存')
                .fontSize(14)
                .layoutWeight(1)
                .backgroundColor('#C62828')
                .onClick(async () => {
                  await this.stopBoxRecording();
                })
              Button('取消录音')
                .fontSize(14)
                .layoutWeight(1)
                .fontColor('#555555')
                .backgroundColor('#E0E0E0')
                .onClick(async () => {
                  await this.cancelBoxRecording();
                })
            }
            .width('100%')
          } else {
            Button('🎙 录音采集（保存到本机采集箱）')
              .fontSize(15)
              .width('100%')
              .height(46)
              .onClick(async () => {
                await this.startBoxRecording();
              })
          }
          // PX-KK04-06：首次使用者立即可懂——区分「首次未授权/被系统拒绝/已授权」三态，
          // 明确告知可在系统设置随时恢复，不诱导放弃；文字采集始终可用。
          Text(this.micState === MicState.PERMISSION_DENIED
            ? '麦克风：你之前在系统弹窗里拒绝了录音权限。不影响文字采集；若想录音，到「系统设置 › 应用 › 本应用 › 权限」打开麦克风即可，随时可改。'
            : (this.micState === MicState.PERMISSION_REQUIRED
              ? '麦克风：首次录音时系统会弹窗请求授权，点「允许」就能录；不授权也能用文字采集。'
              : '麦克风：已授权 · 录音原件保存在本机，上传前不删除'))
            .fontSize(10)
            .fontColor(this.micState === MicState.PERMISSION_DENIED ? '#B26A00' : '#999999')
            .width('100%')
          if (!this.recordingBox) {
            Row({ space: 8 }) {
              Button('导入演示音频')
                .fontSize(12)
                .layoutWeight(1)
                .fontColor('#1B4F8A')
                .backgroundColor('#E3ECF7')
                .enabled(this.bridgeConfigured && !this.importingAudio)
                .onClick(async () => {
                  await this.importDemoAudio(false);
                })
              Button('导入·昨日捕获')
                .fontSize(12)
                .layoutWeight(1)
                .fontColor('#1B4F8A')
                .backgroundColor('#E3ECF7')
                .enabled(this.bridgeConfigured && !this.importingAudio)
                .onClick(async () => {
                  await this.importDemoAudio(true);
                })
              Button('导入·5分钟')
                .fontSize(12)
                .layoutWeight(1)
                .fontColor('#1B4F8A')
                .backgroundColor('#E3ECF7')
                .enabled(this.bridgeConfigured && !this.importingAudio)
                .onClick(async () => {
                  await this.importDemoAudio(false, 'kk04_reading_5min');
                })
            }
            .width('100%')
            Text('模拟器无真实麦克风：从已连接工作台拉取合成朗读音频入箱（内容合成，ASR/整理为真实链路）')
              .fontSize(10)
              .fontColor('#999999')
              .width('100%')
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(12)
        .borderRadius(12)
        .backgroundColor('#FFFFFF')
        .border({ width: 1, color: '#DDE4DD' })

        // ── ② 采集箱（未同步 / 未整理 状态分明） ──
        Column({ space: 8 }) {
          Text(`② 采集箱（${this.captureList.length} 条 · 草稿不入库）`)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .width('100%')
          if (this.captureList.length === 0) {
            Text('还没有采集。上面输入文字或录音后点「保存到采集箱」，再显式「交给灵犀」。')
              .fontSize(11)
              .fontColor('#999999')
              .width('100%')
          }
          ForEach(this.captureList, (item: CaptureItem) => {
            Column({ space: 4 }) {
              Row({ space: 6 }) {
                Text(item.kind === CaptureKind.AUDIO ? '🎙' : '📝')
                  .fontSize(13)
                Text(this.itemTitle(item))
                  .fontSize(13)
                  .layoutWeight(1)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(item.capturedAt.slice(5, 16))
                  .fontSize(10)
                  .fontColor('#999999')
              }
              .width('100%')
              Row({ space: 6 }) {
                Text(statusLabel(item))
                  .fontSize(10)
                  .fontColor(this.statusColor(item))
                  .layoutWeight(1)
                if (item.transfer === TransferStatus.DRAFT ||
                  item.transfer === TransferStatus.LOCAL_SAVED ||
                  item.transfer === TransferStatus.FAILED ||
                  item.transfer === TransferStatus.QUEUED) {
                  Button(this.submittingId === item.captureId
                    ? '提交中…'
                    : (item.transfer === TransferStatus.DRAFT ? '交给灵犀' : '重新同步'))
                    .fontSize(11)
                    .backgroundColor(this.submittingId === item.captureId ? '#9A9AC8' : '#5656D6')
                    .enabled(this.submittingId !== item.captureId)
                    .onClick(async () => {
                      await this.handToLingxi(item);
                    })
                }
                if (item.processing === ProcessingStatus.FAILED && item.taskId.length > 0) {
                  // D-KK04-05：整理失败（如工作台超时）提供显式重试入口，服务端幂等
                  Button('重试整理')
                    .fontSize(11)
                    .backgroundColor('#B26A00')
                    .onClick(async () => {
                      const r = await this.bridge.retryTask(item.taskId);
                      if (r.ok) {
                        this.say('已请求重新整理，状态会自动更新。');
                        this.syncCtl.kick();
                      } else {
                        this.say(`重试整理失败：${r.error.length > 0 ? r.error : `HTTP ${r.status}`}`);
                      }
                    })
                }
                if (item.transfer === TransferStatus.RECEIVED) {
                  // D-LE2-04：可靠接收后即可现场修正/补充（每次修正都是独立新
                  // revision，服务端按 revision 链处理），不再要求等待上一次
                  // 整理完成——否则整理超时期间 J08 补充链被事实阻断。
                  Button('现场修正')
                    .fontSize(11)
                    .fontColor('#1B4F8A')
                    .backgroundColor('#E3ECF7')
                    .onClick(() => {
                      this.startCorrection(item);
                    })
                }
              }
              .width('100%')
              if (item.error.length > 0) {
                Text(`⚠ ${item.error}${item.recoveryAction ? ` · ${item.recoveryAction}` : ''}`)
                  .fontSize(10)
                  .fontColor('#C62828')
                  .width('100%')
              }
              // PX-KK04-04：音频质量判定必须出现在卡片层（结果入口），
              // 近静音/过弱/转写循环等不得只显示普通「已整理」。
              if (item.kind === CaptureKind.AUDIO &&
                (item.qualityLevel ?? '') !== '' && item.qualityLevel !== 'ok') {
                Text(`⚠ 音频质量可疑（${item.qualityLevel}）${item.qualityNote ? `：${item.qualityNote}` : ''}`)
                  .fontSize(10)
                  .fontColor('#B26A00')
                  .width('100%')
                Text('可重新录制、点「现场修正」改文字，或仅保留原件存档（原件不会被覆盖）。')
                  .fontSize(10)
                  .fontColor('#B26A00')
                  .width('100%')
              }
              // ③ 灵犀结果 + 原始来源（两次导航内）
              // D-LE2-04：原始来源自可靠接收起即可查看（来源不依赖整理完成）；
              // 灵犀结果仍需整理完成且有 note_id。
              if (item.transfer === TransferStatus.RECEIVED) {
                Row({ space: 6 }) {
                  if (item.processing === ProcessingStatus.COMPLETED && item.noteId.length > 0) {
                    Button(this.resultFor === item.captureId ? '收起结果' : '查看灵犀结果')
                      .fontSize(11)
                      .fontColor('#1B6E3C')
                      .backgroundColor('#E4F2E8')
                      .onClick(async () => {
                        if (this.resultFor === item.captureId) {
                          this.resultFor = '';
                        } else {
                          await this.viewResult(item);
                        }
                      })
                  }
                  Button(this.provenanceFor === item.captureId ? '收起来源' : '原始来源')
                    .fontSize(11)
                    .fontColor('#555555')
                    .backgroundColor('#EFEFEF')
                    .onClick(async () => {
                      if (this.provenanceFor === item.captureId) {
                        this.provenanceFor = '';
                      } else {
                        await this.viewProvenance(item);
                      }
                    })
                }
                .width('100%')
              }
              if (this.resultFor === item.captureId) {
                Text(`灵犀结果（note_id：${item.noteId} · rev ${item.noteRevision}）`)
                  .fontSize(11)
                  .fontColor('#1B6E3C')
                  .width('100%')
                Text(this.resultBody.slice(0, 1500))
                  .fontSize(12)
                  .fontColor('#333333')
                  .width('100%')
                  .padding(8)
                  .borderRadius(8)
                  .backgroundColor('#F0F7F1')
                Text('技术细节（原始转写 / 质量判定 / 时间戳 / 哈希）见下方「原始来源」面板。')
                  .fontSize(10)
                  .fontColor('#999999')
                  .width('100%')
                  .padding({ left: 8, right: 8, bottom: 4 })
              }
              if (this.provenanceFor === item.captureId) {
                if (this.provenanceRev !== item.payloadRevision) {
                  Text(`⚠ 此面板是 revision ${this.provenanceRev} 的来源，当前已到 revision ${item.payloadRevision}；点「收起来源」再开可刷新。`)
                    .fontSize(10)
                    .fontColor('#B26A00')
                    .width('100%')
                    .padding({ left: 8, right: 8, top: 4 })
                }
                Text(this.provenanceText)
                  .fontSize(11)
                  .fontColor('#555555')
                  .width('100%')
                  .padding(8)
                  .borderRadius(8)
                  .backgroundColor('#F0F0F5')
              }
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .padding(8)
            .borderRadius(8)
            .backgroundColor('#FFFFFF')
          }, (item: CaptureItem) => this.captureRowKey(item))
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(12)
        .borderRadius(12)
        .backgroundColor('#F0F0F5')

        // ── Agent 反馈（当前操作与历史消息分开，带时间） ──
        Column({ space: 6 }) {
          ForEach(this.visibleMessages, (msg: AgentMessage, idx: number) => {
            Text(this.formatMsg(msg, idx))
              .fontSize(12)
              .fontColor(msg.role === 'owner' ? '#1B4F8A' : '#333333')
              .width('100%')
          }, (msg: AgentMessage) => `${msg.at}-${msg.role}`)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(10)
        .borderRadius(10)
        .backgroundColor('#F4F4FA')

        // ── 声纹（可选能力，折叠；不作为采集/上传门槛） ──
        Column({ space: 6 }) {
          Button(this.showVoiceIdentity ? '收起声纹（可选）▴' : '声纹（可选来源识别，非上传门槛）▾')
            .fontSize(11)
            .fontColor('#777777')
            .backgroundColor('#EFEFEF')
            .onClick(() => {
              this.showVoiceIdentity = !this.showVoiceIdentity;
            })
          if (this.showVoiceIdentity) {
            Text('声纹是可选的来源识别能力，不代替设备认证；不录入也能采集和上传。设备属主不代表资料作者。')
              .fontSize(11)
              .fontColor('#888888')
              .width('100%')
            Text(`录入状态：${this.speakerState === SpeakerState.ENROLLED ? '已录入（本地声纹档案）' : '未录入'}${this.enrollmentText ? ` · ${this.enrollmentText}` : ''}`)
              .fontSize(12)
              .width('100%')
            Button(this.speakerState === SpeakerState.ENROLLED ? '重新录入（3 句采样）' : '录入我的声纹')
              .fontSize(12)
              .enabled(this.micState !== MicState.RECORDING && !this.recordingBox)
              .onClick(async () => {
                if (!this.session.permission.isGranted()) {
                  await this.session.requestPermission(this.uiContext());
                  this.refreshVoice();
                  if (!this.session.permission.isGranted()) {
                    return;
                  }
                }
                const ok = await this.session.startSession(SessionPurpose.ENROLLMENT);
                if (ok) {
                  this.enrollmentText = `采样 ${this.session.enrollmentCount}/3 · 请朗读一句中文，说完点停止`;
                  //  enrollment 走既有 session 控制器（停止在下方按钮）
                }
              })
            if (this.micState === MicState.RECORDING &&
              this.session.purpose === SessionPurpose.ENROLLMENT) {
              Row({ space: 8 }) {
                Button('停止采样')
                  .fontSize(12)
                  .backgroundColor('#C62828')
                  .onClick(async () => {
                    await this.session.stopSession();
                    const n = this.session.enrollmentCount;
                    if (n >= 3) {
                      const done = this.session.speaker.completeEnrollment();
                      this.enrollmentText = done ? '录入完成（3/3）' : '录入失败，请重试';
                    } else if (n > 0) {
                      this.enrollmentText = `采样 ${n}/3 · 再录 ${3 - n} 句`;
                    } else {
                      this.enrollmentText = '采样无效，请重试';
                    }
                    this.refreshVoice();
                  })
                Button('取消')
                  .fontSize(12)
                  .fontColor('#555555')
                  .backgroundColor('#E0E0E0')
                  .onClick(async () => {
                    await this.session.cancelSession();
                    this.enrollmentText = '';
                    this.refreshVoice();
                  })
              }
            }
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        // ── 技术诊断（次要，折叠） ──
        Column({ space: 4 }) {
          Button(this.showDiagnostics ? '收起技术诊断 ▴' : '技术诊断（引擎/连接详情）▾')
            .fontSize(11)
            .fontColor('#777777')
            .backgroundColor('#EFEFEF')
            .onClick(() => {
              this.showDiagnostics = !this.showDiagnostics;
            })
          if (this.showDiagnostics) {
            Text(this.engineInitText)
              .fontSize(11)
              .fontColor(this.engineInitText.includes('不可用') ? '#C62828' : '#1B6E3C')
              .width('100%')
            Text(`设备：${this.deviceIdText || '未注册'} · 工作台：${this.connectUrl || '未配置'}`)
              .fontSize(11)
              .fontColor('#777777')
              .width('100%')
            Text(`采集箱目录：应用沙箱 capturebox/ · 同步节流 3s · 轮询 5s`)
              .fontSize(11)
              .fontColor('#999999')
              .width('100%')
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding(16)
      .constraintSize({ minHeight: '100%' })
      .justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAFAFD')
  }
}
