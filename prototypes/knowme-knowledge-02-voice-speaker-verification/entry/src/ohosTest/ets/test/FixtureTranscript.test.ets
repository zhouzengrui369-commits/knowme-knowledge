import { describe, it, expect } from '@ohos/hypium';
import { CandidateStatus, MicState, SpeakerState, TrustGateDecision } from '../../../main/ets/core/VoiceCore';
import { SessionPurpose, VoiceSessionController } from '../../../main/ets/voice/VoiceSessionController';
import {
  SpeakerVerificationController,
  UnprovisionedSpeakerEngine
} from '../../../main/ets/voice/SpeakerVerificationController';

/**
 * R2 TEST_FIXTURE contract tests (AO-03/AO-05): the disclosed simulator
 * fixture transcript may ONLY unlock the candidate flow when a real capture
 * ran, the speaker is VERIFIED, no real transcript exists, and the sole
 * blocker is NOT_AVAILABLE. Every other state must refuse.
 */
function newSession(): VoiceSessionController {
  return new VoiceSessionController(new SpeakerVerificationController(new UnprovisionedSpeakerEngine()));
}

/** Drive the session into the one legal fixture state. */
function toFixtureEligible(s: VoiceSessionController): void {
  s.purpose = SessionPurpose.CAPTURE;
  s.micState = MicState.STOPPED;
  s.speakerState = SpeakerState.VERIFIED;
  s.transcript = '';
  s.fixtureTranscript = false;
  s.gate = TrustGateDecision.BLOCKED_NOT_AVAILABLE;
  s.candidateStatus = CandidateStatus.NONE;
}

export default function fixtureTranscriptTest(): void {
  describe('FixtureTranscriptTest', () => {

    it('FIXTURE_golden_state_unlocks_candidate', 0, () => {
      const s = newSession();
      toFixtureEligible(s);
      expect(s.injectFixtureTranscript('这是一条模拟器测试转写')).assertTrue();
      expect(s.fixtureTranscript).assertTrue();
      expect(s.transcript).assertEqual('这是一条模拟器测试转写');
      expect(s.gate).assertEqual(TrustGateDecision.CANDIDATE_ALLOWED);
      expect(s.candidateStatus).assertEqual(CandidateStatus.DRAFT);
    });

    it('FIXTURE_refused_when_speaker_not_verified', 0, () => {
      const blocked: SpeakerState[] = [
        SpeakerState.NOT_ENROLLED, SpeakerState.ENROLLING,
        SpeakerState.NOT_VERIFIED, SpeakerState.UNCERTAIN, SpeakerState.NOT_AVAILABLE
      ];
      for (const st of blocked) {
        const s = newSession();
        toFixtureEligible(s);
        s.speakerState = st;
        expect(s.injectFixtureTranscript('x')).assertFalse();
        expect(s.fixtureTranscript).assertFalse();
        expect(s.gate).assertEqual(TrustGateDecision.BLOCKED_NOT_AVAILABLE);
      }
    });

    it('FIXTURE_refused_when_real_transcript_exists', 0, () => {
      const s = newSession();
      toFixtureEligible(s);
      s.transcript = '真实转写';
      expect(s.injectFixtureTranscript('x')).assertFalse();
      expect(s.transcript).assertEqual('真实转写');
      expect(s.fixtureTranscript).assertFalse();
    });

    it('FIXTURE_refused_when_gate_not_blocked_not_available', 0, () => {
      const s = newSession();
      toFixtureEligible(s);
      s.gate = TrustGateDecision.BLOCKED_UNCERTAIN;
      expect(s.injectFixtureTranscript('x')).assertFalse();
      const s2 = newSession();
      toFixtureEligible(s2);
      s2.gate = null;
      expect(s2.injectFixtureTranscript('x')).assertFalse();
    });

    it('FIXTURE_refused_while_recording_or_idle', 0, () => {
      const s = newSession();
      toFixtureEligible(s);
      s.micState = MicState.RECORDING;
      expect(s.injectFixtureTranscript('x')).assertFalse();
      const s2 = newSession();
      toFixtureEligible(s2);
      s2.micState = MicState.IDLE;
      expect(s2.injectFixtureTranscript('x')).assertFalse();
    });

    it('FIXTURE_refused_for_enrollment_purpose', 0, () => {
      const s = newSession();
      toFixtureEligible(s);
      s.purpose = SessionPurpose.ENROLLMENT;
      expect(s.injectFixtureTranscript('x')).assertFalse();
    });

    it('FIXTURE_refused_for_blank_text', 0, () => {
      const s = newSession();
      toFixtureEligible(s);
      expect(s.injectFixtureTranscript('   ')).assertFalse();
      expect(s.fixtureTranscript).assertFalse();
    });

    it('FIXTURE_flag_cleared_on_dismiss', 0, () => {
      const s = newSession();
      toFixtureEligible(s);
      s.injectFixtureTranscript('测试');
      expect(s.fixtureTranscript).assertTrue();
      s.dismissResult();
      expect(s.fixtureTranscript).assertFalse();
      expect(s.transcript).assertEqual('');
      expect(s.gate).assertEqual(null);
      expect(s.candidateStatus).assertEqual(CandidateStatus.NONE);
    });

    it('R2D14_force_refresh_bypasses_d13_guard_for_enrollment_lifecycle', 0, () => {
      // Reproduce R2-D14: transcript on screen blocks refreshSpeakerState(),
      // leaving a stale NOT_ENROLLED strip next to 注册完成(3/3).
      const s = newSession();
      s.speakerState = SpeakerState.ENROLLED; // stale value
      s.transcript = '注册采样转写仍显示在屏幕上';
      s.gate = null;
      s.candidateStatus = CandidateStatus.NONE;
      s.refreshSpeakerState();
      expect(s.speakerState).assertEqual(SpeakerState.ENROLLED); // guarded: unchanged
      s.forceRefreshSpeakerState();
      // UnprovisionedSpeakerEngine → NOT_AVAILABLE; key assertion: it changed.
      expect(s.speakerState).assertEqual(SpeakerState.NOT_AVAILABLE);
    });
  });
}
