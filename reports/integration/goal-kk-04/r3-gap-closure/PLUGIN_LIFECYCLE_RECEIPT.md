# PLUGIN_LIFECYCLE_RECEIPT — r3-gap-closure（J05）

2026-09-23 ｜ 双实例实证 ｜ canonical HAP a7302224…

## 合同要件

插件停用期间：提交被拒绝且不丢数据、有明确用户反馈；启用后自动补传；启停状态持久化（重启保持）。

## ED 侧（18241，21:05–21:08）

1. `POST /api/mobile-capture/v1/plugin/disable` → `{"status":"disabled"}`（持久化 meta.enabled=false）。
2. App 内保存+提交 J05 文本 → 服务端拒收，条目「排队待传」+ 红字「⚠ 工作台插件停用中 · 保持排队，插件启用后自动补传」（截图 ed3_s13）。
3. `POST /plugin/enable` → `{"status":"enabled","resumed_tasks":0}`（resumed=0 如实：该采集停在 App 侧队列，服务器无既有 task）。
4. App 自动补传 → cap_d3f4c0dfd1e05e2e5ff9c2a9f81437e1 / task_cfb159386fd64257 COMPLETED attempts=1（21:08:07），笔记落盘（截图 ed3_s14）。

## LE 侧（agent-3，18243）

- 停用期提交收到 HTTP 503（截图 le3/shots/j05_02_submit_503.jpeg），条目保留；启用后补传 COMPLETED。详见 le3/LE_RECEIPT.md J05 节。

## 结论

J05 双侧 PASS：停用拒绝+排队+明确反馈，启用自动补传，零丢失零重复。启停持久化由 store meta.enabled 实现（前轮已验重启保持，本轮未重复重启插件层——服务重启发生于 J04，启用状态在 J04 重启前后无变化需求，如实说明）。
