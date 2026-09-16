# Mock Data Disclosure — GOAL-KK-01 Prototype (R4)

```text
ARTIFACT=MOCK_DATA_DISCLOSURE
ACTOR_ROLE=ENGINEERING_DELIVERY
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
CANDIDATE_SHA=3c2088888a0896f9bb0149560dcfbf5412adb2f4
```

Everything the prototype shows is deterministic mock content. Mapping:

| Surface | Content | Nature | Disclosure in UI |
|---|---|---|---|
| Knowledge seed (6 items) | AOG/SLA/决策/风险 fixture entries | Invented fixture data, `src/fixtures.js` | 来源 `原型种子数据 · MOCK_SOURCE`; header pill `0.1 PROTOTYPE · 确定性 Mock · 非真实数据` |
| Agent replies | Keyword-matched template answers | Deterministic local function, no model, no network | 「灵犀 · 确定性 Mock 回答」 label on every reply |
| Sensing strip | Simulated sensing stream (tick lines) | Local timer + fixture strings; no microphone, no ASR, nothing auto-written | 「模拟感知 · 无真实 ASR」 always visible |
| Capture pipeline | 已采集→AI 整理草稿→确认后入库 | Local state only | Channel chips: Text AVAILABLE; Voice/Files/Website PROTOTYPE_ONLY |
| **五维知识地图 (R4)** | Five life dimensions from the KnowMe-NJX-Demo authority | Deterministic attribution (`dim5` fixture field); counts computed live | Live counts; zero-count dimensions show an honest empty note |
| **九维认知图谱 (R4)** | Nine cognitive dimensions from the Demo authority | Deterministic attribution (`dim9` fixture field); counts computed live | Same live-count honesty |
| Knowledge calendar | Day groups (今天 2026-09-16 / 昨天 / 7 月 18 日) | Fixture day attribution + local session date | Per-item state chips; no real persistence |
| **Calendar 月/周/日 (R4)** | September 2026 month grid (real weekdays), Mon–Sun week rows, day schedule + linked todos | Fixture schedule/todos; month grid computed from real `Date` weekdays | NOT_CONNECTED chip + 「Mock 日程 · 无真实日历后端」; dot legend disclosed |
| Todo | 3 mock todos, local toggle, calendar deep link | Fixture, no todo backend; link is local state | NOT_CONNECTED chip + 「状态仅保存在本原型本地」 |
| Skills | PLANNED card | Not implemented by contract | PLANNED chip, no fake surface |
| Persistence | In-memory only | Reload resets | Allowed limitation NO_REAL_PERSISTENCE_REQUIRED |

The prototype never presents mock content as real Owner data, never presents
NOT_CONNECTED as CONNECTED, never presents PROTOTYPE_ONLY as REAL, and never
presents the simulated sensing stream as real ASR. Dimension counts are
always computed from the actual knowledge context — never hardcoded.
