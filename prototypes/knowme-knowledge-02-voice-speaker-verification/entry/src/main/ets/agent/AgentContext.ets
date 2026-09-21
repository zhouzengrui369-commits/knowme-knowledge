/**
 * Lightweight Agent-first context for the KK-02 prototype.
 *
 * Voice is an ATTACHED capture capability of the 灵犀 Agent — not a recorder
 * app. This model keeps the accepted GOAL-KK-01 grammar alive: conversation
 * thread → voice candidate card → correct / reject / explicit confirm →
 * knowledge-context growth → Agent explanation → context preserved.
 *
 * R3 (PX-KK02-01): confirmed knowledge + bounded conversation context are
 * persistable through a snapshot/restore contract (AgentContextStore owns the
 * sandbox file I/O; this class stays kit-free and unit-testable). Only
 * EXPLICITLY confirmed items and manual text notes ever enter a snapshot —
 * draft / corrected / rejected / discarded voice candidates never do.
 *
 * Honest disclosure: the Agent here is a deterministic prototype shell —
 * NO real LLM/Harness/RAG (out of scope by contract).
 */

import { NoteDraft } from '../note/NoteFlow';

export interface AgentMessage {
  role: 'agent' | 'owner' | 'system';
  text: string;
  at: number;
  /**
   * R3-D20: transient UI notices (e.g. the "restored from local storage"
   * marker) must never cross a restart. say(..., persist=false) marks a
   * message ephemeral; snapshot() drops it and restore() refuses legacy
   * ones, so a marker can never accumulate one copy per launch.
   */
  ephemeral?: boolean;
}

export interface KnowledgeItem {
  id: string;
  title: string;
  /**
   * Canonical note body (R3: full content kept for later inspection).
   * For KK-03 note saves this is the ORGANIZED, user-edited body; it never
   * replaces the original transcript, which is kept separately below.
   */
  text: string;
  /**
   * voice  = real captured speech, VERIFIED speaker, explicitly saved;
   * text   = manual text entry (no voice claim);
   * fixture= disclosed simulator TEST_FIXTURE demo (no real ASR / no speaker claim).
   */
  source: 'voice' | 'text' | 'fixture';
  /**
   * KK-03 provenance: the original transcript exactly as captured/corrected
   * before organization. '' for manual text and for legacy (pre-KK-03) items.
   * ORIGINAL_SOURCE_PRESERVED: organized note bodies never overwrite this.
   */
  originalTranscript: string;
  confirmedAt: number;
  speakerState: string;
}

/** Serializable snapshot — the ONLY state allowed to cross process restarts. */
export interface AgentSnapshot {
  version: number;
  counter: number;
  knowledge: KnowledgeItem[];
  messages: AgentMessage[];
}

export const AGENT_SNAPSHOT_VERSION: number = 4;
/** Bounded prototype persistence: conversation tail + confirmed items caps. */
export const AGENT_MESSAGE_CAP: number = 30;
export const AGENT_KNOWLEDGE_CAP: number = 100;

export class AgentContext {
  messages: AgentMessage[] = [];
  knowledge: KnowledgeItem[] = [];
  private counter = 0;
  /** Fired after every persisted-state mutation (wired to the store by the page). */
  onChanged: () => void = () => {};

  /** First-run intro — only when nothing was restored. */
  ensureIntro(): void {
    if (this.messages.length === 0 && this.knowledge.length === 0) {
      this.say('agent',
        '我是灵犀,你的个人知识 Agent。点下方「开始录音」说一段话,我会给你诚实的转写候选;' +
        '你确认后点「整理成笔记」,编辑、保存,这条知识才真正入库。未经你确认的转写永远不会变成知识。');
    }
  }

  say(role: 'agent' | 'owner' | 'system', text: string, persist: boolean = true): void {
    this.messages.push({ role: role, text: text, at: Date.now(), ephemeral: !persist });
    if (this.messages.length > AGENT_MESSAGE_CAP) {
      this.messages = this.messages.slice(this.messages.length - AGENT_MESSAGE_CAP);
    }
    if (persist) {
      this.onChanged();
    }
  }

  knowledgeCount(): number {
    return this.knowledge.length;
  }

  /** Snapshot of exactly the state that may survive restart (bounded). */
  snapshot(): AgentSnapshot {
    return {
      version: AGENT_SNAPSHOT_VERSION,
      counter: this.counter,
      knowledge: this.knowledge.slice(-AGENT_KNOWLEDGE_CAP),
      messages: this.messages.filter((m: AgentMessage) => m.ephemeral !== true).slice(-AGENT_MESSAGE_CAP)
    };
  }

  /**
   * Restore a previously persisted snapshot. Defensive: any malformed field
   * drops that entry (never throws on corrupt data); unknown/missing content
   * restores as empty. Restored items keep their original source labels —
   * rejected/discarded/unconfirmed candidates are absent by construction.
   */
  restore(snap: AgentSnapshot): void {
    const knowledge: KnowledgeItem[] = [];
    if (Array.isArray(snap.knowledge)) {
      for (const raw of snap.knowledge) {
        if (raw && typeof raw.id === 'string' && typeof raw.title === 'string' &&
          typeof raw.text === 'string' && typeof raw.confirmedAt === 'number' &&
          (raw.source === 'voice' || raw.source === 'text' || raw.source === 'fixture')) {
          knowledge.push({
            id: raw.id,
            title: raw.title,
            text: raw.text,
            source: raw.source,
            originalTranscript: typeof raw.originalTranscript === 'string' ? raw.originalTranscript : '',
            confirmedAt: raw.confirmedAt,
            speakerState: typeof raw.speakerState === 'string' ? raw.speakerState : 'N/A'
          });
        }
      }
    }
    const messages: AgentMessage[] = [];
    if (Array.isArray(snap.messages)) {
      for (const raw of snap.messages) {
        if (raw && (raw.role === 'agent' || raw.role === 'owner' || raw.role === 'system') &&
          typeof raw.text === 'string' && typeof raw.at === 'number') {
          // R3-D20 defense: never resurrect transient notices persisted by
          // older builds (restore marker leaked into snapshots before the
          // ephemeral filter existed).
          if (raw.ephemeral === true || raw.text.indexOf('已从本地恢复') === 0) {
            continue;
          }
          messages.push({ role: raw.role, text: raw.text, at: raw.at });
        }
      }
    }
    this.knowledge = knowledge.slice(-AGENT_KNOWLEDGE_CAP);
    this.messages = messages.slice(-AGENT_MESSAGE_CAP);
    // ID continuity: never re-issue an id that a restored item already used.
    let maxNum = typeof snap.counter === 'number' && snap.counter >= 0 ? Math.floor(snap.counter) : 0;
    for (const item of this.knowledge) {
      const m = /^k[a-z]+-(\d+)$/.exec(item.id);
      if (m) {
        const n = parseInt(m[1], 10);
        if (n > maxNum) {
          maxNum = n;
        }
      }
    }
    this.counter = maxNum;
  }

  /** Explicit-confirm ingestion (VERIFIED voice candidate only). */
  confirmVoiceCandidate(text: string, speakerState: string, fixture: boolean = false): KnowledgeItem | null {
    const trimmed = text.trim();
    if (trimmed.length === 0) {
      return null;
    }
    this.counter += 1;
    const item: KnowledgeItem = {
      id: `kv-${this.counter}`,
      title: trimmed.length > 24 ? `${trimmed.slice(0, 24)}…` : trimmed,
      text: trimmed,
      source: fixture ? 'fixture' : 'voice',
      originalTranscript: trimmed,
      confirmedAt: Date.now(),
      speakerState: speakerState
    };
    this.knowledge.push(item);
    if (fixture) {
      this.say('agent', `已入库:「${item.title}」。⚠ 来源是模拟器测试转写(TEST_FIXTURE),不是真实语音识别;仅演示候选流程,真机未验证。`);
    } else {
      this.say('agent', `已入库:「${item.title}」。这条来自你本人的语音(已验证),是你确认后才进入知识的。`);
    }
    return item;
  }

  /**
   * KK-03: explicit note-draft save — exactly +1 knowledge item with full
   * provenance (source class + original transcript). The organized/edited
   * body becomes the canonical note text; the original transcript rides
   * alongside and is never overwritten. Caller guarantees exactly-once
   * (NoteFlowController.save is terminal).
   */
  saveNoteDraft(draft: NoteDraft): KnowledgeItem | null {
    const title = draft.title.trim();
    const body = draft.body.trim();
    if (title.length === 0 || body.length === 0) {
      return null;
    }
    this.counter += 1;
    const item: KnowledgeItem = {
      id: `kn-${this.counter}`,
      title: title,
      text: body,
      source: draft.source,
      originalTranscript: draft.originalTranscript,
      confirmedAt: Date.now(),
      speakerState: draft.speakerState
    };
    this.knowledge.push(item);
    if (draft.source === 'fixture') {
      this.say('agent',
        `已保存笔记「${item.title}」,知识 +1(现在共 ${this.knowledgeCount()} 条)。⚠ 来源是模拟器测试转写(TEST_FIXTURE),不是真实语音识别;原始测试转写已保留,可随时点开笔记查看。`);
    } else if (draft.source === 'voice') {
      this.say('agent',
        `已保存笔记「${item.title}」,知识 +1(现在共 ${this.knowledgeCount()} 条)。这条来自你本人已验证的语音;原始转写已保留,点开笔记即可对照查看。`);
    } else {
      this.say('agent', `已保存笔记「${item.title}」,知识 +1(现在共 ${this.knowledgeCount()} 条,手动文本来源)。`);
    }
    return item;
  }

  /** KK-03: explicit note-draft cancel — +0 knowledge, honestly explained. */
  explainNoteCancelled(): void {
    this.say('agent', '已取消,这条笔记没有保存。知识没有变化(+0);原始转写候选也已丢弃。');
  }

  explainBlocked(reason: string): void {
    this.say('agent', `这段语音没有进入候选:${reason}。它不会静默变成知识。你可以重说、改用手动文本,或先完成机主声纹注册。`);
  }

  explainRejected(): void {
    this.say('agent', '已丢弃这段语音转写,知识没有变化。');
  }

  /** Manual text capture stays available (deterministic, no trust claims). */
  addTextNote(text: string): KnowledgeItem | null {
    const trimmed = text.trim();
    if (trimmed.length === 0) {
      return null;
    }
    this.counter += 1;
    const item: KnowledgeItem = {
      id: `kt-${this.counter}`,
      title: trimmed.length > 24 ? `${trimmed.slice(0, 24)}…` : trimmed,
      text: trimmed,
      source: 'text',
      originalTranscript: '',
      confirmedAt: Date.now(),
      speakerState: 'N/A'
    };
    this.knowledge.push(item);
    this.say('agent', `已记下:「${item.title}」(手动文本)。`);
    return item;
  }
}
