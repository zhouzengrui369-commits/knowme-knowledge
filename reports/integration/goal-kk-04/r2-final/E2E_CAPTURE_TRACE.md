# GOAL-KK-04 R2-final — E2E_CAPTURE_TRACE

> 2026-09-23 · J02 主链路端到端追踪（文本），辅以 J03(a) 30s 音频。
> 追踪口径：App 操作 → 协议事件 → DB 状态迁移 → KB 三产物 → App 结果/溯源回读，每一跳均有实证。

## 1. J02 文本（ED 实例，capture cap_ffe9ac2909183734e29a631ec383447a rev1）

| 跳 | 时间（+08:00） | 证据 |
|---|---|---|
| App 输入+保存到采集箱 | 14:1x | 草稿「未提交」，服务端 0 行（草稿不入库） |
| 显式「交给灵犀」 | 14:1x | CAPTURE_ACCEPTED/RECEIVED 事件（kind=text） |
| 服务端持久化 | 即刻 | captures 行 transfer=RECEIVED、durable_received_at 落盘 |
| 串行整理 | → 14:16:00 | PROCESSING_STARTED → ORGANIZE_COMPLETED（events seq 17） |
| KB 三产物 | 14:15–14:16 | daily/202609231412移动采集ED-J02…-c383447a.md（v4 frontmatter：run_id 20260923T141439+0800-njx-v4-instant、raw_sha256 f63f3a84…、epistemic_counts）+ .raw-transcript.backup.md + .md.html（meta source-hash/run-id 一致） |
| App 回读 | 整理后 | 「已整理（可查看）」+ 查看灵犀结果 note_id/rev1（ed_s15）+ 原始来源面板 capture_id/三时间/哈希/原文（ed_s16/s17） |

认知防火墙实证：笔记「NJX 视角」如实留空并带「他人观点不归因提示」——来源未标发言者，不做归因推定。

## 2. J03(a) 30s 音频（LE 实例，capture …f84f83）

- 链路：导入演示音频（合成朗读，已披露）→ 元数据 202 → PUT asset（1,024,078B，sha256 1e95b1be…d84c 三端一致）→ 真实 mlx-whisper 转写（中文，内嵌笔记「最初转写（ASR 原文）」节）→ organizer v4 → 三产物。task 3c4209 13:30:33→13:33:55（202s 热 ASR+整理）。
- ED 实例同链路复验：cap_a85bfb90…3428113e 14:14:01 接收 → 14:23:31 COMPLETED（串行队列排队后一次性成功，attempts=1）。

## 3. 串行化实证（E1 修复后两轮）

ED 实例 ORGANIZE_COMPLETED 事件时间序列：14:16:00 → 14:17:36 → 14:19:47 → 14:21:11 → 14:23:31 → 14:26:00 → 14:28:15 →（续 4 条）→ 14:35 前全部终态——逐一相继、零重叠、零 LOCKED_SKIP、零超时 FAILED。LE 实例 9/9 同结论（LOCAL_EXECUTION_RECEIPT §J06）。

## 4. 哈希三端一致

- 30s 音频：手机原件/服务端 asset/笔记 frontmatter = 1e95b1be2c1a27c590284cfd1161e9ecb59c8b004b16696d5c4dd9946fc3d84c。
- J08 r3 文本：App 溯源面板 sha256:3e7811b7…e688 = 服务端 content_hash（ed_s19 与 DB 一致）。
- 5min 音频（LE）：8dbc7bae…/10,793,598B/337,299ms 三端一致。
