# KnowMe UI Traceability Matrix — GOAL-KK-01 Prototype (R2)

```text
ARTIFACT=KNOWME_UI_TRACEABILITY_MATRIX
ACTOR_ROLE=ENGINEERING_DELIVERY
ACTOR_CONTEXT_ID=ED-KK-GOAL01-EXACT-CANDIDATE-EVIDENCE-REBIND-20260916-1155-R2
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
CANDIDATE_SHA=9f3071e22def4f99cbf3a4589349e628e9e15a97
UI_AUTHORITY_REPOSITORY=zhouzengrui369-commits/knowme
UI_AUTHORITY_COMMIT=baa61e693c4681445b8ef0f34c2113292f68e8c7
UI_AUTHORITY_TREE=3bad5f228b47c8e76ccd4203744e5e40b2f30fe4
UI_AUTHORITY_ROOT=tasks/pm/20260721-knowme-cognitive-surface-demo-r5/
APP_BLOB=4523e61d60017d63e99b2a58cff763f1a82d6b49 (verified fresh, R1)
STYLES_BLOB=9667f012df8e03496395ee176a93ea2db976a697 (verified fresh, R1)
OFFLINE_HTML_BLOB=2b00d2e158619f5c20380cbf06b90236c33eb55b (verified fresh, R1)
PROTOTYPE_SOURCE=prototypes/knowme-knowledge-01-agent-native-mate60/
```

KnowMe Demo was read-only; nothing was written back. The prototype inherits
the Demo's dark contextual-workbench lineage and translates its desktop
three-column structure into a Mate60-class portrait, Agent-first layout.
R2 adds four Owner-directed surfaces; each is traced to its Demo lineage
below (rows marked R2).

| Lineage element | KnowMe Demo (authority) | Prototype realization | Adaptation |
|---|---|---|---|
| Agent center | Desktop center column: knowledge surface + composer (`问懂我` input, voice key, orange send `#ee8a15`) | Central conversation thread + composer with voice key and orange send; Agent is the first and persistent surface | Desktop center becomes the mobile main view; conversation never replaced by navigation |
| **R2: 声音流 (continuous sensing)** | Left `sensory-panel`: 声音流 with live transcript, always-ticking sense feed | **Sensing strip** pinned above the conversation: 「后台持续感知中」 + simulated tick lines + mic key pause/resume; survives across sheet open/close; honestly labeled 「模拟感知 · 无真实 ASR」 | The Demo's left-column 声音流 becomes an always-on mobile strip; Owner-directed requirement 「语音录入要持续后台运行」 realized as continuous background state, not a per-tap action |
| Context field | Center `knowledge-surface` (WIKI/MOC navigation, freshness `81 条知识 · 更新于 12 秒前`) | `ContextStrip`: tappable knowledge-context summary (`N 条知识 · M 条连接 · 持续生长`) + known/unknown chips (已知 green / 未知 amber) | Graph visualizations (2D/3D) not copied (out of 0.1 scope); the *evolving context* semantics kept via live counts that really change on confirm |
| **R2: 知识导航 (MOC map)** | Center `knowledge-surface` WIKI/MOC navigation grouping | Knowledge sheet tab **知识导航**: entries grouped 主题入口 · MOC / 知识文档 · WIKI / 笔记与捕获 · NOTE with evidence counts and CONFIRMED chips | Demo's WIKI/MOC navigation becomes the knowledge sheet's first tab; Owner-directed 「可查看知识导航」 |
| **R2: 按日历查看 (daily notes lineage)** | Demo freshness timestamps + daily knowledge flow semantics | Knowledge sheet tab **按日历查看**: knowledge grouped by day (今天 2026-09-16 / 昨天 / 7 月 18 日); session-confirmed items land under today | Owner-directed 「知识要可按日历查看」; deterministic mock day attribution, no real persistence |
| Capture surface | Left `sensory-panel`: capture drawer with pipeline 已采集→AI 整理草稿→确认后入库 and sensing roadmap with honest per-channel status | Bottom-sheet Capture: channel cards Text/Voice/Files/Website with honest state chips, same pipeline row, candidate card with 确认入库/修正/拒绝 | Left column becomes summonable bottom sheet; pipeline and confirm-gate semantics preserved verbatim |
| Capability surface | Right `intelligence-panel`: system metrics, 计划/轨迹/助手 tabs, capability panels | Bottom nav 知识/日历/待办/技能 + capability sheets with explicit state chips (AVAILABLE / NOT_CONNECTED / PLANNED) | Right column becomes bottom navigation + sheets; per-capability honesty made mandatory UI |
| **R2: 可视化日历 (schedule/todo linkage)** | Right-panel 计划 tab: plan-list rows with time and state | Calendar sheet: **5-day week strip** (昨天/今天/明天/周四/周五), per-day schedule rows, **当日关联待办** section linking todos to the viewed day; todo sheet deep link jumps calendar to the linked day | Owner-directed 「日程/待办需要关联可视化日历」; NOT_CONNECTED honesty preserved |
| Contextual overlay / work surface | `capability-panel` modal and `document-preview` overlay | Knowledge detail sheet + 上下文工作面 sheet that float over the conversation | Same overlay pattern: backdrop + sheet, conversation DOM never unmounted |
| Visual hierarchy | Dark workbench tokens: `--bg #09121b`, `--panel #111d29`, `--amber #ff9d1c`, `--blue #57a8e6`, `--green #55ce91`, `--violet #9a7bf7`, `--radius 16px`, mono state labels | Identical CSS custom properties and component treatments in `src/styles.css` | Tokens copied 1:1; layout rules rewritten for portrait |
| Interaction return | Overlays close back to the workbench without losing center state | Every sheet closes back to the identical Agent conversation; `AGENT_CONTEXT_RESTORED` explicitly tracked; sensing strip survives | Same mental model, single-column |
| State disclosure | `DEMO · 只读` badge, `尚未激活` skill gates, sensing roadmap per-channel status | Persistent header pill `0.1 PROTOTYPE · 确定性 Mock · 非真实数据`, per-channel/per-capability chips, `模拟感知 · 无真实 ASR` strip label, `MOCK_SOURCE` labels | Strengthened: disclosure is always-on |
| Mobile translation | Desktop-only demo (min widths, three columns, hover cues) | Portrait-first 360–520px shell, ≥38–46px tap targets, no hover-dependent actions (asserted), no horizontal overflow (asserted) | New translation layer; the Goal's core product question |

Intentional non-inheritance (contract-compliant): neural brain canvas, audio
waveform, 2D/3D knowledge graphs, and multi-column grid were not ported —
they are desktop-parlor visuals, not required by the frozen contract, and
Journey/AO coverage does not depend on them. R2 surfaces are deterministic
mock realizations; no real ASR, calendar, or todo backend exists.
