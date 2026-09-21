import { common } from '@kit.AbilityKit';
import { CandidateStatus, MicState, SpeakerState, TrustGateDecision } from '../core/VoiceCore';
import { SessionPurpose, VoiceSessionController } from '../voice/VoiceSessionController';
import { SpeakerVerificationController, UnprovisionedSpeakerEngine } from '../voice/SpeakerVerificationController';
import { SherpaSpeakerEngine } from '../engine/SherpaSpeakerEngine';
import { AgentContext, AgentMessage, KnowledgeItem } from '../agent/AgentContext';
import { AgentContextStore } from '../agent/AgentContextStore';
import { NoteDraft, NoteDraftStatus, NoteFlowController } from '../note/NoteFlow';

/**
 * GOAL-KK-03 first-use voice-to-note product surface.
 *
 * Layout contract (frozen): the FIRST screen must read as a product —
 * purpose + primary recording action + voice-identity entry visible without
 * scrolling; simulator/test tooling and diagnostics stay secondary/collapsed.
 *
 * Product loop: start recording → clear RECORDING feedback → stop/cancel →
 * honest transcript candidate → correct / reject / 整理成笔记 → editable
 * note draft (title + body, original transcript preserved) → explicit
 * save (+1) / cancel (+0) → saved note reopenable with provenance →
 * Agent explains what changed, context preserved.
 */
@Entry
@Component
struct Index {
  @State agent: AgentContext = new AgentContext();
  @State session: VoiceSessionController =
    new VoiceSessionController(new SpeakerVerificationController(new UnprovisionedSpeakerEngine()));
  private sherpaEngine: SherpaSpeakerEngine = new SherpaSpeakerEngine();
  private store: AgentContextStore = new AgentContextStore();
  private noteFlow: NoteFlowController = new NoteFlowController();
  @State engineInitText: string = '声纹引擎初始化中…';
  @State micState: string = MicState.IDLE;
  @State speakerState: string = SpeakerState.NOT_ENROLLED;
  @State transcript: string = '';
  @State similarityText: string = '';
  @State gateText: string = '';
  @State candidateStatus: string = CandidateStatus.NONE;
  @State enrollmentText: string = '';
  @State enrollmentArchiveText: string = '';
  @State verdictText: string = '—(尚未捕获)';
  @State sttNote: string = '';
  @State speakerNote: string = '';
  @State knowledgeCount: number = 0;
  @State correctedText: string = '';
  @State manualText: string = '';
  @State degradedCapture: boolean = false;
  @State fixtureActive: boolean = false;
  @State fixtureDemo: boolean = false;
  @State fixtureText: string = '';
  @State showDiagnostics: boolean = false;
  @State showSimTools: boolean = false;
  @State showVoiceIdentity: boolean = false;
  @State expandedKnowledgeId: string = '';
  @State tick: number = 0;
  // KK-03: live recording feedback (mm:ss ticking while RECORDING).
  @State recordElapsedSec: number = 0;
  private recordTimer: number = -1;
  // KK-03: note-draft editor mirror (NoteFlowController is unobserved).
  @State noteStatus: string = NoteDraftStatus.NONE;
  @State noteTitle: string = '';
  @State noteBody: string = '';
  @State noteOriginal: string = '';
  @State noteSource: string = 'text';
  @State noteSpeaker: string = 'N/A';
  @State noteShowOriginal: boolean = false;
  @State noteSaving: boolean = false;
  // D12 fix: agent.messages is a plain array on an unobserved class — push()
  // is invisible to @State. Mirror the tail into a real @State array.
  @State visibleMessages: AgentMessage[] = [];
  // R3 (PX-KK02-01/04): restored + live knowledge must be inspectable — mirror
  // the full confirmed list into a real @State array (latest first).
  @State visibleKnowledge: KnowledgeItem[] = [];

  private refresh(): void {
    this.micState = this.session.micState;
    this.speakerState = this.session.speakerState;
    this.transcript = this.session.transcript;
    this.similarityText = Number.isNaN(this.session.similarity)
      ? '—'
      : this.session.similarity.toFixed(3);
    this.candidateStatus = this.session.candidateStatus;
    this.sttNote = this.session.sttEngineNote;
    this.speakerNote = this.session.speaker.engineIdentity();
    this.knowledgeCount = this.agent.knowledgeCount();
    this.gateText = this.gateLabel();
    this.fixtureActive = this.session.fixtureTranscript;
    this.fixtureDemo = this.session.fixtureDemo;
    this.visibleMessages = this.agent.messages.slice(-6);
    this.visibleKnowledge = this.agent.knowledge.slice().reverse();
    this.enrollmentArchiveText = this.enrollmentArchiveLabel();
    this.verdictText = this.currentVerdictLabel();
    this.tick += 1;
  }

  /** Mirror the note-draft controller into observable state. */
  private syncNoteState(): void {
    this.noteStatus = this.noteFlow.status;
    const d = this.noteFlow.draft;
    if (d !== null && this.noteStatus === NoteDraftStatus.EDITING) {
      this.noteTitle = d.title;
      this.noteBody = d.body;
      this.noteOriginal = d.originalTranscript;
      this.noteSource = d.source;
      this.noteSpeaker = d.speakerState;
    }
    if (this.noteStatus === NoteDraftStatus.NONE) {
      this.noteTitle = '';
      this.noteBody = '';
      this.noteOriginal = '';
      this.noteSource = 'text';
      this.noteSpeaker = 'N/A';
      this.noteShowOriginal = false;
      this.noteSaving = false;
    }
  }

  private gateLabel(): string {
    const gate = this.session.gate;
    if (gate === null) {
      return '';
    }
    switch (gate) {
      case TrustGateDecision.CANDIDATE_ALLOWED:
        return '信任门通过:可进入候选(仍需你明确确认)';
      case TrustGateDecision.BLOCKED_NOT_VERIFIED:
        return '信任门拦截:非机主语音(NOT_VERIFIED),不入库';
      case TrustGateDecision.BLOCKED_UNCERTAIN:
        return '信任门拦截:无法确定是谁(UNCERTAIN),不入库';
      case TrustGateDecision.BLOCKED_NOT_AVAILABLE:
        return '信任门拦截:本地能力不可用(NOT_AVAILABLE),无云端回退';
      case TrustGateDecision.BLOCKED_NOT_ENROLLED:
        return '信任门拦截:尚未注册机主声纹';
      default:
        return '';
    }
  }

  private micLabel(): string {
    switch (this.micState) {
      case MicState.IDLE: return '空闲 · 未录音';
      case MicState.PERMISSION_REQUIRED: return '需要麦克风权限';
      case MicState.PERMISSION_GRANTED: return '权限已授予 · 待开始';
      case MicState.PERMISSION_DENIED: return '权限被拒绝 · 无法录音';
      case MicState.RECORDING: return '● 录音中';
      case MicState.STOPPED: return '已停止';
      case MicState.UNAVAILABLE: return '本地语音能力不可用';
      default: return this.micState;
    }
  }

  /**
   * R3 (PX-KK02-05): enrollment archive state is a persistent profile fact,
   * shown separately from each capture verdict — they must never share one line.
   */
  private enrollmentArchiveLabel(): string {
    const s = this.session.speaker.state();
    switch (s) {
      case SpeakerState.ENROLLED: return '已录入(本地声纹档案)';
      case SpeakerState.NOT_ENROLLED: return '未录入';
      case SpeakerState.NOT_AVAILABLE: return '引擎不可用(NOT_AVAILABLE)';
      default: return s;
    }
  }

  /** R3 (PX-KK02-05): per-capture verdict — only meaningful while a result is on screen. */
  private currentVerdictLabel(): string {
    if (this.session.fixtureDemo) {
      return '不适用(演示候选,未采集语音)';
    }
    // R3-D19: an enrollment stop leaves its STT echo on screen — that is a
    // sampling echo, NOT a capture verdict.
    if (this.session.purpose === SessionPurpose.ENROLLMENT &&
      (this.session.gate !== null || this.session.transcript.length > 0 ||
        this.session.candidateStatus !== CandidateStatus.NONE)) {
      return '—(注册采样回声,非本次验证)';
    }
    if (this.session.gate !== null || this.session.transcript.length > 0 ||
      this.session.candidateStatus !== CandidateStatus.NONE) {
      return `${this.session.speakerState} · 相似度 ${this.similarityText}`;
    }
    return '—(尚未捕获)';
  }

  aboutToAppear(): void {
    // R3 (PX-KK02-01): restore bounded confirmed knowledge + conversation
    // context from the app-private sandbox BEFORE first render. Only
    // explicitly saved items were ever persisted; rejected, discarded and
    // unconfirmed candidates/drafts are absent by construction.
    this.store.init(this.uiContext());
    const snap = this.store.load();
    if (snap !== null && (snap.knowledge.length > 0 || snap.messages.length > 0)) {
      this.agent.restore(snap);
      this.agent.say('system',
        `已从本地恢复 ${this.agent.knowledgeCount()} 条已保存知识与对话上下文(0.1 原型有界本地存储,非生产备份)。`, false);
    } else {
      this.agent.ensureIntro();
    }
    this.agent.onChanged = () => {
      this.store.save(this.agent);
    };
    this.session.speaker.initStorage(this.uiContext());
    this.session.onEvent(() => {
      this.refresh();
    });
    this.session.refreshPermission();
    this.refresh();
    // Async engine provisioning: honest NOT_AVAILABLE if it cannot init.
    this.sherpaEngine.init(this.uiContext()).then((ok: boolean) => {
      if (ok) {
        this.session.speaker.setEngine(this.sherpaEngine);
        this.engineInitText = '声纹引擎就绪(本地 sherpa-onnx)';
      } else {
        this.engineInitText = `声纹引擎不可用(NOT_AVAILABLE):${this.sherpaEngine.engineIdentity()}`;
      }
      this.session.refreshSpeakerState();
      this.refresh();
    });
  }

  aboutToDisappear(): void {
    this.stopRecordTimer();
  }

  /**
   * D8 fix: returning from a settings round-trip does not re-run
   * aboutToAppear — refresh the mic strip so a granted permission shows up.
   */
  onPageShow(): void {
    this.session.refreshPermission();
    this.refresh();
  }

  private captureButtonLabel(): string {
    if (this.micState === MicState.PERMISSION_REQUIRED) {
      return '🎙 授权麦克风并开始录音';
    }
    if (this.micState === MicState.PERMISSION_DENIED) {
      return '麦克风已拒绝 · 点这里去设置开启';
    }
    return '🎙 开始录音';
  }

  /** Deep-link to system settings when the system no longer re-prompts. */
  private async openMicSettings(): Promise<void> {
    const ctx = this.uiContext();
    const settingsBundles: string[] = ['com.huawei.hmos.settings', 'com.ohos.settings'];
    for (const bundle of settingsBundles) {
      try {
        await ctx.startAbility({
          bundleName: bundle,
          abilityName: `${bundle}.MainAbility`,
          uri: 'application_info_entry',
          parameters: { pushParams: ctx.applicationInfo.name }
        });
        this.agent.say('system', '请在系统设置中允许麦克风权限,然后返回灵犀。');
        this.refresh();
        return;
      } catch (e) {
        // try next settings bundle name
      }
    }
    this.agent.say('system', '无法自动跳转:请手动到 系统设置 → 应用 → 灵犀语音原型 → 权限 开启麦克风。');
    this.refresh();
  }

  /** KK-03: ticking elapsed-time feedback while RECORDING. */
  private startRecordTimer(): void {
    this.stopRecordTimer();
    this.recordElapsedSec = 0;
    this.recordTimer = setInterval(() => {
      const ms = this.session.recordingElapsedMs();
      if (ms >= 0) {
        this.recordElapsedSec = Math.floor(ms / 1000);
      }
    }, 500);
  }

  private stopRecordTimer(): void {
    if (this.recordTimer >= 0) {
      clearInterval(this.recordTimer);
      this.recordTimer = -1;
    }
  }

  private recordClock(): string {
    const mm = Math.floor(this.recordElapsedSec / 60).toString().padStart(2, '0');
    const ss = (this.recordElapsedSec % 60).toString().padStart(2, '0');
    return `${mm}:${ss}`;
  }

  private async startCapture(): Promise<void> {
    if (!this.session.permission.isGranted()) {
      await this.session.requestPermission(this.uiContext());
      this.refresh();
      if (this.micState !== MicState.PERMISSION_GRANTED) {
        this.agent.say('system', '麦克风权限未授予,无法录音;可以改用下方手动文本记录,不丢上下文。');
        this.refresh();
        if (this.micState === MicState.PERMISSION_DENIED) {
          await this.openMicSettings();
        }
        return;
      }
    }
    this.session.backToIdle();
    const started = await this.session.startSession(SessionPurpose.CAPTURE);
    // D10 fix: when STT is NOT_AVAILABLE the session refuses to record at
    // all — surface the degraded fallback honestly.
    this.degradedCapture = !started && this.session.micState === MicState.UNAVAILABLE;
    if (this.degradedCapture) {
      this.agent.say('system', '本地语音识别不可用,录音通道已关闭;可以先用手动文本记录,不丢上下文。');
    }
    if (started) {
      this.startRecordTimer();
    }
    this.refresh();
  }

  private async stopCapture(): Promise<void> {
    this.stopRecordTimer();
    await this.session.stopSession();
    if (this.session.purpose === SessionPurpose.ENROLLMENT) {
      const n = this.session.enrollmentCount;
      if (n >= 3) {
        const done = this.session.speaker.completeEnrollment();
        this.enrollmentText = done ? '录入完成(3/3)' : '录入失败,请重试';
        // R2-D14: unconditional refresh — the guarded variant is skipped
        // while the enrollment transcript is on screen.
        this.session.forceRefreshSpeakerState();
      } else if (n > 0) {
        this.enrollmentText = `采样 ${n}/3 · 再录 ${3 - n} 句`;
      } else {
        this.enrollmentText = '采样无效(太短或引擎未就绪),请重试';
      }
    }
    this.refresh();
  }

  private async cancelCapture(): Promise<void> {
    this.stopRecordTimer();
    await this.session.cancelSession();
    this.enrollmentText = '';
    this.refresh();
  }

  /** R3 (PX-KK02-02): manual text save — always available, source-labeled. */
  private saveManualText(): void {
    if (this.manualText.trim().length > 0) {
      this.agent.addTextNote(this.manualText.trim());
      this.manualText = '';
      this.degradedCapture = false;
      this.session.dismissResult();
      this.refresh();
    }
  }

  /** KK-03: fixture demo generation lives in the collapsed simulator tools. */
  private startFixtureDemo(): void {
    const text = this.fixtureText.trim().length > 0
      ? this.fixtureText.trim()
      : '今天把语音转笔记的流程完整跑通了一遍。整理、保存、溯源都验证过了。';
    if (this.session.startFixtureCandidate(text)) {
      this.fixtureText = '';
      this.agent.say('system', '已生成演示候选(TEST_FIXTURE):这是明确标注的测试转写,不是真实语音识别,也不代表机主身份;仅用于演示修正/丢弃/整理成笔记流程,真机未验证。');
    }
    this.refresh();
  }

  /** KK-03: explicit "整理成笔记" — candidate → one editable note draft. */
  private organizeIntoNote(): void {
    const payload = this.session.continueToNote();
    if (payload !== null) {
      const created = this.noteFlow.createFromCandidate(
        payload.transcript, payload.source, payload.speakerState, payload.trustClass);
      if (created) {
        this.agent.say('agent',
          '已整理成笔记草稿:标题和正文都可以直接改,原始转写已保留可对照。点「保存笔记」才真正入库(+1);点「取消」则什么都不保存(+0)。');
      }
    }
    this.syncNoteState();
    this.refresh();
  }

  /** KK-03: explicit note save — exactly +1, exactly-once (double-tap safe). */
  private saveNote(): void {
    if (this.noteSaving) {
      return;
    }
    this.noteSaving = true;
    const draft: NoteDraft | null = this.noteFlow.save();
    if (draft !== null) {
      this.agent.saveNoteDraft(draft);
      this.noteFlow.clear();
    } else {
      this.agent.say('system', '这条草稿当前不能保存(标题/正文为空,或信任条件不满足)。', false);
    }
    this.noteSaving = false;
    this.syncNoteState();
    this.refresh();
  }

  /** KK-03: explicit note cancel — +0 knowledge. */
  private cancelNote(): void {
    if (this.noteFlow.cancel()) {
      this.agent.explainNoteCancelled();
      this.noteFlow.clear();
    }
    this.syncNoteState();
    this.refresh();
  }

  private knowledgeSourceLabel(item: KnowledgeItem): string {
    if (item.source === 'voice') {
      return '本人语音 · 已验证';
    }
    if (item.source === 'fixture') {
      return 'TEST_FIXTURE 演示';
    }
    return '手动文本';
  }

  private knowledgeSourceColor(item: KnowledgeItem): string {
    if (item.source === 'voice') {
      return '#1B6E3C';
    }
    if (item.source === 'fixture') {
      return '#B26A00';
    }
    return '#1B4F8A';
  }

  private formatTime(at: number): string {
    const d = new Date(at);
    const hh = d.getHours().toString().padStart(2, '0');
    const mm = d.getMinutes().toString().padStart(2, '0');
    return `${hh}:${mm}`;
  }

  private uiContext(): common.UIAbilityContext {
    return this.getUIContext().getHostContext() as common.UIAbilityContext;
  }

  build() {
    Scroll() {
      Column({ space: 12 }) {
        // ── Agent-first header: purpose understandable at first glance ──
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
            Text('灵犀 · 把语音变成笔记')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
            Text(`个人知识 Agent · 知识 ${this.knowledgeCount} 条 · 说话→转写→整理成笔记`)
              .fontSize(11)
              .fontColor('#777777')
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')

        // ── Compact boundary disclosure (single line, never a wall) ──
        Text('0.1 原型 · OpenHarmony 模拟器演示(非 Mate60 真机)· 全程本地 · 无云端上传')
          .fontSize(10)
          .fontColor('#A05000')
          .width('100%')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(6)
          .backgroundColor('#FFF3E0')

        // ── PRIMARY CARD: recording action + voice identity entry ──
        // First-screen rule: start-recording and voice-identity entries are
        // discoverable without scrolling.
        Column({ space: 8 }) {
          if (this.micState === MicState.RECORDING) {
            // KK-03: unmistakable in-progress feedback — red state, ticking
            // clock, and the two verbs that match the next tap.
            Text(`● 正在录音 ${this.recordClock()}`)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#C62828')
              .width('100%')
            Text(this.session.purpose === SessionPurpose.ENROLLMENT
              ? '声纹录入采样中:说完一句点「停止」,共 3 句;点「取消」丢弃本次采样'
              : '说完点「停止录音」得到转写候选;点「取消录音」丢弃这段语音')
              .fontSize(11)
              .fontColor('#888888')
              .width('100%')
            Row({ space: 10 }) {
              Button(this.session.purpose === SessionPurpose.ENROLLMENT ? '停止' : '停止录音')
                .fontSize(14)
                .layoutWeight(1)
                .backgroundColor('#C62828')
                .onClick(async () => {
                  await this.stopCapture();
                })
              Button(this.session.purpose === SessionPurpose.ENROLLMENT ? '取消' : '取消录音')
                .fontSize(14)
                .layoutWeight(1)
                .fontColor('#555555')
                .backgroundColor('#E0E0E0')
                .onClick(async () => {
                  await this.cancelCapture();
                })
            }
            .width('100%')
          } else {
            Button(this.captureButtonLabel())
              .fontSize(16)
              .width('100%')
              .height(50)
              .enabled((this.candidateStatus === CandidateStatus.NONE ||
                this.candidateStatus === CandidateStatus.CONFIRMED ||
                this.candidateStatus === CandidateStatus.REJECTED) &&
                this.noteStatus !== NoteDraftStatus.EDITING)
              .onClick(async () => {
                await this.startCapture();
              })
            Text(`麦克风:${this.micLabel()}`)
              .fontSize(11)
              .fontColor('#777777')
              .width('100%')
          }

          // Voice identity entry — archive state visible, entry discoverable.
          Row({ space: 8 }) {
            Text(`声纹档案:${this.enrollmentArchiveText}`)
              .fontSize(12)
              .fontColor(this.session.speaker.state() === SpeakerState.ENROLLED ? '#1B6E3C' : '#7A4A00')
              .layoutWeight(1)
            Button(this.showVoiceIdentity ? '收起声纹管理' : (this.session.speaker.state() === SpeakerState.ENROLLED ? '查看/重录声纹' : '录入我的声纹'))
              .fontSize(12)
              .fontColor('#1B4F8A')
              .backgroundColor('#E3ECF7')
              .enabled(this.micState !== MicState.RECORDING)
              .onClick(() => {
                this.showVoiceIdentity = !this.showVoiceIdentity;
              })
          }
          .width('100%')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(12)
        .borderRadius(12)
        .backgroundColor('#FFFFFF')
        .border({ width: 1, color: '#E4E4EE' })

        // ── Voice identity panel (expanded via the entry above) ──
        if (this.showVoiceIdentity) {
          Column({ space: 6 }) {
            Text('机主声纹(原型验证,非生产身份认证)')
              .fontSize(13)
              .fontWeight(FontWeight.Medium)
              .width('100%')
            Text('声纹档案是你的长期身份状态;「本次验证」只是某一次录音的结果,两者互不代表。')
              .fontSize(11)
              .fontColor('#888888')
              .width('100%')
            Text(`录入状态:${this.enrollmentArchiveText}` +
              (this.enrollmentText.length > 0 ? ` · ${this.enrollmentText}` : ''))
              .fontSize(12)
              .width('100%')
            Text(`本次验证:${this.verdictText}`)
              .fontSize(12)
              .fontColor('#555555')
              .width('100%')
            Row({ space: 8 }) {
              Button(this.session.speaker.state() === SpeakerState.ENROLLED ? '重新录入(3 句采样)' : '开始录入采样')
                .fontSize(12)
                .enabled(this.micState !== MicState.RECORDING)
                .onClick(async () => {
                  if (!this.session.permission.isGranted()) {
                    await this.session.requestPermission(this.uiContext());
                    this.refresh();
                    if (this.micState !== MicState.PERMISSION_GRANTED) {
                      return;
                    }
                  }
                  const ok = await this.session.startSession(SessionPurpose.ENROLLMENT);
                  if (ok) {
                    this.startRecordTimer();
                    this.enrollmentText = `采样 ${this.session.enrollmentCount}/3 · 请朗读一句中文,说完点停止`;
                  }
                  this.refresh();
                })
              Button('重置声纹')
                .fontSize(12)
                .fontColor('#C62828')
                .enabled(this.micState !== MicState.RECORDING)
                .onClick(() => {
                  // R2-D15: destructive reset must be confirmed.
                  AlertDialog.show({
                    title: '重置机主声纹?',
                    message: '将删除本机声纹档案,不可恢复;已保存的笔记与知识不受影响。',
                    autoCancel: true,
                    alignment: DialogAlignment.Center,
                    primaryButton: {
                      value: '取消',
                      fontColor: '#555555',
                      action: () => {}
                    },
                    secondaryButton: {
                      value: '确认重置',
                      fontColor: '#C62828',
                      action: () => {
                        this.session.speaker.resetEnrollment();
                        // R2-D17: the old result belongs to the deleted
                        // voiceprint — clear it with the reset.
                        this.session.clearResultForReset();
                        this.enrollmentText = '已重置';
                        this.refresh();
                      }
                    }
                  });
                })
            }
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .padding(12)
          .borderRadius(12)
          .backgroundColor('#F7F7FB')
        }

        // ── Transcript candidate (never silently saved) ──
        if (this.candidateStatus === CandidateStatus.DRAFT || this.candidateStatus === CandidateStatus.CORRECTED) {
          Column({ space: 8 }) {
            Text(this.fixtureActive
              ? '转写候选(TEST_FIXTURE 测试转写 · 未入库 · 不会自动保存)'
              : '转写候选(未入库 · 不会自动保存)')
              .fontSize(13)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.fixtureActive ? '#B26A00' : '#333333')
              .width('100%')
            if (this.fixtureDemo) {
              Text('演示候选:与声纹验证无关,不创建任何机主身份结论;整理成笔记并保存后按 TEST_FIXTURE 来源入库(+1),丢弃则不变(+0)。')
                .fontSize(11)
                .fontColor('#B26A00')
                .width('100%')
            }
            if (!this.fixtureDemo && !this.fixtureActive) {
              Text(`本次验证:${this.speakerState} · 相似度 ${this.similarityText}`)
                .fontSize(11)
                .fontColor('#555555')
                .width('100%')
            }
            Text(this.fixtureActive ? `转写(测试代理):「${this.transcript}」` : `转写:「${this.transcript}」`)
              .fontSize(14)
              .width('100%')
            TextInput({ text: this.transcript, placeholder: '可修正转写内容' })
              .onChange((v: string) => {
                this.correctedText = v;
              })
            Row({ space: 8 }) {
              Button('保存修正')
                .fontSize(12)
                .onClick(() => {
                  if (this.correctedText.trim().length > 0) {
                    this.session.correctCandidate(this.correctedText.trim());
                    this.correctedText = '';
                    this.refresh();
                  }
                })
              Button('丢弃')
                .fontSize(12)
                .fontColor('#C62828')
                .onClick(() => {
                  this.session.rejectCandidate();
                  this.agent.explainRejected();
                  this.session.dismissResult();
                  this.refresh();
                })
            }
            .width('100%')
            Button('整理成笔记')
              .fontSize(15)
              .width('100%')
              .height(44)
              .backgroundColor('#1B6E3C')
              .onClick(() => {
                this.organizeIntoNote();
              })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .padding(12)
          .borderRadius(12)
          .backgroundColor('#FFFFFF')
          .border({ width: 1, color: '#DDDDDD' })
        }

        // ── Note draft editor (explicit save / cancel) ──
        if (this.noteStatus === NoteDraftStatus.EDITING) {
          Column({ space: 8 }) {
            Text('笔记草稿(未保存 · 保存 +1 / 取消 +0)')
              .fontSize(13)
              .fontWeight(FontWeight.Medium)
              .width('100%')
            Text('确定性整理(非真实 LLM):只重排你说过的话,不新增内容;标题与正文都可编辑。')
              .fontSize(11)
              .fontColor('#888888')
              .width('100%')
            TextInput({ text: this.noteTitle, placeholder: '笔记标题' })
              .onChange((v: string) => {
                this.noteTitle = v;
                this.noteFlow.editTitle(v);
              })
            TextArea({ text: this.noteBody, placeholder: '笔记正文' })
              .height(120)
              .onChange((v: string) => {
                this.noteBody = v;
                this.noteFlow.editBody(v);
              })
            Button(this.noteShowOriginal ? '收起原始转写与来源 ▴' : '查看原始转写与来源 ▾')
              .fontSize(11)
              .fontColor('#555555')
              .backgroundColor('#EFEFEF')
              .onClick(() => {
                this.noteShowOriginal = !this.noteShowOriginal;
              })
            if (this.noteShowOriginal) {
              Text(this.noteSource === 'voice'
                ? `来源:机主本人语音(验证状态 ${this.noteSpeaker})`
                : this.noteSource === 'fixture'
                  ? '来源:模拟器 TEST_FIXTURE 演示转写 — 非真实语音识别,非机主身份,真机未验证。'
                  : '来源:手动文本输入(非语音,未做声纹验证)。')
                .fontSize(11)
                .fontColor(this.noteSource === 'fixture' ? '#B26A00' : '#555555')
                .width('100%')
              Text(`原始转写(整理不会覆盖它):「${this.noteOriginal}」`)
                .fontSize(12)
                .fontColor('#555555')
                .width('100%')
                .padding(8)
                .borderRadius(8)
                .backgroundColor('#F0F0F5')
            }
            Row({ space: 10 }) {
              Button('保存笔记')
                .fontSize(14)
                .layoutWeight(1)
                .backgroundColor('#1B6E3C')
                .enabled(!this.noteSaving)
                .onClick(() => {
                  this.saveNote();
                })
              Button('取消')
                .fontSize(14)
                .layoutWeight(1)
                .fontColor('#555555')
                .backgroundColor('#E0E0E0')
                .onClick(() => {
                  this.cancelNote();
                })
            }
            .width('100%')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .padding(12)
          .borderRadius(12)
          .backgroundColor('#FFFFFF')
          .border({ width: 1, color: '#CBDDCE' })
        }

        // ── Result + trust gate (capture outcome outside candidate/draft) ──
        if ((this.transcript.length > 0 || this.gateText.length > 0) &&
          this.candidateStatus !== CandidateStatus.DRAFT &&
          this.candidateStatus !== CandidateStatus.CORRECTED &&
          this.noteStatus !== NoteDraftStatus.EDITING) {
          Column({ space: 6 }) {
            if (!this.fixtureDemo) {
              Text(this.session.purpose === SessionPurpose.ENROLLMENT
                ? '注册采样回声(非本次验证)'
                : `本次验证:${this.speakerState} · 相似度 ${this.similarityText}` +
                  (this.session.lastStopToResultMs >= 0 ? ` · 停止→结果 ${this.session.lastStopToResultMs}ms` : ''))
                .fontSize(12)
                .fontColor('#555555')
            }
            if (this.transcript.length > 0) {
              Text(this.fixtureActive ? `转写(测试代理):「${this.transcript}」` : `转写:「${this.transcript}」`)
                .fontSize(14)
                .width('100%')
            }
            if (this.fixtureActive) {
              Text('⚠ TEST_FIXTURE:这段"转写"是模拟器测试代理文本,不是真实语音识别;仅用于演示流程。真机未验证。')
                .fontSize(11)
                .fontColor('#B26A00')
                .width('100%')
            }
            if (this.gateText.length > 0) {
              Text(this.gateText)
                .fontSize(12)
                .fontColor(this.session.gate === TrustGateDecision.CANDIDATE_ALLOWED ? '#1B6E3C' : '#C62828')
                .width('100%')
            }
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .padding(10)
          .borderRadius(10)
          .backgroundColor('#F0F6FF')
        }

        // ── Blocked path: retry / discard (+ disclosed fixture injection) ──
        if (this.session.gate !== null && this.session.gate !== TrustGateDecision.CANDIDATE_ALLOWED &&
          this.candidateStatus === CandidateStatus.NONE) {
          Column({ space: 8 }) {
            Text('这段语音不会进入知识。你可以重说、丢弃,或直接用下方文本框手动记录:')
              .fontSize(12)
              .fontColor('#555555')
            Row({ space: 8 }) {
              Button('重说一次')
                .fontSize(12)
                .onClick(async () => {
                  this.session.backToIdle();
                  const ok = await this.session.startSession(SessionPurpose.CAPTURE);
                  if (ok) {
                    this.startRecordTimer();
                  }
                  this.refresh();
                })
              Button('丢弃')
                .fontSize(12)
                .fontColor('#C62828')
                .onClick(() => {
                  this.agent.explainBlocked(this.gateText);
                  this.session.dismissResult();
                  this.refresh();
                })
            }
            // R2: disclosed simulator TEST_FIXTURE — only when the speaker is
            // VERIFIED and the sole blocker is missing STT transcript.
            if (this.session.gate === TrustGateDecision.BLOCKED_NOT_AVAILABLE &&
              this.speakerState === SpeakerState.VERIFIED) {
              Column({ space: 4 }) {
                Text('模拟器无可用离线转写。可注入一段测试转写走完候选流程(全程标注 TEST_FIXTURE,不代表真实识别):')
                  .fontSize(11)
                  .fontColor('#B26A00')
                  .width('100%')
                Row({ space: 6 }) {
                  TextInput({ text: this.fixtureText, placeholder: '输入测试转写(TEST_FIXTURE)' })
                    .layoutWeight(1)
                    .onChange((v: string) => {
                      this.fixtureText = v;
                    })
                  Button('注入测试转写')
                    .fontSize(12)
                    .fontColor('#B26A00')
                    .onClick(() => {
                      if (this.session.injectFixtureTranscript(this.fixtureText)) {
                        this.fixtureText = '';
                        this.agent.say('system', '已注入模拟器测试转写(TEST_FIXTURE,非真实语音识别),候选流仅为流程演示。');
                      } else {
                        // D-KK03-03: never a silent no-op — a refused injection
                        // must say so and why (only blank input or a real
                        // transcript already on screen can refuse here).
                        this.agent.say('system', '注入被拒绝:请输入测试转写文本;若已有真实转写,请先丢弃再试。', false);
                      }
                      this.refresh();
                    })
                }
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .padding(10)
          .borderRadius(10)
          .backgroundColor('#F7F7FB')
        }

        // ── Degraded path: STT NOT_AVAILABLE at capture start ──
        if (this.degradedCapture && this.session.gate === null &&
          this.candidateStatus === CandidateStatus.NONE) {
          Column({ space: 8 }) {
            Text('本地语音暂不可用(NOT_AVAILABLE,无云端回退)。可以直接用下方文本框手动记录,或点关闭。')
              .fontSize(12)
              .fontColor('#555555')
              .width('100%')
            Button('关闭')
              .fontSize(12)
              .fontColor('#555555')
              .backgroundColor('#E0E0E0')
              .onClick(() => {
                this.degradedCapture = false;
                this.session.dismissResult();
                this.refresh();
              })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .padding(10)
          .borderRadius(10)
          .backgroundColor('#F7F7FB')
        }

        // ── Agent conversation (center of the product) ──
        Column({ space: 8 }) {
          ForEach(this.visibleMessages, (msg: AgentMessage) => {
            Text(msg.text)
              .fontSize(13)
              .fontColor(msg.role === 'owner' ? '#1B4F8A' : '#333333')
              .width('100%')
          }, (msg: AgentMessage) => `${msg.at}-${msg.role}`)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(10)
        .borderRadius(10)
        .backgroundColor('#F4F4FA')

        // ── Mic denied / voice unavailable banner (manual path pointed out) ──
        if (this.micState === MicState.PERMISSION_DENIED || this.micState === MicState.PERMISSION_REQUIRED) {
          Column({ space: 6 }) {
            Text(this.micState === MicState.PERMISSION_DENIED
              ? '麦克风权限被拒绝。不授权也能继续:直接用下方文本框手动记录(来源标注为手动文本,不会被当成语音)。'
              : '麦克风未授权。不授权也能继续:直接用下方文本框手动记录(来源标注为手动文本,不会被当成语音);或点上方按钮授权后开始录音。')
              .fontSize(12)
              .fontColor('#7A4A00')
              .width('100%')
            Button('去系统设置开启麦克风(可选)')
              .fontSize(12)
              .fontColor('#555555')
              .backgroundColor('#E0E0E0')
              .onClick(async () => {
                await this.openMicSettings();
              })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .padding(10)
          .borderRadius(10)
          .backgroundColor('#FFF8EC')
        }

        // ── Manual text continuation (permanent, every mic state) ──
        Row({ space: 6 }) {
          TextInput({ text: this.manualText, placeholder: '也可以手动记录一条(文本来源,非语音)' })
            .layoutWeight(1)
            .onChange((v: string) => {
              this.manualText = v;
            })
          Button('记录')
            .fontSize(12)
            .onClick(() => {
              this.saveManualText();
            })
        }
        .width('100%')

        // ── Saved notes & knowledge (provenance within one tap) ──
        Column({ space: 6 }) {
          Text(`已保存的笔记与知识(${this.knowledgeCount})`)
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .width('100%')
          if (this.visibleKnowledge.length === 0) {
            Text('还没有已保存的笔记。录音 → 转写候选 → 整理成笔记 → 保存之后,笔记会出现在这里;点开可查看正文、来源和原始转写。')
              .fontSize(11)
              .fontColor('#999999')
              .width('100%')
          }
          ForEach(this.visibleKnowledge, (item: KnowledgeItem) => {
            Column({ space: 3 }) {
              Row({ space: 6 }) {
                Text(this.knowledgeSourceLabel(item))
                  .fontSize(10)
                  .fontColor(this.knowledgeSourceColor(item))
                  .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                  .borderRadius(6)
                  .border({ width: 1, color: this.knowledgeSourceColor(item) })
                Text(item.title)
                  .fontSize(13)
                  .layoutWeight(1)
                Text(this.formatTime(item.confirmedAt))
                  .fontSize(10)
                  .fontColor('#999999')
              }
              .width('100%')
              if (this.expandedKnowledgeId === item.id) {
                Text(item.text)
                  .fontSize(12)
                  .fontColor('#555555')
                  .width('100%')
                Text(item.source === 'voice'
                  ? `来源:机主本人语音(验证状态 ${item.speakerState}),你明确保存后入库。`
                  : item.source === 'fixture'
                    ? '来源:模拟器 TEST_FIXTURE 演示转写 — 非真实语音识别,非机主身份,真机未验证。'
                    : '来源:手动文本输入(非语音,未做声纹验证)。')
                  .fontSize(10)
                  .fontColor('#999999')
                  .width('100%')
                if (item.originalTranscript.length > 0) {
                  Text(`原始转写:「${item.originalTranscript}」`)
                    .fontSize(11)
                    .fontColor('#777777')
                    .width('100%')
                    .padding(6)
                    .borderRadius(6)
                    .backgroundColor('#F0F0F5')
                }
              }
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .padding(6)
            .borderRadius(8)
            .backgroundColor('#FFFFFF')
            .onClick(() => {
              this.expandedKnowledgeId = this.expandedKnowledgeId === item.id ? '' : item.id;
              this.refresh();
            })
          }, (item: KnowledgeItem) => item.id)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(10)
        .borderRadius(10)
        .backgroundColor('#F0F0F5')

        // ── Simulator test tooling (SECONDARY, collapsed by default) ──
        // KK-03 first-use rule: TEST_FIXTURE tooling must never sit on the
        // primary first-use path; it lives here for development/review only.
        Column({ space: 6 }) {
          Button(this.showSimTools ? '收起模拟器测试工具 ▴' : '模拟器测试工具(次要 · TEST_FIXTURE)▾')
            .fontSize(11)
            .fontColor('#777777')
            .backgroundColor('#EFEFEF')
            .onClick(() => {
              this.showSimTools = !this.showSimTools;
            })
          if (this.showSimTools) {
            Text('模拟器声学链不稳定时,可用明确标注的测试转写演示候选→笔记流程(修正/丢弃/整理/保存)。TEST_FIXTURE ≠ 真实语音识别,不代表机主身份,真机未验证。')
              .fontSize(11)
              .fontColor('#B26A00')
              .width('100%')
            Row({ space: 6 }) {
              TextInput({ text: this.fixtureText, placeholder: '演示转写(留空用默认示例)' })
                .layoutWeight(1)
                .onChange((v: string) => {
                  this.fixtureText = v;
                })
              Button('生成 TEST_FIXTURE 演示候选')
                .fontSize(12)
                .fontColor('#B26A00')
                .enabled(this.candidateStatus === CandidateStatus.NONE &&
                  this.micState !== MicState.RECORDING &&
                  this.noteStatus !== NoteDraftStatus.EDITING)
                .onClick(() => {
                  this.startFixtureDemo();
                })
            }
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        // ── Technical diagnostics (secondary, collapsed by default) ──
        Column({ space: 4 }) {
          Button(this.showDiagnostics ? '收起技术诊断 ▴' : '技术诊断(引擎/模型详情)▾')
            .fontSize(11)
            .fontColor('#777777')
            .backgroundColor('#EFEFEF')
            .onClick(() => {
              this.showDiagnostics = !this.showDiagnostics;
            })
          if (this.showDiagnostics) {
            Text(`STT:${this.sttNote.length > 0 ? this.sttNote : '未初始化'}`)
              .fontSize(11)
              .fontColor('#777777')
              .width('100%')
            Text(`声纹引擎:${this.speakerNote}`)
              .fontSize(11)
              .fontColor('#777777')
              .width('100%')
            Text(this.engineInitText)
              .fontSize(11)
              .fontColor(this.engineInitText.includes('不可用') ? '#C62828' : '#1B6E3C')
              .width('100%')
            Text('离线时:本地链路可用则照常完成;不可用则如实 NOT_AVAILABLE,绝不静默走云端。')
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
      // Scroll centers short content vertically; pinning minHeight keeps the
      // agent header at the top when the page is shorter than the viewport.
      .constraintSize({ minHeight: '100%' })
      .justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAFAFD')
  }
}
