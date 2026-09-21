import { describe, it, expect } from '@ohos/hypium';
import { CandidateStatus, CandidateTrustClass, SpeakerState } from '../../../main/ets/core/VoiceCore';
import {
  NoteDraftStatus,
  NoteFlowController,
  canSaveNoteDraft,
  organizeTranscript,
  splitSentences
} from '../../../main/ets/note/NoteFlow';
import { AgentContext, AgentSnapshot } from '../../../main/ets/agent/AgentContext';
import { SessionPurpose, VoiceSessionController } from '../../../main/ets/voice/VoiceSessionController';
import {
  SpeakerVerificationController,
  UnprovisionedSpeakerEngine
} from '../../../main/ets/voice/SpeakerVerificationController';

/**
 * GOAL-KK-03 note-flow contract tests:
 *  - "整理成笔记" is an explicit transition producing exactly one editable
 *    NOTE_DRAFT (title + editable body) with the ORIGINAL transcript kept as
 *    immutable provenance — organization never overwrites it.
 *  - Explicit save ingests exactly +1; cancel/reject ingest +0; double-tap /
 *    repeated submit can never duplicate (+2).
 *  - VOICE-sourced drafts still require the VERIFIED capture verdict at save
 *    time (GOAL-KK-02 trust discipline unweakened); FIXTURE/TEXT drafts carry
 *    no speaker claim.
 *  - Unconfirmed drafts never enter the persisted snapshot.
 */
export default function noteFlowTest(): void {
  describe('NoteFlowTest', () => {

    it('NOTE_organize_is_deterministic_and_adds_no_content', 0, () => {
      const n = organizeTranscript('今天完成了语音笔记流程。明天继续验证保存和溯源。');
      expect(n.title).assertEqual('今天完成了语音笔记流程');
      expect(n.body).assertEqual('· 今天完成了语音笔记流程\n· 明天继续验证保存和溯源');
      // Same input → same output (deterministic organizer, no LLM claim).
      const n2 = organizeTranscript('今天完成了语音笔记流程。明天继续验证保存和溯源。');
      expect(n2.title).assertEqual(n.title);
      expect(n2.body).assertEqual(n.body);
    });

    it('NOTE_organize_truncates_long_title_honestly', 0, () => {
      const long = '这是一句特别特别长的话长到必须被截断才能成为标题所以截断';
      const n = organizeTranscript(long);
      expect(n.title.length <= 21).assertTrue(); // 20 chars + ellipsis
      expect(n.title.endsWith('…')).assertTrue();
      // Body still carries the full sentence — nothing summarized away.
      expect(n.body).assertEqual(`· ${long}`);
    });

    it('NOTE_split_sentences_drops_empty_segments', 0, () => {
      const s = splitSentences('第一句。。第二句!\n\n第三句?');
      expect(s.length).assertEqual(3);
      expect(s[1]).assertEqual('第二句');
    });

    it('NOTE_create_from_candidate_sets_editing_with_provenance', 0, () => {
      const f = new NoteFlowController();
      const ok = f.createFromCandidate('原始转写内容。第二句。',
        'voice', SpeakerState.VERIFIED, CandidateTrustClass.VOICE);
      expect(ok).assertTrue();
      expect(f.status).assertEqual(NoteDraftStatus.EDITING);
      expect(f.draft !== null).assertTrue();
      expect(f.draft!.originalTranscript).assertEqual('原始转写内容。第二句。');
      expect(f.draft!.title).assertEqual('原始转写内容');
      expect(f.draft!.source).assertEqual('voice');
      expect(f.draft!.speakerState).assertEqual(SpeakerState.VERIFIED);
    });

    it('NOTE_create_refused_for_blank_or_while_editing', 0, () => {
      const f = new NoteFlowController();
      expect(f.createFromCandidate('   ', 'voice', SpeakerState.VERIFIED, CandidateTrustClass.VOICE)).assertFalse();
      expect(f.status).assertEqual(NoteDraftStatus.NONE);
      expect(f.createFromCandidate('第一句。', 'voice', SpeakerState.VERIFIED, CandidateTrustClass.VOICE)).assertTrue();
      expect(f.createFromCandidate('第二个候选。', 'voice', SpeakerState.VERIFIED, CandidateTrustClass.VOICE)).assertFalse();
      expect(f.draft!.originalTranscript).assertEqual('第一句。');
    });

    it('NOTE_voice_draft_save_requires_verified_capture', 0, () => {
      // GOAL-KK-02 trust discipline: a VOICE-sourced note may only be saved
      // when the capture verdict was VERIFIED.
      for (const st of [SpeakerState.NOT_ENROLLED, SpeakerState.ENROLLING, SpeakerState.NOT_VERIFIED,
        SpeakerState.UNCERTAIN, SpeakerState.NOT_AVAILABLE]) {
        expect(canSaveNoteDraft(NoteDraftStatus.EDITING, CandidateTrustClass.VOICE, st)).assertFalse();
      }
      expect(canSaveNoteDraft(NoteDraftStatus.EDITING, CandidateTrustClass.VOICE, SpeakerState.VERIFIED)).assertTrue();
      // FIXTURE / TEXT carry no speaker claim — same class as manual text.
      expect(canSaveNoteDraft(NoteDraftStatus.EDITING, CandidateTrustClass.FIXTURE, 'N/A')).assertTrue();
      // Terminal statuses are never saveable.
      expect(canSaveNoteDraft(NoteDraftStatus.SAVED, CandidateTrustClass.FIXTURE, 'N/A')).assertFalse();
      expect(canSaveNoteDraft(NoteDraftStatus.CANCELLED, CandidateTrustClass.FIXTURE, 'N/A')).assertFalse();

      const f = new NoteFlowController();
      f.createFromCandidate('不确定的语音。', 'voice', SpeakerState.UNCERTAIN, CandidateTrustClass.VOICE);
      expect(f.save()).assertEqual(null);
      expect(f.status).assertEqual(NoteDraftStatus.EDITING); // refused, not consumed
    });

    it('NOTE_save_is_exactly_once_double_tap_cannot_duplicate', 0, () => {
      const f = new NoteFlowController();
      const agent = new AgentContext();
      f.createFromCandidate('要保存的内容。', 'voice', SpeakerState.VERIFIED, CandidateTrustClass.VOICE);
      const first = f.save();
      expect(first !== null).assertTrue();
      agent.saveNoteDraft(first!);
      // Double-tap / repeated submit: every later save() returns null.
      expect(f.save()).assertEqual(null);
      expect(f.save()).assertEqual(null);
      expect(agent.knowledgeCount()).assertEqual(1);
    });

    it('NOTE_cancel_is_plus_zero_and_terminal', 0, () => {
      const f = new NoteFlowController();
      const agent = new AgentContext();
      f.createFromCandidate('要取消的草稿。', 'voice', SpeakerState.VERIFIED, CandidateTrustClass.VOICE);
      expect(f.cancel()).assertTrue();
      expect(f.cancel()).assertFalse(); // exactly-once
      expect(f.save()).assertEqual(null); // cancelled draft can never save
      expect(agent.knowledgeCount()).assertEqual(0);
    });

    it('NOTE_edit_title_and_body_are_what_gets_saved', 0, () => {
      const f = new NoteFlowController();
      const agent = new AgentContext();
      f.createFromCandidate('原始第一句。原始第二句。', 'voice', SpeakerState.VERIFIED, CandidateTrustClass.VOICE);
      expect(f.editTitle('我改的标题')).assertTrue();
      expect(f.editBody('我完全重写的正文')).assertTrue();
      const saved = f.save();
      expect(saved !== null).assertTrue();
      const item = agent.saveNoteDraft(saved!);
      expect(item !== null).assertTrue();
      expect(item!.title).assertEqual('我改的标题');
      expect(item!.text).assertEqual('我完全重写的正文');
      // Provenance survives user edits verbatim.
      expect(item!.originalTranscript).assertEqual('原始第一句。原始第二句。');
    });

    it('NOTE_blank_title_or_body_refuses_save_and_stays_editing', 0, () => {
      const f = new NoteFlowController();
      f.createFromCandidate('内容。', 'voice', SpeakerState.VERIFIED, CandidateTrustClass.VOICE);
      f.editTitle('   ');
      expect(f.save()).assertEqual(null);
      expect(f.status).assertEqual(NoteDraftStatus.EDITING);
      f.editTitle('恢复标题');
      f.editBody('  ');
      expect(f.save()).assertEqual(null);
      expect(f.status).assertEqual(NoteDraftStatus.EDITING);
    });

    it('NOTE_clear_only_after_terminal_and_allows_next_draft', 0, () => {
      const f = new NoteFlowController();
      f.createFromCandidate('第一条。', 'voice', SpeakerState.VERIFIED, CandidateTrustClass.VOICE);
      f.clear(); // no-op while EDITING — an active draft is never swept away
      expect(f.status).assertEqual(NoteDraftStatus.EDITING);
      f.save();
      f.clear();
      expect(f.status).assertEqual(NoteDraftStatus.NONE);
      expect(f.draft).assertEqual(null);
      expect(f.createFromCandidate('第二条。', 'voice', SpeakerState.VERIFIED, CandidateTrustClass.VOICE)).assertTrue();
    });

    it('NOTE_agent_save_maps_source_and_explains_change', 0, () => {
      const agent = new AgentContext();
      const f = new NoteFlowController();
      f.createFromCandidate('测试代理转写。', 'fixture', 'N/A', CandidateTrustClass.FIXTURE);
      const saved = f.save();
      expect(saved !== null).assertTrue();
      const item = agent.saveNoteDraft(saved!);
      expect(item !== null).assertTrue();
      expect(item!.source).assertEqual('fixture');
      expect(item!.originalTranscript).assertEqual('测试代理转写。');
      expect(agent.knowledgeCount()).assertEqual(1);
      const last = agent.messages[agent.messages.length - 1].text;
      expect(last.includes('知识 +1')).assertTrue();
      expect(last.includes('TEST_FIXTURE')).assertTrue();
    });

    it('NOTE_unconfirmed_draft_never_enters_snapshot', 0, () => {
      const agent = new AgentContext();
      const f = new NoteFlowController();
      f.createFromCandidate('未确认的草稿。', 'voice', SpeakerState.VERIFIED, CandidateTrustClass.VOICE);
      f.editTitle('还没保存');
      // Draft lives only in the NoteFlowController — AgentContext.knowledge
      // is untouched, so a snapshot cannot resurrect it after a restart.
      const snap = agent.snapshot();
      expect(snap.knowledge.length).assertEqual(0);
      const cancelled = new NoteFlowController();
      cancelled.createFromCandidate('将被取消。', 'voice', SpeakerState.VERIFIED, CandidateTrustClass.VOICE);
      cancelled.cancel();
      expect(agent.snapshot().knowledge.length).assertEqual(0);
    });

    it('NOTE_snapshot_roundtrip_preserves_provenance', 0, () => {
      const agent = new AgentContext();
      const f = new NoteFlowController();
      f.createFromCandidate('原始转写第一句。原始转写第二句。', 'voice', SpeakerState.VERIFIED,
        CandidateTrustClass.VOICE);
      f.editTitle('保存后的标题');
      agent.saveNoteDraft(f.save()!);
      const snap = agent.snapshot();
      expect(snap.version).assertEqual(4);

      const b = new AgentContext();
      b.restore(snap);
      expect(b.knowledgeCount()).assertEqual(1);
      expect(b.knowledge[0].title).assertEqual('保存后的标题');
      expect(b.knowledge[0].originalTranscript).assertEqual('原始转写第一句。原始转写第二句。');
      expect(b.knowledge[0].source).assertEqual('voice');
    });

    it('NOTE_restore_legacy_items_default_original_transcript', 0, () => {
      // Snapshots written by KK-02 (v3) builds carry no originalTranscript —
      // restore must default it to '' (honest "no provenance recorded"),
      // never fabricate one.
      const rawJson: string = '{"version":3,"counter":1,' +
        '"knowledge":[{"id":"kv-1","title":"旧条目","text":"旧正文","source":"voice","confirmedAt":1,"speakerState":"VERIFIED"}],' +
        '"messages":[]}';
      const legacy = JSON.parse(rawJson) as AgentSnapshot;
      const b = new AgentContext();
      b.restore(legacy);
      expect(b.knowledgeCount()).assertEqual(1);
      expect(b.knowledge[0].originalTranscript).assertEqual('');
    });

    it('NOTE_session_continue_to_note_payload_and_exactly_once', 0, () => {
      // End-to-end at the wiring level: candidate → 整理成笔记 → payload
      // carries verbatim transcript + trust class; session outcome cleared;
      // a second continue is impossible.
      const s = new VoiceSessionController(new SpeakerVerificationController(new UnprovisionedSpeakerEngine()));
      s.purpose = SessionPurpose.CAPTURE;
      s.startFixtureCandidate('演示转写第一句。第二句。');
      const payload = s.continueToNote();
      expect(payload !== null).assertTrue();
      expect(payload!.transcript).assertEqual('演示转写第一句。第二句。');
      expect(payload!.source).assertEqual('fixture');
      expect(payload!.trustClass).assertEqual(CandidateTrustClass.FIXTURE);
      expect(payload!.speakerState).assertEqual('N/A');
      // Session outcome disposed: no stale candidate/result left behind.
      expect(s.candidateStatus).assertEqual(CandidateStatus.NONE);
      expect(s.transcript).assertEqual('');
      expect(s.fixtureDemo).assertEqual(false);
      expect(s.continueToNote()).assertEqual(null);
      // Full loop through the draft controller → exactly +1.
      const agent = new AgentContext();
      const f = new NoteFlowController();
      expect(f.createFromCandidate(payload!.transcript, payload!.source, payload!.speakerState,
        payload!.trustClass)).assertTrue();
      agent.saveNoteDraft(f.save()!);
      expect(agent.knowledgeCount()).assertEqual(1);
      expect(agent.knowledge[0].originalTranscript).assertEqual('演示转写第一句。第二句。');
    });
  });
}
