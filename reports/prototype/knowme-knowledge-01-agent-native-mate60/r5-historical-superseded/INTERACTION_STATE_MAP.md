# Interaction State Map — GOAL-KK-01 Prototype (R5)

```text
ARTIFACT=INTERACTION_STATE_MAP
ACTOR_ROLE=ENGINEERING_DELIVERY
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
CANDIDATE_SHA=40063afd16a36674e8660f6b4a05315d51f4e546
```

The running prototype exposes its current state on
`[data-testid="app-root"][data-journey-state]`, and the sensing strip exposes
`[data-sensing=on|off]`. Every state below corresponds to real UI and
executable actions; each transition is exercised by the browser assertion
suite (80/80 at the final operated candidate, both runs).

| State | Real UI | Entry action | Exit actions |
|---|---|---|---|
| FIRST_VIEW | Header (Agent identity + disclosure pill), sensing strip (on, ticking), context strip, opening Agent message, composer, bottom nav | cold load | type+send → ASK_AGENT; tap 捕获 → CAPTURE; tap 日历/待办/技能 → CAPABILITY_WORK; tap 知识 → knowledge sheet; mic key → sensing paused (journey state unchanged) |
| ASK_AGENT | user bubble + deterministic Agent reply with reference chips + next-action button | send question | tap next-action → knowledge detail; tap nav → CAPTURE / CAPABILITY_WORK |
| CAPTURE | capture sheet: channel cards (Text AVAILABLE; Voice/Files/Website PROTOTYPE_ONLY), textarea, 生成候选知识 | nav 捕获 / Agent next-action | submit text → CANDIDATE_KNOWLEDGE; close → previous state |
| CANDIDATE_KNOWLEDGE | candidate card: pipeline, CANDIDATE chip, 确认入库/修正/拒绝 | 生成候选知识 | 确认入库 → CONFIRMED; 修正 → CONFIRMED; 拒绝 → CAPTURE |
| CONFIRMED | transient: candidate committed | confirm / save-correction | automatic → KNOWLEDGE_CONTEXT_UPDATED |
| KNOWLEDGE_CONTEXT_UPDATED | counts increment; Agent explanation with ref chip + next-action | confirm completion | tap next-action → KNOWLEDGE_WORK; any nav |
| KNOWLEDGE_WORK | knowledge sheet, two tabs: 知识导航 (**五维知识地图 + 九维认知图谱**, expandable dims, MOC/WIKI/NOTE groups) and 按日历查看 (day groups); → knowledge detail → 上下文工作面 | nav 知识 / next-action | dim expand/collapse (asserted); tab switch (asserted); back paths → conversation preserved |
| CAPABILITY_WORK | capability sheet; Calendar: **日/周/月 three views** — day (week strip + schedule + 当日关联待办), week (Mon–Sun rows), month (September 2026 grid, dots, deep-open); Todo: toggles + calendar deep link; Skills: PLANNED | nav 日历/待办/技能 / todo-calendar-link | view switch (asserted); month cell / week row → day view (asserted); close → AGENT_CONTEXT_RESTORED |
| AGENT_CONTEXT_RESTORED | identical conversation DOM, sensing strip alive | close capability sheet | any FIRST_VIEW action |

Sensing sub-state (orthogonal): sensing=on (default, ticks) ↔ mic key ↔
sensing=off (感知已暂停); survives every sheet open/close. Asserted by
SENSING_STRIP_VISIBLE, SENSING_CONTINUOUS_BY_DEFAULT, SENSING_HONESTLY_MOCK,
SENSING_STREAM_TICKS, VOICE_KEY_PAUSES_SENSING, VOICE_KEY_RESUMES_SENSING,
SENSING_RUNS_IN_BACKGROUND.

Required transition coverage (contract §28) + R2/R3/R4/R5 additions:

```text
FIRST_VIEW → ASK_AGENT                          STATE_ASK_AGENT
FIRST_VIEW → CAPTURE                            STATE_CAPTURE
CAPTURE → CANDIDATE_KNOWLEDGE                   CANDIDATE_KNOWLEDGE_CREATED
CANDIDATE_KNOWLEDGE → CONFIRMED                 CONFIRM_WORKS / CORRECT_WORKS
CONFIRMED → KNOWLEDGE_CONTEXT_UPDATED           STATE_CONTEXT_UPDATED
KNOWLEDGE_CONTEXT_UPDATED → KNOWLEDGE_WORK      KNOWLEDGE_ITEM_OPENS
AGENT_CONTEXT → CAPABILITY_WORK                 STATE_CAPABILITY_WORK
CAPABILITY_WORK → AGENT_CONTEXT_RESTORED        STATE_CONTEXT_RESTORED (incl. via 引用对话 sheet auto-close)
R2: knowledge tabs / calendar / todo deep link  KNOWLEDGE_NAVIGATION_VIEW, KNOWLEDGE_CALENDAR_VIEW, TODO_DEEP_LINKS_TO_CALENDAR_DAY, …
R3: dim maps                                    KNOWLEDGE_NAV_FIVE_DIM_MAP, KNOWLEDGE_NAV_NINE_DIM_COGNITIVE, CAPTURED_ITEM_IN_FIVE_DIM, DIM_ROW_EXPAND_LISTS_REAL_ITEMS, DIM_ITEM_OPENS_DETAIL
R3: calendar views                              CALENDAR_VIEW_SWITCHER, CALENDAR_MONTH_VIEW, CALENDAR_MONTH_EVENT_DOTS, CALENDAR_MONTH_DAY_OPENS_DAY_VIEW, CALENDAR_WEEK_VIEW
R4: brand rename                                BRAND_RENAMED_LINGXI (懂我 → 灵犀, Owner-directed)
R5: nav simplification                          KNOWLEDGE_NAV_NO_LEGACY_GROUPS, CAPTURED_ITEM_IN_NAV (via 九维 expansion)
R5: knowledge calendar views                    KNOWLEDGE_CAL_VIEW_SWITCHER, KNOWLEDGE_CAL_MONTH_VIEW, KNOWLEDGE_CAL_MONTH_CELL_OPENS_DAY, KNOWLEDGE_CAL_OTHER_MONTH_DAY, KNOWLEDGE_CAL_WEEK_VIEW
R5: quick actions + 引用对话                    SCHEDULE_QUICK_ACTION_COMPLETE, SCHEDULE_QUICK_ACTION_POSTPONE, SCHEDULE_POSTPONED_VISIBLE_ON_NEXT_DAY, SCHEDULE_REFERENCE_TO_CHAT, TODO_QUICK_ACTION_POSTPONE, TODO_REFERENCE_TO_CHAT
```

Negative paths: reject keeps context count unchanged
(REJECT_DOES_NOT_GROW_CONTEXT); unknown-topic questions acknowledge the gap
and route to capture (UNKNOWN_TOPIC_ACKNOWLEDGES_GAP +
UNKNOWN_TOPIC_NEXT_ACTION_CAPTURE); zero-count dimensions render an honest
empty note instead of fabricated items.
