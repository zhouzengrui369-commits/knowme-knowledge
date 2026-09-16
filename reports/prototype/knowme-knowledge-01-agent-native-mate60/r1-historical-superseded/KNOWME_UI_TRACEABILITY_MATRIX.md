# KnowMe UI Traceability Matrix — GOAL-KK-01 Prototype

```text
ARTIFACT=KNOWME_UI_TRACEABILITY_MATRIX
ACTOR_ROLE=ENGINEERING_DELIVERY
ACTOR_CONTEXT_ID=ED-KK-GOAL01-AGENT-NATIVE-MATE60-PROTOTYPE-R1-20260916-1013-4A7D
UI_AUTHORITY_REPOSITORY=zhouzengrui369-commits/knowme
UI_AUTHORITY_COMMIT=baa61e693c4681445b8ef0f34c2113292f68e8c7
UI_AUTHORITY_TREE=3bad5f228b47c8e76ccd4203744e5e40b2f30fe4
UI_AUTHORITY_ROOT=tasks/pm/20260721-knowme-cognitive-surface-demo-r5/
APP_BLOB=4523e61d60017d63e99b2a58cff763f1a82d6b49 (verified fresh)
STYLES_BLOB=9667f012df8e03496395ee176a93ea2db976a697 (verified fresh)
OFFLINE_HTML_BLOB=2b00d2e158619f5c20380cbf06b90236c33eb55b (verified fresh)
PROTOTYPE_SOURCE=prototypes/knowme-knowledge-01-agent-native-mate60/
```

KnowMe Demo was read-only; nothing was written back. The prototype inherits
the Demo's dark contextual-workbench lineage and translates its desktop
three-column structure into a Mate60-class portrait, Agent-first layout.

| Lineage element | KnowMe Demo (authority) | Prototype realization | Adaptation |
|---|---|---|---|
| Agent center | Desktop center column: knowledge surface + composer (`问懂我` input, voice key, orange send `#ee8a15`) | Central conversation thread + composer with voice key and orange send; Agent is the first and persistent surface | Desktop center becomes the mobile main view; conversation never replaced by navigation |
| Context field | Center `knowledge-surface` (WIKI/MOC navigation, freshness `81 条知识 · 更新于 12 秒前`) | `ContextStrip`: tappable knowledge-context summary (`N 条知识 · M 条连接 · 持续生长`) + known/unknown chips (已知 green / 未知 amber) | Graph visualizations (2D/3D) not copied (out of 0.1 scope); the *evolving context* semantics kept via live counts that really change on confirm |
| Capture surface | Left `sensory-panel`: 声音流, live transcript, capture drawer with pipeline 已采集→AI 整理草稿→确认后入库 and sensing roadmap with honest per-channel status | Bottom-sheet Capture: channel cards Text/Voice/Files/Website with honest state chips, same pipeline row 已采集→AI 整理草稿→确认后入库, candidate card with 确认入库/修正/拒绝 | Left column becomes summonable bottom sheet; pipeline and confirm-gate semantics preserved verbatim |
| Capability surface | Right `intelligence-panel`: system metrics, 计划/轨迹/助手 tabs, capability panels | Bottom nav 知识/日历/待办/技能 + capability sheets with explicit state chips (AVAILABLE / NOT_CONNECTED / PLANNED) | Right column becomes bottom navigation + sheets; per-capability honesty made mandatory UI, not footer text |
| Contextual overlay / work surface | `capability-panel` modal (metrics, sources, workspace, guidance, output rail, `DEMO · 只读` state) and `document-preview` overlay | Knowledge detail sheet + 上下文工作面 sheet (conclusion card, metric grid, 来源可追溯·只读草案) that float over the conversation | Same overlay pattern: backdrop + sheet, conversation DOM never unmounted |
| Visual hierarchy | Dark workbench tokens: `--bg #09121b`, `--panel #111d29`, `--panel-deep #0d1822`, `--amber #ff9d1c`, `--blue #57a8e6`, `--green #55ce91`, `--violet #9a7bf7`, `--radius 16px`, brand-mark amber-glow Brain, mono state labels | Identical CSS custom properties and component treatments (brand-mark, state chips, composer, sheet borders, plan-list rows) in `src/styles.css` | Tokens copied 1:1; layout rules rewritten for portrait |
| Interaction return | Overlays close back to the workbench; capture drawer `✕`/backdrop returns without losing center state | Every sheet closes back to the identical Agent conversation; `AGENT_CONTEXT_RESTORED` state explicitly tracked; asserted by `RETURN_PRESERVES_CONTEXT` | Same mental model, single-column |
| State disclosure | `DEMO · 只读` badge, `尚未激活` skill gates, sensing roadmap `MVP · 运行中` vs planned items | Persistent header pill `0.1 PROTOTYPE · 确定性 Mock · 非真实数据`, per-channel and per-capability state chips, mock source labels (`MOCK_SOURCE`) in knowledge detail | Strengthened: disclosure is always-on, not only inside drawers |
| Mobile translation | Desktop-only demo (min widths, three columns, hover cues) | Portrait-first 360–520px shell, ≥38–46px tap targets, no hover-dependent actions (asserted), no horizontal overflow (asserted) | New translation layer; this is the Goal's core product question |

Intentional non-inheritance (contract-compliant): neural brain canvas, audio
waveform, 2D/3D knowledge graphs, and multi-column grid were not ported —
they are desktop-parlor visuals, not required by the frozen contract, and
Journey/AO coverage does not depend on them. This is a technical
simplification, not a product-boundary change.
