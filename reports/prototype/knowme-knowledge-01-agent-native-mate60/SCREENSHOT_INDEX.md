# Screenshot Index — GOAL-KK-01 (R5, final exact candidate)

```text
ARTIFACT=SCREENSHOT_INDEX
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
CANDIDATE_SHA=40063afd16a36674e8660f6b4a05315d51f4e546
CANDIDATE_TREE=72464ee6727af4837cb24b77238f7ddadeca02ed
VIEWPORT=360x780 (actual captured size), kind=MATE60_CLASS_SIMULATION
NOTE=No screenshot claims a real Mate60 viewport; both sets are browser
     simulations. No screenshot is a design mockup, stitched image, source
     screenshot, or a historical capture from a different SHA. All 24 frames
     bind to candidate 40063af. Deterministic rendering makes several ED/LE
     frames byte-identical across operators; recorded, not hidden.
```

## Local Executor set — `screenshots/local-executor/`

Runtime identity: fresh clone of the exact candidate (--filter=blob:none,
identity verified), `npm ci && npm run dev -- --port 5174 --strictPort`,
actual URL http://127.0.0.1:5174/. Operator:
LOCAL_EXECUTOR (LE-KK-GOAL01-40063AF-FINAL-20260916-1615-D9A3).

| Screenshot | sha256 (prefix) | Journey | Evidence meaning |
|---|---|---|---|
| R5-LE-P01-FIRST-ENCOUNTER | 0fd40ddd…b6a6 | A | 灵犀-first view + continuous sensing strip |
| R5-LE-P02-ASK-AGENT | 595b42f9…3fe5 | B | Referenced mock reply labeled 灵犀 + next action |
| R5-LE-P03-CANDIDATE-KNOWLEDGE | f470e481…dd5e | C | Candidate card with 确认/修正/拒绝 |
| R5-LE-P04-KNOWLEDGE-CONTEXT-CHANGED | 3c8407e6…0a24 | C | Context growth 6→7 + 灵犀 explanation |
| R5-LE-P05-KNOWLEDGE-WORK-SURFACE | 629ee9a3…555e | D | Contextual work surface over preserved conversation |
| R5-LE-P06-CAPABILITY-WORK-SURFACE | 2839b3ca…60e2 | E/R5 | Day view 周四 09-17 with quick actions (完成/顺延/引用到对话) |
| R5-LE-P07-RETURN-CONTEXT-PRESERVED | a57e6e59…f54e | E→return/R5 | Quote card + 灵犀 linked-knowledge answer; context preserved |
| R5-LE-P08-KNOWLEDGE-CALENDAR-VIEW | f81ba858…fbf9 | D/R5 | Knowledge 按日历查看 day view (昨天 via strip) |
| R5-LE-P09-TODO-CALENDAR-LINK | bc79b319…5190 | E/R2/R5 | Todo deep link → calendar day (postponed t-2 visible) |
| R5-LE-P10-KNOWLEDGE-NAVIGATION | 8da0c8bf…972a | D/R3/R5 | Nav = 五维+九维 maps only; 工作记录 expanded (5, captures inside) |
| R5-LE-P11-CALENDAR-MONTH-VIEW | 92b14f1d…4c84 | E/R3 | September 2026 month grid, today + event dots |
| R5-LE-P12-CALENDAR-WEEK-VIEW | be49bb83…1848 | E/R3 | Full Mon–Sun week rows with schedule + todo counts |

Machine receipt: `le-assertions.json` (80/80).

## ED personal set — `screenshots/ed-personal/`

Runtime identity: ED worktree verified at HEAD=40063af (= branch head = PR #9
head), `npm run dev`, actual URL http://127.0.0.1:5173. Operator:
ENGINEERING_DELIVERY (ED-KK-GOAL01-R5-NAVCAL-QUICKACTION-20260916-1610-R5).

| Screenshot | sha256 (prefix) | Journey | Evidence meaning |
|---|---|---|---|
| R5-ED-P01-FIRST-ENCOUNTER | fe014af1…c850 | A | ED-confirmed first encounter, 灵犀 header + sensing strip |
| R5-ED-P02-ASK-AGENT | 73efef56…9583 | B | ED-confirmed ask-灵犀 loop |
| R5-ED-P03-CANDIDATE-KNOWLEDGE | f470e481…dd5e | C | ED-confirmed candidate card |
| R5-ED-P04-KNOWLEDGE-CONTEXT-CHANGED | 8f5661e0…104a | C | ED-confirmed visible context growth |
| R5-ED-P05-KNOWLEDGE-WORK-SURFACE | 629ee9a3…555e | D | ED-confirmed work surface |
| R5-ED-P06-CAPABILITY-WORK-SURFACE | 2839b3ca…60e2 | E/R5 | ED-confirmed day view with quick actions (visually inspected) |
| R5-ED-P07-RETURN-CONTEXT-PRESERVED | 8c71979f…4015 | E→return/R5 | ED-confirmed 引用对话 quote card + answer (visually inspected) |
| R5-ED-P08-KNOWLEDGE-CALENDAR-VIEW | f81ba858…fbf9 | D/R5 | ED-confirmed knowledge calendar day view (visually inspected) |
| R5-ED-P09-TODO-CALENDAR-LINK | bc79b319…5190 | E/R2/R5 | ED-confirmed todo deep link |
| R5-ED-P10-KNOWLEDGE-NAVIGATION | 8da0c8bf…972a | D/R3/R5 | ED-confirmed nav = maps only (visually inspected) |
| R5-ED-P11-CALENDAR-MONTH-VIEW | 92b14f1d…4c84 | E/R3 | ED-confirmed month grid (visually inspected) |
| R5-ED-P12-CALENDAR-WEEK-VIEW | be49bb83…1848 | E/R3 | ED-confirmed week view (visually inspected) |

Historical evidence: R4 (`r4-historical-superseded/`, bound to 3c20888),
R3 (`r3-historical-superseded/`, bound to e6e9c3d), R2
(`r2-historical-superseded/`, bound to 9f3071e) and R1
(`r1-historical-superseded/`, bound to fb43216) are preserved unmodified and
are not evidence for this candidate.
