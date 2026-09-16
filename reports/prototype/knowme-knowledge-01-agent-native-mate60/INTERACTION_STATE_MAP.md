# Interaction State Map — GOAL-KK-01 Prototype (R2)

```text
ARTIFACT=INTERACTION_STATE_MAP
ACTOR_ROLE=ENGINEERING_DELIVERY
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
CANDIDATE_SHA=9f3071e22def4f99cbf3a4589349e628e9e15a97
```

The running prototype exposes its current state on
`[data-testid="app-root"][data-journey-state]`, and the sensing strip exposes
`[data-sensing=on|off]`. Every state below corresponds to real UI and
executable actions, and each transition is exercised by the browser
assertion suite (57/57 at the final operated candidate, both runs).

| State | Real UI | Entry action | Exit actions |
|---|---|---|---|
| FIRST_VIEW | Header (Agent identity + disclosure pill), **sensing strip (on, ticking)**, context strip, opening Agent message, composer, bottom nav | cold load | type+send → ASK_AGENT; tap 捕获 → CAPTURE; tap 日历/待办/技能 → CAPABILITY_WORK; tap 知识 → knowledge sheet (KNOWLEDGE_WORK); mic key → sensing paused (journey state unchanged) |
| ASK_AGENT | user bubble + deterministic Agent reply with reference chips + next-action button | send question | tap next-action → knowledge detail; tap nav → CAPTURE / CAPABILITY_WORK |
| CAPTURE | capture sheet: channel cards (Text AVAILABLE; Voice/Files/Website PROTOTYPE_ONLY), textarea, 生成候选知识 | nav 捕获 / Agent next-action | submit text → CANDIDATE_KNOWLEDGE; close → previous state (conversation + sensing intact) |
| CANDIDATE_KNOWLEDGE | candidate card: pipeline 已采集→AI整理草稿→确认后入库, CANDIDATE chip, 确认入库/修正/拒绝 | 生成候选知识 | 确认入库 → CONFIRMED; 修正 → edit → 保存修正 → CONFIRMED; 拒绝 → CAPTURE |
| CONFIRMED | transient: candidate committed, sheet closing | confirm / save-correction | automatic → KNOWLEDGE_CONTEXT_UPDATED |
| KNOWLEDGE_CONTEXT_UPDATED | header + context strip counts increment; Agent posts explanation message with ref chip and next-action | confirm completion | tap next-action → KNOWLEDGE_WORK; any nav → corresponding state |
| KNOWLEDGE_WORK | knowledge sheet with **two tabs**: 知识导航 (MOC/WIKI/NOTE groups) and 按日历查看 (day groups); → knowledge detail (summary, 来源与状态, day attribution, 关联知识) → 上下文工作面 | nav 知识 / next-action | tab switch (asserted); work-surface-back → detail → list → close → conversation preserved |
| CAPABILITY_WORK | capability sheet with honest state chip; Calendar: **visual week strip + per-day schedule + 当日关联待办**, day switch; Todo: togglable mock items + **calendar deep link**; Skills: PLANNED | nav 日历/待办/技能 / todo-calendar-link | close → AGENT_CONTEXT_RESTORED; todo deep link → calendar sheet on linked day |
| AGENT_CONTEXT_RESTORED | identical conversation DOM, scroll content preserved, sensing strip still alive | close capability sheet | any FIRST_VIEW action |

Sensing sub-state (orthogonal to journey state):

```text
sensing=on  (default, continuous background, stream ticks)
  -- mic key --> sensing=off (感知已暂停 / 点击麦克风恢复持续感知)
  -- mic key --> sensing=on  (resumes; stream continues)
Survives: CAPTURE / KNOWLEDGE_WORK / CAPABILITY_WORK open+close
Asserted: SENSING_STRIP_VISIBLE, SENSING_CONTINUOUS_BY_DEFAULT,
          SENSING_HONESTLY_MOCK, SENSING_STREAM_TICKS,
          VOICE_KEY_PAUSES_SENSING, VOICE_KEY_RESUMES_SENSING,
          SENSING_RUNS_IN_BACKGROUND
```

Required transition coverage (contract §28) + R2 additions:

```text
FIRST_VIEW → ASK_AGENT                          asserted (STATE_ASK_AGENT)
FIRST_VIEW → CAPTURE                            asserted (STATE_CAPTURE)
CAPTURE → CANDIDATE_KNOWLEDGE                   asserted (CANDIDATE_KNOWLEDGE_CREATED)
CANDIDATE_KNOWLEDGE → CONFIRMED                 asserted (CONFIRM_WORKS / CORRECT_WORKS)
CONFIRMED → KNOWLEDGE_CONTEXT_UPDATED           asserted (STATE_CONTEXT_UPDATED)
KNOWLEDGE_CONTEXT_UPDATED → KNOWLEDGE_WORK      asserted (KNOWLEDGE_ITEM_OPENS via next-action)
AGENT_CONTEXT → CAPABILITY_WORK                 asserted (STATE_CAPABILITY_WORK)
CAPABILITY_WORK → AGENT_CONTEXT_RESTORED        asserted (STATE_CONTEXT_RESTORED)
R2: knowledge sheet tab navigation              asserted (KNOWLEDGE_NAVIGATION_VIEW / KNOWLEDGE_CALENDAR_VIEW)
R2: confirmed item visible in nav + calendar    asserted (CAPTURED_ITEM_IN_NAV / VALUE_LOOP_CAPTURED_VISIBLE_BY_CALENDAR)
R2: calendar day switch + linked todo           asserted (CALENDAR_DAY_SWITCH / CALENDAR_TODO_LINKED_ON_DAY)
R2: todo → calendar deep link                   asserted (TODO_DEEP_LINKS_TO_CALENDAR_DAY)
```

Negative paths: reject keeps context count unchanged
(REJECT_DOES_NOT_GROW_CONTEXT); unknown-topic questions acknowledge the gap
and route to capture (UNKNOWN_TOPIC_ACKNOWLEDGES_GAP +
UNKNOWN_TOPIC_NEXT_ACTION_CAPTURE).
