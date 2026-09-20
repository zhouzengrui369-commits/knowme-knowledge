import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import {
  CandidateStatus,
  CandidateTrustClass,
  MicState,
  SpeakerState,
  TrustGateDecision,
  canConfirmCandidate,
  statusAfterCorrection,
  trustGateDecision
} from '../core/VoiceCore';
import { PermissionController } from './PermissionController';
import { AudioCaptureController } from './AudioCaptureController';
import { SpeechToTextController } from './SpeechToTextController';
import { SpeakerVerificationController } from './SpeakerVerificationController';

const DOMAIN = 0x0200;
const TAG = 'KnowMEVoice.Session';

export interface VoiceSessionOutcome {
  micState: MicState;
  speakerState: SpeakerState;
  similarity: number;
  transcript: string;
  sttError: string;
  gate: TrustGateDecision;
  candidateStatus: CandidateStatus;
  /** capture-stop → visible-result latency in ms (AO-08 evidence). */
  stopToResultMs: number;
  durationMs: number;
}

export type SessionEvent =
  | 'STATE_CHANGED'
  | 'TRANSCRIPT_PARTIAL'
  | 'SESSION_DONE';

export type SessionListener = (event: SessionEvent) => void;

export enum SessionPurpose {
  CAPTURE = 'CAPTURE',
  ENROLLMENT = 'ENROLLMENT'
}

/**
 * Orchestrates one voice session:
 * permission → recording (PCM → STT frames + session buffer) → stop →
 * transcript + speaker verification → trust gate → optional candidate.
 * All honesty/trust rules come from VoiceCore; this class never overrides
 * a blocking decision.
 */
export class VoiceSessionController {
  readonly permission = new PermissionController();
  private capture = new AudioCaptureController();
  private stt = new SpeechToTextController();
  readonly speaker: SpeakerVerificationController;

  micState: MicState = MicState.IDLE;
  speakerState: SpeakerState = SpeakerState.NOT_ENROLLED;
  transcript = '';
  /** R2: true when transcript is a disclosed simulator TEST_FIXTURE, never real STT. */
  fixtureTranscript = false;
  /**
   * R3 (PX-KK02-03): true when the current candidate came from the direct,
   * always-reachable disclosed TEST_FIXTURE demo entry (no capture ran, no
   * speaker verdict exists). Such candidates are trust-class FIXTURE: they
   * claim no speaker identity and confirm exactly like manual text; the real
   * VOICE trust gate is untouched.
   */
  fixtureDemo = false;
  similarity: number = Number.NaN;
  sttEngineNote = '';
  speakerEngineNote = '';
  gate: TrustGateDecision | null = null;
  candidateStatus: CandidateStatus = CandidateStatus.NONE;
  purpose: SessionPurpose = SessionPurpose.CAPTURE;
  enrollmentCount = 0;
  lastStopToResultMs = -1;
  lastDurationMs = -1;

  private recordingStartedAt = 0;
  private listener: SessionListener = () => {};

  constructor(speaker: SpeakerVerificationController) {
    this.speaker = speaker;
    this.speakerEngineNote = speaker.engineIdentity();
    this.capture.onFrame = (frame) => {
      this.stt.pushFrame(frame);
    };
    this.capture.onError = (message) => {
      // D3 fix: keep error attribution honest — a microphone failure must not
      // be displayed as an STT/engine problem.
      this.sttEngineNote = `麦克风:${message}`;
    };
  }

  onEvent(listener: SessionListener): void {
    this.listener = listener;
  }

  private emit(event: SessionEvent): void {
    this.listener(event);
  }

  refreshSpeakerState(): void {
    // D13 fix: onPageShow → refreshPermission() used to clobber a live
    // post-capture verdict (VERIFIED/UNCERTAIN) back to the enrollment state
    // (ENROLLED) while the result card still showed the old similarity —
    // the strip then contradicted itself. Only revert to enrollment state
    // when no result is on screen.
    if (this.gate === null && this.transcript.length === 0 &&
      this.candidateStatus === CandidateStatus.NONE) {
      this.speakerState = this.speaker.state();
    }
  }

  /**
   * R2-D14 fix: unconditional speaker-state refresh for enrollment-lifecycle
   * transitions (completeEnrollment / resetEnrollment). The D13 guard above
   * must NOT apply here: an enrollment session leaves a transcript on screen,
   * which blocked the guard and left the strip saying NOT_ENROLLED next to
   * 注册完成(3/3) — the strip contradicted itself again. There is no
   * trust-gate verdict to protect in these contexts.
   */
  forceRefreshSpeakerState(): void {
    this.speakerState = this.speaker.state();
  }

  /**
   * R2-D17 (D-LE-02): voiceprint reset must also clear any on-screen capture
   * result. After resetEnrollment the strip said NOT_ENROLLED while the old
   * similarity (e.g. 0.762) was still displayed — a verdict that belongs to
   * the deleted voiceprint, contradicting the strip on the same line.
   * Enrollment-lifecycle transition: no trust-gate verdict needs protecting.
   */
  clearResultForReset(): void {
    this.transcript = '';
    this.fixtureTranscript = false;
    this.fixtureDemo = false;
    this.similarity = Number.NaN;
    this.lastStopToResultMs = -1;
    this.gate = null;
    this.candidateStatus = CandidateStatus.NONE;
    this.speakerState = this.speaker.state();
    this.emit('STATE_CHANGED');
  }

  /** Journey A: surface honest permission state before any capture. */
  refreshPermission(): void {
    if (this.micState !== MicState.RECORDING) {
      this.micState = this.permission.currentState();
    }
    this.refreshSpeakerState();
    this.emit('STATE_CHANGED');
  }

  async requestPermission(context: common.UIAbilityContext): Promise<void> {
    this.micState = await this.permission.requestFromUser(context);
    this.emit('STATE_CHANGED');
  }

  sttAvailable(): boolean {
    return SpeechToTextController.capabilityAvailable();
  }

  /** Start capture. Returns false (with honest state) when it cannot. */
  async startSession(purpose: SessionPurpose): Promise<boolean> {
    // D4 fix: no re-entry while a session is live — a second start would
    // silently reset buffers of the in-flight recording.
    if (this.micState === MicState.RECORDING) {
      return false;
    }
    this.purpose = purpose;
    if (!this.permission.isGranted()) {
      this.micState = MicState.PERMISSION_REQUIRED;
      this.emit('STATE_CHANGED');
      return false;
    }
    const sttReady = await this.stt.init();
    if (!sttReady) {
      this.sttEngineNote = '本地语音识别不可用 (NOT_AVAILABLE,无云端回退)';
      if (purpose === SessionPurpose.CAPTURE) {
        this.micState = MicState.UNAVAILABLE;
        this.emit('STATE_CHANGED');
        return false;
      }
      // Enrollment does not need STT.
    } else {
      this.sttEngineNote = 'CoreSpeechKit 离线中文 (on-device,无云端)';
    }
    const started = await this.capture.start();
    if (!started) {
      this.micState = MicState.UNAVAILABLE;
      this.emit('STATE_CHANGED');
      return false;
    }
    if (sttReady) {
      // D5 fix: surface a beginSession failure honestly instead of recording
      // on with no transcript while the note still claims the engine is ready.
      const begun = this.stt.beginSession();
      if (!begun) {
        this.sttEngineNote = 'STT 会话启动失败(本地引擎拒绝开始,无云端回退)';
      }
    }
    this.micState = MicState.RECORDING;
    this.recordingStartedAt = Date.now();
    this.transcript = '';
    this.fixtureTranscript = false;
    this.fixtureDemo = false;
    this.similarity = Number.NaN;
    this.gate = null;
    this.candidateStatus = CandidateStatus.NONE;
    this.emit('STATE_CHANGED');
    return true;
  }

  /**
   * R3 (PX-KK02-03): direct, always-reachable disclosed TEST_FIXTURE demo
   * candidate. The simulator's acoustic path cannot repeatably produce a
   * usable VERIFIED+transcript candidate, so the contract allows a clearly
   * disclosed fixture route through visible UI — without touching thresholds
   * or internal verification state.
   *
   * Hard rules:
   *  - no capture/session may be live and no candidate may be on screen;
   *  - no speaker verdict is created or implied (speakerState untouched,
   *    gate stays null — there is NO trust-gate pass to show);
   *  - the fixture flag follows the candidate through confirm → knowledge;
   *  - correction, reject and explicit confirm stay separate operations;
   *  - reject increments knowledge by 0, confirm by exactly +1 (via the
   *    Agent layer with source=fixture, never "verified voice").
   */
  startFixtureCandidate(text: string): boolean {
    const trimmed = text.trim();
    if (this.micState === MicState.RECORDING ||
      this.candidateStatus !== CandidateStatus.NONE ||
      trimmed.length === 0) {
      return false;
    }
    this.purpose = SessionPurpose.CAPTURE;
    this.micState = MicState.IDLE;
    this.transcript = trimmed;
    this.fixtureTranscript = true;
    this.fixtureDemo = true;
    this.similarity = Number.NaN;
    this.lastStopToResultMs = -1;
    this.gate = null;
    this.candidateStatus = CandidateStatus.DRAFT;
    this.emit('STATE_CHANGED');
    return true;
  }

  /**
   * R2 contract: disclosed simulator TEST_FIXTURE transcript. Legal only when
   * a real capture ran, the speaker verdict is VERIFIED, and STT produced
   * nothing (BLOCKED_NOT_AVAILABLE — simulator lacks a usable offline model).
   * Never presented as real recognition; the fixture flag follows the
   * transcript through candidate → knowledge and every UI surface.
   */
  injectFixtureTranscript(text: string): boolean {
    const trimmed = text.trim();
    if (this.purpose !== SessionPurpose.CAPTURE ||
      this.micState !== MicState.STOPPED ||
      this.speakerState !== SpeakerState.VERIFIED ||
      this.transcript.length > 0 || trimmed.length === 0 ||
      this.gate !== TrustGateDecision.BLOCKED_NOT_AVAILABLE) {
      return false;
    }
    this.transcript = trimmed;
    this.fixtureTranscript = true;
    // Route through the same VoiceCore rule — the speaker trust boundary is
    // unchanged; only the transcript source is a disclosed fixture.
    this.gate = trustGateDecision(this.speakerState, true);
    this.candidateStatus = this.gate === TrustGateDecision.CANDIDATE_ALLOWED
      ? CandidateStatus.DRAFT
      : CandidateStatus.NONE;
    this.emit('STATE_CHANGED');
    return true;
  }

  /** Stop capture → STT finalize → speaker verify → trust gate. */
  async stopSession(): Promise<VoiceSessionOutcome> {
    const stoppedAt = Date.now();
    this.lastDurationMs = stoppedAt - this.recordingStartedAt;
    const pcm = await this.capture.stop();
    const sttResult = await this.stt.finishSession();
    this.transcript = sttResult.transcript;
    if (sttResult.errorMessage.length > 0) {
      // R2-D16 (D-LE-01): a partial STT failure must not overwrite the
      // engine-disclosure copy when the transcript actually succeeded —
      // otherwise the strip claims "STT 错误" while a real transcript is
      // on screen, and the no-cloud disclosure disappears. Compose both
      // facts honestly instead.
      if (sttResult.transcript.length > 0) {
        this.sttEngineNote = 'CoreSpeechKit 离线中文 (on-device,无云端) · 转写成功,' +
          `但会话收尾报错已如实记录:${sttResult.errorMessage}`;
      } else {
        this.sttEngineNote = sttResult.errorMessage;
      }
    }

    if (this.purpose === SessionPurpose.ENROLLMENT) {
      const n = this.speaker.addEnrollmentSample(pcm);
      this.enrollmentCount = n;
      this.speakerState = this.speaker.state();
      this.gate = null;
      this.candidateStatus = CandidateStatus.NONE;
    } else {
      const verdict = this.speaker.verify(pcm);
      this.speakerState = verdict.state;
      this.similarity = verdict.similarity;
      this.gate = trustGateDecision(verdict.state, this.transcript.length > 0);
      this.candidateStatus = this.gate === TrustGateDecision.CANDIDATE_ALLOWED
        ? CandidateStatus.DRAFT
        : CandidateStatus.NONE;
    }

    this.micState = MicState.STOPPED;
    this.lastStopToResultMs = Date.now() - stoppedAt;
    this.emit('SESSION_DONE');
    return this.currentOutcome();
  }

  /** Cancel: discard audio, no transcript, no candidate, back to idle. */
  async cancelSession(): Promise<void> {
    await this.capture.cancel();
    await this.stt.cancelSession();
    this.micState = MicState.IDLE;
    this.transcript = '';
    this.fixtureTranscript = false;
    this.fixtureDemo = false;
    this.similarity = Number.NaN;
    this.gate = null;
    this.candidateStatus = CandidateStatus.NONE;
    this.refreshSpeakerState();
    this.emit('STATE_CHANGED');
  }

  backToIdle(): void {
    this.micState = MicState.IDLE;
    this.emit('STATE_CHANGED');
  }

  currentOutcome(): VoiceSessionOutcome {
    return {
      micState: this.micState,
      speakerState: this.speakerState,
      similarity: this.similarity,
      transcript: this.transcript,
      sttError: this.sttEngineNote,
      gate: this.gate ?? TrustGateDecision.BLOCKED_NOT_AVAILABLE,
      candidateStatus: this.candidateStatus,
      stopToResultMs: this.lastStopToResultMs,
      durationMs: this.lastDurationMs
    };
  }

  /** Candidate flow — identical semantics to accepted GOAL-KK-01: correct→candidate, confirm→ingest. */
  correctCandidate(newText: string): boolean {
    if (this.candidateStatus !== CandidateStatus.DRAFT && this.candidateStatus !== CandidateStatus.CORRECTED) {
      return false;
    }
    this.transcript = newText;
    this.candidateStatus = statusAfterCorrection(this.candidateStatus);
    this.emit('STATE_CHANGED');
    return true;
  }

  /** Returns the confirmed text when ingestion is allowed; empty string otherwise. */
  confirmCandidate(): string {
    const trustClass = this.fixtureDemo ? CandidateTrustClass.FIXTURE : CandidateTrustClass.VOICE;
    if (!canConfirmCandidate(this.candidateStatus, this.speakerState, trustClass)) {
      hilog.warn(DOMAIN, TAG, 'confirm blocked by trust gate');
      return '';
    }
    this.candidateStatus = CandidateStatus.CONFIRMED;
    this.emit('STATE_CHANGED');
    return this.transcript;
  }

  rejectCandidate(): void {
    if (this.candidateStatus === CandidateStatus.DRAFT || this.candidateStatus === CandidateStatus.CORRECTED) {
      this.candidateStatus = CandidateStatus.REJECTED;
      this.emit('STATE_CHANGED');
    }
  }

  /**
   * D11 fix: the Owner has disposed of the outcome (confirm / reject /
   * discard / manual-text record) — clear gate + transcript + similarity so
   * the result/blocked/candidate cards do not linger as stale UI.
   */
  dismissResult(): void {
    // R3-D21: disposing an outcome must not clobber an honest permission
    // state. A manual-text record while PERMISSION_DENIED / PERMISSION_REQUIRED
    // used to force IDLE, which hid the denied banner and the settings deep
    // link until the next page show — the mic line read "空闲" while recording
    // was still impossible. Only a completed capture (STOPPED) returns to IDLE.
    if (this.micState === MicState.STOPPED) {
      this.micState = MicState.IDLE;
    }
    this.transcript = '';
    this.fixtureTranscript = false;
    this.fixtureDemo = false;
    this.similarity = Number.NaN;
    this.gate = null;
    this.candidateStatus = CandidateStatus.NONE;
    this.emit('STATE_CHANGED');
  }
}
