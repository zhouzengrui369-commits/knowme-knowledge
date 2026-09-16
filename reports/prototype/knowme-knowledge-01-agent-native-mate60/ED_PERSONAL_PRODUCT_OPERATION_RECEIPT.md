# ED Personal Product Operation Receipt — GOAL-KK-01

```text
ARTIFACT=ED_PERSONAL_PRODUCT_OPERATION_RECEIPT
ACTOR_ROLE=ENGINEERING_DELIVERY
ACTOR_CONTEXT_ID=ED-KK-GOAL01-AGENT-NATIVE-MATE60-PROTOTYPE-R1-20260916-1013-4A7D
CANDIDATE_SHA=fb432162e7dd099a32fec7b52ff00659982942f3
CANDIDATE_TREE=aed8058e5139948fbf8c4a3152a8fbf122ce8b5a
RUNTIME_URL=http://127.0.0.1:5173
VIEWPORT=360x780 (MATE60_CLASS_SIMULATION, browser simulation, not on-device)
JOURNEY_A=OPERATED
JOURNEY_B=OPERATED
JOURNEY_C=OPERATED
JOURNEY_D=OPERATED
JOURNEY_E=OPERATED
ISSUED_AT=2026-09-16T11:12:00Z
```

ED personally operated the exact candidate `fb43216` (worktree HEAD verified
equal to the pushed candidate before starting) in a real Chromium browser via
direct interactive control, then visually inspected the captured frames of its
own operation. This receipt is independent of the Local Executor evidence.

## What ED did and saw, per journey

- **A. First Encounter.** Cold-opened the running product. Saw: Agent
  identity header (懂我 · KnowME, 个人知识 Agent, 当前知识上下文 6 条),
  always-on disclosure pill, knowledge-context summary, two 未知 gaps and one
  已知 chip, opening Agent message with reference chips, composer, and the
  five-entry bottom nav. First impression reads as a personal knowledge
  Agent, not a dashboard/notes list/empty chatbot. No defect.
- **B. Ask the Agent.** Typed `ABC 供应商延迟会影响什么?`, sent. Observed
  real state change: user bubble → thinking → deterministic reply referencing
  AOG 航材保障/供应商与 SLA/供应风险记录, with ref chips and a next-action
  button. Clicked the next action: knowledge detail opened as an overlay with
  the conversation preserved underneath. No defect (final candidate).
- **C. Information enters knowledge.** Opened 捕获; verified channel chips
  (文本 AVAILABLE; 语音/文件/网页 PROTOTYPE_ONLY with honest notes). Entered
  text, generated a candidate, exercised 修正 (edited title, saved → confirmed
  into context), then 拒绝 on a second candidate (context count unchanged,
  Agent explained the rejection), then direct 确认入库 on a third (6→7→…→8
  条知识, connection count grew, Agent explained each change with a ref chip
  and next-action). No defect.
- **D. Work from knowledge.** 知识 → opened 供应风险记录 → 来源与状态 showed
  MOCK_SOURCE + CONFIRMED + evidence count → opened 上下文工作面 → returned
  step-by-step (work surface → detail → list → closed). Conversation,
  including the Journey B question, fully preserved. No defect.
- **E. Capability attachment.** 日历 opened a concrete mock schedule work
  surface labeled NOT_CONNECTED; 待办 opened a mock todo surface and a real
  toggle flipped state; 技能 showed PLANNED with no fake surface. No
  NOT_CONNECTED capability ever presented itself as connected. No defect.
- **Hygiene.** No horizontal overflow at 360px; all critical controls are
  real buttons/inputs operable by tap; zero console errors; zero page errors.

## Defects ED found and fixed during the candidate loop

1. `D-01` (found by ED runtime interaction, round 1): the knowledge sheet id
   `knowledge` collided with the capability-sheet render condition, stacking
   an invisible capability backdrop that swallowed the detail sheet's close
   button (blocked sheet close; Playwright hit-test proved the interception).
   Fixed in `App.jsx` by restricting the capability sheet to
   calendar/todo/skills and deleting the dead branch. Re-verified: 41/41.
2. `D-02` (found by ED review of its own operation, round 2): the composer
   voice key used a blocking `alert()` for its PROTOTYPE_ONLY disclosure.
   Replaced with an in-conversation Agent disclosure message; added a
   regression assertion (VOICE_KEY_HONEST_DISCLOSURE). Re-verified: 41/41.

Both fixes are inside the frozen contract scope (ED_OWNS_FIX=YES); neither
changed product meaning, journeys, acceptance outcomes or limitations.

## ED personal screenshot set

`screenshots/ed-personal/ED-P01..P07-*.png`, all captured by ED on candidate
`fb43216` at http://127.0.0.1:5173, viewport 360x780 MATE60_CLASS_SIMULATION:

| File | sha256 |
|---|---|
| ED-P01-FIRST-ENCOUNTER.png | d0d1fa30c582f556f2cf10014a56c3a60e54f555a24cfece4809db9075885efe |
| ED-P02-ASK-AGENT.png | 2303c14e49a950b3b7324c21f8f6419e4229ac21c18055fe16eba276d88b6391 |
| ED-P03-CANDIDATE-KNOWLEDGE.png | 438d92f92b7b67da7bc53b9c04d09cba622d216eaafbc75cbfeef3c2b60152c0 |
| ED-P04-KNOWLEDGE-CONTEXT-CHANGED.png | 695ac3f7349a8403c11b99b1b484743177de2beaaf57da6cf705a8b3f0ea68e7 |
| ED-P05-KNOWLEDGE-WORK-SURFACE.png | 153b0bd01e2debf6d4786c492b7e560a2392c8925d29d1e58fe78139e573235d |
| ED-P06-CAPABILITY-WORK-SURFACE.png | ed48d16004e7adf2379db694314d3fa0cebabbc2b9c525729227bd14971a04a4 |
| ED-P07-RETURN-CONTEXT-PRESERVED.png | 295f262e969ba62ba3675671cb31d46d9a7b8b215b8ee33567cd02f0baca3abd |

Full machine-readable receipt of the same ED run:
`ed-browser-assertions.json` (41/41 passed).
