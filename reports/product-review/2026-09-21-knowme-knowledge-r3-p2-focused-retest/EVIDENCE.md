# Evidence Manifest

Candidate: `3317469085d8dc10a88818369ffcc2922904079c` / tree `c688e8d6da0fe5fdaa12f2412158eb0c6d86ee15`。所有运行证据由本轮reviewer在2026-09-21采集，未复用ED/LE截图。

## 快速复核路径

系统拒权06 → 候选修正15 → 丢弃16及实际跳转17 → 确认29 → 手动保存32 → 未确认候选36/39 → 授权41/42 → 录音开始/取消43/44 → 冷启动后来源48/49 → 上下文50。

## 精选截图

| 序号 | 主机采集时间（+08:00） | 原生截图无损副本 |
|---|---|---|
| 02 | 2026-09-21T13:10:46.547662+08:00 | [02-initial-stable.png](evidence/published/02-initial-stable.png) |
| 06 | 2026-09-21T13:12:43.026695+08:00 | [06-mic-off.png](evidence/published/06-mic-off.png) |
| 10 | 2026-09-21T13:13:26.039483+08:00 | [10-reject-generated.png](evidence/published/10-reject-generated.png) |
| 15 | 2026-09-21T13:14:17.003256+08:00 | [15-reject-correction-saved.png](evidence/published/15-reject-correction-saved.png) |
| 16 | 2026-09-21T13:14:18.837456+08:00 | [16-rejected-plus-zero.png](evidence/published/16-rejected-plus-zero.png) |
| 17 | 2026-09-21T13:14:41.766135+08:00 | [17-permission-action-after-reject.png](evidence/published/17-permission-action-after-reject.png) |
| 29 | 2026-09-21T13:16:22.443183+08:00 | [29-confirm-plus-one-denied.png](evidence/published/29-confirm-plus-one-denied.png) |
| 32 | 2026-09-21T13:17:10.411546+08:00 | [32-manual-keyboard-hide.png](evidence/published/32-manual-keyboard-hide.png) |
| 36 | 2026-09-21T13:20:46.640294+08:00 | [36-return-pending.png](evidence/published/36-return-pending.png) |
| 39 | 2026-09-21T13:21:18.571072+08:00 | [39-cold-list-pending-absent.png](evidence/published/39-cold-list-pending-absent.png) |
| 41 | 2026-09-21T13:21:46.425541+08:00 | [41-mic-granted-system.png](evidence/published/41-mic-granted-system.png) |
| 42 | 2026-09-21T13:21:49.144305+08:00 | [42-return-granted.png](evidence/published/42-return-granted.png) |
| 43 | 2026-09-21T13:22:01.885649+08:00 | [43-granted-start.png](evidence/published/43-granted-start.png) |
| 44 | 2026-09-21T13:22:16.281464+08:00 | [44-granted-cancel.png](evidence/published/44-granted-cancel.png) |
| 48 | 2026-09-21T13:23:02.646290+08:00 | [48-manual-detail-scroll.png](evidence/published/48-manual-detail-scroll.png) |
| 49 | 2026-09-21T13:23:15.061414+08:00 | [49-fixture-detail.png](evidence/published/49-fixture-detail.png) |
| 50 | 2026-09-21T13:23:20.925870+08:00 | [50-final-context.png](evidence/published/50-final-context.png) |

17张1256×2760原生截图，PNG重新无损编码以减小Git体积，未裁切、缩放、涂改或重绘；逐张RGBA像素相等核对通过。原始与发布副本hash见[screenshot-integrity.json](evidence/screenshot-integrity.json)。
所有50组原始PNG/JSON仍保留本机本目录evidence；GitHub只发布上述精选PNG及全部布局原文。未选PNG仅发布hash，不能声称其二进制已在GitHub。

## 全序列索引

完整操作：[operation-log.jsonl](evidence/operation-log.jsonl)，342条命令记录；安装/冷启动：[environment-commands.jsonl](evidence/environment-commands.jsonl)，10条记录。
[all-layouts.jsonl.gz](evidence/all-layouts.jsonl.gz) 收录50份原布局文本，每行包含filename和raw_text；解压后raw_text与本机原文件逐字节核对通过。读取布局不是产品源码审查。

| 序号/名称 | PNG最后接收时间 | 发布PNG |
|---|---|---|
| 01-cold-entry | 2026-09-21T13:10:32.257730+08:00 | NO; raw hash only |
| 02-initial-stable | 2026-09-21T13:10:46.547662+08:00 | YES |
| 03-settings | 2026-09-21T13:11:59.181725+08:00 | NO; raw hash only |
| 04-apps | 2026-09-21T13:12:17.123420+08:00 | NO; raw hash only |
| 05-app-mic-before | 2026-09-21T13:12:19.586491+08:00 | NO; raw hash only |
| 06-mic-off | 2026-09-21T13:12:43.026695+08:00 | YES |
| 07-denied-entry | 2026-09-21T13:12:45.381341+08:00 | NO; raw hash only |
| 08-denied-capabilities | 2026-09-21T13:12:49.821382+08:00 | NO; raw hash only |
| 09-reject-input | 2026-09-21T13:13:07.159058+08:00 | NO; raw hash only |
| 10-reject-generated | 2026-09-21T13:13:26.039483+08:00 | YES |
| 11-correction-focus | 2026-09-21T13:13:48.268284+08:00 | NO; raw hash only |
| 12-correction-select | 2026-09-21T13:13:50.272852+08:00 | NO; raw hash only |
| 13-correction-replace | 2026-09-21T13:13:53.046922+08:00 | NO; raw hash only |
| 14-correction-keyboard-dismiss | 2026-09-21T13:13:55.338733+08:00 | NO; raw hash only |
| 15-reject-correction-saved | 2026-09-21T13:14:17.003256+08:00 | YES |
| 16-rejected-plus-zero | 2026-09-21T13:14:18.837456+08:00 | YES |
| 17-permission-action-after-reject | 2026-09-21T13:14:41.766135+08:00 | YES |
| 18-settings-return-still-denied | 2026-09-21T13:14:43.759272+08:00 | NO; raw hash only |
| 19-confirm-input | 2026-09-21T13:15:01.782771+08:00 | NO; raw hash only |
| 20-confirm-generated | 2026-09-21T13:15:23.664969+08:00 | NO; raw hash only |
| 21-confirm-edit-focus | 2026-09-21T13:15:25.434408+08:00 | NO; raw hash only |
| 22-confirm-select | 2026-09-21T13:15:27.172901+08:00 | NO; raw hash only |
| 23-confirm-replace | 2026-09-21T13:15:29.637108+08:00 | NO; raw hash only |
| 24-confirm-edit-focus-corrected | 2026-09-21T13:15:52.664922+08:00 | NO; raw hash only |
| 25-confirm-select-all | 2026-09-21T13:15:54.544614+08:00 | NO; raw hash only |
| 26-confirm-replace-verified | 2026-09-21T13:15:57.521179+08:00 | NO; raw hash only |
| 27-confirm-dismiss-keyboard | 2026-09-21T13:15:59.541634+08:00 | NO; raw hash only |
| 28-confirm-correction-save | 2026-09-21T13:16:20.504168+08:00 | NO; raw hash only |
| 29-confirm-plus-one-denied | 2026-09-21T13:16:22.443183+08:00 | YES |
| 30-manual-denied-input | 2026-09-21T13:16:41.519060+08:00 | NO; raw hash only |
| 31-manual-save-denied | 2026-09-21T13:17:07.766878+08:00 | NO; raw hash only |
| 32-manual-keyboard-hide | 2026-09-21T13:17:10.411546+08:00 | YES |
| 33-pending-input | 2026-09-21T13:17:32.604312+08:00 | NO; raw hash only |
| 34-pending-generated | 2026-09-21T13:20:29.034858+08:00 | NO; raw hash only |
| 35-background-pending | 2026-09-21T13:20:44.684960+08:00 | NO; raw hash only |
| 36-return-pending | 2026-09-21T13:20:46.640294+08:00 | YES |
| 37-cold-denied | 2026-09-21T13:21:03.488950+08:00 | NO; raw hash only |
| 38-cold-denied-stable | 2026-09-21T13:21:05.227731+08:00 | NO; raw hash only |
| 39-cold-list-pending-absent | 2026-09-21T13:21:18.571072+08:00 | YES |
| 40-grant-action-settings | 2026-09-21T13:21:32.920636+08:00 | NO; raw hash only |
| 41-mic-granted-system | 2026-09-21T13:21:46.425541+08:00 | YES |
| 42-return-granted | 2026-09-21T13:21:49.144305+08:00 | YES |
| 43-granted-start | 2026-09-21T13:22:01.885649+08:00 | YES |
| 44-granted-cancel | 2026-09-21T13:22:16.281464+08:00 | YES |
| 45-final-cold-granted | 2026-09-21T13:22:40.903730+08:00 | NO; raw hash only |
| 46-final-granted-list | 2026-09-21T13:22:45.643444+08:00 | NO; raw hash only |
| 47-final-inspect-manual | 2026-09-21T13:22:58.461564+08:00 | NO; raw hash only |
| 48-manual-detail-scroll | 2026-09-21T13:23:02.646290+08:00 | YES |
| 49-fixture-detail | 2026-09-21T13:23:15.061414+08:00 | YES |
| 50-final-context | 2026-09-21T13:23:20.925870+08:00 | YES |

01/45是启动转场，不作为恢复成功截图；21–23是未命中候选输入框的操作者无效动作，24重新定位后才完成实际输入。截图与布局相邻采样但非原子，同一capture的最后PNG由工具直接重采；不以布局已就绪推定过渡PNG已经显示产品。状态栏约慢主机12小时，绝对时间使用日志。

## 身份、权威与完整性

- [reviewer-identity.json](evidence/reviewer-identity.json)：操作结束后PR/branch/SHA/tree/干净工作树、HAP双hash、OS/API/arch复核。
- [candidate-manifest.md](evidence/candidate-manifest.md)：工程配置背景，不替代本轮体验证据。
- [Contract R3](evidence/contract-r3.md)、[baseline v2](evidence/baseline-v2.md)、[admission](evidence/admission.md)、[referral](evidence/referral.md)。
- [Stage A](evidence/stage-a.md)：13:11:33冻结的primed初始观察。
- [authority-index.json](evidence/authority-index.json)：读取的权威副本hash与pin。
- [hashes.json](evidence/hashes.json)：50原PNG、50原JSON及发布文档/证据hash（不含自身，validator单独附原文）。
- [skill-validation.txt](evidence/skill-validation.txt)：固定Skill/Core/report结构校验，不是产品测试。

隐私/状态：本轮输入均为合成短句。没有提交Owner音频、声纹/embedding、HAP或凭据。已有ED条目只作2条初始基数；本轮最终4条，权限恢复已授权，WLAN未改、声纹未注册。没有删除既有知识。

[审核报告](REVIEW.md) · [Parent提示词](PARENT_HANDOFF.md)
