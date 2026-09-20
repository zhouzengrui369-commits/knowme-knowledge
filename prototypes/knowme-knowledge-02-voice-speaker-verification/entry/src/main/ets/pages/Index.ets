import { common } from '@kit.AbilityKit';
import { CandidateStatus, MicState, SpeakerState, TrustGateDecision } from '../core/VoiceCore';
import { SessionPurpose, VoiceSessionController } from '../voice/VoiceSessionController';
import { SpeakerVerificationController, UnprovisionedSpeakerEngine } from '../voice/SpeakerVerificationController';
import { SherpaSpeakerEngine } from '../engine/SherpaSpeakerEngine';
import { AgentContext, AgentMessage, KnowledgeItem } from '../agent/AgentContext';
import { AgentContextStore } from '../agent/AgentContextStore';

@Entry
@Component
struct Index {
  @State agent: AgentContext = new AgentContext();
  @State session: VoiceSessionController =
    new VoiceSessionController(new SpeakerVerificationController(new UnprovisionedSpeakerEngine()));
  private sherpaEngine: SherpaSpeakerEngine = new SherpaSpeakerEngine();
  private store: AgentContextStore = new AgentContextStore();
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
  @State expandedKnowledgeId: string = '';
  @State tick: number = 0;
  // D12 fix: agent.messages is a plain array on an unobserved class — push()
  // is invisible to @State, so say() between two unchanged values stayed
  // visually stale until an unrelated redraw (the D7 .id() trick did not
  // actually force re-render). Mirror the tail into a real @State array.
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
      case SpeakerState.ENROLLED: return '已注册(本地声纹档案)';
      case SpeakerState.NOT_ENROLLED: return '未注册';
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
    // sampling echo, NOT a capture verdict. Showing NOT_ENROLLED/ENROLLED as
    // "本次验证" re-conflates exactly what PX-KK02-05 separated.
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
    // explicitly confirmed/manual items were ever persisted; rejected,
    // discarded and unconfirmed candidates are absent by construction.
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

  /**
   * D8 fix: returning from a settings round-trip does not re-run
   * aboutToAppear — without this the mic strip kept showing a stale
   * PERMISSION_DENIED after the Owner granted mic in system settings.
   */
  onPageShow(): void {
    this.session.refreshPermission();
    this.refresh();
  }

  private captureButtonLabel(): string {
    // D6 fix: a denied permission must say so on the action itself.
    // R3 (PX-KK02-05): verbs match the real interaction — TAP to start/stop,
    // nothing here is press-and-hold.
    if (this.micState === MicState.PERMISSION_REQUIRED) {
      return '授权麦克风并开始说话';
    }
    if (this.micState === MicState.PERMISSION_DENIED) {
      return '麦克风已拒绝 · 点这里去设置开启';
    }
    return '🎙 点开始说话';
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

  /** R3 (PX-KK02-03): create the disclosed TEST_FIXTURE demo candidate. */
  private startFixtureDemo(): void {
    const text = this.fixtureText.trim().length > 0
      ? this.fixtureText.trim()
      : '今天把语音原型的候选流程完整跑通了一遍';
    if (this.session.startFixtureCandidate(text)) {
      this.fixtureText = '';
      this.agent.say('system', '已生成演示候选(TEST_FIXTURE):这是明确标注的测试转写,不是真实语音识别,也不代表机主身份;仅用于演示修正/拒绝/确认流程,真机未验证。');
    }
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
      Column({ space: 14 }) {
        // ── Agent-first header ───────────────────────────────
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
            Text('灵犀 · KnowME 语音原型')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
            Text(`知识 ${this.knowledgeCount} 条 · 0.1 原型 · 确定性演示(无真实 LLM)`)
              .fontSize(11)
              .fontColor('#777777')
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')

        // ── Simulator / boundary disclosure (normal state, always visible) ──
        // R3 (PX-KK02-05): the simulator / not-real-device / prototype-identity
        // boundary must be understandable on the DEFAULT surface, not only in
        // error or fixture states.
        Column({ space: 3 }) {
          Text('OpenHarmony 模拟器演示环境 · 非 Mate60 真机 · 真机未验证')
            .fontSize(11)
            .fontColor('#A05000')
            .width('100%')
          Text('原型声纹验证 ≠ 生产身份认证 · 全程本地 · 无云端上传')
            .fontSize(11)
            .fontColor('#A05000')
            .width('100%')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(8)
        .borderRadius(8)
        .backgroundColor('#FFF3E0')

        // ── Agent conversation (primary surface) ─────────────
        Column({ space: 8 }) {
          ForEach(this.visibleMessages, (msg: AgentMessage) => {
            Text(msg.text)
              .fontSize(13)
              .fontColor(msg.role === 'owner' ? '#1B4F8A' : '#333333')
              .width('100%')
          }, (msg: AgentMessage) => `${msg.at}-${msg.role}`)
        }
        // D12: visibleMessages is a real @State mirror (see refresh()); the
        // old D7 .id() tick read alone did not re-render pushed messages.
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(10)
        .borderRadius(10)
        .backgroundColor('#F4F4FA')

        // ── Manual text continuation (permanent, every mic state) ──
        // R3 (PX-KK02-02): mic denied / voice unavailable must NOT dead-end
        // the capture task — manual text is one explicit save away, without
        // any microphone reauthorization, labeled by source, never voice.
        Row({ space: 6 }) {
          TextInput({ text: this.manualText, placeholder: '手动记录一条知识(文本来源,非语音)' })
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

        // ── Mic denied / voice unavailable banner (manual path pointed out) ──
        // R3 (PX-KK02-02) + R3-D18: the system collapses "denied" and "never
        // asked" into PERMISSION_REQUIRED after every settings round-trip, so
        // a DENIED-only banner was unreachable. The manual continuation hint
        // must be visible whenever the mic is not ready — the user must never
        // face a capture dead-end.
        if (this.micState === MicState.PERMISSION_DENIED || this.micState === MicState.PERMISSION_REQUIRED) {
          Column({ space: 6 }) {
            Text(this.micState === MicState.PERMISSION_DENIED
              ? '麦克风权限被拒绝。不授权也能继续:直接用上方文本框手动记录(来源标注为手动文本,不会被当成语音)。'
              : '麦克风未授权。不授权也能继续:直接用上方文本框手动记录(来源标注为手动文本,不会被当成语音);或点下方按钮授权后开始说话。')
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

        // ── Saved knowledge inspection (Agent work result) ────
        // R3 (PX-KK02-01/04): confirmed items stay inspectable — same Agent
        // context before and after capture/recovery, recorder console never
        // becomes the product surface.
        Column({ space: 6 }) {
          Text(`已保存的知识(${this.knowledgeCount})`)
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .width('100%')
          if (this.visibleKnowledge.length === 0) {
            Text('还没有已保存的知识。手动文本、或你明确确认后的候选,会出现在这里并可点开查看。')
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
                  ? `来源:机主本人语音(验证状态 ${item.speakerState}),你明确确认后入库。`
                  : item.source === 'fixture'
                    ? '来源:模拟器 TEST_FIXTURE 演示转写 — 非真实语音识别,非机主身份,真机未验证。'
                    : '来源:手动文本输入(非语音,未做声纹验证)。')
                  .fontSize(10)
                  .fontColor('#999999')
                  .width('100%')
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

        // ── Voice capture (capability attached to the Agent) ──
        Column({ space: 8 }) {
          Text('语音捕获(附加能力)')
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .width('100%')
          Text(`麦克风:${this.micLabel()}`)
            .fontSize(12)
            .fontColor(this.micState === MicState.RECORDING ? '#C62828' : '#555555')
            .width('100%')

          if (this.micState === MicState.RECORDING) {
            Row({ space: 10 }) {
              Button('点停止')
                .fontSize(14)
                .backgroundColor('#C62828')
                .onClick(async () => {
                  await this.session.stopSession();
                  if (this.session.purpose === SessionPurpose.ENROLLMENT) {
                    const n = this.session.enrollmentCount;
                    if (n >= 3) {
                      const done = this.session.speaker.completeEnrollment();
                      this.enrollmentText = done ? '注册完成(3/3)' : '注册失败,请重试';
                      // D9 fix: refresh speaker state right after enrollment —
                      // the strip kept saying NOT_ENROLLED next to 注册完成.
                      // R2-D14: the D13-guarded refreshSpeakerState() is skipped
                      // while the enrollment transcript is on screen, so use the
                      // unconditional variant here.
                      this.session.forceRefreshSpeakerState();
                    } else if (n > 0) {
                      this.enrollmentText = `采样 ${n}/3 · 再录 ${3 - n} 句`;
                    } else {
                      this.enrollmentText = '采样无效(太短或引擎未就绪),请重试';
                    }
                  }
                  this.refresh();
                })
              Button('取消')
                .fontSize(14)
                .fontColor('#555555')
                .backgroundColor('#E0E0E0')
                .onClick(async () => {
                  await this.session.cancelSession();
                  this.enrollmentText = '';
                  this.refresh();
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
          } else {
            Button(this.captureButtonLabel())
              .fontSize(15)
              .width('100%')
              .height(48)
              .enabled(this.candidateStatus === CandidateStatus.NONE || this.candidateStatus === CandidateStatus.CONFIRMED ||
                this.candidateStatus === CandidateStatus.REJECTED)
              .onClick(async () => {
                if (!this.session.permission.isGranted()) {
                  await this.session.requestPermission(this.uiContext());
                  this.refresh();
                  if (this.micState !== MicState.PERMISSION_GRANTED) {
                    this.agent.say('system', '麦克风权限未授予,无法录音;可以改用手动文本记录,不丢上下文。');
                    this.refresh();
                    // D6 fix: system may stop re-prompting after denial —
                    // give the Owner a real path forward instead of a dead button.
                    if (this.micState === MicState.PERMISSION_DENIED) {
                      await this.openMicSettings();
                    }
                    return;
                  }
                }
                this.session.backToIdle();
                const started = await this.session.startSession(SessionPurpose.CAPTURE);
                // D10 fix: when STT is NOT_AVAILABLE the session refuses to
                // record at all — without a degraded fallback the Owner has no
                // way to capture anything (offline old-device scenario).
                this.degradedCapture = !started && this.session.micState === MicState.UNAVAILABLE;
                if (this.degradedCapture) {
                  this.agent.say('system', '本地语音识别不可用,录音通道已关闭;可以先用手动文本记录,不丢上下文。');
                }
                this.refresh();
              })
          }

          // ── R3 (PX-KK02-03): disclosed TEST_FIXTURE demo entry ──
          // Always reachable from the visible UI in the declared simulator;
          // never touches thresholds or verification state; the candidate it
          // creates is amber-labeled end to end.
          if (this.candidateStatus === CandidateStatus.NONE && this.micState !== MicState.RECORDING) {
            Column({ space: 6 }) {
              Text('模拟器声学链不稳定时,可用明确标注的测试转写演示候选流程(修正/拒绝/确认)。TEST_FIXTURE ≠ 真实语音识别,不代表机主身份,真机未验证:')
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
                  .onClick(() => {
                    this.startFixtureDemo();
                  })
              }
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }

          // ── Result + trust gate ─────────────────────────────
          if (this.transcript.length > 0 || this.gateText.length > 0) {
            Column({ space: 6 }) {
              if (!this.fixtureDemo) {
                // R3-D19 (second surface): after an ENROLLMENT stop the STT
                // echo is a sampling echo, not a capture verdict — never
                // render the archive/enrollment state as "本次验证".
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
                Text('⚠ TEST_FIXTURE:这段"转写"是模拟器测试代理文本,不是真实语音识别;仅用于演示候选流程。真机未验证。')
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

          // ── Candidate card (correct / reject / explicit confirm) ──
          if (this.candidateStatus === CandidateStatus.DRAFT || this.candidateStatus === CandidateStatus.CORRECTED) {
            Column({ space: 8 }) {
              Text(this.fixtureActive ? '候选知识(TEST_FIXTURE 测试转写 · 未入库 · 待你确认)' : '候选知识(未入库 · 待你确认)')
                .fontSize(13)
                .fontWeight(FontWeight.Medium)
              if (this.fixtureDemo) {
                Text('演示候选:与声纹验证无关,不创建任何机主身份结论;确认后按 TEST_FIXTURE 来源入库(+1),拒绝则不变(+0)。')
                  .fontSize(11)
                  .fontColor('#B26A00')
                  .width('100%')
              }
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
                Button('确认入库')
                  .fontSize(12)
                  .backgroundColor('#1B6E3C')
                  .onClick(() => {
                    const text = this.session.confirmCandidate();
                    if (text.length > 0) {
                      this.agent.confirmVoiceCandidate(text, this.session.speakerState, this.session.fixtureTranscript);
                    }
                    this.session.dismissResult();
                    this.refresh();
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
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .padding(10)
            .borderRadius(10)
            .backgroundColor('#FFFFFF')
            .border({ width: 1, color: '#DDDDDD' })
          }

          // ── Blocked path: retry / discard (+ legacy fixture injection) ──
          if (this.session.gate !== null && this.session.gate !== TrustGateDecision.CANDIDATE_ALLOWED &&
            this.candidateStatus === CandidateStatus.NONE) {
            Column({ space: 8 }) {
              Text('这段语音不会进入知识。你可以重说、丢弃,或直接用上方文本框手动记录:')
                .fontSize(12)
                .fontColor('#555555')
              Row({ space: 8 }) {
                Button('重说一次')
                  .fontSize(12)
                  .onClick(async () => {
                    this.session.backToIdle();
                    await this.session.startSession(SessionPurpose.CAPTURE);
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
              // VERIFIED and the sole blocker is missing STT transcript. Lets
              // the Owner exercise the full candidate flow in the simulator
              // without ever presenting fixture text as real recognition.
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
          }

          // ── Degraded path: STT NOT_AVAILABLE at capture start ──
          // D10 fix: no recording possible, but knowledge capture must not
          // dead-end — manual text entry stays available with Agent context.
          if (this.degradedCapture && this.session.gate === null &&
            this.candidateStatus === CandidateStatus.NONE) {
            Column({ space: 8 }) {
              Text('本地语音暂不可用(NOT_AVAILABLE,无云端回退)。可以直接用上方文本框手动记录,或点关闭。')
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
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(10)
        .borderRadius(10)
        .backgroundColor('#F7F7FB')

        // ── Enrollment & trust (archive ≠ current verdict) ────
        Column({ space: 6 }) {
          Text('机主声纹(原型验证,非生产身份认证)')
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .width('100%')
          // R3 (PX-KK02-05): two separate rows — the persistent enrollment
          // archive and the per-capture verdict are different facts.
          Text(`注册档案:${this.enrollmentArchiveText}` +
            (this.enrollmentText.length > 0 ? ` · ${this.enrollmentText}` : ''))
            .fontSize(12)
            .width('100%')
          Text(`本次验证:${this.verdictText}`)
            .fontSize(12)
            .fontColor('#555555')
            .width('100%')
          Row({ space: 8 }) {
            Button('开始注册采样')
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
                  this.enrollmentText = `采样 ${this.session.enrollmentCount}/3 · 请朗读一句中文,说完点停止`;
                }
                this.refresh();
              })
            Button('重置声纹')
              .fontSize(12)
              .fontColor('#C62828')
              .enabled(this.micState !== MicState.RECORDING)
              .onClick(() => {
                // R2-D15: destructive reset must be confirmed. A single
                // accidental tap (e.g. stale-coordinate touch after the
                // message list shifts the layout) used to wipe the on-device
                // voiceprint profile irreversibly.
                AlertDialog.show({
                  title: '重置机主声纹?',
                  message: '将删除本机声纹档案,不可恢复;已入库的知识条目不受影响。',
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
                      // R2-D14: reset must always update the strip, even while
                      // an old transcript/result is still on screen.
                      // R2-D17: and the old result (similarity/duration) belongs
                      // to the deleted voiceprint — clear it with the reset.
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
        .padding(10)
        .borderRadius(10)
        .backgroundColor('#F7F7FB')

        // ── Technical diagnostics (secondary, collapsed by default) ──
        // R3 (PX-KK02-04): diagnostics stay available but must not dominate
        // the default product surface.
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
