import { describe, it, expect } from '@ohos/hypium';
import {
  CandidateStatus,
  PcmChunker,
  SpeakerState,
  TrustGateDecision,
  averageEmbedding,
  canConfirmCandidate,
  cosineSimilarity,
  speakerStateFromScore,
  statusAfterCorrection,
  trustGateDecision,
  SPEAKER_THRESHOLD_UNCERTAIN_FLOOR,
  SPEAKER_THRESHOLD_VERIFIED
} from '../../../main/ets/core/VoiceCore';

/**
 * Contract-semantics tests for the frozen trust model (AO-05 trust gate,
 * AO-06 candidate handoff). Device-executable via Hypium.
 */
export default function voiceCoreTest(): void {
  describe('VoiceCoreTest', () => {

    it('TRUSTGATE_verified_with_transcript_allows_candidate', 0, () => {
      expect(trustGateDecision(SpeakerState.VERIFIED, true))
        .assertEqual(TrustGateDecision.CANDIDATE_ALLOWED);
    });

    it('TRUSTGATE_verified_without_transcript_blocked_not_available', 0, () => {
      expect(trustGateDecision(SpeakerState.VERIFIED, false))
        .assertEqual(TrustGateDecision.BLOCKED_NOT_AVAILABLE);
    });

    it('TRUSTGATE_not_verified_blocked', 0, () => {
      expect(trustGateDecision(SpeakerState.NOT_VERIFIED, true))
        .assertEqual(TrustGateDecision.BLOCKED_NOT_VERIFIED);
    });

    it('TRUSTGATE_uncertain_blocked', 0, () => {
      expect(trustGateDecision(SpeakerState.UNCERTAIN, true))
        .assertEqual(TrustGateDecision.BLOCKED_UNCERTAIN);
    });

    it('TRUSTGATE_not_available_blocked', 0, () => {
      expect(trustGateDecision(SpeakerState.NOT_AVAILABLE, true))
        .assertEqual(TrustGateDecision.BLOCKED_NOT_AVAILABLE);
    });

    it('TRUSTGATE_not_enrolled_blocked', 0, () => {
      expect(trustGateDecision(SpeakerState.NOT_ENROLLED, true))
        .assertEqual(TrustGateDecision.BLOCKED_NOT_ENROLLED);
    });

    it('TRUSTGATE_no_silent_trust_invariant', 0, () => {
      // For every non-VERIFIED state the gate must NEVER allow a candidate,
      // with or without a transcript (AO-05: no silent trust).
      const blockedStates: SpeakerState[] = [
        SpeakerState.NOT_ENROLLED,
        SpeakerState.ENROLLING,
        SpeakerState.NOT_VERIFIED,
        SpeakerState.UNCERTAIN,
        SpeakerState.NOT_AVAILABLE
      ];
      for (const s of blockedStates) {
        expect(trustGateDecision(s, true) !== TrustGateDecision.CANDIDATE_ALLOWED).assertTrue();
        expect(trustGateDecision(s, false) !== TrustGateDecision.CANDIDATE_ALLOWED).assertTrue();
      }
    });

    it('CONFIRM_only_verified_draft_or_corrected', 0, () => {
      expect(canConfirmCandidate(CandidateStatus.DRAFT, SpeakerState.VERIFIED)).assertTrue();
      expect(canConfirmCandidate(CandidateStatus.CORRECTED, SpeakerState.VERIFIED)).assertTrue();
      expect(canConfirmCandidate(CandidateStatus.DRAFT, SpeakerState.NOT_VERIFIED)).assertFalse();
      expect(canConfirmCandidate(CandidateStatus.DRAFT, SpeakerState.UNCERTAIN)).assertFalse();
      expect(canConfirmCandidate(CandidateStatus.DRAFT, SpeakerState.NOT_AVAILABLE)).assertFalse();
      expect(canConfirmCandidate(CandidateStatus.CONFIRMED, SpeakerState.VERIFIED)).assertFalse();
      expect(canConfirmCandidate(CandidateStatus.REJECTED, SpeakerState.VERIFIED)).assertFalse();
      expect(canConfirmCandidate(CandidateStatus.NONE, SpeakerState.VERIFIED)).assertFalse();
    });

    it('CORRECTION_never_ingests', 0, () => {
      expect(statusAfterCorrection(CandidateStatus.DRAFT)).assertEqual(CandidateStatus.CORRECTED);
      expect(statusAfterCorrection(CandidateStatus.CORRECTED)).assertEqual(CandidateStatus.CORRECTED);
      expect(statusAfterCorrection(CandidateStatus.CONFIRMED)).assertEqual(CandidateStatus.CONFIRMED);
    });

    it('SPEAKER_score_mapping_with_uncertain_band', 0, () => {
      expect(speakerStateFromScore(SPEAKER_THRESHOLD_VERIFIED + 0.05)).assertEqual(SpeakerState.VERIFIED);
      expect(speakerStateFromScore((SPEAKER_THRESHOLD_VERIFIED + SPEAKER_THRESHOLD_UNCERTAIN_FLOOR) / 2))
        .assertEqual(SpeakerState.UNCERTAIN);
      expect(speakerStateFromScore(SPEAKER_THRESHOLD_UNCERTAIN_FLOOR - 0.05))
        .assertEqual(SpeakerState.NOT_VERIFIED);
      expect(speakerStateFromScore(Number.NaN)).assertEqual(SpeakerState.UNCERTAIN);
    });

    it('COSINE_identical_is_one_orthogonal_is_zero', 0, () => {
      const a = [1, 2, 3];
      expect(Math.abs(cosineSimilarity(a, a) - 1) < 1e-6).assertTrue();
      expect(Math.abs(cosineSimilarity([1, 0], [0, 1])) < 1e-6).assertTrue();
      expect(Number.isNaN(cosineSimilarity([], []))).assertTrue();
      expect(Number.isNaN(cosineSimilarity([1], [1, 2]))).assertTrue();
    });

    it('AVERAGE_embedding_normalized', 0, () => {
      const avg = averageEmbedding([[3, 4], [3, 4]]);
      expect(Math.abs(avg[0] - 0.6) < 1e-6 && Math.abs(avg[1] - 0.8) < 1e-6).assertTrue();
      expect(averageEmbedding([]).length).assertEqual(0);
    });

    it('PCM_chunker_frames_and_tail', 0, () => {
      const c = new PcmChunker(1280);
      expect(c.push(new Uint8Array(1000)).length).assertEqual(0);
      const frames = c.push(new Uint8Array(2000));
      expect(frames.length).assertEqual(2);
      expect(frames[0].length).assertEqual(1280);
      expect(c.flush().length).assertEqual(1000 + 2000 - 2560);
    });

    it('PCM_chunker_flush_resets', 0, () => {
      const c = new PcmChunker(1280);
      c.push(new Uint8Array(500));
      expect(c.flush().length).assertEqual(500);
      expect(c.flush().length).assertEqual(0);
    });
  });
}
