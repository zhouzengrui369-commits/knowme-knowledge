# Screenshot Index — GOAL-KK-01 (R2, final exact candidate)

```text
ARTIFACT=SCREENSHOT_INDEX
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
CANDIDATE_SHA=9f3071e22def4f99cbf3a4589349e628e9e15a97
CANDIDATE_TREE=b165a075f4e6a3784c6fc7794fc8c5581dc539c0
VIEWPORT=360x780 (actual captured size), kind=MATE60_CLASS_SIMULATION
NOTE=No screenshot claims a real Mate60 viewport; both sets are browser
     simulations of a Mate60-class portrait viewport. No screenshot is a
     design mockup, stitched image, source screenshot, or a historical
     capture from a different SHA. All 20 frames bind to candidate 9f3071e.
```

## Local Executor set — `screenshots/local-executor/`

Runtime identity: fresh clone of the exact candidate, `npm ci && npm run dev`,
actual URL http://127.0.0.1:5173/. Operator: LOCAL_EXECUTOR
(LE-KK-GOAL01-9F3071E-FINAL-20260916-1205-C7A2), ~2026-09-16T04:13Z.

| Screenshot | sha256 (prefix) | Journey | State before → action → state after | Evidence meaning |
|---|---|---|---|---|
| R2-LE-P01-FIRST-ENCOUNTER | ddbe990e…dfc9e | A | cold load → open URL → Agent first view | First view: Agent identity, knowledge context, known/unknown, entries, plus continuous sensing strip (`data-sensing=on`) |
| R2-LE-P02-ASK-AGENT | 403554ef…c7bbf | B | first view → typed question + send → referenced mock reply | Real input produces a context-referencing Agent answer with next action |
| R2-LE-P03-CANDIDATE-KNOWLEDGE | 49a6bbde…03e2fe | C | capture sheet → submit text → candidate card | Capture produces a confirmable candidate with pipeline + 确认/修正/拒绝 |
| R2-LE-P04-KNOWLEDGE-CONTEXT-CHANGED | 9dcdb088…b5a71c | C | candidate card → 确认入库 → counts 6→7 | Confirmed knowledge visibly changes the context; Agent explains |
| R2-LE-P05-KNOWLEDGE-WORK-SURFACE | 7a714df7…8e1911 | D | knowledge detail → open work surface → surface rendered | Knowledge item supports a contextual work surface; detail shows day attribution |
| R2-LE-P06-CAPABILITY-WORK-SURFACE | 954cb3b5…f45da0 | E | calendar sheet → day switch 周四 → schedule + linked todo | Visual calendar week strip; per-day schedule + 当日关联待办; honest NOT_CONNECTED |
| R2-LE-P07-RETURN-CONTEXT-PRESERVED | c6525f28…ad60c7 | E→return | all sheets closed → conversation preserved | Full context restoration including Journey B question |
| R2-LE-P08-KNOWLEDGE-CALENDAR-VIEW | 22db7681…8ef39d1 | D/R2 | knowledge nav tab → 按日历查看 → day groups | Knowledge viewable by calendar; today's confirmed capture under 今天 2026-09-16 |
| R2-LE-P09-TODO-CALENDAR-LINK | 954cb3b5…f45da0 | E/R2 | todo toggle → todo-calendar-link-t-3 → calendar on linked day | Todo deep link lands the calendar on the linked day (byte-identical to P06, same surface; recorded, not hidden) |
| R2-LE-P10-KNOWLEDGE-NAVIGATION | a544fa45…c2dfcf | D/R2 | nav-knowledge → sheet in 知识导航 tab | Knowledge navigation: MOC/WIKI/NOTE groups; capture visible under NOTE |

Full per-shot metadata incl. sensing states:
`screenshots/local-executor/le-run-metadata.json`.

## ED personal set — `screenshots/ed-personal/`

Runtime identity: ED worktree verified at HEAD=9f3071e (= branch head = PR #9
head), `npm run dev`, actual URL http://127.0.0.1:5173. Operator:
ENGINEERING_DELIVERY
(ED-KK-GOAL01-EXACT-CANDIDATE-EVIDENCE-REBIND-20260916-1155-R2),
2026-09-16T04:16Z. Captured by the same assertion run recorded in
`ed-browser-assertions.json`.

| Screenshot | sha256 (prefix) | Journey | Interaction state at capture | Evidence meaning |
|---|---|---|---|---|
| R2-ED-P01-FIRST-ENCOUNTER | d347498a…b714fe | A | FIRST_VIEW + sensing on | ED-confirmed Agent-first first encounter with continuous sensing strip |
| R2-ED-P02-ASK-AGENT | 0b09fc37…ff6457 | B | ASK_AGENT | ED-confirmed ask-Agent loop with refs + next action |
| R2-ED-P03-CANDIDATE-KNOWLEDGE | b39aa57b…538e74 | C | CANDIDATE_KNOWLEDGE | ED-confirmed candidate card with all three decisions |
| R2-ED-P04-KNOWLEDGE-CONTEXT-CHANGED | 965421bc…fed9b | C | KNOWLEDGE_CONTEXT_UPDATED | ED-confirmed visible context growth (7 条) + Agent explanation |
| R2-ED-P05-KNOWLEDGE-WORK-SURFACE | 802edba1…330aaf | D | KNOWLEDGE_WORK | ED-confirmed contextual work surface over preserved conversation |
| R2-ED-P06-CAPABILITY-WORK-SURFACE | 9323c5f1…b7d88 | E | CAPABILITY_WORK (周四) | ED-confirmed visual calendar + 当日关联待办 + NOT_CONNECTED |
| R2-ED-P07-RETURN-CONTEXT-PRESERVED | f5dd5999…544e0 | E→return | AGENT_CONTEXT_RESTORED | ED-confirmed full conversation preservation across A–E |
| R2-ED-P08-KNOWLEDGE-CALENDAR-VIEW | 90de8c6c…2ed78 | D/R2 | knowledge 按日历查看 | ED-confirmed knowledge by calendar, capture under today |
| R2-ED-P09-TODO-CALENDAR-LINK | 9323c5f1…b7d88 | E/R2 | todo deep link → calendar 周四 | ED-confirmed todo-calendar association (byte-identical to P06; recorded, not hidden) |
| R2-ED-P10-KNOWLEDGE-NAVIGATION | 0ce17641…ed5df3 | D/R2 | knowledge 知识导航 | ED-confirmed MOC/WIKI/NOTE navigation map |

Both sets bind to the same final exact candidate SHA/tree. Historical R1
screenshots (bound to fb43216) are preserved unmodified under
`r1-historical-superseded/` and are not evidence for this candidate.
