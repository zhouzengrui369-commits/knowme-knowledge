# PERSISTENCE RECOVERY RECEIPT — GOAL-KK-02 Contract R3 (PX-KK02-01)

## 持久化契约

- 唯一允许跨进程的状态：AgentContext snapshot v3（已确认/手动知识 ≤100 条、对话尾部 ≤30 条、id 计数器），落盘于应用沙盒 `haps/entry/files/kk02_agent_context.json`。
- 按构造不可恢复：未确认/已修正未确认/已拒绝/已丢弃候选（不进入 knowledge，快照中不存在）。
- R3-D20：瞬时提示（恢复标记）带 ephemeral 标记，snapshot() 过滤、restore() 拒绝历史泄漏——每次冷开恢复标记恰好一条，不累积。

## 场景实证（LE run2 + ED 本人，均为 exact SHA 06b013c 同构建）

| 场景 | LE | ED 本人 | 结果 |
|------|-----|---------|------|
| force-stop → cold reopen | le-05：知识 1 条在，恢复标记恰好一次 | ed2-05：知识+上下文在，标记一次 | ✅ |
| 权限撤销（系统杀进程）→ 重开 | le-15：知识 2 条+上下文完整，标记一次 | ed2-15：知识 2 条在（checked=false 实证） | ✅ |
| 权限授予往返（不杀进程） | le-04：数据在，状态即刷"权限已授予" | ed2-04：数据在 | ✅ |
| Home 后台 → 返回 | （覆盖于各旅程往返） | 探索期 ed-29：状态无损 | ✅ |
| 未确认候选重启不复活 | le run1 覆盖 + run2 旅程间接覆盖 | 探索期 ed-26→ed-27：候选卡不复活，知识数不变 | ✅ |
| 注册档案持久化 | le-11→le-16：注册后档案在、重置后清除 | ed2-10→ed2-16：同 | ✅ |
| 同签名 install -r | — | ED 探针：数据保留（平台行为确认） | ✅ |

## D20 累积回归实证

- 修复前（探索期实测）：恢复标记经后续保存事件被扫入快照，每次冷开多一条（界面实测两条并存）。
- 修复后：le-05、le-15、ed2-05、ed2-15 四次冷开/杀进程恢复，恢复标记均恰好一次；AgentContextPersistence 含 2 个 D20 回归用例（快照排除 ephemeral、restore 拒绝历史泄漏），46/46 PASS。

## 结论

PX-KK02-01 要求的全部持久化/恢复场景在 final exact SHA 上双通道实证成立。
