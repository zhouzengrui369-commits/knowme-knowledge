# 灵犀移动采集终端里程碑路线 v3

BASELINE=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260922-v3-LINGXI-CAPTURE-DEVICE
一个 Goal = 一个 Milestone；接口、手机 UI、联调和测试是同一价值增量的工作包，不能分别充当完成的里程碑。

| Goal | 唯一对应 Milestone | 产品结果 | 当前状态 |
|---|---|---|---|
| GOAL-KK-03-VOICE-TO-NOTE-FIRST-USE-PROTOTYPE | MILESTONE-GOAL-KK-03-VOICE-TO-NOTE-FIRST-USE-PROTOTYPE | 原独立手机语音到笔记探索 | SUSPENDED，未完成，Issue #30 保持开放 |
| GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE | MILESTONE-GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE | 语音/文本离线采集→插件可靠接收→工作台真实整理→手机查看同一知识结果 | 当前唯一 FROZEN；Issue #35 |
| GOAL-KK-05-LINGXI-MULTIMODAL-CAPTURE | MILESTONE-GOAL-KK-05-LINGXI-MULTIMODAL-CAPTURE | 相机/图片、系统分享文件/链接、同事件资料归组；复用工作台可用解析能力，格式能力诚实 | PLANNED_NOT_AUTHORIZED |
| GOAL-KK-06-LINGXI-CAPTURE-CONTEXT-ACTIONS | MILESTONE-GOAL-KK-06-LINGXI-CAPTURE-CONTEXT-ACTIONS | 采集结果追问、关联旧知识、补充/纠正、日程待办意图确认，引用同一知识与会话 | PLANNED_NOT_AUTHORIZED |
| GOAL-KK-07-LINGXI-MOBILE-1-0-FINAL | MILESTONE-GOAL-KK-07-LINGXI-MOBILE-1-0-FINAL | 1.0 全能力整合、长录音/离线恢复/隐私检查、完整 PE、再受控真机安装与兼容、最终 Owner Acceptance | PLANNED_NOT_AUTHORIZED；必须另冻 exact 合同 |

## 当前唯一执行目标 KK04

两个仓库各有工程 PR，作为同一集成候选交付；一个 canonical contract、一个 lifecycle Issue #35，整体准入和审核。工作台保持主体：不再把“手机独立整理器完成”算接入完成。必须产生真实工作台结果。

KK04 最低覆盖：文本、语音至少 5 分钟单段采集（本阶段边界，不是最终产品上限）；可靠离线队列、断线/进程/服务重启恢复、幂等接收、原始资产保留、跨日时间归属、实时状态反馈、同一 note_id 双端查看、可启停插件、无生产影响。无需真机提前介入。

## 1.0 与 2.0

1.0 手机核心是采集、采集箱和灵犀结果工作面。知识整理、Wiki/图谱/索引、模型和长期记忆由工作台拥有；手机需要哪些结果视图按后续冻结合同接入，不重建后台。

0.1 为历史原型；当前 KK04–06 是朝 1.0 的开发增量，不再另做假数据演示作为终点。2.0 为 PLANNED 的连续演进：更多设备、更多采集源、可选现场智能、长期知识回流；必须逐一形成有独立价值的 Goal/Milestone，未冻结项不授权开发。

## 门禁

KK04–06：ED 双实操证据→PG Candidate Admission→PG Review Eligibility（实际 Reviewer 独立性验证）→独立 FULL_EXPERIENCE_REVIEW→PG 按合同关闭。失败则同 Goal 新候选修正，不把例行验证推给 Owner。

KK07：先完整模拟器/隔离服务 PE；之后经单独签名/设备授权实施真机安装、由 ED/LE 与独立 PE 验证兼容和实际核心采集；最后才提交 Owner 1.0 最终产品验收。没有真机证据不得称 Mate60 1.0 已交付；不要求 Owner 升级系统或承担开发回归。Release/生产授权单独，不因 Milestone 关闭自动授权。

以上 Milestone 是治理合同对象与 Issue 配对。本次不宣称已建立 GitHub 原生 Milestones UI 对象；执行与关闭权威以 exact 合同/Issue 为准。