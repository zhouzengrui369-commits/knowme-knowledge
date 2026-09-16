# Screenshot Index — GOAL-KK-01 (R4, final exact candidate)

```text
ARTIFACT=SCREENSHOT_INDEX
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
CANDIDATE_SHA=3c2088888a0896f9bb0149560dcfbf5412adb2f4
CANDIDATE_TREE=625a7f471b0c723debb4a0295da3b4cd6c72a178
VIEWPORT=360x780 (actual captured size), kind=MATE60_CLASS_SIMULATION
NOTE=No screenshot claims a real Mate60 viewport; both sets are browser
     simulations. No screenshot is a design mockup, stitched image, source
     screenshot, or a historical capture from a different SHA. All 24 frames
     bind to candidate 3c20888. Deterministic rendering makes several ED/LE
     frames byte-identical across operators; recorded, not hidden.
```

## Local Executor set — `screenshots/local-executor/`

Runtime identity: fresh clone of the exact candidate, `npm ci && npm run dev
-- --port 5174 --strictPort`, actual URL http://127.0.0.1:5174/. Operator:
LOCAL_EXECUTOR (LE-KK-GOAL01-3C20888-FINAL-20260916-1505-B7C2).

| Screenshot | sha256 (prefix) | Journey | Evidence meaning |
|---|---|---|---|
| R4-LE-P01-FIRST-ENCOUNTER | ad964be1…0321 | A | 灵犀-first view + continuous sensing strip (rename visible) |
| R4-LE-P02-ASK-AGENT | a29e0f9a…545d | B | Referenced mock reply labeled 灵犀 + next action |
| R4-LE-P03-CANDIDATE-KNOWLEDGE | f470e481…dd5e | C | Candidate card with 确认/修正/拒绝 |
| R4-LE-P04-KNOWLEDGE-CONTEXT-CHANGED | 991ad5aa…a2a7 | C | Context growth 6→7 + 灵犀 explanation |
| R4-LE-P05-KNOWLEDGE-WORK-SURFACE | 629ee9a3…555e | D | Contextual work surface over preserved conversation |
| R4-LE-P06-CAPABILITY-WORK-SURFACE | 61f4541e…6598 | E | Day view 周四 09-17: schedule + linked todo, NOT_CONNECTED |
| R4-LE-P07-RETURN-CONTEXT-PRESERVED | 5ab2c751…619f | E→return | Conversation fully preserved |
| R4-LE-P08-KNOWLEDGE-CALENDAR-VIEW | 0daaa61c…5daa | D/R2 | Knowledge by calendar; captures under 今天 |
| R4-LE-P09-TODO-CALENDAR-LINK | 61f4541e…6598 | E/R2 | Todo deep link → calendar day (== P06, recorded) |
| R4-LE-P10-KNOWLEDGE-NAVIGATION | 8da0c8bf…972a | D/R3 | 五维知识地图 expanded (工作记录 5, captures inside) |
| R4-LE-P11-CALENDAR-MONTH-VIEW | 92b14f1d…4c84 | E/R3 | September 2026 month grid, today + event dots |
| R4-LE-P12-CALENDAR-WEEK-VIEW | be49bb83…1848 | E/R3 | Full Mon–Sun week rows with schedule + todo counts |

Machine receipt: `le-assertions.json` (68/68).

## ED personal set — `screenshots/ed-personal/`

Runtime identity: ED worktree verified at HEAD=3c20888 (= branch head = PR #9
head), `npm run dev`, actual URL http://127.0.0.1:5173. Operator:
ENGINEERING_DELIVERY (ED-KK-GOAL01-R4-LINGXI-RENAME-20260916-1500-R4).

| Screenshot | sha256 (prefix) | Journey | Evidence meaning |
|---|---|---|---|
| R4-ED-P01-FIRST-ENCOUNTER | 297c60c8…0fb6 | A | ED-confirmed first encounter, 灵犀 header + sensing strip |
| R4-ED-P02-ASK-AGENT | 73efef56…9583 | B | ED-confirmed ask-灵犀 loop |
| R4-ED-P03-CANDIDATE-KNOWLEDGE | f470e481…dd5e | C | ED-confirmed candidate card |
| R4-ED-P04-KNOWLEDGE-CONTEXT-CHANGED | 94eae260…f3a5 | C | ED-confirmed visible context growth |
| R4-ED-P05-KNOWLEDGE-WORK-SURFACE | 629ee9a3…555e | D | ED-confirmed work surface |
| R4-ED-P06-CAPABILITY-WORK-SURFACE | 61f4541e…6598 | E | ED-confirmed day view 周四 09-17 + linked todo |
| R4-ED-P07-RETURN-CONTEXT-PRESERVED | 77275281…aa78 | E→return | ED-confirmed full preservation |
| R4-ED-P08-KNOWLEDGE-CALENDAR-VIEW | 0daaa61c…5daa | D/R2 | ED-confirmed knowledge by calendar |
| R4-ED-P09-TODO-CALENDAR-LINK | 61f4541e…6598 | E/R2 | ED-confirmed todo deep link (== P06, recorded) |
| R4-ED-P10-KNOWLEDGE-NAVIGATION | 8da0c8bf…972a | D/R3 | ED-confirmed 五维地图 expansion (visually inspected) |
| R4-ED-P11-CALENDAR-MONTH-VIEW | 92b14f1d…4c84 | E/R3 | ED-confirmed month grid (visually inspected) |
| R4-ED-P12-CALENDAR-WEEK-VIEW | be49bb83…1848 | E/R3 | ED-confirmed week view (visually inspected) |

Historical evidence: R3 (`r3-historical-superseded/`, bound to e6e9c3d), R2
(`r2-historical-superseded/`, bound to 9f3071e) and R1
(`r1-historical-superseded/`, bound to fb43216) are preserved unmodified and
are not evidence for this candidate.
