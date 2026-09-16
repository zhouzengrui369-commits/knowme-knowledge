# Mock Data Disclosure — GOAL-KK-01 Prototype (R2)

```text
ARTIFACT=MOCK_DATA_DISCLOSURE
ACTOR_ROLE=ENGINEERING_DELIVERY
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
CANDIDATE_SHA=9f3071e22def4f99cbf3a4589349e628e9e15a97
```

Everything the prototype shows is deterministic mock content. Mapping:

| Surface | Content | Nature | Disclosure in UI |
|---|---|---|---|
| Knowledge seed (6 items) | AOG/SLA/决策/风险 fixture entries | Invented fixture data, `src/fixtures.js` | 来源 `原型种子数据 · MOCK_SOURCE`; header pill `0.1 PROTOTYPE · 确定性 Mock · 非真实数据` |
| Agent replies | Keyword-matched template answers | Deterministic local function, no model, no network | 「懂我 · 确定性 Mock 回答」 label on every reply |
| **Sensing strip (R2)** | Simulated sensing stream: tick lines like 「09:12 模拟感知:环境安静,无语音片段」 / 「检测到一段语音(演示),未写入知识」 | Local timer + fixture strings; **no microphone access, no ASR, nothing written to knowledge** | Strip label 「模拟感知 · 无真实 ASR」 always visible; paused state 「感知已暂停 · 点击麦克风恢复持续感知」 |
| Capture pipeline | 已采集→AI 整理草稿→确认后入库 | Local state only | Channel chips: Text AVAILABLE (本地状态); Voice/Files/Website PROTOTYPE_ONLY |
| **Knowledge navigation (R2)** | MOC/WIKI/NOTE grouping of the same fixtures | Local grouping, no real index | Same MOCK_SOURCE labels per item |
| **Knowledge calendar (R2)** | Day groups (今天 2026-09-16 / 昨天 / 7 月 18 日) | Fixture day attribution + local session date | Same per-item state chips; no real persistence |
| Calendar | 5-day week strip + mock schedule rows + 当日关联待办 | Fixture, no calendar backend | NOT_CONNECTED chip + 「Mock 日程 · 无真实日历后端」 |
| Todo | 3 mock todos, local toggle, calendar deep link | Fixture, no todo backend; link is local state | NOT_CONNECTED chip + 「状态仅保存在本原型本地」 |
| Skills | PLANNED card | Not implemented by contract | PLANNED chip, no fake surface |
| Persistence | In-memory only | Reload resets | Allowed limitation NO_REAL_PERSISTENCE_REQUIRED |

The prototype never presents mock content as real Owner data, never presents
NOT_CONNECTED as CONNECTED, never presents PROTOTYPE_ONLY as REAL, and never
presents the simulated sensing stream as real ASR.
