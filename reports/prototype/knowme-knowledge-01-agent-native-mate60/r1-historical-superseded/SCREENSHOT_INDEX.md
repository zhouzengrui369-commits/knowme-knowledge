# Screenshot Index — GOAL-KK-01

```text
ARTIFACT=SCREENSHOT_INDEX
CANDIDATE_SHA=fb432162e7dd099a32fec7b52ff00659982942f3
CANDIDATE_TREE=aed8058e5139948fbf8c4a3152a8fbf122ce8b5a
VIEWPORT=360x780 (actual captured size), kind=MATE60_CLASS_SIMULATION
NOTE=No screenshot claims a real Mate60 viewport; both sets are browser
     simulations of a Mate60-class portrait viewport.
```

## Local Executor set — `screenshots/local-executor/`

Runtime identity: fresh clone of the exact candidate, `npm ci && npm run dev`,
actual URL http://127.0.0.1:5174/. Operator: LOCAL_EXECUTOR
(LE-KK-GOAL01-FINAL-CANDIDATE-20260916-1058-B3E9), ~2026-09-16T11:03Z.

| Screenshot | sha256 (prefix) | Journey | State before → action → state after | Evidence meaning |
|---|---|---|---|---|
| LE-P01-FIRST-ENCOUNTER | 8f52129c…6d78 | A | cold load → open URL → Agent first view | First view communicates Agent identity, knowledge context, known/unknown, capture/ask/capability entries |
| LE-P02-ASK-AGENT | d28edb47…47bb | B | first view → typed question + send → referenced mock reply | Real input produces a context-referencing Agent answer with next action |
| LE-P03-CANDIDATE-KNOWLEDGE | 43a6d53f…f23f | C | capture sheet → submit text → candidate card | Capture produces a confirmable candidate with pipeline + 确认/修正/拒绝 |
| LE-P04-KNOWLEDGE-CONTEXT-CHANGED | f37a7883…dd09 | C | candidate card → 确认入库 → counts 6→7 | Confirmed knowledge visibly changes the context; Agent explains |
| LE-P05-KNOWLEDGE-WORK-SURFACE | cfbc6eaa…b2f1 | D | knowledge detail → open work surface → surface rendered | Knowledge item supports a contextual work surface |
| LE-P06-CAPABILITY-WORK-SURFACE | 8b1bd38e…bf20 | E | main view → 日历 → NOT_CONNECTED mock schedule | Capability opens concrete work with honest NOT_CONNECTED state |
| LE-P07-RETURN-CONTEXT-PRESERVED | f37a7883…dd09 | E→return | sheet closed → return → conversation preserved | Context restored exactly (byte-identical to P04 at this viewport; recorded, not hidden) |

Full per-shot metadata: `screenshots/local-executor/le-run-metadata.json`.

## ED personal set — `screenshots/ed-personal/`

Runtime identity: ED worktree verified at HEAD=fb43216, `npm run dev`, actual
URL http://127.0.0.1:5173. Operator: ENGINEERING_DELIVERY
(ED-KK-GOAL01-AGENT-NATIVE-MATE60-PROTOTYPE-R1-20260916-1013-4A7D),
2026-09-16T11:09Z. Captured by the same assertion run recorded in
`ed-browser-assertions.json`.

| Screenshot | sha256 (prefix) | Journey | Interaction state at capture | Evidence meaning |
|---|---|---|---|---|
| ED-P01-FIRST-ENCOUNTER | d0d1fa30…5efe | A | FIRST_VIEW | ED-confirmed Agent-first first encounter |
| ED-P02-ASK-AGENT | 2303c14e…6391 | B | ASK_AGENT | ED-confirmed ask-Agent loop with refs + next action |
| ED-P03-CANDIDATE-KNOWLEDGE | 438d92f9…52c0 | C | CANDIDATE_KNOWLEDGE | ED-confirmed candidate card with all three decisions |
| ED-P04-KNOWLEDGE-CONTEXT-CHANGED | 695ac3f7…68e7 | C | KNOWLEDGE_CONTEXT_UPDATED | ED-confirmed visible context growth + Agent explanation |
| ED-P05-KNOWLEDGE-WORK-SURFACE | 153b0bd0…235d | D | KNOWLEDGE_WORK | ED-confirmed contextual work surface over preserved conversation |
| ED-P06-CAPABILITY-WORK-SURFACE | ed48d160…a04a | E | CAPABILITY_WORK | ED-confirmed honest NOT_CONNECTED calendar work surface |
| ED-P07-RETURN-CONTEXT-PRESERVED | 295f262e…3abd | E→return | AGENT_CONTEXT_RESTORED | ED-confirmed full conversation preservation across A–E |

Both sets bind to the same exact candidate SHA/tree. No screenshot is a
design mockup, stitched image, source screenshot or a historical capture from
a different SHA.
