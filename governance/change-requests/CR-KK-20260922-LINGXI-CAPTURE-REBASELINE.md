# CR-KK-20260922-LINGXI-CAPTURE-REBASELINE

DECISION=APPROVED_BY_PRODUCT_GOVERNANCE_ON_EXPLICIT_OWNER_DIRECTION
CHANGE_CLASS=PRODUCT_REBASELINE_AND_PRIORITY_CHANGE
DATE=2026-09-22
AUTHORITY_ISSUE=knowme-knowledge#35
PRODUCT_MUTATION_BY_PM=NONE

## Owner 输入

Owner 明确灵犀工作台已经搭好，NJX-Knowledge 为知识底座、DSH 为智能体框架；KnowME Knowledge 为服务灵犀的智能信息采集设备，通过插件连接，离线采集、联网及时同步；随后明确要求“更新项目基线和里程碑，基于里程碑输出 ED 执行合同”。此 CR 将该方向落实为项目范围，不伪造 Owner 产品验收。

## 被改变的基线与权限

旧有效引用 baseline v2@978ed0608bda8e278c348ad2987f6a25fa3c3c2f；旧治理 preimage@02329efa8b41e5242a0e457d836d27051a2f5bbe 实际 baseline 文件仍为 v1、PROJECT_PROFILE 仍指向独立手机/Codex，现一次对齐为 v3。

由独立手机知识 Agent 改为工作台主产品的移动采集终端；主要 Harness/模型运行迁至既有工作台，取消手机重复知识处理义务，保留本地采集和工作副本。

联网范围从旧模拟器禁止云端音频上传，改为本 Goal 可向明确配置的隔离灵犀服务传输合成采集，并调用既有授权 DSH/ASR/整理能力。真实私人资料、生产写入、公网部署、对外发送仍未授权。手机账户设备认证与声纹分开；明确授权的第三方资料允许作为来源素材，不默认归因 NJX。

本 CR 明确授权两仓库同一 Goal 的限定工程路径；这不是给予任何角色任意跨仓库修改权限。NJX 的 kbctl.py、真实知识库、既有技能框架规则和生产部署受保护。

## GOAL-KK-03 处置

GOAL-KK-03 与其 Milestone 同时标记 DISPOSITION=SUSPENDED_BY_OWNER_REBASELINE。该字段是管理处置，不冒充中央状态机的完成状态。Issue #30 保持 OPEN；GOAL_MILESTONE_CLOSED=NO；原 PR #32/#33/#34、旧合同、旧 terminal 原样保留。

旧 Engineering activation Issue #30 comment 5770169760 自本次正式 rebaseline activation 发布起撤销，禁止继续按旧合同扩张实现。未提交工作只能由其原 ED 保全并交接，不由 PM 提交源码。新 Goal 仅复用 GitHub 固定 preimage；任何其他在途分支须提出纳入请求，不自动摘取 dirty 内容。

旧 PX-KK03-01..03 继续作为未关闭历史发现，分别转为新合同的来源链、重复操作无副作用、当前/历史状态要求；只有新候选实证才能证明新实现满足，不能因此回写旧问题已通过。

## 治理锁对齐

本项目显式采用 Parent PM 0.4.0-alpha exact commit fc4872d9ba33325cf43a0778bb3ea01aea050c0f / tree 3acdba332db5cb58236a8abe87065846cf3ab8a0，包含 Human Owner Final Acceptance at 1.0 政策。是项目内固定版本采用，不合并中央 Draft PR、不宣称全生态已升级。ED 和 Reviewer authority 保持原锁定 SHA。

本次是产品含义变化，不能使用 governance-only preservation 例外。GOAL-KK-04 的 Engineering Ready、Admission、Review、Owner 全部从未开始；任何旧 PASS 不转移。

## 变更控制

仅冻结 GOAL-KK-04，其余 roadmap 项为 PLANNED_NOT_AUTHORIZED。实现路径、验收阈值、数据外传范围、正式设备/生产授权再变化，必须新 CR。旧暂停 Goal 的后续恢复或取消要独立治理记录，不能虚报完成。