# GOAL-KK-04 — 端到端采集链路追踪（E2E_CAPTURE_TRACE）

> GOAL-KK-04 · E2E_CAPTURE_TRACE · ED context ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E
> Final pair：App `10d829195ebb7f6c4c576b0d116e45087ec2b35a` / Workbench `e548883b1d696b8245631bad129dd3737afcc5b7`
> 日期：2026-09-22

## 1. 结论

文本（J02）与音频（J03）主链路均完成「手机采集 → 本地保存 → 可靠接收（hash 校验落盘）→ 真实 MLX ASR（音频）→ 真实 organizer v4 整理 → 同一 note_id 双端可见 → 原始来源可溯」全跳贯通；两端 ID 与哈希一致。以下逐跳给出证据锚点。

## 2. J02 文本主链路（ED 实例 18231，截图 s5–s17）

| 跳 | 动作 | 证据锚点 |
|---|---|---|
| 1 采集 | App 采集区输入文本，1 秒内本地反馈 | s5–s7（过程存证） |
| 2 本地保存 | 草稿入采集箱（LOCAL_SAVED），**服务端 0 行**（草稿不入库） | s8–s9；LE R1 独立核验「草稿期服务端 0 行」 |
| 3 提交 | 「交给灵犀」→ POST /captures → QUEUED→UPLOADING→RECEIVED(ACK) | s10–s11 |
| 4 整理 | 约 40s 真实 organizer v4（DSH/TokenHub）→ COMPLETED，三件产物（md/backup/html）齐全，无企业微信外发 | s12–s14；冒烟 cap_smoke001 同路径坐实 |
| 5 状态回传 | App 轮询/事件补拉自动更新「已整理(可查看)」（D-KK04-03 修复后） | s12（重装后会话恢复+轮询补拉） |
| 6 查看结果 | 灵犀结果区显示 note_id/rev/frontmatter/正文 | s15–s16 |
| 7 原始来源 | ≤2 次导航见 capture_id/captured_at/sha256/原文/收发三时间 | s17 |

### LE R1 独立复跑（实例 18232，旧 pair，链路语义一致）

cap_897e80b3bd5b59bc7da5e33fffaa31f1 / task_5849e19248964c5f；received 19:23:31 → organized 19:27:03；note_id 202609221923…-ffaa31f1 两端一致；content_hash 与 raw backup sha256 两端一致。截图 le_s06–s12。

### LE R2（新 pair）

cap_875c6d48095aed619cf872ce0653110a：草稿期服务端 0 行、提交入库正常；整理 4 次尝试均遇 E1 超时 FAILED（后端环境性，见 DEFECT_CYCLE.md），链路接收层 PASS。

### ED 本人 same-pair 复核（2026-09-22 23:10，实例 18231）

cap_a7d9908dd1adb117453d35be24ddfded → 接收 23:07:17 → 真实 organizer COMPLETED 23:09:24（note_id 202609222307…-24ddfded），约 2 分钟，E1 后端已恢复。截图 s62–s67（s63 已整理、s65/s67 原始来源面板完整含 sha256:53304210…）。

## 3. J03 音频主链路

### 3.1 30 秒链路（ED，18:20）

导入演示音频（kk04_reading_30s.wav，32.0s / 1,024,078 B，git 样本）→ 草稿 → 交给灵犀 → 服务端 sha256 校验一致 → 真实 MLX ASR（可识别转写，有真实同音误识特征）→ organizer COMPLETED（note_id 202609221808…ede4de3f）→ App 状态自动回「已整理」。截图 s18–s23 区间。

LE R1 复跑：cap_b2a6a1978c001a49b15a2fa26ec02fc1，asset sha256 `1e95b1be…` 与 git 样本逐字节一致（1,024,078B / 32,001ms），19:39:22→19:46:31 COMPLETED（le_s19–s21）。
LE R2 复跑：cap_6a4479dd8839547a632a3a4ed00bdc69，sha256 一致，COMPLETED。

### 3.2 5 分钟链路（保存/传输完整性）

ED：337.299s / 10,793,598 B，服务端 asset_sha256=`8dbc7bae…` 与源文件逐字节一致（保存/传输完整性 ✓）；ASR 转写 1,343 字；organizer COMPLETED（note_id 202609221814…69f8ea37，全程约 6 分钟）。截图 s24–s29 区间。

LE R1：cap_4f0a584ac63a33453727cd2d7ee45ffd，asset sha256 `8dbc7bae…aaf3` 两端一致（10,793,598B / 337,299ms），ASR 完成 1,343 字；整理遇 E1 DSH 600s 超时 FAILED（环境性）。le_s22–s23。
LE R2：上传/哈希一致，整理 2 次超时 FAILED（E1）。

## 4. 两端 ID / 哈希一致表

| 链路 | capture_id | task_id | note_id | 关键哈希（两端一致） |
|---|---|---|---|---|
| J02 文本（LE R1） | cap_897e80b3bd5b59bc7da5e33fffaa31f1 | task_5849e19248964c5f | 202609221923…-ffaa31f1 | content_hash = raw backup sha256 |
| J02 文本（ED 复核） | cap_a7d9908dd1adb117453d35be24ddfded | —（服务端可查） | 202609222307…-24ddfded | sha256:53304210…（来源面板） |
| J03a 30s（ED） | —（App 侧提交） | — | 202609221808…ede4de3f | 样本 sha256 `1e95b1be…` |
| J03a 30s（LE R1） | cap_b2a6a1978c001a49b15a2fa26ec02fc1 | — | — | `1e95b1be…`（=git 样本字节） |
| J03b 5min（ED） | — | — | 202609221814…69f8ea37 | `8dbc7bae…`（逐字节一致） |
| J03b 5min（LE R1） | cap_4f0a584ac63a33453727cd2d7ee45ffd | — | 整理 FAILED（E1） | `8dbc7bae…aaf3`（两端一致） |
| 冒烟文本 | cap_smoke001 | — | COMPLETED | — |
| 冒烟音频 | cap_smoke_audio01 | — | COMPLETED | sha 130e8815…（753,106B） |

## 5. 环境披露

- 音频输入为合成朗读（合同 J03 允许），模拟器 mic 无声；ASR 与整理均为工作台真实链路，无假转写/预制产物。
- 整理耗时受 E1 后端时段影响（40s–6min 成功样本；超时样本见 DEFECT_CYCLE.md）。「处理完成」以前台状态/事件为准，未把 1s 反馈阈值误写成 1s 完成 AI 处理。
