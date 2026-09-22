# GOAL-KK-04 — 迟到采集回执（LATE_ARRIVAL_RECEIPT，J07）

> GOAL-KK-04 · LATE_ARRIVAL_RECEIPT · ED context ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E
> Final pair：App `10d829195ebb7f6c4c576b0d116e45087ec2b35a` / Workbench `e548883b1d696b8245631bad129dd3737afcc5b7`
> 日期：2026-09-22

## 1. 结论

昨日采集今日上传（J07）在 ED 与 LE 两侧实操通过：捕获/接收/整理三时间分离并分别持久化披露；产物落「今日接收主源」（organizer 仅处理今日），不创建、不修改 2026-09-21 的任何文件；笔记保留 captured_at/captured_date 关联；按捕获日期查询语义正确；跨设备查询隔离正确。未修改系统时间、未重写历史 daily/Wiki。

## 2. ED 实操（实例 18231，2026-09-22 18:29）

- 操作：App「导入·昨日捕获」按钮 → 演示音频以 captured_at=**2026-09-21T21:00:00+08:00** 提交。
- 三时间分离（服务端 captures 表）：
  - captured_at = 2026-09-21T21:00:00+08:00
  - received_at = 2026-09-22 18:25:29
  - organized_at = 2026-09-22 18:28:57
- 落盘归属：产物落今日接收主源（date=2026-09-22）；核验**无 2026-09-21 文件被创建或修改**。
- 笔记正文保留 captured_at 与 captured_date；organizer 真实识别出迟到采集与时区不一致风险（frontmatter 标「迟到采集」「内容待确认」）——非预制文案，真实模型输出。
- 按捕获日期查询 SQL 语义验证：from_date=2026-09-21 仅该条；2026-09-22 四条。
- 设备隔离：curl 以其它设备凭证跨设备查询返回空 = 隔离正确。
- 截图：s24–s29 区间（J07 段）。

## 3. LE 复验

### R1（旧 pair，实例 18232）

首试 cap_e767ca7b… 整理超时 FAILED（E1）；重试 cap_c06a23ad8d7c9c8d COMPLETED：captured 2026-09-21T21:00+08:00 / received 09-22T20:34:02 / organized 20:41:04 三时间分离；产物落今日；全库 0 个 20260921 文件。截图 le_s29。

### R2（新 pair）

cap_f5b536652a5d8e53b54fd9069bd48d7f：captured 09-21T21:00 / received 21:23:39 / organized 21:29:58 三时间分离；全库 0 个 20260921 文件；note_id 202609222123…-9bd48d7f。

## 4. 实现机制（受控适配，合同 §5）

organizer v4 仅处理 KB_ROOT/knowledge/notes/daily/ 今日（Asia/Shanghai）主源。插件为迟到采集建立**接收日**的今日接收主源，frontmatter 与原文件首行保留 `captured_at`/`captured_timezone`/capture_id/hash 与原捕获日期关联；`/captures?from_date=` 按捕获日期可查。不改真实系统时间、不无授权重写历史 daily/Wiki。

## 5. 环境披露

- 设备 shell date=+08:00 与主机一致；Intl 报 America/Chicago 为模拟器 region 怪癖，偏移以 +08:00 为准（见 ENVIRONMENT_RECEIPT.md §2）。
- 跨时区仅验证到「时区字段贯通 + 迟到关联」层；真实跨地域设备未验证。
