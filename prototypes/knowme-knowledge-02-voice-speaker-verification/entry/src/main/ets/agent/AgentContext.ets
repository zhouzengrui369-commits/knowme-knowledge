/**
 * Lightweight Agent-first context for the KK-02 prototype.
 *
 * Voice is an ATTACHED capture capability of the 灵犀 Agent — not a recorder
 * app. This model keeps the accepted GOAL-KK-01 grammar alive: conversation
 * thread → voice candidate card → correct / reject / explicit confirm →
 * knowledge-context growth → Agent explanation → context preserved.
 *
 * Honest disclosure: the Agent here is a deterministic prototype shell —
 * NO real LLM/Harness/RAG (out of scope by contract).
 */

export interface AgentMessage {
  role: 'agent' | 'owner' | 'system';
  text: string;
  at: number;
}

export interface KnowledgeItem {
  id: string;
  title: string;
  source: 'voice' | 'text';
  confirmedAt: number;
  speakerState: string;
}

export class AgentContext {
  messages: AgentMessage[] = [];
  knowledge: KnowledgeItem[] = [];
  private counter = 0;

  constructor() {
    this.say('agent', '我是灵犀。语音是你的新捕获通道:先说,我看清是谁说的、说了什么,再由你决定要不要入库。');
  }

  say(role: 'agent' | 'owner' | 'system', text: string): void {
    this.messages.push({ role: role, text: text, at: Date.now() });
  }

  knowledgeCount(): number {
    return this.knowledge.length;
  }

  /** Explicit-confirm ingestion (VERIFIED voice candidate only). */
  confirmVoiceCandidate(text: string, speakerState: string): KnowledgeItem | null {
    const trimmed = text.trim();
    if (trimmed.length === 0) {
      return null;
    }
    this.counter += 1;
    const title = trimmed.length > 24 ? `${trimmed.slice(0, 24)}…` : trimmed;
    const item: KnowledgeItem = {
      id: `kv-${this.counter}`,
      title: title,
      source: 'voice',
      confirmedAt: Date.now(),
      speakerState: speakerState
    };
    this.knowledge.push(item);
    this.say('agent', `已入库:「${item.title}」。这条来自你本人的语音(已验证),是你确认后才进入知识的。`);
    return item;
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
      source: 'text',
      confirmedAt: Date.now(),
      speakerState: 'N/A'
    };
    this.knowledge.push(item);
    this.say('agent', `已记下:「${item.title}」(手动文本)。`);
    return item;
  }
}
