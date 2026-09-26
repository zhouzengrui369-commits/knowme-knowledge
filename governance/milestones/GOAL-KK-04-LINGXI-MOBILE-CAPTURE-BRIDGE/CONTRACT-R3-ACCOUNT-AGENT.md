# GOAL-KK-04 R3 — 账户化灵犀移动工作台与 APK 交付冻结合同

PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
GOAL_ID=GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
MILESTONE_ID=MILESTONE-GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
ONE_GOAL_EQUALS_ONE_MILESTONE=true
CONTRACT_REVISION=R3-ACCOUNT-AGENT
STATUS=FROZEN_PENDING_EXACT_PAIR_ACTIVATION
VERSION_HORIZON=PRE_1_0
CANONICAL_ISSUE=knowme-knowledge#35
PARTICIPATION_ISSUE=njx-knowledge#6
BASELINE_ID=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260926-v5-ACCOUNT-SHARED-KNOWLEDGE
APPROVED_CR=CR-KK-20260926-ACCOUNT-SHARED-KNOWLEDGE-AGENT

## 1. 唯一交付目标

交付在 Owner 现有 Mate60 实际可安装的签名 Android APK，登录 NJX 私人工作区后使用本地硬件和离线工作能力，联网同步同一 NJX-Knowledge，并在手机端与 Mac 端各执行适合的 Agent/工具；没有账户授权不能使用 NJX 数据。

不是网页壳、不是 APK 文件生成即完成、不是重建电脑知识库。账户化不能删去已批准的离线转写、原生附件、可靠同步和结果可读性。未来其他用户自建电脑 App 在本轮记录架构，不开发公共 SaaS 或商业安装器。

## 2. 精确继承和取代关系

前序 R2 完整合同位于 knowme-knowledge@916e40b93ed702414639fb341246e5533ebad1e7:governance/milestones/GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE/CONTRACT-R2-ANDROID-OFFLINE.md，blob 601e3b02ba277cf0fec0da03f442d395536faf16。R2 §2–5 的界面/硬件/数据行为和 J01–J17、受控性能与 CER 定义是本 R3 的冻结附录，须完整读取，不是可选背景。

明确修改：R2“执行都在工作台、手机不运行 Harness”的限制由本合同手机 Agent 条款取代；R2 初始未登录私人记录行为以本合同账户保护条款为准；R2 工程路径、隐私实连边界、开工与精确身份由本 R3 §7–10 取代。其他未修改要求原样保留；不允许利用继承关系弱化任何旅程。出现真实冲突必须停止并由 PG 解决。

从本轮最终 activation 起撤销 R2 5843318495 的后续执行授权，不改历史。旧 Goal03 保持暂停。不是新 Goal，亦不把 KK04 关闭再重开。

## 3. 账户与统一知识行为

账户、workspace、server、device 独立标识；服务端校验所属与授权，不能只靠客户端传入 workspace_id 或显示名。服务器可配置且不能硬编码 NJX 地址/密钥；第一阶段复用现有服务，必要时在隔离适配层补足真实鉴权。

首次未授权：壳/引导/明确合成演示，不显示私人知识/会话/上个用户缩略图，不获得 remote tools。已授权离线：本机解锁后访问账户所有的下载副本及草稿，网络凭证状态与离线可用性分开。退出/切换：账户私有缓存、数据、任务和模型凭据隔离；有未同步资料须先明确保留/同步/导出选择，绝不串传或静默清理。

记录/修订/附件/任务均带工作区归属及稳定 ID。服务端正式知识为权威，手机工作副本保留基准版本；冲突保全双方。手机/桌面共享同任务和正式成果，不要求同步运行时堆栈。传输成功、可靠接收、整理完成、索引更新、发送完成分别表达。

## 4. 手机 Agent 与工具路由

本轮最小手机 Agent 必须实际在 Android 客户端编排一次多步任务：调用用户配置的模型 API，调用至少一个实际手机本地工具（例如本地已下载知识检索或创建草稿），返回带本地知识范围/时间的结果；Mac 关闭/不可达时仍须可复现。仅转发到 Mac 执行不算本条通过。

完整 DSH 移植为优先可行性选项而非未经验证的强制技术路线。ED 必须读实际 DSH/相关候选源码许可及 Android 运行约束并给复用矩阵；可以选择满足上述行为的可替换轻量运行时，但必须披露不具备完整 DSH 插件等价，不得悄悄取消手机 Agent。离线通用大模型推理不在本轮；离线转写仍必须在设备上完成。

远端调用至少打通受限的知识检索和整理/结果查询，分别标注执行端。工具授权由 server enforcement 实施：手机没有工具不等于失败，可委派已授权电脑；电脑离线时排队/取消明确；不能无授权暴露任意 Shell/目录。远端模型密钥不下发手机；手机自配模型密钥不进普通存储/同步/日志/Git。

## 5. 全部必验旅程

R2 J01–J17 继续全部必验，以新的 exact pair/APK/账户语义重新运行，不沿用旧 HAP 或旧 APK 截图。下表为 R3 索引和新增要求，详细原生/离线条款仍以冻结附录为准。

| ID | 必验结果 |
|---|---|
| J01 接入/撤销 | 安装 APK、账户登录/配对与工作区绑定、查看设备；撤销后 server 拒绝请求；状态真实 |
| J02 在线文本 | 本地保存→显式交给灵犀→可靠接收→真实整理→同 note/revision 双端可读 |
| J03 真实语音 | Mate60 实际录音≥30秒和独立≥5分钟；原音可听/hash一致、本机转写可编辑、真实整理及工作台ASR恢复，不用导入替代麦克风 |
| J04 离线冷开 | 已授权账户飞行模式冷开/重启、记录编辑原件和 outbox 持久，草稿不误提交 |
| J05 故障恢复 | 断传/ACK丢失/服务或插件停启恢复；已有产物先回绑，不能多造正式结果/第二主源 |
| J06 幂等/对象 | 动态列表同条连点≥3不作用错对象；同名同分钟不同ID独立，重复请求不重复效果 |
| J07 跨日/时区 | 真实一致的合成元数据保留捕获/接收/处理时间和原时区，不更改系统时间或重写历史 |
| J08 来源/修订 | 九点→十点→十一点各层保留；双端两次导航内回源，卡片/标题/时间/note映射真实 |
| J09 当前状态 | 失败恢复/冷启动/面板保持打开时状态及时，旧连接/能力/修订不冒充当前 |
| J10 权限/隔离 | 拒权、认证到期/撤销、含指令素材、清缓存；无跨账户/越权/假外发，文字路径不被无关权限卡住 |
| J11 桌面兼容 | 真实工作台 UI 新增/检索/预览/对话不退化，手机不依赖桌面当前会话/窗口 |
| J12 首次使用 | 新装未登录引导清楚；绑定后不用工程说明完成记录到结果；默认正文可读、主要按钮不截断 |
| J13 本机中文ASR | 保留R2：资源预置、飞行模式冷开、10段合成内容真实普通话录音总长≥5分钟、固定参照总CER≤20%；无远端识别 |
| J14 离线知识/冲突 | 指定下载、离线读搜编辑；标范围/时间；两端冲突保双方、原件不被清缓存删除 |
| J15 会话任务 | 手机在线可问/看真实结果，离线问题经确认排队；执行端、取消和结果状态清晰 |
| J16 安装升级锁屏 | 实际签名 APK 安装/更新不卸载丢数据；5分钟录音含后台/锁屏；被终止诚实报停保片段 |
| J17 原生附件 | 相机、选定文件、系统分享各一次，离线保原件再同步；取消/拒权不误提交，不伪称已解析 |
| J18 账户边界 | 合成A/B工作区以及NJX授权配置：未登录/错误凭据/越权workspace拒绝，A切B不出现A知识、会话、缩略图、凭据和outbox |
| J19 三态运行 | 完全离线、手机有网Mac离线、两端在线逐一切换；能力位置/知识新鲜度如实，离线解锁与网络登录分开 |
| J20 手机Agent | Mac不可达时，手机实际调用已授权模型API与至少一个本地工具完成任务；显示执行端，记录真实调用和可取消路径 |
| J21 远端工具与同任务 | 同一账户手机发起Mac知识检索/整理；server限权；断线重试不重复副作用；Mac恢复后同一task/result可在两端继续 |
| J22 退出/丢机/恢复 | 未同步资料退出不误删，账户切换不串传；设备撤销后重连被拒；离线缓存边界明确，无瞬时擦除虚假承诺 |
| J23 Owner底座连接 | 在现有认证入口和本机受限授权下，读取Owner明确选择的NJX资料，手机结果可回源；写入仅专用测试工作区；隔离通过不冒充实连完成 |

保留受控性能：操作≤1秒明确反馈；前台网络/服务/授权就绪后≤10秒启动同步；server完成后前台≤5秒更新。J13的CER规范化和参照必须事前固定，不事后删除失败样本；质量警告是正确恢复而非ASR达标。手机Agent记录冷/热启动耗时、峰值内存和请求流量，结果如实，不预设未验证的芯片性能数值。

七项 PX-KK04-01..07 的原报告 PR #38@3b2ec6fc948cb4b19a8febd2e2228b0b1f0a5591 仍是必要行为保护：状态真、连点不错对象、来源不混、低质录音有恢复、未发不报已发、结果可读、恢复回绑已有产物。旧 finding 不能由 ED 宣布独立体验关闭。

## 6. 第一阶段范围与后续

当前包含单真实Owner、多授权设备及第二合成账户隔离验证；不是多人共享同一NJX库。初期电脑端使用现有 Mac mini 工作台/服务接口，不新开发通用跨平台桌面安装器。未来“每人自己的手机App+电脑App+知识底座”由完整方案保留，不自动授权商业多用户部署。

完整DSH插件等价、本地通用语言模型、全量离线镜像、企业账户、收费、NAS/云托管、应用商店发布为后续。不得以未来范围为名移走当前手机Agent、本地转写或账户隔离必交项。

## 7. 允许路径与运行边界

App ED可写：apps/lingxi-mobile-android/**；reports/integration/goal-kk-04-r3-account-agent/**。App子目录内包含所选框架、原生模块、模型适配、测试、构建和依赖；具体语言/框架由ED选择。旧HAP原型、旧报告只读参考，不继续修改。

Workbench ED可写：lingxi/plugins/mobile_capture_bridge/**；lingxi/server/mobile_capture_bridge/**；lingxi/scripts/mobile_capture_bridge/**；tests/mobile_capture_bridge/**；reports/integration/goal-kk-04-r3-account-agent/**。在其中实现有边界的账户/工作区/任务/知识工作副本适配，避免通用身份平台。仅兼容挂载、会话/结果返回路由和隔离配置可最小修改 lingxi/server/lingxi_server.py、lingxi/server/dsh_acp_client.py、lingxi/server/lingxi_bot.py、lingxi/server/lingxi_ai.py；不得重写桌面接口合同。

App 可只读参考成熟工作台 e1df8fd2c47b53cd6057fbbbafa54f72df6fbe83 的 lingxi 前端/服务/已提交文档并有血统地复用到 App 允许目录；不得批量复制该commit中的私人知识。工作台当前部署身份由本机验证，不把 main 快照当已验证运行版本。超出路径、需要重新绑定后端base或修改桌面源/生产网关必须报告准确差异并由PG处理。

禁止 ED 改 AGENTS、governance、PROJECT_STATUS、.github、kbctl.py、既有skills/**、lingxi/vendor/**、生产public_gateway/public_access脚本、已有私人raw/knowledge/wiki/state/secrets、旧证据和其他产品。不得把整个旧工程分支部署覆盖生产。

允许本轮签名 APK 的受控目标机安装与测试；系统安装/麦克风/文件/后台权限由本机授权，不再要求 HAP/AGC。测试先合成隔离，external_send=disabled。Owner 已要求连接自己的底座，可在本机对其明确选择的内容通过已有认证接口做只读实际连接；生产服务替换、网关路由、正式NJX写入/迁移、第三方发送仍需绑定exact candidate和目标的单独授权。凭据只由本机安全注入。无法实连时J23=BLOCKED，不能伪造；不阻止其他隔离实现继续。

## 8. 证据归属

engineering_required：技术方案/复用与模型许可、目标机能力/本机ASR、账户隔离、三态运行/手机Agent/远端工具/同任务、J01-J23及性能/故障/隐私实证、与成熟工作台兼容和J23受限实连、签名APK安装升级、完整集成Manifest/Technical Receipt；包括fresh LE和ED本人各自final同候选实际操作截图及目验。

admission_required：PG核对双repo SHA/tree/parent/branch/PR、合同/CR、APK/模型/运行时/配置身份、证据覆盖和角色分离；不代ED跑技术测试。

review_required：可操作环境、可取回exact APK/资源、实际独立reviewer声明、精确referral、干净首次进入路径和隐私范围；不能PM预造Reviewer context已存在。

product_experience：独立code-blind Reviewer亲自操作新APK全体验，账户/离线/Agent/知识/工具/恢复及旧七项，生成自己的证据和PASS/FAIL/BLOCKED。

human_owner：设备和敏感权限及正式生产操作授权；本pre-1.0不安排Owner例行回归，不要求用Owner声音当数据集。最终1.0明确Owner Acceptance保留。

## 9. 冻结候选和 APK 交付

最终候选原子身份=App SHA/tree/parent/PR + Workbench SHA/tree/parent/PR + 单一签名APK SHA256 + 手机ASR资源/Agent运行时/依赖hash + server DSH/ASR/organizer + Provider/model/协议/脱敏行为配置hash + tested service identity + exact baseline/CR/contract。

同一 APK 字节由 LE 与 ED 安装前校验，不能两次不同构建冒充同一包。提供真实可取回的私有APK产物及文件名/大小/包名/versionName/versionCode/minSdk/targetSdk/ABI/签名证书指纹/安装升级说明；私钥由Owner机器保管，不进Git。源码链接和BUILD PASS不是APK交付。

工作流使用独立evidence transport避免自指SHA；模型、行为配置、产品tree或APK变动使final双实操失效，必须重新冻结/重跑。旧回执仅追加说明不改写。

## 10. 开工和关闭

本合同与同目录 ENGINEERING_EXECUTION_CONTRACT-R3.md 配套。精确App治理提交和Workbench参与提交必须由Issue#35最终activation绑定，fresh ED才可开工。PG沿用fc4872d9ba33325cf43a0778bb3ea01aea050c0f/tree3acdba332db5cb58236a8abe87065846cf3ab8a0；ED沿用8bcf9da58d6147fcd2345a4b465f17f7a27850fd/tree593bacfee4910a55b9b6c7bd2f2ca56b8761d134；reviewer沿用4253deb55a04de20fca6ac50a47b42a6d4489c04，实际独立性仍须验证。

建议新工程分支 engineering/goal-kk-04-r3-account-agent，分别以R3治理分支为Draft PR base；不复用此前工程/PG/PX运行上下文。Assigned handoff ID不证明运行上下文或子代理已启动。

全部engineering_required完成且已知合同内必修缺陷为零，才能ENGINEERING_READY；然后PG准入→review eligibility/referral→独立完整PX→合同全部门禁满足后Goal和Milestone同步关闭。MERGE/RELEASE/正式PRODUCTION不自动授权。未满足只返回规范NOT_READY/BLOCKED并逐项列缺口；不能先交产品验收再验证。
