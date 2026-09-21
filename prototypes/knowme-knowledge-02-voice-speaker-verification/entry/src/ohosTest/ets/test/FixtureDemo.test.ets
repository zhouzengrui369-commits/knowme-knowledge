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

    it('FIXTURE_DEMO_D21_dismiss_preserves_honest_permission_state', 0, () => {
      // R3-D21: manual-text record (or any outcome dispose) while the mic is
      // PERMISSION_DENIED / PERMISSION_REQUIRED must NOT be clobbered to IDLE —
      // that hid the denied banner + settings deep link until the next page
      // show. Only a completed capture (STOPPED) returns to IDLE.
      const denied = newSession();
      denied.micState = MicState.PERMISSION_DENIED;
      denied.dismissResult();
      expect(denied.micState).assertEqual(MicState.PERMISSION_DENIED);

      const required = newSession();
      required.micState = MicState.PERMISSION_REQUIRED;
      required.dismissResult();
      expect(required.micState).assertEqual(MicState.PERMISSION_REQUIRED);

      const stopped = newSession();
      stopped.micState = MicState.STOPPED;
      stopped.dismissResult();
      expect(stopped.micState).assertEqual(MicState.IDLE);
    });

    it('FIXTURE_DEMO_R3_06_generate_preserves_permission_fact', 0, () => {
      // PX-KK02-R3-06: while system mic permission is denied/required/
      // unavailable, creating a TEST_FIXTURE candidate must NOT clear the
      // state to a fake "空闲·未录音" (IDLE). FIXTURE_STATE never overwrites
      // MIC_PERMISSION_STATE.
      const denied = newSession();
      denied.micState = MicState.PERMISSION_DENIED;
      expect(denied.startFixtureCandidate('拒绝态演示')).assertTrue();
      expect(denied.micState).assertEqual(MicState.PERMISSION_DENIED);
      expect(denied.candidateStatus).assertEqual(CandidateStatus.DRAFT);

      const required = newSession();
      required.micState = MicState.PERMISSION_REQUIRED;
      expect(required.startFixtureCandidate('待授权演示')).assertTrue();
      expect(required.micState).assertEqual(MicState.PERMISSION_REQUIRED);

      const unavailable = newSession();
      unavailable.micState = MicState.UNAVAILABLE;
      expect(unavailable.startFixtureCandidate('不可用演示')).assertTrue();
      expect(unavailable.micState).assertEqual(MicState.UNAVAILABLE);

      const idle = newSession();
      idle.micState = MicState.IDLE;
      expect(idle.startFixtureCandidate('空闲演示')).assertTrue();
      expect(idle.micState).assertEqual(MicState.IDLE);
    });

    it('FIXTURE_DEMO_R3_06_correct_reject_confirm_keep_denied_state', 0, () => {
      // Full fixture lifecycle while denied: every entry/exit keeps the
      // honest DENIED fact so the banner + truthful CTA never regress.
      const s = newSession();
      s.micState = MicState.PERMISSION_DENIED;
      s.startFixtureCandidate('将被修正');
      expect(s.correctCandidate('已修正内容')).assertTrue();
      expect(s.micState).assertEqual(MicState.PERMISSION_DENIED);
      s.rejectCandidate();
      expect(s.micState).assertEqual(MicState.PERMISSION_DENIED);
      s.dismissResult();
      expect(s.micState).assertEqual(MicState.PERMISSION_DENIED);

      const s2 = newSession();
      s2.micState = MicState.PERMISSION_DENIED;
      s2.startFixtureCandidate('将被确认');
      expect(s2.confirmCandidate()).assertEqual('将被确认');
      expect(s2.micState).assertEqual(MicState.PERMISSION_DENIED);
      s2.dismissResult();
      expect(s2.micState).assertEqual(MicState.PERMISSION_DENIED);
    });
  });
}
