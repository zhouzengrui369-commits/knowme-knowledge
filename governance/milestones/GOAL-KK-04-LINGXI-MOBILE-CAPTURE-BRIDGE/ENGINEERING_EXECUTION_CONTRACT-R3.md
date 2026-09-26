# GOAL-KK-04 R3 — 独立 Engineering Delivery 执行合同

ROLE=INDEPENDENT_ENGINEERING_DELIVERY
GOAL_ID=GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
MILESTONE_ID=MILESTONE-GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
ONE_GOAL_EQUALS_ONE_MILESTONE=true
PRODUCT_CONTRACT=CONTRACT-R3-ACCOUNT-AGENT.md
ASSIGNED_HANDOFF_ID=ED-KK04-R3-ACCOUNT-AGENT-20260926-A9DFC906
ACTUAL_CONTEXT_ID=REQUIRED_FROM_RUNTIME_AT_START
PREVIOUS_ED_PG_PX_CONTEXT_REUSE=FORBIDDEN
START_AUTHORITY=ISSUE_35_FINAL_EXACT_R3_ACTIVATION

## 1. 唯一目标与角色

以冻结R3产品合同及其exact R2附录为唯一产品目标，交付可安装、可离线、按账户共享知识并支持本端/远端能力的APK。不是仅完成界面、打包、测试绿灯或修旧七项问题。ED对全部合同内实现负责，主动发现并修复新缺陷；不能把仍未实现的当前要求塞入未来工作。

ED自行决定框架、架构、技术测试和工具实现；PG只给产品行为及授权范围。变更产品价值/范围/验收/安全/权限/关闭或越界路径先CR。不借账号功能推倒成熟工作台，不用旧静态Demo当真实资料。

## 2. 开工必读与基础盘点

依序读两repo AGENTS、exact治理锁和中央PG/ED skill、v5基线、批准CR、完整方案、R3合同及R2附录、Workbench R3参与授权、Issue#35/#6最新状态、PR#38七项问题与历史修复、最新PR/branch/SHA/tree。R2授权已被R3替代，不能混用前镜像。

开工回执保存真实context标识，工具没有run ID则如实NOT_EXPOSED，不自造独立性事实。实际读取硬件/OS/API/ABI/可用存储、中文识别资源、后台权限、模型与DSH运行条件；Owner已确认APK可安装，不再重复泛问。

盘点成熟工作台实际部署commit/配置/接口与只读参考e1df8fd2c47b53cd6057fbbbafa54f72df6fbe83的关系。现有生产不切换到旧集成分支；在允许适配层实现兼容，真实需要改base或越界先回报准确文件和影响。

## 3. 同一Goal的实施顺序

1. 提交实施方案、UI血统/能力复用矩阵、账户/工作区/同步/任务协议及端侧运行时评估；给首屏、账户绑定、录音、知识来源、三态状态的交互截图。只是工程内部阶段，不另立Goal。
2. 先做隔离账户绑定后飞行模式冷开→真实录音→本机中文转写→编辑→杀进程重开仍在，验证真实硬件与存储。
3. 打通账户隔离、工作副本同步、原始版本/冲突和结果回绑；以两个合成账户验证不串数据。
4. Mac不可达时手机Agent调用已授权模型API和本地工具；再打通受限Mac工具与同任务续接。完整DSH不可行时诚实选择合同允许的最小本端运行时，不退为网页代理。
5. 原生附件、安装升级、后台录音、性能、UI完整性和现有桌面回归；最后按J23权限实连Owner选择知识。
6. 冻结最终pair/单一APK/模型/配置；fresh LE及ED本人最终全旅程实操；完成证据和GitHub交付。

## 4. 缺陷循环与旧PX保护

实现→技术测试→构建→隔离部署→真实点击/录音/编辑/同步/工具操作→发现问题→复现和根因→修复→回归→新候选冻结。不得拿数据行/HTTP 200/模型自述替代UI结果。

PX-KK04-01状态滞后；02连点错对象；03标题/日期/来源错配；04低质录音普通完成；05虚假发送；06结果格式和首屏；07已有结果未回绑及重复来源，全部建行为映射与新APK实操证据。既有16/16或任何旧PASS都不继承。

任何同合同新缺陷（账号串缓存、重复任务、私有资料外送、手机锁屏丢原件等）都归ED修复。环境因素与产品可见行为分开记录，环境困难不准弱化合同。

## 5. fresh Local Executor 必须真实派出

ED实际派一个fresh observation-only子代理，委托记录真实parent/child/run身份与最终exact pair/APK/模型/配置。不能用ED自己改名或重复引用旧LE回执。

LE在Owner Mac授权隔离目录fresh materialize两repo，核对SHA/tree/parent/clean，核对同一canonical APK hash，独立安装并启动目标Mate60及隔离Workbench。准备合成A/B账户/测试workspace、独立data root/端口/session/凭据。不改生产和原账户资料，不接收明文凭据到聊天。

LE亲自操作J01-J23全部适用步骤、七项PX回归、1s/10s/5s与离线CER证据，包括三种网络状态、Mac离线的手机Agent、真实原生麦克风、账户切换/撤销、冲突和结果回绑。J23受限实际底座连接由已授权执行体执行并脱敏；无相应授权则记录BLOCKED，不伪造或泛化读权限。

每条记录ENTRY/ACTION/EXPECTED/ACTUAL/EXIT/TIMESTAMP/ACCOUNT_ALIAS/WORKSPACE_ALIAS/DEVICE/SCREENSHOT_REFS/对象ID；返回操作前→关键动作→操作后真实截图，连点与计时提供短录屏/时间线。跨端场景同时有手机和Workbench页面。API/数据库只作辅助交叉核对。

LE不得改源码/测试/行为配置、commit/push、自修、放宽阈值或宣布ENGINEERING_READY/PX。发现问题返回ED。

## 6. ED本人必须同候选再次实操

LE完成后，ED本人重新安装/核对同一APK字节和pair/模型/配置，在独立合成数据与自己操作序列上重走核心旅程，并覆盖全部新增J18-J23、七项PX、实时语音/离线转写/锁屏/故障/冲突/任务/性能。LE不能替ED，ED也不能代LE关闭其缺项。

ED生成独立shots/ed-personal，与shots/local-executor分开。ED必须实际打开两套关键图/视频，记录可见内容、预期/实际状态和异常；文件名/hash/尺寸检查不等于目验。不能把工程自验宣布为独立产品体验PASS。

若任一产品SHA/tree、APK、模型/协议或影响行为配置改变，旧final操作失效；重新冻结并重新完整LE和ED最终套件。仅证据transport追加且候选不变无需制造产品commit，历史原文不可改写。

## 7. 交付证据包

目录 reports/integration/goal-kk-04-r3-account-agent/，使用独立evidence分支。至少：CANDIDATE_MANIFEST、TECHNICAL_RECEIPT、IMPLEMENTATION_PLAN、CAPABILITY_REUSE_MATRIX、UI_TRACEABILITY_MATRIX、INTERFACE_CONTRACT、OLD_PX_BEHAVIOR_MAPPING、ACCOUNT_WORKSPACE_ISOLATION_RECEIPT、THREE_MODE_OPERATION_RECEIPT、MOBILE_AGENT_RUNTIME_RECEIPT、REMOTE_TOOL_TASK_RECEIPT、OFFLINE_ASR_RECEIPT、SYNC_CONFLICT_RECEIPT、PROVENANCE_RECOVERY_RECEIPT、APK_DELIVERY_RECEIPT、CANONICAL_ARTIFACT_RECEIPT、WORKBENCH_COMPATIBILITY_RECEIPT、OWNER_KNOWLEDGE_CONNECTION_RECEIPT、PERFORMANCE_RECEIPT、ALLOWED_PATH_DIFF_RECEIPT、RUNTIME_PRIVACY_RECEIPT、DEFECT_CYCLE、LOCAL_EXECUTION_REQUEST/RECEIPT、ED_PERSONAL_OPERATION_RECEIPT、VISUAL_INSPECTION_RECEIPT、SCREENSHOT_INDEX、RUNTIME_RUNBOOK、PARENT_PM_HANDOVER_PROMPT及两套截图。

每条实证绑定来源候选、APK hash、运行时/资源、账户/工作区别名、对象ID、时间和证据路径。未验证项标NOT_RUN/BLOCKED而非勾全表；照片/音频样本使用合成内容，真实NJX原文、截图和token不进GitHub。

## 8. 原子候选与APK

两端各新工程分支/新Draft PR；CANDIDATE_SHA=BRANCH_HEAD=PR_HEAD，clean且前向血统成立。提供同一签名APK实际下载/取回位置和安装升级说明，包含包名、版本、SDK/ABI、大小、SHA256、证书指纹；不提交私钥，不交旧HAP或网页URL冒充APK。

Manifest完整绑定两个候选、合同/CR/基线、canonical APK、本机ASR与Agent版本/资源hash、工作台DSH/ASR/organizer、实际服务兼容身份、协议/脱敏配置。全套最终操作只针对此对象。UI设计和原型截图只是过程资料，不能替代目标机最终截图。

## 9. Ready和阻塞

全部engineering_required、J01-J23、旧七项保护、本地转写质量/性能、真实账号隔离和手机Agent/远端工具已验证；无已知必修问题；LE与ED两套同候选证据完整并目验；APK可取回；PR与Manifest一致且无越界，才允许ENGINEERING_READY。

否则只返回ENGINEERING_NOT_READY、BLOCKED_EXTERNAL_AUTHORITY、BLOCKED_CHANGE_REQUEST_REQUIRED或BLOCKED_IDENTITY_DRIFT，给FIRST_BLOCKER、负责角色、实际尝试、恢复条件及仍未完成项。若仅J23的Owner访问/生产权限缺失，允许继续完成隔离工程但不能声称全合同Ready。无需Owner替代例行测试；只在确实要权限/产品取舍时请求最小动作。

## 10. GitHub terminal与四段交接

真正commit/push产品及独立证据，不停在本机路径。Issue#35发一次原子terminal，njx-knowledge#6引用，不新造Goal/Milestone。按顺序提供：
A 完成什么：账户、手机、服务、每条旅程、复用和新缺陷修复；
B 证据在哪：exact commit/tree/path、双PR/候选、APK可取回地址/hash、模型配置、LE/ED真实身份与截图；
C 为什么Ready/为什么卡：门槛映射或FIRST_BLOCKER/责任/尝试/恢复条件；
D 哪些未完成：CONTRACT_REQUIRED_NOT_COMPLETE与OUT_OF_SCOPE_FUTURE_WORK严格分开。

最高仅ENGINEERING_READY；不得声明Admission/PX/Owner/Merge/Release/Goal通过。合法Ready后NEXT_AUTHORIZED_GATE=PRODUCT_GOVERNANCE_CANDIDATE_ADMISSION并STOPPED=YES。上下文临近满时先提交GitHub进度和未完成清单，不让工作只存在聊天中。
