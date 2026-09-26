# CR-KK-20260926-ANDROID-OFFLINE-APP

DATE=2026-09-26
ACTOR_ROLE=PRODUCT_GOVERNANCE
ACTOR_CONTEXT_ID=PG-KK04-ANDROID-OFFLINE-R2-20260926-3CFB7E80
DECISION=APPROVED_ON_EXPLICIT_OWNER_PRODUCT_DIRECTION
CANONICAL_ISSUE=knowme-knowledge#35
PARTICIPATION_ISSUE=njx-knowledge#6
GOAL_ID=GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
MILESTONE_ID=MILESTONE-GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
ONE_GOAL_EQUALS_ONE_MILESTONE=true

## Owner 最新决定

2026-09-26 Owner 明确同意将既有灵犀工作台移动化，但要求成为好用的手机 App，而不是仅展示远端网页；要求利用手机硬件进行语音转文字和本地存储、离线工作、恢复联网后与同一灵犀工作台打通；要求重新设计并交付 APK，且明确确认目标手机可以安装 APK。本记录是该产品方向的授权依据，不是对尚不存在的 APK 的 Owner Acceptance，也不是代替设备上的安装、麦克风或文件权限确认。

## 为什么是正式产品变更

之前 Issue #35 comment 5843172787 在当时无 Owner 明确变更决定的前提下维持 HAP 合同，是历史有效决定。新的 Owner 输入现在明确改变客户端载体、离线能力和验收对象；因此从本次精确 activation 生效时起，以本 CR 和 R2 合同取代旧路线的继续执行授权，不回写或删除旧裁决。

变更：HAP 原型验收对象改为 Android APK；手机从单纯采集终端升级为离线优先工作客户端；新增本机中文转写、离线编辑/检索工作副本、联网 Agent 工作面和可恢复同步；APK 安装、升级留存及目标手机硬件实测进入本轮。旧合同禁止真机安装和要求 canonical HAP 的条款不适用于 R2。

保持：同一灵犀工作台/DSH/NJX-Knowledge，工作台仍拥有正式知识版本和远程 Agent；不另建手机 Wiki/RAG/全功能 Harness；原始来源、用户修正、幂等、跨日、当前/历史状态及桌面回归保护继续有效。手机本地草稿及待同步修订是真实工作副本，不是另一个正式知识主库。

## Goal 处置

维持一个 Goal 与对应一个 Milestone，修订为 R2，不新开并行 Goal，不借重命名宣布 KK04 已完成。原因：仍交付同一个独立用户价值——手机可可靠工作并接入现有灵犀；本次是这个价值增量的 Owner rebaseline。GOAL-KK-03 既有暂停处置不变。

旧 App PR #37、Workbench PR #8 保持 OPEN/DRAFT/UNMERGED，保全为复用前镜像；不由 PG 提交或修复产品代码。旧修复及证据保留为历史参考，所有 PASS 不自动转移。新工程从本次精确治理提交创建新分支和新 Draft PR，不能继续旧授权悄悄改验收对象。

APP_SOURCE_PREIMAGE=655fc313be1e72504a4df3360a4ba4f3081a9394
APP_SOURCE_TREE=978924e9654f8706df7c28cbccb05d547cd70058
APP_SOURCE_PARENT=c0171d4fa5a988272afa76cabd42b4b6ddbaea8d
WORKBENCH_SOURCE_PREIMAGE=47d3dd2f173de851e16740a5ce5911a986cc2478
WORKBENCH_SOURCE_TREE=1a0bc0b5766b1e65a08c5f3e44e324e035c6d330
WORKBENCH_SOURCE_PARENT=a71118e5f803a1f7346aadc12338bd43f8ef8ce6

## 权限及安全变化

允许独立 ED 为本 Goal 在限定目录实现 Android 客户端、模型适配及兼容工作台接口，并在隔离环境生成私人测试签名 APK。允许受控目标手机测试，但设备接入和系统权限仍由 Owner 在本机给予；不得根据“APK 可安装”推断已经获得设备访问、录音、个人文件、通讯录、后台常驻或生产权限。未连接设备时不得假造真机证据。

开发仍只用合成资料、隔离数据根、测试凭证；不改生产服务、公网网关、真实知识库或对外发送策略。手机连接地址可配置，但不能固化密码、模型厂商密钥或临时隧道 URL；Owner 本机注入凭证。新增可选权限应在用户实际使用功能时申请，拒绝权限不得阻断无关文本功能。

无需 AGC/HAP 生产签名，不以企业级账户、多租户或上架流程阻塞私人 APK 核心价值。真实生产使用授权与最终 1.0 Owner Acceptance 仍为独立事项。

## 生效与失效

本 CR/基线/合同随精确治理提交冻结；最终 Issue #35 activation 必须绑定 App 与 Workbench 治理 SHA/tree/parent 和 PR 后才授权 fresh ED。其生效撤销旧 KK04 activation 的后续执行权限，但不抹除历史。

CONTRACT_CHANGE_INVALIDATES_OLD_ENGINEERING_HANDOFF=YES
OLD_CANDIDATE_PASS_TRANSFER=NO
ENGINEERING_READY=NO
APK_BUILT=NO
APK_DELIVERED=NO
PRODUCT_SOURCE_MUTATION_BY_PG=NONE
MERGE_RELEASE=NOT_AUTHORIZED
GOAL_MILESTONE_CLOSED=NO
