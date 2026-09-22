# GOAL-KK-04 — PARENT_PM_HANDOVER_PROMPT

> 可复制交接。ED context ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E · 2026-09-22
> NEXT_AUTHORIZED_GATE=PRODUCT_GOVERNANCE_CANDIDATE_ADMISSION；STOPPED=YES
> ED 最高声明 ENGINEERING_READY；不宣布 Candidate Admission / PX PASS / Owner Acceptance / Merge / Release / 里程碑关闭。

## 完成了什么

- **手机新增**（knowme-knowledge，prototype knowme-knowledge-02-voice-speaker-verification）：采集箱（文本/录音本地持久化，草稿永不上传）、显式「交给灵犀」提交、离线排队与联网 ≤10s 自动补传、已整理查看（灵犀结果/原始来源两层）、现场修正 revision 链、整理失败「重试整理」、演示音频导入（模拟器无 mic 的受控合成方案）、设备注册/撤销。
- **工作台复用/新增**（njx-knowledge）：新插件 mobile_capture_bridge（设备凭证哈希、SQLite WAL 幂等接收、MLX ASR 桥、instant-note-organizer-v4 窄路径触发、事件补拉、demo-audio 端点、任务重试、auto_organize 语义）；lingxi_server.py 纯追加挂载、dsh_acp_client.py 路径 env 化（默认值逐字不变）。
- **每条旅程结果**：J01–J12 全部实操通过（ED R1 全通；LE R1 发现缺陷；修复后 LE R2 与 ED same-pair 复核在新 pair 全通）。明细见 E2E_CAPTURE_TRACE / OFFLINE_SYNC_RECEIPT / LATE_ARRIVAL_RECEIPT / PROVENANCE_REGRESSION_RECEIPT / VISUAL_INSPECTION_RECEIPT。

## 两仓库 exact candidate / PR / 构建 / 模型 / 插件 / 配置身份

- App：`engineering/goal-kk-04-lingxi-mobile-capture-bridge-r1` @ commit `10d829195ebb7f6c4c576b0d116e45087ec2b35a`（tree `2f669b599d9a9e05fe10b9708d69a7716fb2accb`）= PR knowme-knowledge#37 HEAD（Draft OPEN UNMERGED，base governance/lingxi-mobile-capture-v3-20260922）
- Workbench：`engineering/goal-kk-04-mobile-capture-bridge` @ commit `e548883b1d696b8245631bad129dd3737afcc5b7`（tree `bcfeb544bfc16cbe63fdca2e250c4df9e85feed3`）= PR njx-knowledge#8 HEAD（Draft OPEN UNMERGED，base governance/lingxi-mobile-capture-kk04-20260922）
- HAP：39,201,171 B，sha256 `44cd0c0030bd0286e43287ba7367de8ea611a55ba170a62ba7e2d639b63db732`（build-hap.sh；zip 复构建字节不稳定性已披露）
- 插件 mobile_capture_bridge v1.0.0 / 协议 v1.0.0 / BASE_PATH=/api/mobile-capture/v1；ASR mlx-whisper small；organizer instant-note-organizer-v4；DSH ACP pin tencent-tokenhub deepseek-flash；隔离实例 external_send=disabled。

## 证据在哪里（exact GitHub commit）

- knowme-knowledge branch `evidence/goal-kk-04-lingxi-mobile-capture-20260922` @ `a2de8fe`（+ PARENT_PM_HANDOVER_PROMPT 追加提交，以分支 HEAD 为准）：reports/integration/goal-kk-04/ 下 18 份 receipts + 设计三件套 + shots/ 112 张真实截图。CANDIDATE_MANIFEST.md 绑定两端 commit/tree/parent 与全部运行时身份。

## LE 实际 context / 部署 / 操作 / 截图 / 缺陷 / 返回结果

- LE 为真实派生的 observation-only 子代理（explore 类型）：parent session wd_knowme-knowledge_9c19601bea04 / conv-7d8030eed6db2cc1fafc1f01，child 以 Agent 工具 resume 续跑两轮（R1/R2 回执全文要点见 evidence 包 LOCAL_EXECUTION_RECEIPT.md；原始全文 kk04-ed/le/LE_RECEIPT_R1.md、LE_RECEIPT_R2.md）。
- LE 独立 fresh materialize（kk04-ed/le/ 双 worktree）、核对 SHA/tree/clean、自建隔离实例 18232、独立构建部署模拟器，实操 J01–J12 并截图 le_s01–29 / le2_s01–13 共 42 张。
- LE R1 发现 D1（撤销重连按钮卡死）、D2（失败无重试入口）、E2（auto_organize=false 被忽略）→ 全部返回 ED 修复；R2 复验三项 PASS。

## ED 本人实际操作 / 独立截图 / 目验 / 缺陷修复 / 最终重跑

- ED 全程实操 R1（J01–J12 全通，截图 s05–s52）→ 修复 D-KK04-04/05 与 E2（12 单测+实链验证）→ same-pair 复核：重装 App、注册 18231、文本主链路 cap_a7d9908dd1adb117453d35be24ddfded → note 202609222307…-24ddfded，目验结果与溯源面板（s62–s67）；并真目验 LE 截图（le2_s02/le2_s08 等）。

## 为什么 Ready

全部必验旅程在冻结 pair 上有 ED+LE 双方真实操作证据；无已知必修缺陷（D1/D2/E2 已修并复验 PASS）；双候选身份一致（candidate=branch HEAD=PR HEAD 已核验）；证据齐全且含原始哈希对照；禁区零触碰（ALLOWED_PATH_DIFF_RECEIPT 实跑 diff 佐证）；生产 8787 全程无污染。

## CONTRACT_REQUIRED_NOT_COMPLETE

- 无。合同要求的旅程/双实操/缺陷循环/证据/PR/terminal 均已完成。
- 如实说明：E1（整理后端 DSH 600s 看门狗超时）两轮均有发生（R2 21:38 后 13 连超时、重试 0/6；ED same-pair 时后端已恢复，2min 完成）。属环境性依赖波动，已提供显式重试恢复路径，按合同如实披露而非隐瞒；不构成合同内缺陷，但建议治理侧知悉。

## OUT_OF_SCOPE_FUTURE_WORK

- 真实设备（非模拟器）验证、真麦克风录音链路、生产/公网部署、多模态（图片/视频）采集、完整索引规模验证、整理看门狗超时参数调优（建议 600s→更宽容或加退避重试）、导入按钮文字截断等 UI 抛光。

## 未验证项如实披露

- 真机、生产环境、公网通道、企业微信外发（隔离环境禁用）均未验证；模拟器状态栏时钟异常与 Intl America/Chicago region 怪癖已披露（Date 时间戳 +08:00 正确）。

## 门禁

NEXT_AUTHORIZED_GATE=PRODUCT_GOVERNANCE_CANDIDATE_ADMISSION；STOPPED=YES。
