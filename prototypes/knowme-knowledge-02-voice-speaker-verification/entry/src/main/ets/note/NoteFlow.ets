/**
 * GOAL-KK-03 pure note-flow logic — no @kit imports, deterministic, unit-testable.
 *
 * Frozen contract semantics implemented here:
 *  - A transcript candidate is NEVER silently saved. The only forward path is
 *    the explicit "整理成笔记" action, which creates exactly one NOTE_DRAFT.
 *  - The draft carries title + editable body + source + the ORIGINAL
 *    transcript as immutable provenance. Organized content never overwrites
 *    the original transcript.
 *  - Explicit save ingests exactly +1 knowledge item; cancel/reject ingest +0.
 *    Double-tap / repeated submit can never create a duplicate (+2) — save()
 *    and cancel() are exactly-once terminal operations.
 *  - Trust discipline is unchanged from GOAL-KK-02: a VOICE-sourced draft may
 *    only be saved when the capture speaker verdict was VERIFIED; FIXTURE and
 *    TEXT drafts carry no speaker claim and save like manual text.
 *  - The note organizer is DETERMINISTIC (no real LLM/RAG — contract claim
 *    ceiling). It only restructures the transcript text; it never invent
 *    content that was not spoken.
 */

import { CandidateTrustClass, SpeakerState } from '../core/VoiceCore';

export enum NoteDraftStatus {
  NONE = 'NONE',
  EDITING = 'EDITING',
  SAVED = 'SAVED',
  CANCELLED = 'CANCELLED'
}

export type NoteSource = 'voice' | 'fixture' | 'text';

export interface NoteDraft {
  id: string;
  title: string;
  /** Organized, editable canonical note body. */
  body: string;
  source: NoteSource;
  /** Immutable provenance: the transcript exactly as captured/corrected. */
  originalTranscript: string;
  /** Speaker verdict at capture time ('N/A' when no voice claim exists). */
  speakerState: string;
  trustClass: CandidateTrustClass;
  createdAt: number;
}

export interface OrganizedNote {
  title: string;
  body: string;
}

const TITLE_MAX_CHARS: number = 20;

/** Split a transcript into sentences on CJK/ASCII sentence punctuation. */
export function splitSentences(text: string): string[] {
  const parts: string[] = text.split(/[。!?!?\n;；]+/);
  const out: string[] = [];
  for (const p of parts) {
    const t = p.trim();
    if (t.length > 0) {
      out.push(t);
    }
  }
  return out;
}

/**
 * Deterministic transcript → note organization.
 * Title: first sentence, truncated honestly with an ellipsis marker.
 * Body: one bullet line per sentence, in original order — nothing added,
 * nothing summarized away; the original transcript stays intact alongside.
 */
export function organizeTranscript(transcript: string): OrganizedNote {
  const trimmed = transcript.trim();
  const sentences = splitSentences(trimmed);
  const first = sentences.length > 0 ? sentences[0] : trimmed;
  const title = first.length > TITLE_MAX_CHARS
    ? `${first.slice(0, TITLE_MAX_CHARS)}…`
    : first;
  const lines: string[] = [];
  for (const s of sentences) {
    lines.push(`· ${s}`);
  }
  const body = lines.length > 0 ? lines.join('\n') : trimmed;
  return { title: title, body: body };
}

/** A note may be saved only while EDITING and only under its trust rule. */
export function canSaveNoteDraft(status: NoteDraftStatus, trustClass: CandidateTrustClass,
  speakerState: string): boolean {
  if (status !== NoteDraftStatus.EDITING) {
    return false;
  }
  if (trustClass === CandidateTrustClass.VOICE) {
    return speakerState === SpeakerState.VERIFIED;
  }
  // FIXTURE / TEXT drafts claim no speaker identity — same ingest class as
  // the long-standing manual-text path (explicit save, honest source label).
  return true;
}

/**
 * Owns the lifecycle of exactly one note draft:
 * NONE → EDITING → (SAVED | CANCELLED). Terminal transitions are
 * exactly-once; every later save()/cancel() call is a refused no-op.
 */
export class NoteFlowController {
  status: NoteDraftStatus = NoteDraftStatus.NONE;
  draft: NoteDraft | null = null;
  private seq = 0;

  /** Create a draft from a transcript candidate ("整理成笔记"). */
  createFromCandidate(transcript: string, source: NoteSource, speakerState: string,
    trustClass: CandidateTrustClass): boolean {
    const trimmed = transcript.trim();
    if (this.status === NoteDraftStatus.EDITING || trimmed.length === 0) {
      return false;
    }
    const organized = organizeTranscript(trimmed);
    this.seq += 1;
    this.draft = {
      id: `nd-${this.seq}`,
      title: organized.title,
      body: organized.body,
      source: source,
      originalTranscript: trimmed,
      speakerState: speakerState,
      trustClass: trustClass,
      createdAt: Date.now()
    };
    this.status = NoteDraftStatus.EDITING;
    return true;
  }

  editTitle(title: string): boolean {
    if (this.status !== NoteDraftStatus.EDITING || this.draft === null) {
      return false;
    }
    this.draft.title = title;
    return true;
  }

  editBody(body: string): boolean {
    if (this.status !== NoteDraftStatus.EDITING || this.draft === null) {
      return false;
    }
    this.draft.body = body;
    return true;
  }

  /**
   * Explicit save — exactly-once. Returns the draft to ingest on the first
   * legal call; every repeated/t double call returns null (never a duplicate).
   * A blank title/body is refused honestly (the draft stays EDITING).
   */
  save(): NoteDraft | null {
    if (this.draft === null ||
      !canSaveNoteDraft(this.status, this.draft.trustClass, this.draft.speakerState)) {
      return null;
    }
    if (this.draft.title.trim().length === 0 || this.draft.body.trim().length === 0) {
      return null;
    }
    const out = this.draft;
    this.status = NoteDraftStatus.SAVED;
    return out;
  }

  /** Explicit cancel — exactly-once, +0 knowledge by construction. */
  cancel(): boolean {
    if (this.status !== NoteDraftStatus.EDITING) {
      return false;
    }
    this.status = NoteDraftStatus.CANCELLED;
    return true;
  }

  /** Dispose a terminal draft (after save/cancel has been handled). */
  clear(): void {
    if (this.status === NoteDraftStatus.SAVED || this.status === NoteDraftStatus.CANCELLED) {
      this.status = NoteDraftStatus.NONE;
      this.draft = null;
    }
  }
}
