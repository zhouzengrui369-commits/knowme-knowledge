import { describe, it, expect } from '@ohos/hypium';
import {
  AGENT_KNOWLEDGE_CAP,
  AGENT_MESSAGE_CAP,
  AgentContext,
  AgentMessage,
  AgentSnapshot,
  KnowledgeItem
} from '../../../main/ets/agent/AgentContext';

/**
 * R3 (PX-KK02-01) persistence contract tests: the snapshot/restore boundary
 * is the ONLY thing that may cross Home/permission/force-stop/cold reopen.
 * Confirmed + manual items with source labels and bounded context survive;
 * rejected/discarded/unconfirmed candidates never appear in a snapshot.
 */
export default function agentContextPersistenceTest(): void {
  describe('AgentContextPersistenceTest', () => {

    it('PERSIST_roundtrip_preserves_confirmed_items_sources_and_count', 0, () => {
      const a = new AgentContext();
      a.ensureIntro();
      a.addTextNote('第一条手动合成知识');
      a.confirmVoiceCandidate('第二条语音合成知识', 'VERIFIED');
      a.confirmVoiceCandidate('第三条演示合成知识', 'N/A', true);
      const snap = a.snapshot();

      const b = new AgentContext();
      b.restore(snap);
      expect(b.knowledgeCount()).assertEqual(3);
      expect(b.knowledge[0].source).assertEqual('text');
      expect(b.knowledge[1].source).assertEqual('voice');
      expect(b.knowledge[2].source).assertEqual('fixture');
      expect(b.knowledge[0].text).assertEqual('第一条手动合成知识');
      expect(b.knowledge[1].text).assertEqual('第二条语音合成知识');
      expect(b.messages.length > 0).assertTrue();
    });

    it('PERSIST_snapshot_contains_only_confirmed_or_manual_items', 0, () => {
      // Draft/corrected/rejected voice candidates live in the session
      // controller and never reach AgentContext.knowledge — the snapshot
      // therefore cannot resurrect them after a restart (contract rule).
      const a = new AgentContext();
      a.addTextNote('已确认的手动条目');
      a.explainRejected(); // rejection explanation is a message, not knowledge
      a.explainBlocked('信任门拦截:无法确定是谁(UNCERTAIN),不入库');
      const snap = a.snapshot();
      expect(snap.knowledge.length).assertEqual(1);
      expect(snap.knowledge[0].source).assertEqual('text');
      // Messages may persist (bounded context) but must contain no candidate.
      for (const m of snap.messages) {
        expect(m.text.includes('候选知识(未入库')).assertFalse();
      }
    });

    it('PERSIST_restore_rejects_malformed_entries_without_throwing', 0, () => {
      // Malformed entries arrive as raw JSON (missing text field, unknown
      // source, non-string message text) — restore must drop them, keep the
      // valid entries, and never throw on corrupt data.
      const rawJson: string = '{"version":3,"counter":5,' +
        '"knowledge":[' +
        '{"id":"kv-1","title":"ok","text":"ok","source":"voice","confirmedAt":1,"speakerState":"VERIFIED"},' +
        '{"id":"bad","title":"no-text","source":"voice","confirmedAt":2,"speakerState":"VERIFIED"},' +
        '{"id":"bad2","title":"bad-source","text":"x","source":"cloud","confirmedAt":3,"speakerState":"VERIFIED"}],' +
        '"messages":[{"role":"agent","text":"hello","at":1},{"role":"owner","text":42,"at":2}]}';
      const bad = JSON.parse(rawJson) as AgentSnapshot;
      const b = new AgentContext();
      b.restore(bad);
      expect(b.knowledgeCount()).assertEqual(1);
      expect(b.knowledge[0].id).assertEqual('kv-1');
      expect(b.messages.length).assertEqual(1);
    });

    it('PERSIST_restore_id_continuity_no_duplicate_ids', 0, () => {
      const a = new AgentContext();
      a.addTextNote('旧条目一');
      a.addTextNote('旧条目二');
      const snap = a.snapshot();
      const b = new AgentContext();
      b.restore(snap);
      const item = b.addTextNote('重启后的新条目');
      expect(item !== null).assertTrue();
      expect(item!.id).assertEqual('kt-3');
      const ids = b.knowledge.map((k: KnowledgeItem) => k.id);
      expect(new Set(ids).size).assertEqual(ids.length);
    });

    it('PERSIST_message_cap_is_bounded', 0, () => {
      const a = new AgentContext();
      for (let i = 0; i < AGENT_MESSAGE_CAP + 15; i++) {
        a.say('system', `msg-${i}`);
      }
      expect(a.messages.length).assertEqual(AGENT_MESSAGE_CAP);
      const snap = a.snapshot();
      expect(snap.messages.length).assertEqual(AGENT_MESSAGE_CAP);
      // Tail preserved (most recent), oldest dropped.
      expect(snap.messages[snap.messages.length - 1].text).assertEqual(`msg-${AGENT_MESSAGE_CAP + 14}`);
    });

    it('PERSIST_knowledge_cap_is_bounded', 0, () => {
      const a = new AgentContext();
      for (let i = 0; i < AGENT_KNOWLEDGE_CAP + 5; i++) {
        a.addTextNote(`item-${i}`);
      }
      const snap = a.snapshot();
      expect(snap.knowledge.length).assertEqual(AGENT_KNOWLEDGE_CAP);
      expect(snap.knowledge[snap.knowledge.length - 1].text).assertEqual(`item-${AGENT_KNOWLEDGE_CAP + 4}`);
    });

    it('PERSIST_empty_snapshot_restores_empty', 0, () => {
      const b = new AgentContext();
      b.restore({ version: 3, counter: 0, knowledge: [], messages: [] });
      expect(b.knowledgeCount()).assertEqual(0);
      expect(b.messages.length).assertEqual(0);
      b.ensureIntro();
      expect(b.messages.length).assertEqual(1);
    });

    it('PERSIST_onChanged_fires_on_mutation_not_on_restore', 0, () => {
      const a = new AgentContext();
      let fires = 0;
      a.onChanged = () => {
        fires += 1;
      };
      a.addTextNote('x');
      expect(fires > 0).assertTrue();
      const before = fires;
      a.restore({ version: 3, counter: 0, knowledge: [], messages: [] });
      expect(fires).assertEqual(before);
      a.say('system', 'transient marker', false);
      expect(fires).assertEqual(before);
    });

    it('PERSIST_D20_ephemeral_notice_never_enters_snapshot', 0, () => {
      // R3-D20: the restore marker is said with persist=false; before the
      // fix it stayed in memory and was swept into the NEXT save, so every
      // launch accumulated one more visible marker copy.
      const a = new AgentContext();
      a.addTextNote('已确认条目');
      a.say('system', '已从本地恢复 1 条已保存知识与对话上下文(0.1 原型有界本地存储,非生产备份)。', false);
      a.say('system', '已生成演示候选(TEST_FIXTURE):后续持久化事件');
      const snap = a.snapshot();
      for (const m of snap.messages) {
        expect(m.text.indexOf('已从本地恢复') === 0).assertFalse();
      }
      expect(snap.messages.some((m: AgentMessage) => m.text.indexOf('已生成演示候选') === 0)).assertTrue();
    });

    it('PERSIST_D20_restore_drops_legacy_persisted_restore_markers', 0, () => {
      // Snapshots written by older builds may already contain the leaked
      // marker — restore must refuse them so the pollution self-heals.
      const rawJson: string = '{"version":3,"counter":1,' +
        '"knowledge":[{"id":"kt-1","title":"ok","text":"ok","source":"text","confirmedAt":1,"speakerState":"N/A"}],' +
        '"messages":[' +
        '{"role":"system","text":"已从本地恢复 1 条已保存知识与对话上下文(0.1 原型有界本地存储,非生产备份)。","at":1},' +
        '{"role":"agent","text":"正常消息","at":2}]}';
      const legacy = JSON.parse(rawJson) as AgentSnapshot;
      const b = new AgentContext();
      b.restore(legacy);
      expect(b.messages.length).assertEqual(1);
      expect(b.messages[0].text).assertEqual('正常消息');
      // And re-snapshotting stays clean even after a fresh marker is shown.
      b.say('system', '已从本地恢复 1 条已保存知识与对话上下文(0.1 原型有界本地存储,非生产备份)。', false);
      const snap2 = b.snapshot();
      for (const m of snap2.messages) {
        expect(m.text.indexOf('已从本地恢复') === 0).assertFalse();
      }
    });
  });
}
