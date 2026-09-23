# OFFLINE_SYNC_RECEIPT — r3-gap-closure（J04）

2026-09-23 ｜ ED 侧实例 18241 / LE 侧实例 18243 ｜ canonical HAP a7302224…

## 合同要件

offline→online：断网期间采集不丢、本地排队、明确反馈；draft→cold restart：冷开后草稿/待传保留；恢复后补传成功且无重复。

## ED 侧（21:02–21:04）

- 真离线实现方式：停 18241 工作台服务（isolated.sh stop）。（如实：首尝用 hdc rport/fport rm 移除转发失败——"ruler is not exist"，该次采集 cap_cbc56ba3 被在线误提交，记为无效尝试并重做。）
- 离线下保存 J04 文本成功（本地采集箱）→ 提交显示「排队待传」+「⚠ 提交失败(网络) · 检查网络后自动重试」（截图 ed3_s09）。
- `aa force-stop` 冷开：待传条目完整保留（截图 ed3_s10，「已连接（本地会话恢复）」）。
- 服务重启（isolated.sh start，200 OK）后自动重试：cap_aa1fef829bb5aee0caec3b78c35592bf / task_ac4b649c60544ac1 COMPLETED **attempts=2**（21:04:53）——第一次失败、第二次成功，无重复笔记（截图 ed3_s11）。

## LE 侧（agent-3，18243）

- 同样停服模拟离线：离线保存→冷开队列保留（j04_07/08/09/10 系列截图）→恢复后 COMPLETED。详见 le3/LE_RECEIPT.md J04 节。

## 结论

J04 双侧 PASS：离线不丢、冷开保留、恢复补传、attempts 递增如实、无重复正式效果。PX-KK03-03 的 offline→online 与 draft→cold restart 要件同时覆盖。
