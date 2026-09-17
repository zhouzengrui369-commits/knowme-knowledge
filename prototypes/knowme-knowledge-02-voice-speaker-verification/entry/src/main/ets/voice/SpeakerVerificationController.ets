import { hilog } from '@kit.PerformanceAnalysisKit';
import { common } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';
import {
  averageEmbedding,
  cosineSimilarity,
  SpeakerState,
  speakerStateFromScore
} from '../core/VoiceCore';

const DOMAIN = 0x0200;
const TAG = 'KnowMEVoice.Speaker';

/**
 * On-device speaker embedding engine interface. The concrete engine
 * (sherpa-onnx SpeakerEmbeddingExtractor via sherpa_onnx.har, model
 * 3dspeaker_speech_eres2net_base_200k_sv_zh-cn_16k-common.onnx) is injected;
 * until it is provisioned the controller honestly reports NOT_AVAILABLE —
 * never a silent substitute.
 */
export interface ISpeakerEmbeddingEngine {
  engineIdentity(): string;
  isReady(): boolean;
  /** Extract one embedding from 16 kHz mono s16le PCM. Empty array on failure. */
  extract(pcm: Uint8Array): number[];
}

/** Placeholder used before the sherpa-onnx har/model is provisioned. */
export class UnprovisionedSpeakerEngine implements ISpeakerEmbeddingEngine {
  engineIdentity(): string {
    return 'NOT_PROVISIONED (sherpa-onnx eres2net zh-cn model pending)';
  }

  isReady(): boolean {
    return false;
  }

  extract(pcm: Uint8Array): number[] {
    return [];
  }
}

interface EnrollmentProfile {
  embedding: number[];
  sampleCount: number;
  createdAt: number;
  engineIdentity: string;
}

/** Verification verdict (declared class per ArkTS rules). */
export class VerifyVerdict {
  state: SpeakerState;
  similarity: number;

  constructor(state: SpeakerState, similarity: number) {
    this.state = state;
    this.similarity = similarity;
  }
}

/**
 * Owner enrollment + prototype verification.
 *
 * Privacy: the averaged embedding is stored ONLY in the app-private sandbox
 * (deleted on uninstall), never leaves the device, never enters git, and is
 * fully reversible via resetEnrollment(). The UI must disclose that this is
 * PROTOTYPE_VERIFICATION, not production authentication.
 */
export class SpeakerVerificationController {
  private engine: ISpeakerEmbeddingEngine;
  private profile: EnrollmentProfile | null = null;
  private enrollmentSamples: number[][] = [];
  private storePath = '';
  static readonly ENROLLMENT_SAMPLE_TARGET = 3;
  static readonly MIN_PCM_BYTES = 16000 * 2; // ≥ 1 s of speech

  constructor(engine: ISpeakerEmbeddingEngine) {
    this.engine = engine;
  }

  setEngine(engine: ISpeakerEmbeddingEngine): void {
    this.engine = engine;
  }

  engineIdentity(): string {
    return this.engine.engineIdentity();
  }

  engineReady(): boolean {
    return this.engine.isReady();
  }

  initStorage(context: common.UIAbilityContext): void {
    this.storePath = `${context.filesDir}/kk02_speaker_profile.json`;
    this.loadProfile();
  }

  state(): SpeakerState {
    if (!this.engine.isReady()) {
      return SpeakerState.NOT_AVAILABLE;
    }
    return this.profile ? SpeakerState.ENROLLED : SpeakerState.NOT_ENROLLED;
  }

  isEnrolled(): boolean {
    return this.profile !== null;
  }

  enrollmentProgress(): number {
    return this.enrollmentSamples.length;
  }

  /** Add one enrollment utterance; returns samples collected so far. */
  addEnrollmentSample(pcm: Uint8Array): number {
    if (!this.engine.isReady() || pcm.length < SpeakerVerificationController.MIN_PCM_BYTES) {
      return this.enrollmentSamples.length;
    }
    const emb = this.engine.extract(pcm);
    if (emb.length > 0) {
      this.enrollmentSamples.push(emb);
    }
    return this.enrollmentSamples.length;
  }

  /** Complete enrollment (averages samples, persists locally). */
  completeEnrollment(): boolean {
    if (this.enrollmentSamples.length === 0 || !this.engine.isReady()) {
      return false;
    }
    const averaged = averageEmbedding(this.enrollmentSamples);
    if (averaged.length === 0) {
      return false;
    }
    this.profile = {
      embedding: averaged,
      sampleCount: this.enrollmentSamples.length,
      createdAt: Date.now(),
      engineIdentity: this.engine.engineIdentity()
    };
    this.enrollmentSamples = [];
    this.persistProfile();
    return true;
  }

  cancelEnrollment(): void {
    this.enrollmentSamples = [];
  }

  /** Full reversible reset: removes in-memory and on-disk profile. */
  resetEnrollment(): void {
    this.profile = null;
    this.enrollmentSamples = [];
    if (this.storePath.length > 0) {
      try {
        if (fileIo.accessSync(this.storePath)) {
          fileIo.unlinkSync(this.storePath);
        }
      } catch (e) {
        hilog.warn(DOMAIN, TAG, `profile unlink warn: ${JSON.stringify(e)}`);
      }
    }
  }

  /**
   * Verify a fresh utterance against the enrolled profile.
   * Returns the contract speaker state + the raw similarity for the
   * sanitized sample matrix (never the embedding itself).
   */
  verify(pcm: Uint8Array): VerifyVerdict {
    if (!this.engine.isReady()) {
      return new VerifyVerdict(SpeakerState.NOT_AVAILABLE, Number.NaN);
    }
    if (!this.profile) {
      return new VerifyVerdict(SpeakerState.NOT_ENROLLED, Number.NaN);
    }
    if (pcm.length < SpeakerVerificationController.MIN_PCM_BYTES) {
      return new VerifyVerdict(SpeakerState.UNCERTAIN, Number.NaN);
    }
    const emb = this.engine.extract(pcm);
    if (emb.length === 0) {
      return new VerifyVerdict(SpeakerState.UNCERTAIN, Number.NaN);
    }
    const score = cosineSimilarity(emb, this.profile.embedding);
    return new VerifyVerdict(speakerStateFromScore(score), score);
  }

  private persistProfile(): void {
    if (this.storePath.length === 0 || !this.profile) {
      return;
    }
    try {
      const file = fileIo.openSync(this.storePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC);
      fileIo.writeSync(file.fd, JSON.stringify(this.profile));
      fileIo.closeSync(file);
    } catch (e) {
      hilog.error(DOMAIN, TAG, `profile persist failed: ${JSON.stringify(e)}`);
    }
  }

  private loadProfile(): void {
    if (this.storePath.length === 0) {
      return;
    }
    try {
      if (!fileIo.accessSync(this.storePath)) {
        return;
      }
      const file = fileIo.openSync(this.storePath, fileIo.OpenMode.READ_ONLY);
      const buffer = new ArrayBuffer(1024 * 1024);
      const len = fileIo.readSync(file.fd, buffer);
      fileIo.closeSync(file);
      const text = String.fromCharCode(...new Uint8Array(buffer.slice(0, len)));
      this.profile = JSON.parse(text) as EnrollmentProfile;
    } catch (e) {
      hilog.warn(DOMAIN, TAG, `profile load warn: ${JSON.stringify(e)}`);
      this.profile = null;
    }
  }
}
