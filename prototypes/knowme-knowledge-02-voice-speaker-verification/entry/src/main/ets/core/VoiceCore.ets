/**
 * GOAL-KK-02 pure core logic — no @kit imports.
 * Owns: mic/capture state machine, speaker-verification trust semantics,
 * trust-gate decisions, candidate-flow rules, PCM frame chunking, cosine
 * similarity. Everything here is deterministic and unit-testable.
 *
 * Contract semantics (frozen):
 *  - NOT_VERIFIED / UNCERTAIN / NOT_AVAILABLE never auto-confirm, never
 *    silently ingest knowledge.
 *  - VERIFIED may enter the candidate flow but STILL requires Owner explicit
 *    confirm before knowledge-context growth.
 *  - Microphone activity is never implied while idle / denied / unavailable.
 */

export enum MicState {
  IDLE = 'IDLE',
  PERMISSION_REQUIRED = 'PERMISSION_REQUIRED',
  PERMISSION_GRANTED = 'PERMISSION_GRANTED',
  PERMISSION_DENIED = 'PERMISSION_DENIED',
  RECORDING = 'RECORDING',
  STOPPED = 'STOPPED',
  UNAVAILABLE = 'UNAVAILABLE'
}

export enum SpeakerState {
  NOT_ENROLLED = 'NOT_ENROLLED',
  ENROLLING = 'ENROLLING',
  ENROLLED = 'ENROLLED',
  VERIFIED = 'VERIFIED',
  NOT_VERIFIED = 'NOT_VERIFIED',
  UNCERTAIN = 'UNCERTAIN',
  NOT_AVAILABLE = 'NOT_AVAILABLE'
}

export enum CandidateStatus {
  NONE = 'NONE',
  DRAFT = 'DRAFT',
  CORRECTED = 'CORRECTED',
  CONFIRMED = 'CONFIRMED',
  REJECTED = 'REJECTED'
}

export enum TrustGateDecision {
  CANDIDATE_ALLOWED = 'CANDIDATE_ALLOWED',
  BLOCKED_NOT_VERIFIED = 'BLOCKED_NOT_VERIFIED',
  BLOCKED_UNCERTAIN = 'BLOCKED_UNCERTAIN',
  BLOCKED_NOT_AVAILABLE = 'BLOCKED_NOT_AVAILABLE',
  BLOCKED_NOT_ENROLLED = 'BLOCKED_NOT_ENROLLED'
}

/**
 * Speaker-verification similarity thresholds (cosine on eres2net embeddings).
 * Values are Engineering-tuned on the real device benchmark; the mapping
 * rule itself is contract-frozen: an uncertain band must exist and must NOT
 * resolve to trust.
 */
export const SPEAKER_THRESHOLD_VERIFIED: number = 0.62;
export const SPEAKER_THRESHOLD_UNCERTAIN_FLOOR: number = 0.45;

/** Map a cosine similarity score to a contract speaker state. */
export function speakerStateFromScore(score: number): SpeakerState {
  if (Number.isNaN(score)) {
    return SpeakerState.UNCERTAIN;
  }
  if (score >= SPEAKER_THRESHOLD_VERIFIED) {
    return SpeakerState.VERIFIED;
  }
  if (score >= SPEAKER_THRESHOLD_UNCERTAIN_FLOOR) {
    return SpeakerState.UNCERTAIN;
  }
  return SpeakerState.NOT_VERIFIED;
}

/**
 * The trust gate. Only VERIFIED speech may create a knowledge candidate.
 * Everything else is blocked with an explicit, user-visible decision.
 */
export function trustGateDecision(speaker: SpeakerState, hasTranscript: boolean): TrustGateDecision {
  if (speaker === SpeakerState.VERIFIED) {
    return hasTranscript ? TrustGateDecision.CANDIDATE_ALLOWED : TrustGateDecision.BLOCKED_NOT_AVAILABLE;
  }
  if (speaker === SpeakerState.NOT_ENROLLED || speaker === SpeakerState.ENROLLING) {
    return TrustGateDecision.BLOCKED_NOT_ENROLLED;
  }
  if (speaker === SpeakerState.NOT_VERIFIED) {
    return TrustGateDecision.BLOCKED_NOT_VERIFIED;
  }
  if (speaker === SpeakerState.UNCERTAIN) {
    return TrustGateDecision.BLOCKED_UNCERTAIN;
  }
  return TrustGateDecision.BLOCKED_NOT_AVAILABLE;
}

/** Explicit-confirm rule: only a DRAFT/CORRECTED candidate from VERIFIED speech can ingest. */
export function canConfirmCandidate(status: CandidateStatus, speaker: SpeakerState): boolean {
  return speaker === SpeakerState.VERIFIED &&
    (status === CandidateStatus.DRAFT || status === CandidateStatus.CORRECTED);
}

/** Correction keeps the item a candidate; it never ingests by itself. */
export function statusAfterCorrection(status: CandidateStatus): CandidateStatus {
  if (status === CandidateStatus.DRAFT || status === CandidateStatus.CORRECTED) {
    return CandidateStatus.CORRECTED;
  }
  return status;
}

/** Cosine similarity between two equal-length embedding vectors. */
export function cosineSimilarity(a: number[], b: number[]): number {
  if (a.length === 0 || a.length !== b.length) {
    return Number.NaN;
  }
  let dot = 0;
  let na = 0;
  let nb = 0;
  for (let i = 0; i < a.length; i++) {
    dot += a[i] * b[i];
    na += a[i] * a[i];
    nb += b[i] * b[i];
  }
  if (na === 0 || nb === 0) {
    return Number.NaN;
  }
  return dot / (Math.sqrt(na) * Math.sqrt(nb));
}

/** Average multiple enrollment embeddings element-wise (then L2-normalized). */
export function averageEmbedding(embeddings: number[][]): number[] {
  if (embeddings.length === 0) {
    return [];
  }
  const dim = embeddings[0].length;
  const out: number[] = new Array<number>(dim).fill(0);
  let used = 0;
  for (const e of embeddings) {
    if (e.length !== dim) {
      continue;
    }
    used++;
    for (let i = 0; i < dim; i++) {
      out[i] += e[i];
    }
  }
  if (used === 0) {
    return [];
  }
  let norm = 0;
  for (let i = 0; i < dim; i++) {
    out[i] /= used;
    norm += out[i] * out[i];
  }
  norm = Math.sqrt(norm);
  if (norm > 0) {
    for (let i = 0; i < dim; i++) {
      out[i] /= norm;
    }
  }
  return out;
}

/**
 * Splits a PCM byte stream into fixed-size frames (CoreSpeechKit writeAudio
 * requires exactly 640- or 1280-byte chunks; 16 kHz/mono/s16le ⇒ 1280 B =
 * 40 ms). Tail bytes are retained for the next call.
 */
export class PcmChunker {
  private tail: Uint8Array = new Uint8Array(0);
  private readonly frameSize: number;

  constructor(frameSize: number = 1280) {
    this.frameSize = frameSize;
  }

  push(chunk: Uint8Array): Uint8Array[] {
    const merged = new Uint8Array(this.tail.length + chunk.length);
    merged.set(this.tail, 0);
    merged.set(chunk, this.tail.length);
    const frames: Uint8Array[] = [];
    let offset = 0;
    while (offset + this.frameSize <= merged.length) {
      frames.push(merged.slice(offset, offset + this.frameSize));
      offset += this.frameSize;
    }
    this.tail = merged.slice(offset);
    return frames;
  }

  flush(): Uint8Array {
    const rest = this.tail;
    this.tail = new Uint8Array(0);
    return rest;
  }
}
