# 灵犀多端个人工作台 — 产品基线 v5

BASELINE_ID=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260926-v5-ACCOUNT-SHARED-KNOWLEDGE
STATUS=FROZEN_BY_PRODUCT_GOVERNANCE
APPROVED_CR=CR-KK-20260926-ACCOUNT-SHARED-KNOWLEDGE-AGENT
CANONICAL_ISSUE=knowme-knowledge#35
ACTIVE_CONTRACT=governance/milestones/GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE/CONTRACT-R3-ACCOUNT-AGENT.md
MASTER_PLAN=governance/designs/LINGXI_ACCOUNT_SHARED_KNOWLEDGE_MASTER_PLAN_20260926.md

## 产品承诺

同一账户、同一逻辑知识工作区，多端各自使用硬件和执行能力。第一阶段是 Mate60 Android APK + NJX 的 Mac mini 灵犀工作台；未来同一通用客户端连接其他人的账户/工作区/电脑。手机不是网页壳或单纯上传器；既有电脑工作台和 NJX-Knowledge 不重建。

账户证明主体与授权，workspace 标识知识归属，server 是执行和存储位置，device 是可撤销授权终端。新装未登录只显示壳/引导/合成演示，不可访问 NJX 私人内容。已授权离线在本机解锁后可继续工作；退出和账户切换隔离缓存、会话、原件、任务及凭据，未同步资料不误删不串传。初期单 Owner 加合成第二账户隔离验证，无公共注册/商业权限平台。

## 数据与执行

工作台保有正式知识版本/完整知识组织，手机有真实持久工作副本、授权 outbox、选择性下载及本地文本索引。共享逻辑知识不要求实时连线，也不允许两套互相矛盾的正式主库。原件、本机转写、用户修正、远端补充和正式结果分层。编辑带基准 revision，冲突保双方。

手机能力：麦克风/录音、本机中文转写、照片/文件/分享、本地编辑/检索、缓存管理、最小本地 Agent 编排。电脑能力：既有 DSH、全量授权知识、整理/索引、电脑工具。手机有网但 Mac 不可达时可直接调用用户授权模型 API，结合已同步知识及手机本地工具；完全离线不伪造云端推理。

DSH 优先复用但须验证 Android 运行条件；完整插件兼容不是预先事实。允许在保留最小手机 Agent 行为与可替换边界的前提下选择轻量运行时；不得不告知地改成仅远程 Agent。完整端侧 DSH/本地通用模型和商业电脑安装器属后续路线。

同一任务明确执行端及稳定身份；手机和电脑不能重复执行同一副作用。服务不可用排队/取消可见，结果已生成先回绑，不重复造主源。素材不是执行授权。任意 Shell、对外发送、删除/覆盖不因登录而自动授权。

## 用户体验

四入口：灵犀 / 记录 / 知识 / 我的。首页 Agent 协作和可达录入，遵循成熟工作台视觉语义但按小屏重排。展示账户/工作区、执行端、连接和知识新鲜度；默认可读正文，原始来源两步内可查。技术信息次级可看，不能掩盖错误或质量问题。

完全离线可冷开、录音、本机中文转写、编辑/持久保存、读搜指定下载资料。保留 R2 全部硬件、转写质量、同步与升级要求；失败保全原件不等于离线转写通过。用户主动后台/锁屏录音需按目标机实际验证，不承诺强停后仍运行。

## 安全与落地

数据安全按单用户/<10用户、私密录音/知识、已有公网入口和自动执行风险定级。凭据设备安全保存，不进 APK/Git/普通日志/知识同步。电脑凭据不发给手机。模型处理去向清楚，不能声称本地知识永不发送模型；只发送用户本次授权上下文。

先隔离合成验证，再通过现有认证入口只读实连 Owner 选择知识，写入先用专用测试工作区；生产更改与外发另外授权。不得用旧集成分支覆盖成熟工作台。其他用户未来部署独立服务，不默认连 NJX 服务器。

## 当前与未来门禁

当前同一 GOAL-KK-04 / Milestone 按 R3 冻结，不另起 Goal；旧合同、PR、PX FAIL、工程修复均保留而不继承 PASS。ED 只交 ENGINEERING_READY；PG 准入/转审；独立 Reviewer 实操；满足合同时同时关闭 Goal/Milestone。例行 pre-1.0 无 Owner 回归，最终 1.0 Owner Acceptance 保留；私测 APK 不等于公开发布/生产部署。

当前方案是要求，APK_BUILT=NO。v4@916e40b93ed702414639fb341246e5533ebad1e7 和 v3@be400447c1d68062d22ae5e9ea0d169d929514df 均按原 SHA 保留。后续电脑安装器、NAS/托管、完整插件生态另以独立价值冻结，不自动进入本轮。
