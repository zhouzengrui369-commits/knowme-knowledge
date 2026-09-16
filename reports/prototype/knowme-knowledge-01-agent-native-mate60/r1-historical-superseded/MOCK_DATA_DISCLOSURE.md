# Mock Data Disclosure — GOAL-KK-01 Prototype

```text
ARTIFACT=MOCK_DATA_DISCLOSURE
ACTOR_ROLE=ENGINEERING_DELIVERY
CANDIDATE_SHA=fb432162e7dd099a32fec7b52ff00659982942f3
```

Everything the prototype shows is deterministic mock content. Mapping:

| Surface | Content | Nature | Disclosure in UI |
|---|---|---|---|
| Knowledge seed (6 items) | AOG/SLA/决策/风险 fixture entries | Invented fixture data, `src/fixtures.js` | 来源 `原型种子数据 · MOCK_SOURCE`; header pill `0.1 PROTOTYPE · 确定性 Mock · 非真实数据` |
| Agent replies | Keyword-matched template answers | Deterministic local function, no model, no network | 「懂我 · 确定性 Mock 回答」 label on every reply |
| Capture pipeline | 已采集→AI 整理草稿→确认后入库 | Local state only | Channel chips: Text AVAILABLE (本地状态); Voice/Files/Website PROTOTYPE_ONLY |
| Calendar | 4 mock schedule rows | Fixture, no calendar backend | NOT_CONNECTED chip + 「Mock 日程 · 无真实日历后端」 |
| Todo | 3 mock todos, local toggle | Fixture, no todo backend | NOT_CONNECTED chip + 「状态仅保存在本原型本地」 |
| Skills | PLANNED card | Not implemented by contract | PLANNED chip, no fake surface |
| Persistence | In-memory only | Reload resets | Allowed limitation NO_REAL_PERSISTENCE_REQUIRED |

The prototype never presents mock content as real Owner data, never presents
NOT_CONNECTED as CONNECTED, and never presents PROTOTYPE_ONLY as REAL.
