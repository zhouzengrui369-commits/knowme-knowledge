# CR-KK-20260926-ACCOUNT-SHARED-KNOWLEDGE-AGENT

ROLE=PRODUCT_GOVERNANCE
ACTOR_CONTEXT_ID=PG-KK04-R3-ACCOUNT-AGENT-20260926-A9DFC906
DATE=2026-09-26
DECISION=APPROVED_ON_EXPLICIT_OWNER_DIRECTION
GOAL_ID=GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
MILESTONE_ID=MILESTONE-GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
ONE_GOAL_EQUALS_ONE_MILESTONE=true
CANONICAL_ISSUE=knowme-knowledge#35
PARTICIPATION_ISSUE=njx-knowledge#6

## Owner 授权

Owner 在本轮明确同意：每人安装自己的灵犀手机 App 和电脑 App，账户区分知识底座；先将完整方案提交 knowme-knowledge，并推进 Android APK 连接自己的灵犀工作台运行。前序补充明确手机/电脑共享同一知识库，但客户端能力可独立，手机可在硬件允许时运行 DSH/Agent 并调用模型 API，依赖电脑的工具由个人服务器提供。

这是产品方向授权，不是尚不存在的 APK 的体验通过、Owner Acceptance 或无边界生产授权。产品设计方案在 governance/designs/LINGXI_ACCOUNT_SHARED_KNOWLEDGE_MASTER_PLAN_20260926.md。

## 与当前正式 R2 的差异

CURRENT_R2_COMMIT=916e40b93ed702414639fb341246e5533ebad1e7
CURRENT_R2_TREE=5eb837f690ed6c851f3d3d85bdcf5b6679614fe0
CURRENT_R2_CONTRACT_BLOB=601e3b02ba277cf0fec0da03f442d395536faf16
CURRENT_R2_ACTIVATION=Issue_35_comment_5843318495

变更：增加账户/工作区/服务器分离、未登录私人数据不可见、账户切换与缓存隔离；允许手机最小 Agent 运行时和用户自行配置的模型 API 凭据；增加 Mac 不可达时手机独立有网 Agent、工具执行端发现和远端受限调用；增加统一任务归属与结果回绑；将“连接 Owner NJX 底座”分为隔离验证、授权只读实连与正式写入权限边界。

保留：Android APK、Mate60 现有系统、本机中文离线转写和 R2 CER≤20% 合成实测目标、离线编辑和知识副本、原生附件、后台/锁屏录音、1s/10s/5s 受控反馈要求、原始来源/修正/版本冲突、幂等、双端操作及独立审核。不开第二套正式知识库，不重写电脑 DSH/知识引擎，不变成网页壳。

明确取消 R2 的后续工程限制：harness_location=workbench_only、手机不得持有任何自配 Provider 凭据、手机全部 Agent 任务必须由电脑执行。增加的手机凭据只允许设备安全配置，不能下发电脑秘密。

## Goal / Milestone 处置

继续同一 KK04 与对应 Milestone，合同修订 R3-ACCOUNT-AGENT；不增加并行 Goal，不用 rebaseline 把旧 FAIL 变成完成。理由：仍在交付同一尚未完成的独立价值“手机可靠使用灵犀工作台”；账户与独立端能力是 Owner 对该增量的正式补充。

R3 activation 生效后，R2 activation 5843318495 及更早 R1/HAP 后续执行授权被取代；历史原文不变。R2 PR #40、Workbench PR #9 及旧 #37/#8/#38 保留 OPEN/DRAFT/UNMERGED，不自动关闭或合并。GOAL-KK-03 暂停状态不变。

所有旧候选的 Engineering/Admission/PX 不向 R3 迁移。当前没有 R3 产品候选、APK 或运行中的新 ED 的证明。

## 精确继承与权限

APP_GOVERNANCE_PARENT=916e40b93ed702414639fb341246e5533ebad1e7
APP_PARENT_TREE=5eb837f690ed6c851f3d3d85bdcf5b6679614fe0
WORKBENCH_GOVERNANCE_PARENT=043aaefbe2245b77c330f8bc0895437db9510494
WORKBENCH_PARENT_TREE=9089689d31187326a5a08b3865d5a6c6d9168c69
MATURE_WORKBENCH_READONLY_REFERENCE=e1df8fd2c47b53cd6057fbbbafa54f72df6fbe83

工程只在 R3 合同及工作台 R3 参与授权范围内新增/兼容适配。不得因账户功能扩张全仓、修改生产网关或拷贝真实私人资料进 Git。两个合成账户用于隔离测试，不建设企业多租户平台。

Owner 要求连接 NJX-Knowledge 的意图记录为受限集成方向：通过现有认证接口对其明确选择内容只读验证，写入先用专用测试工作区；生产写入、服务替换、公网更改、第三方发送另需精确授权。不得以“待生产授权”为由停止可以在隔离环境完成的工程，但未实际连接不能宣称“已连接 Owner 底座”。

## 冻结与生效

本 CR、v5 基线、R3 合同/ED 合同和完整方案随精确提交冻结。App 提交后，Workbench 另提交参与授权；最终 Issue #35 activation 原子绑定双 SHA/tree/parent/PR、合同 blob 和 ED 权威才开始 fresh ED。未绑定不得开工。

CONTRACT_CHANGE_INVALIDATES_R2_HANDOFF=YES
OLD_PASS_TRANSFER=NO
PRODUCT_SOURCE_MUTATION_BY_PG=NONE
NEW_GOAL_CREATED=NO
APK_BUILT=NO
MERGE_RELEASE_PRODUCTION=NOT_AUTHORIZED
GOAL_MILESTONE_CLOSED=NO
