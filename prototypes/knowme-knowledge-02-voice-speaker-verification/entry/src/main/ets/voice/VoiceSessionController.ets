import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import {
  CandidateStatus,
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
    this.speakerState = this.speaker.state();
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
    this.similarity = Number.NaN;
    this.gate = null;
    this.candidateStatus = CandidateStatus.NONE;
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
      this.sttEngineNote = sttResult.errorMessage;
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
    if (!canConfirmCandidate(this.candidateStatus, this.speakerState)) {
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
}
