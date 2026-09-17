# Mock Data Disclosure — GOAL-KK-01 PX02 Disclosure Correction R1

All content in candidate `f89fe6695ebdbfa69e6b569447247120fab0c360` is
deterministic prototype mock data. No real Owner data, no real backends, no
real model, no real ASR.

| Surface | Mock content | Disclosure in UI |
| --- | --- | --- |
| Seed knowledge (6 items: AOG 航材保障, 供应商与 SLA, 历史决策:双线并行, AOG 响应基线, 供应风险记录, 我的决策偏好) | fictional AOG/supplier narrative, `MOCK_SOURCE` source labels | `原型种子数据 · MOCK_SOURCE`; global pill `0.1 PROTOTYPE · 确定性 Mock · 非真实数据` |
| Deterministic conclusions | only two seed items carry a `conclusion` (AOG 航材保障, AOG 响应基线); every other item honestly shows 当前没有可模拟的确定性结论 (PX1) | work surface labels 结论(确定性 Mock) vs 结论状态(诚实说明) |
| Agent replies | keyword/shingle-matched deterministic text composed ONLY from matched items' own title/summary/conclusion (PX1); unknown topics → honest 已知空白 with zero references | `灵犀 · 确定性 Mock 回答` label on every reply |
| Sensing stream | 4 deterministic SENSING_MOCK_LINES rotating every 4s | 模拟感知 · 无真实 ASR chips (global strip); in-sheet bar: dedicated non-truncated disclosure chip 「模拟 · 无真实 ASR」 fully readable in ON and PAUSED states (PX02) |
| Calendar / Todo | CALENDAR_MOCK + TODO_MOCK fictional schedule/todos | NOT_CONNECTED chips + muted notes |
| Captured knowledge | stored in local React state only; keywords derived from the Owner-typed title | source `Owner 文本捕获 · 原型本地状态` |
| Evidence/conflict counters | evidence = fixture number or 1 for captured items; conflicts = item.conflicts ?? 0, rendered as 0 项(无虚构) — never fabricated (PX1) | work grid labels |
| Voice / files / website capture channels | entry points only | PROTOTYPE_ONLY chips with honest notes |
| Skills | PLANNED card | PLANNED chip, contract out-of-scope note |

```text
NO_REAL_OWNER_DATA=YES
NO_REAL_AI/RAG/ASR/BACKEND_CLAIMS=YES
ALL_MOCK_CONTENT_DISCLOSED=YES
```
