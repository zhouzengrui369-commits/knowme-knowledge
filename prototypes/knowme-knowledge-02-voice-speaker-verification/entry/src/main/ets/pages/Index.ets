import { common } from '@kit.AbilityKit';
import { CandidateStatus, MicState, SpeakerState, TrustGateDecision } from '../core/VoiceCore';
import { SessionPurpose, VoiceSessionController } from '../voice/VoiceSessionController';
import { SpeakerVerificationController, UnprovisionedSpeakerEngine } from '../voice/SpeakerVerificationController';
import { AgentContext, AgentMessage } from '../agent/AgentContext';

@Entry
@Component
struct Index {
  @State agent: AgentContext = new AgentContext();
  @State session: VoiceSessionController =
    new VoiceSessionController(new SpeakerVerificationController(new UnprovisionedSpeakerEngine()));
  @State micState: string = MicState.IDLE;
  @State speakerState: string = SpeakerState.NOT_ENROLLED;
  @State transcript: string = '';
  @State similarityText: string = '';
  @State gateText: string = '';
  @State candidateStatus: string = CandidateStatus.NONE;
  @State enrollmentText: string = '';
  @State sttNote: string = '';
  @State speakerNote: string = '';
  @State knowledgeCount: number = 0;
  @State correctedText: string = '';
  @State manualText: string = '';
  @State tick: number = 0;

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

  aboutToAppear(): void {
    this.session.speaker.initStorage(this.uiContext());
    this.session.onEvent(() => {
      this.refresh();
    });
    this.session.refreshPermission();
    this.refresh();
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

        // ── Conversation (Agent context preserved) ──────────
        Column({ space: 8 }) {
          ForEach(this.agent.messages.slice(-4), (msg: AgentMessage) => {
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

        // ── Mic / capability honesty strip ──────────────────
        Column({ space: 4 }) {
          Text(`麦克风:${this.micLabel()}`)
            .fontSize(13)
            .fontColor(this.micState === MicState.RECORDING ? '#C62828' : '#333333')
          Text(`STT:${this.sttNote.length > 0 ? this.sttNote : '未初始化'}`)
            .fontSize(11)
            .fontColor('#777777')
          Text(`声纹:${this.speakerNote}`)
            .fontSize(11)
            .fontColor('#777777')
          Text('原型声纹验证 ≠ 生产身份认证 · 全程本地 · 无云端上传')
            .fontSize(11)
            .fontColor('#A05000')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(10)
        .borderRadius(10)
        .backgroundColor('#FFF8EC')

        // ── Enrollment ──────────────────────────────────────
        Column({ space: 6 }) {
          Text(`机主声纹:${this.speakerState}` +
            (this.enrollmentText.length > 0 ? ` · ${this.enrollmentText}` : ''))
            .fontSize(13)
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
                this.session.speaker.resetEnrollment();
                this.session.refreshSpeakerState();
                this.enrollmentText = '已重置';
                this.refresh();
              })
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        // ── Voice capture controls ──────────────────────────
        if (this.micState === MicState.RECORDING) {
          Row({ space: 10 }) {
            Button('停止')
              .fontSize(14)
              .backgroundColor('#C62828')
              .onClick(async () => {
                await this.session.stopSession();
                if (this.session.purpose === SessionPurpose.ENROLLMENT) {
                  const n = this.session.enrollmentCount;
                  if (n >= 3) {
                    const done = this.session.speaker.completeEnrollment();
                    this.enrollmentText = done ? '注册完成(3/3)' : '注册失败,请重试';
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
          Button(this.micState === MicState.PERMISSION_REQUIRED ? '授权并按住说话' : '🎙 开始说话')
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
                  this.agent.say('system', '麦克风权限未授予,无法录音。');
                  this.refresh();
                  return;
                }
              }
              this.session.backToIdle();
              await this.session.startSession(SessionPurpose.CAPTURE);
              this.refresh();
            })
        }

        // ── Result + trust gate ─────────────────────────────
        if (this.transcript.length > 0 || this.gateText.length > 0) {
          Column({ space: 6 }) {
            Text(`说话人:${this.speakerState} · 相似度 ${this.similarityText}` +
              (this.session.lastStopToResultMs >= 0 ? ` · 停止→结果 ${this.session.lastStopToResultMs}ms` : ''))
              .fontSize(12)
              .fontColor('#555555')
            if (this.transcript.length > 0) {
              Text(`转写:「${this.transcript}」`)
                .fontSize(14)
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
            Text('候选知识(未入库 · 待你确认)')
              .fontSize(13)
              .fontWeight(FontWeight.Medium)
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
                    this.agent.confirmVoiceCandidate(text, this.session.speakerState);
                  }
                  this.refresh();
                })
              Button('丢弃')
                .fontSize(12)
                .fontColor('#C62828')
                .onClick(() => {
                  this.session.rejectCandidate();
                  this.agent.explainRejected();
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

        // ── Blocked path: discard / retry / manual text ─────
        if (this.session.gate !== null && this.session.gate !== TrustGateDecision.CANDIDATE_ALLOWED &&
          this.candidateStatus === CandidateStatus.NONE) {
          Column({ space: 8 }) {
            Text('这段语音不会进入知识。你可以:')
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
                  this.session.backToIdle();
                  this.refresh();
                })
            }
            Row({ space: 6 }) {
              TextInput({ text: this.manualText, placeholder: '或改用手动文本' })
                .layoutWeight(1)
                .onChange((v: string) => {
                  this.manualText = v;
                })
              Button('记录')
                .fontSize(12)
                .onClick(() => {
                  if (this.manualText.trim().length > 0) {
                    this.agent.addTextNote(this.manualText.trim());
                    this.manualText = '';
                    this.session.backToIdle();
                    this.refresh();
                  }
                })
            }
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }

        Text('离线时:本地链路可用则照常完成;不可用则如实 NOT_AVAILABLE,绝不静默走云端。')
          .fontSize(11)
          .fontColor('#999999')
          .width('100%')
      }
      .width('100%')
      .padding(16)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAFAFD')
  }
}
