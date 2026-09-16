# Screenshot Index — GOAL-KK-01 (R3, final exact candidate)

```text
ARTIFACT=SCREENSHOT_INDEX
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
CANDIDATE_SHA=e6e9c3d87a1c87fa0614aa1a4ec44e354117adde
CANDIDATE_TREE=beeb0d6e136419036fb71fe5bd31aa8863f9227f
VIEWPORT=360x780 (actual captured size), kind=MATE60_CLASS_SIMULATION
NOTE=No screenshot claims a real Mate60 viewport; both sets are browser
     simulations. No screenshot is a design mockup, stitched image, source
     screenshot, or a historical capture from a different SHA. All 24 frames
     bind to candidate e6e9c3d. Deterministic rendering makes several ED/LE
     frames byte-identical across operators; recorded, not hidden.
```

## Local Executor set — `screenshots/local-executor/`

Runtime identity: fresh clone of the exact candidate, `npm ci && npm run dev
-- --port 5174 --strictPort`, actual URL http://127.0.0.1:5174/. Operator:
LOCAL_EXECUTOR (LE-KK-GOAL01-E6E9C3D-FINAL-20260916-1330-D4E1).

| Screenshot | sha256 (prefix) | Journey | Evidence meaning |
|---|---|---|---|
| R3-LE-P01-FIRST-ENCOUNTER | aaef21e3…9eec | A | Agent-first view + continuous sensing strip |
| R3-LE-P02-ASK-AGENT | c8d0caa7…191f | B | Referenced mock reply + next action |
| R3-LE-P03-CANDIDATE-KNOWLEDGE | b39aa57b…8e74 | C | Candidate card with 确认/修正/拒绝 |
| R3-LE-P04-KNOWLEDGE-CONTEXT-CHANGED | f1ac2f83…0bf0 | C | Context growth 6→7 + Agent explanation |
| R3-LE-P05-KNOWLEDGE-WORK-SURFACE | 802edba1…0aaf | D | Contextual work surface over preserved conversation |
| R3-LE-P06-CAPABILITY-WORK-SURFACE | fee7ecbe…a5c3 | E | Day view 周四 09-17: schedule + linked todo, NOT_CONNECTED |
| R3-LE-P07-RETURN-CONTEXT-PRESERVED | b9eb1b8f…2ff3 | E→return | Conversation fully preserved |
| R3-LE-P08-KNOWLEDGE-CALENDAR-VIEW | 90de8c6c…ed78 | D/R2 | Knowledge by calendar; captures under 今天 |
| R3-LE-P09-TODO-CALENDAR-LINK | fee7ecbe…a5c3 | E/R2 | Todo deep link → calendar day (== P06, recorded) |
| R3-LE-P10-KNOWLEDGE-NAVIGATION | d591c0ff…2434 | D/R3 | 五维知识地图 expanded (工作记录 5, captures inside) |
| R3-LE-P11-CALENDAR-MONTH-VIEW | 2be550e9…0984 | E/R3 | September 2026 month grid, today + event dots |
| R3-LE-P12-CALENDAR-WEEK-VIEW | b614fa1b…ad7f | E/R3 | Full Mon–Sun week rows with schedule + todo counts |

Machine receipt: `le-assertions.json` (67/67).

## ED personal set — `screenshots/ed-personal/`

Runtime identity: ED worktree verified at HEAD=e6e9c3d (= branch head = PR #9
head), `npm run dev`, actual URL http://127.0.0.1:5173. Operator:
ENGINEERING_DELIVERY (ED-KK-GOAL01-R3-DEMO-AUTHORITY-20260916-1320-R3).

| Screenshot | sha256 (prefix) | Journey | Evidence meaning |
|---|---|---|---|
| R3-ED-P01-FIRST-ENCOUNTER | b518c9f3…bef1 | A | ED-confirmed first encounter + sensing strip |
| R3-ED-P02-ASK-AGENT | 296df79b…477f | B | ED-confirmed ask-Agent loop |
| R3-ED-P03-CANDIDATE-KNOWLEDGE | b39aa57b…8e74 | C | ED-confirmed candidate card |
| R3-ED-P04-KNOWLEDGE-CONTEXT-CHANGED | deb77004…884a | C | ED-confirmed visible context growth |
| R3-ED-P05-KNOWLEDGE-WORK-SURFACE | 802edba1…0aaf | D | ED-confirmed work surface |
| R3-ED-P06-CAPABILITY-WORK-SURFACE | fee7ecbe…a5c3 | E | ED-confirmed day view 周四 09-17 + linked todo |
| R3-ED-P07-RETURN-CONTEXT-PRESERVED | 11f9e4c2…7bdf | E→return | ED-confirmed full preservation |
| R3-ED-P08-KNOWLEDGE-CALENDAR-VIEW | 90de8c6c…ed78 | D/R2 | ED-confirmed knowledge by calendar |
| R3-ED-P09-TODO-CALENDAR-LINK | fee7ecbe…a5c3 | E/R2 | ED-confirmed todo deep link (== P06, recorded) |
| R3-ED-P10-KNOWLEDGE-NAVIGATION | d591c0ff…2434 | D/R3 | ED-confirmed 五维地图 expansion (visually inspected) |
| R3-ED-P11-CALENDAR-MONTH-VIEW | 2be550e9…0984 | E/R3 | ED-confirmed month grid (visually inspected) |
| R3-ED-P12-CALENDAR-WEEK-VIEW | b614fa1b…ad7f | E/R3 | ED-confirmed week view (visually inspected) |

Historical evidence: R2 (`r2-historical-superseded/`, bound to 9f3071e) and
R1 (`r1-historical-superseded/`, bound to fb43216) are preserved unmodified
and are not evidence for this candidate.
