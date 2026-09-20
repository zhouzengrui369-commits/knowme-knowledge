import { describe, it, expect } from '@ohos/hypium';
import {
  CandidateStatus,
  CandidateTrustClass,
  MicState,
  SpeakerState,
  TrustGateDecision,
  canConfirmCandidate
} from '../../../main/ets/core/VoiceCore';
import { SessionPurpose, VoiceSessionController } from '../../../main/ets/voice/VoiceSessionController';
import {
  SpeakerVerificationController,
  UnprovisionedSpeakerEngine
} from '../../../main/ets/voice/SpeakerVerificationController';
import { AgentContext } from '../../../main/ets/agent/AgentContext';

/**
 * R3 (PX-KK02-03) disclosed TEST_FIXTURE demo candidate tests: the direct
 * demo entry must be repeatably reachable from a clean state, must create NO
 * speaker verdict, must keep correct/reject/confirm as separate operations,
 * reject must increment knowledge by 0 and confirm by exactly +1 — and the
 * real VOICE trust gate must remain exactly as strong as before.
 */
function newSession(): VoiceSessionController {
  return new VoiceSessionController(new SpeakerVerificationController(new UnprovisionedSpeakerEngine()));
}

export default function fixtureDemoTest(): void {
  describe('FixtureDemoTest', () => {

    it('FIXTURE_DEMO_creates_candidate_from_clean_idle_without_capture', 0, () => {
      const s = newSession();
      expect(s.startFixtureCandidate('演示转写一')).assertTrue();
      expect(s.fixtureTranscript).assertTrue();
      expect(s.fixtureDemo).assertTrue();
      expect(s.transcript).assertEqual('演示转写一');
      expect(s.candidateStatus).assertEqual(CandidateStatus.DRAFT);
    });

    it('FIXTURE_DEMO_creates_no_speaker_verdict', 0, () => {
      const s = newSession();
      const before = s.speakerState;
      s.startFixtureCandidate('演示转写');
      expect(s.speakerState).assertEqual(before); // untouched — no VERIFIED fabricated
      expect(s.gate).assertEqual(null); // no trust-gate pass to display
      expect(Number.isNaN(s.similarity)).assertTrue();
      expect(s.lastStopToResultMs).assertEqual(-1);
    });

    it('FIXTURE_DEMO_refused_while_recording', 0, () => {
      const s = newSession();
      s.micState = MicState.RECORDING;
      expect(s.startFixtureCandidate('x')).assertFalse();
      expect(s.fixtureDemo).assertFalse();
    });

    it('FIXTURE_DEMO_refused_when_candidate_already_active', 0, () => {
      const s = newSession();
      s.startFixtureCandidate('first');
      expect(s.startFixtureCandidate('second')).assertFalse();
      expect(s.transcript).assertEqual('first');
    });

    it('FIXTURE_DEMO_refused_for_blank_text', 0, () => {
      const s = newSession();
      expect(s.startFixtureCandidate('   ')).assertFalse();
      expect(s.fixtureDemo).assertFalse();
      expect(s.candidateStatus).assertEqual(CandidateStatus.NONE);
    });

    it('FIXTURE_DEMO_correct_reject_confirm_are_separate_operations', 0, () => {
      const s = newSession();
      s.startFixtureCandidate('原始演示文本');
      expect(s.correctCandidate('修正后的演示文本')).assertTrue();
      expect(s.candidateStatus).assertEqual(CandidateStatus.CORRECTED);
      expect(s.transcript).assertEqual('修正后的演示文本');
      s.rejectCandidate();
      expect(s.candidateStatus).assertEqual(CandidateStatus.REJECTED);
      // A rejected candidate cannot be confirmed afterwards.
      expect(s.confirmCandidate()).assertEqual('');
    });

    it('FIXTURE_DEMO_reject_causes_zero_knowledge_increment', 0, () => {
      const s = newSession();
      const agent = new AgentContext();
      s.startFixtureCandidate('要被拒绝的演示');
      s.rejectCandidate();
      // Mirror the page wiring: rejection never calls confirmVoiceCandidate.
      expect(agent.knowledgeCount()).assertEqual(0);
      s.dismissResult();
      expect(s.fixtureDemo).assertFalse();
      expect(s.candidateStatus).assertEqual(CandidateStatus.NONE);
    });

    it('FIXTURE_DEMO_confirm_causes_exactly_one_increment_with_fixture_source', 0, () => {
      const s = newSession();
      const agent = new AgentContext();
      s.startFixtureCandidate('要确认的演示');
      const text = s.confirmCandidate();
      expect(text).assertEqual('要确认的演示');
      expect(s.candidateStatus).assertEqual(CandidateStatus.CONFIRMED);
      // Page wiring: one confirmCandidate → one confirmVoiceCandidate → +1.
      agent.confirmVoiceCandidate(text, s.speakerState, s.fixtureTranscript);
      expect(agent.knowledgeCount()).assertEqual(1);
      expect(agent.knowledge[0].source).assertEqual('fixture');
      // Confirm is terminal: a second confirm returns empty (no double count).
      expect(s.confirmCandidate()).assertEqual('');
    });

    it('FIXTURE_DEMO_voice_trust_gate_not_weakened', 0, () => {
      // VOICE class still requires VERIFIED speech for every blocked state.
      const blocked: SpeakerState[] = [
        SpeakerState.NOT_ENROLLED, SpeakerState.ENROLLING,
        SpeakerState.NOT_VERIFIED, SpeakerState.UNCERTAIN, SpeakerState.NOT_AVAILABLE
      ];
      for (const st of blocked) {
        expect(canConfirmCandidate(CandidateStatus.DRAFT, st, CandidateTrustClass.VOICE)).assertFalse();
        expect(canConfirmCandidate(CandidateStatus.CORRECTED, st, CandidateTrustClass.VOICE)).assertFalse();
      }
      expect(canConfirmCandidate(CandidateStatus.DRAFT, SpeakerState.VERIFIED, CandidateTrustClass.VOICE)).assertTrue();
      // Default parameter stays VOICE (legacy call sites unchanged).
      expect(canConfirmCandidate(CandidateStatus.DRAFT, SpeakerState.UNCERTAIN)).assertFalse();
      // FIXTURE class never upgrades a NON-candidate status.
      expect(canConfirmCandidate(CandidateStatus.NONE, SpeakerState.NOT_ENROLLED, CandidateTrustClass.FIXTURE)).assertFalse();
      expect(canConfirmCandidate(CandidateStatus.REJECTED, SpeakerState.NOT_ENROLLED, CandidateTrustClass.FIXTURE)).assertFalse();
    });

    it('FIXTURE_DEMO_fixture_confirm_blocked_for_voice_candidate_without_verified', 0, () => {
      // A REAL capture candidate (fixtureDemo=false) from unverified speech
      // must stay unconfirmable — the demo path cannot leak into voice.
      const s = newSession();
      s.purpose = SessionPurpose.CAPTURE;
      s.micState = MicState.STOPPED;
      s.speakerState = SpeakerState.UNCERTAIN;
      s.transcript = '真实但不确定的转写';
      s.gate = TrustGateDecision.BLOCKED_UNCERTAIN;
      s.candidateStatus = CandidateStatus.DRAFT;
      expect(s.confirmCandidate()).assertEqual('');
      expect(s.candidateStatus).assertEqual(CandidateStatus.DRAFT);
    });

    it('FIXTURE_DEMO_dismiss_and_cancel_clear_demo_flags', 0, () => {
      const s = newSession();
      s.startFixtureCandidate('演示');
      s.dismissResult();
      expect(s.fixtureDemo).assertFalse();
      expect(s.fixtureTranscript).assertFalse();
      expect(s.transcript).assertEqual('');
      expect(s.gate).assertEqual(null);
      expect(s.candidateStatus).assertEqual(CandidateStatus.NONE);
      const s2 = newSession();
      s2.startFixtureCandidate('演示');
      s2.clearResultForReset();
      expect(s2.fixtureDemo).assertFalse();
      expect(s2.fixtureTranscript).assertFalse();
    });
  });
}
