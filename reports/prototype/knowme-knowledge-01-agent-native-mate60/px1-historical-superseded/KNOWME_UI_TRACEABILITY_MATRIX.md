# KnowME UI Traceability Matrix — GOAL-KK-01 PX Findings Correction R1

UI authority: Owner-provided `KnowMe-NJX-Demo.html` (sha256
`3ef8605a6b74c6514ee7097d24100d5f06e258b2e6bbdb03e591a02a51fc7d9f`, copy at
`r3-historical-superseded/r3-ui-authority/`). Candidate
`0e859d93960e630965a5b71a3ff4c07e631d8570`.

| Demo / contract element | Prototype realization | Status |
| --- | --- | --- |
| 灵犀 · Digital Brain identity | header「灵犀 · KnowME」, 灵 avatar, Agent-first first view | PRESERVED |
| Agent conversation center | conversation thread, refs chips, next-action routing | PRESERVED |
| Continuous background sensing | global strip + in-sheet sensing bar in every work sheet (PX1), 暂停/恢复 synced, 模拟·无真实 ASR disclosure | CORRECTED (KK-PX-R5-02) |
| Capture pipeline | text channel AVAILABLE; voice/files/website PROTOTYPE_ONLY; candidate → explicit 确认入库 (PX1 model A) | CORRECTED (KK-PX-R5-03) |
| 五维知识地图 | dim5 map, live counts, expandable real items | PRESERVED |
| 九维认知图谱 | dim9 map, live counts, expandable real items | PRESERVED |
| 知识按日历查看 | knowledge calendar 日/周/月三视图 (R5) | PRESERVED |
| Calendar 月/周/日 | schedule+todo shared calendar, three views | PRESERVED |
| Todo → Calendar day | deep link into calendar day view | PRESERVED |
| 快速操作 + 引用对话 | schedule/todo 完成/顺延/引用到对话 (R5); P3 ordering + date-dedup fixed | PRESERVED + P3 FIXED |
| Knowledge detail / work surface | per-item own content, honest conclusion state, 冲突 0 项(无虚构) (PX1) | CORRECTED (KK-PX-R5-01) |
| Return navigation | 「返回 Agent 对话」 lands directly on Agent conversation, both entry paths (PX1) | CORRECTED (KK-PX-R5-04) |
| Honest states | NOT_CONNECTED / PROTOTYPE_ONLY / PLANNED / CANDIDATE / CONFIRMED chips | PRESERVED |
| Demo 2D relation / 3D star map | NOT_IMPLEMENTED_BY_CONTRACT (desktop-parlor visual, out of scope) | UNCHANGED |
