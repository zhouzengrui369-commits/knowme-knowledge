# Interaction State Map — GOAL-KK-01 PX Findings Correction R1

Contract §28 transition coverage plus R2/R3/R4/R5 additions, updated for the
PX correction. Machine-verified by tests/browser_assertions.py (115/115).

```text
FIRST_VIEW → ASK_AGENT                                   ASK_AGENT_WORKS, STATE_ASK_AGENT
FIRST_VIEW → CAPTURE                                     TEXT_CAPTURE_WORKS, STATE_CAPTURE
CAPTURE → CANDIDATE_KNOWLEDGE                            CANDIDATE_KNOWLEDGE_CREATED
CANDIDATE_KNOWLEDGE → CANDIDATE_KNOWLEDGE (correct→save) CORRECT_SAVE_RETURNS_TO_CANDIDATE   ← PX1 model A
CANDIDATE_KNOWLEDGE → CONFIRMED (explicit 确认入库 only)  CONFIRM_WORKS, CORRECT_WORKS        ← PX1
CONFIRMED → KNOWLEDGE_CONTEXT_UPDATED                    CONFIRMED_KNOWLEDGE_CHANGES_CONTEXT, STATE_CONTEXT_UPDATED
CANDIDATE_KNOWLEDGE → REJECTED                           REJECT_WORKS, REJECT_DOES_NOT_GROW_CONTEXT
KNOWLEDGE_CONTEXT_UPDATED → KNOWLEDGE_WORK               KNOWLEDGE_ITEM_OPENS, WORK_SURFACE_OPENS
AGENT_CONTEXT → CAPABILITY_WORK                          CAPABILITY_OPENS_CONTEXTUAL_WORK, STATE_CAPABILITY_WORK
CAPABILITY_WORK → AGENT_CONTEXT_RESTORED                 STATE_CONTEXT_RESTORED
KNOWLEDGE_WORK → AGENT_CONTEXT_RESTORED (direct)         WORK_BACK_LABEL_MATCHES_TARGET_NAV_PATH,
                                                         PX04_AGENT_PATH_BACK_MATCHES_LABEL  ← PX1 option A
SENSING=ON/PAUSED × all sheets                           PX02_* (15 assertions)               ← PX1
```

## PX1 semantic changes

- `保存修正` no longer transitions CANDIDATE_KNOWLEDGE → CONFIRMED. It stays
  in CANDIDATE_KNOWLEDGE with updated draft content; only the explicit
  「确认入库」 control performs the CONFIRMED transition. One trustworthy
  state: confirmed items carry `已确认`, never `待确认` (KK-PX-R5-03).
- Work surface 「返回 Agent 对话」 now performs KNOWLEDGE_WORK →
  AGENT_CONTEXT_RESTORED directly (both entry paths), matching its label;
  conversation and knowledge context persist (KK-PX-R5-04).
- Every sheet overlay carries the sensing state sub-display and pause/resume
  control; the global strip remains the same underlying state (KK-PX-R5-02).
- Agent replies and work surfaces are functions of the selected/matched item's
  own recorded content; no cross-topic template state exists (KK-PX-R5-01).
