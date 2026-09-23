# GOAL-KK-04 R2-final — SCREENSHOT_INDEX

> 2026-09-23 · 截图索引（§21 强制字段绑定）。共 43 张：LE 20 张（shots/local-executor/）+ ED 23 张（shots/ed-personal/），均为 hdc snapshot_display 真实屏幕原始 jpeg（1256×2760），从 le2/shots/ 与 ed/shots/ 原样复制。

## 0. 全包不变字段（每张共享，不再逐行重复）

- **CANDIDATE_SHA（App）**：`c0171d4fa5a988272afa76cabd42b4b6ddbaea8d`（tree `4c88cf33614e93a1b9dc64be12929cd64dd019e7`）
- **CANDIDATE_SHA（Workbench）**：`92892d66d059211113379b7e49d7f034b7ec921c`（tree `b527133111112abea4831fa6b4be2c251e7927be`）
- **HAP sha256**：ED 套件 `a73022244985e93a3f227b967bd771e8070dd562d499d16ddca4a91b8d721549`；LE 实操 `eef7cabb0f4c50ee52690d91e4b2cc6e746c0b0e5a0c7827db743f077289022b`（同码复构建，尺寸同 39,206,998B，披露见 CANDIDATE_MANIFEST §5）
- **环境**：OpenHarmony 模拟器 127.0.0.1:5555；隔离实例 ED=18241（rport 18246）/ LE=18242（rport 18245）；插件 v1.0.0 enabled、external_send=disabled
- **operator**：ED 截图 = ED 本人（context …A1F7）；LE 截图 = child agent-2（observation-only）
- **时钟**：业务时间戳全部 +08:00 正确；状态栏时钟慢 12h 为已知怪相（D-LE3-03）

## 1. ED 本人截图（shots/ed-personal/，23 张，2026-09-23 14:1x–14:52）

| 文件 | 旅程 | 时间 | 前状态 → 后状态 | 关联 ID（capture/task/note/revision/sha256） |
|---|---|---|---|---|
| ed_s01_first_launch | J12 | 14:1x | 全新安装 → 干净首屏 | — |
| ed_s02_connected | J01 | 14:1x | 未连接 → 已连接+能力可见 | 插件1.0.0/ASR small/organizer v4 |
| ed_s03_text_submitted | J02 | 14:1x | 草稿 → 已提交排队 | cap_ffe9ac29…c383447a rev1；note 202609231412…-c383447a |
| ed_s04_batch1 | J08/J06 | 14:13 | 空箱 → 3 条入箱 | cap_6db22cb0…4cfa3606 rev1；cap_14caf8b3…d6784ded；cap_6b8998b4…f2f850fb（同名对） |
| ed_s05_audio_yesterday | J03/J07 | 14:14 | → 2 条音频入箱 | cap_a85bfb90…3428113e；cap_a3704e1f…b106cffa（captured 09-22T21:00）sha256 1e95b1be…d84c |
| ed_s06_idempotent_3xtap | J06 | 14:15 | 连点×3 → 仅 1 条 | cap_2c469420…53fcb908（DB 实证 1 capture+1 task） |
| ed_s07_correction_mode_r2 | J08 | 14:16 | 浏览 → 修正模式（横幅带目标名） | 目标 cap_6db22cb0…4cfa3606 |
| ed_s08_r2_submitted | J08 | 14:17 | 修正文本 → rev2 提交 | rev2，note 202609231417…十点…-4cfa3606 |
| ed_s09_r3_submitted | J08 | 14:18 | r2 整理中 → rev3 提交 | rev3，note 202609231418…十一点…-4cfa3606 |
| ed_s10_offline_saved | J04 | 14:1x | 断网 → 草稿未提交保留 | 草稿（至终态未提交） |
| ed_s11_cold_reopen_queue | J04 | 14:19 | force-stop → 冷开队列保留 | 全队列 |
| ed_s12_offline_synced | J04 | 14:19 | 恢复网络 → 4s 补传 | cap_787cb472…131d180d；note 202609231419…-131d180d |
| ed_s13_plugin_disabled_submit | J05 | 14:20 | 插件停用 → 提交排队不丢 | cap_6983d988…78750dff |
| ed_s14_disabled_feedback | J05 | 14:20 | → 红字「插件停用中·保持排队」+重新同步 | 同上；enable 后 resumed_tasks=7 |
| ed_s15_j02_result | J02 | 14:2x | 整理中 → 已整理（可查看） | note 202609231412…-c383447a rev1 |
| ed_s16_j02_provenance | J02 | 14:2x | → 溯源面板展开 | cap_ffe9ac29…c383447a |
| ed_s17_j02_provenance_detail | J02 | 14:2x | → capture_id/三时间/哈希/版本链 | sha256 f63f3a84…（raw） |
| ed_s18_workbench_home | J11 | 14:2x | → 浏览器真实工作台首页 | 实例 18246 |
| ed_s19_j08_r3_provenance_chain | J08 | 14:38 | → 版本链三层全 COMPLETED | rev3 sha256:3e7811b7…e688；r1/r2/r3 note 各在 |
| ed_s20_late_arrival_provenance | J07 | 14:39 | → 昨日条三时间溯源 | cap_a3704e1f…b106cffa；捕获 09-22T21:00/接收 14:14:12/整理 14:26:00 |
| ed_s21_msg_prefixes | J09 | 14:51 | 重连 → [早前]+[当前] 前缀 | — |
| ed_s21b_coldstart_no_stale_msgs | J09 | 14:49 | 冷重启 → 零陈旧回执 | — |
| ed_s22_browser_workbench_notes | J11 | 14:52 | → 知识视图 28 条摘要 | 含 9 条本轮移动采集笔记 |

## 2. LE（agent-2）截图（shots/local-executor/，20 张 + INDEX.md，2026-09-23 13:23–14:01）

逐张绑定见该目录 INDEX.md（原样复制，含文件/旅程/时间/绑定关系）。关键张与 ID 对应：

| 文件 | 旅程 | 时间 | 绑定 |
|---|---|---|---|
| le3_j12_01_fresh_firstlaunch | J12 | 13:23 | uninstall+install 全新首屏 |
| le3_j01_01_connected_caps | J01 | 13:25 | 已连接+能力 |
| le3_j01_02_revoked | J01 | 13:26 | 撤销后状态 |
| le3_j01_03_revoked_reject_redtext | J01 | 13:27 | 撤销后提交原位提示 |
| le3_j01_04_redtext_detail | J01 | 13:27 | D-LE2-01 红字细节 |
| le3_j08_01_received_correctable | J08 | 13:32 | D-LE2-04：RECEIVED 可修正 |
| le3_j08_02_correction_banner | J08 | 13:32 | D-LE2-05 横幅带目标 |
| le3_j08_03_after_r2_save | J08 | 13:35 | r2 保存后（`%` 怪相记录 D-LE3-02） |
| le3_j08_04_pct_draft | J08 | 13:36 | r2 草稿内容正确 |
| le3_j08_05_after_r3 | J08 | 13:41 | r3 保存后 |
| le3_j08_06_provenance_layers | J08 | 13:43 | 版本链中间态：r1 COMPLETED/r2 r3 PROCESSING；cap_bcf2af5b…1c61af rev3；sha256:0334b659…c2dd |
| le3_j04_01_offline_queued | J04 | 13:44 | 断网「排队待传」 |
| le3_j04_02_coldstart_queue | J04 | 13:45 | 冷开队列保留 |
| le3_j11_01_workbench_front | J11 | 13:48 | D-LE2-02：浏览器 18245 真实工作台 |
| le3_j05_01_disabled_reject | J05 | 13:58 | 停用 503+「保持排队」 |
| le3_j05_02_enabled_resumed | J05 | 13:59 | enable 后转整理中（resumed_tasks=2） |
| le3_j08_07_provenance_final | J08 | 14:00 | 版本链终态 r1/r2/r3 全 COMPLETED 各带结果链接 |
| le3_j11_02_browser_home | J11 | 13:59 | 知识 tab |
| le3_j11_03_daily_records | J11 | 14:00 | 每日记录 26 条摘要 |
| le3_j11_04_conversation | J11 | 14:01 | 对话区（Web 注入受限转 API，已标注） |

## 3. 交叉一致性

截图画面、双方回执、DB/KB 实证三者一致（VISUAL_INSPECTION_RECEIPT 逐张目验结论）；LE 标题前导 `%`（D-LE3-02）与状态栏时钟（D-LE3-03）两处已知瑕疵均已在索引与回执中同步披露。
