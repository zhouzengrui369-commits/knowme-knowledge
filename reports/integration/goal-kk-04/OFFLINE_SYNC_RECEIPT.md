# GOAL-KK-04 — 离线同步回执（OFFLINE_SYNC_RECEIPT）

> GOAL-KK-04 · OFFLINE_SYNC_RECEIPT · ED context ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E
> Final pair：App `10d829195ebb7f6c4c576b0d116e45087ec2b35a` / Workbench `e548883b1d696b8245631bad129dd3737afcc5b7`
> 日期：2026-09-22

## 1. 结论

J04（离线采集→杀 App→冷开→联网自动补传）与 J05（插件停用→排队→启用补传）两条离线/中断链路在 ED 与 LE 两侧均实操通过：队列与原件持久、草稿不入库、服务可达后 ≤10 秒启动补传、ACK 前不删原件。

## 2. J04 离线队列（ED 实例 18231，截图 s30–s32）

1. 停隔离实例（服务不可达）→ App 采集并「交给灵犀」→ 进入排队（QUEUED），原件保留在沙箱。
2. 杀 App → 冷开 → 采集箱完整恢复，队列仍在（CaptureStore 持久化验证）。
3. 启动实例 → App 在网络/服务恢复后 **≤10 秒**内自动补传 → RECEIVED → 整理 → COMPLETED。
4. 草稿语义：未提交草稿全程不入服务端库（草稿期服务端 0 行，LE R1/R2 均独立核验）。

## 3. LE 复验

### R1（旧 pair，实例 18232）

停实例→提交→排队→杀 App 冷开队列仍在→start 后 **~3s** 自动补传（≤10s）；cap_9eb0728c…42f77cb9 COMPLETED。截图 le_s27–s28。

### R2（新 pair 10d8291/e548883b）

排队（le2_s08）→ 冷开队列仍在（le2_s09）→ **22:39:05 实例就绪、22:39:08 补传（~3s ≤10s）**，cap_7a8feacb285736ddbeb42d4b7ac04969。整理遇 E1 超时 FAILED（环境性，不影响补传链路结论）。

## 4. J05 插件停用补传（详见 PLUGIN_LIFECYCLE_RECEIPT.md）

- ED：disable→503「排队待传·工作台插件停用中，保持排队，插件启用后自动补传」（s42，服务端 0 行）→ enable 后 10s 内补传 cap_9fd26eed… → COMPLETED（note 202609221848…J05…-9cb3cd6e，s44）。
- LE R2：disable→503 排队（le2_s11，与网络错误文案区分）→ enable `resumed_tasks:1` → 2s 补传 cap_5397ffe959a67a1c345be04fa0ee138f。

## 5. 关键语义核验点

| 合同要求 | 证据 |
|---|---|
| 原件与队列在杀 App 后仍在 | s30–s32；le_s27/le2_s09 冷开恢复 |
| 联网/服务可达后 10s 内开始同步 | LE R1 ~3s、R2 ~3s（22:39:05→22:39:08）实测 |
| 未提交草稿不入库 | 草稿期服务端 0 行（ED/LE 双侧核验） |
| 可靠 ACK 前不删原件 | SyncController 状态机：RECEIVED 仅在完整校验+可靠落盘后成立；ACK 丢失重传幂等（J06 坐实） |
| 持久任务可恢复（重启） | SQLite WAL 持久化；重启后任务可查询（J05/J09） |

## 6. 环境披露

- 全部在模拟器 + 隔离实例（18231/18232）验证；App 后台永久在线不在范围——合同口径为「系统不允许后台运行时保存队列，恢复后补传」，实测即此语义。
- 上传完成、整理完成、后续 Wiki/索引完成分别披露：本回执只证明到 RECEIVED/整理 COMPLETED；Wiki/全量索引不在本 Goal。
