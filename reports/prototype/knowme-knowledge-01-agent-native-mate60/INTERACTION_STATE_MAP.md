# Interaction State Map — GOAL-KK-01 Prototype

```text
ARTIFACT=INTERACTION_STATE_MAP
ACTOR_ROLE=ENGINEERING_DELIVERY
CANDIDATE_SHA=fb432162e7dd099a32fec7b52ff00659982942f3
```

The running prototype exposes its current state on
`[data-testid="app-root"][data-journey-state]`. Every state below corresponds
to real UI and executable actions, and each transition is exercised by the
browser assertion suite (41/41 at the final operated candidate).

| State | Real UI | Entry action | Exit actions |
|---|---|---|---|
| FIRST_VIEW | Header (Agent identity + disclosure pill), context strip, opening Agent message, composer, bottom nav | cold load | type+send → ASK_AGENT; tap 捕获 → CAPTURE; tap 日历/待办/技能 → CAPABILITY_WORK; tap 知识 → knowledge sheet |
| ASK_AGENT | user bubble + deterministic Agent reply with reference chips + next-action button | send question | tap next-action → knowledge detail (KNOWLEDGE_WORK); tap nav → CAPTURE / CAPABILITY_WORK |
| CAPTURE | capture sheet: channel cards (Text AVAILABLE; Voice/Files/Website PROTOTYPE_ONLY), textarea, 生成候选知识 | nav 捕获 / Agent next-action | submit text → CANDIDATE_KNOWLEDGE; close → FIRST_VIEW/ASK_AGENT (conversation intact) |
| CANDIDATE_KNOWLEDGE | candidate card: pipeline 已采集→AI整理草稿→确认后入库, CANDIDATE chip, title/summary/tags/source, 确认入库/修正/拒绝 | 生成候选知识 | 确认入库 → CONFIRMED; 修正 → edit fields → 保存修正 → CONFIRMED; 拒绝 → CAPTURE (candidate discarded) |
| CONFIRMED | transient: candidate committed, sheet closing | confirm / save-correction | automatic → KNOWLEDGE_CONTEXT_UPDATED |
| KNOWLEDGE_CONTEXT_UPDATED | header + context strip counts increment; Agent posts explanation message with ref chip and next-action | confirm completion | tap next-action → KNOWLEDGE_WORK; any nav → corresponding state |
| KNOWLEDGE_WORK | knowledge sheet (list) → knowledge detail (summary, 来源与状态: source/state/evidence, 关联知识) → 上下文工作面 (conclusion card, metric grid, 返回 Agent 对话) | nav 知识 / next-action | work-surface-back → detail → list → close → conversation preserved |
| CAPABILITY_WORK | capability sheet with honest state chip; Calendar: mock schedule rows; Todo: togglable mock items; Skills: PLANNED card (no fake surface) | nav 日历/待办/技能 | close → AGENT_CONTEXT_RESTORED |
| AGENT_CONTEXT_RESTORED | identical conversation DOM, scroll position content preserved | close capability sheet | any FIRST_VIEW action |

Required transition coverage (contract §28):

```text
FIRST_VIEW → ASK_AGENT                         asserted (STATE_ASK_AGENT)
FIRST_VIEW → CAPTURE                           asserted (STATE_CAPTURE)
CAPTURE → CANDIDATE_KNOWLEDGE                  asserted (CANDIDATE_KNOWLEDGE_CREATED)
CANDIDATE_KNOWLEDGE → CONFIRMED                asserted (CONFIRM_WORKS / CORRECT_WORKS)
CONFIRMED → KNOWLEDGE_CONTEXT_UPDATED          asserted (STATE_CONTEXT_UPDATED)
KNOWLEDGE_CONTEXT_UPDATED → KNOWLEDGE_WORK     asserted (KNOWLEDGE_ITEM_OPENS via next-action path)
AGENT_CONTEXT → CAPABILITY_WORK                asserted (STATE_CAPABILITY_WORK)
CAPABILITY_WORK → AGENT_CONTEXT_RESTORED       asserted (STATE_CONTEXT_RESTORED)
```

Negative paths: reject keeps context count unchanged
(REJECT_DOES_NOT_GROW_CONTEXT); unknown-topic questions acknowledge the gap
and route to capture (UNKNOWN_TOPIC_ACKNOWLEDGES_GAP +
UNKNOWN_TOPIC_NEXT_ACTION_CAPTURE).
