# GOAL-KK-04 — Engineering Delivery 执行合同 R1

ROLE=INDEPENDENT_ENGINEERING_DELIVERY
GOAL_ID=GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
MILESTONE_ID=MILESTONE-GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
ONE_GOAL_EQUALS_ONE_MILESTONE=true
CANONICAL_ISSUE=knowme-knowledge#35

## 1. 接管条件与权威

新 ED 必须使用独立对话，不得复用 PM/PX/此前 ED；在开工回执中记录实际唯一 context ID。原本暂停的 KK03 不得混入此任务。

工程开工仅由 Issue #35 最终 PG activation 授权。activation 必须同时包含本合同提交/tree/blob、App 治理 preimage SHA/tree/parent、NJX 参与授权治理 preimage SHA/tree/parent、两条新 engineering branch、实际 ED Skill 版本。字段不全或状态更新冲突则 STOP，不拿聊天摘要开工。

先读两仓库 AGENTS，App 新 governance lock/中央 PM 与状态机、ED Skill、baseline v3、CR、roadmap、KK04 CONTRACT、本执行合同、NJX 参与授权、最新 Issue #35/#30、旧 PX#33、exact 双树及 live PR。读取 njx 的工作区角色说明不代表当前 ED 可改任意文件；本跨仓库合同允许路径与 AGENTS 安全禁区共同约束，紧者优先。

ED Skill 固定：chatgpt-engineering-delivery@8bcf9da58d6147fcd2345a4b465f17f7a27850fd / tree 593bacfee4910a55b9b6c7bd2f2ca56b8761d134，core/ENGINEERING_DELIVERY_SKILL.md。须 fresh 核验。

## 2. 唯一任务

以冻结 KK04 Product Contract 为唯一目标，实现手机采集设备接入灵犀工作台的完整真实增量。不得仅把现有 App 多加一个地址框；不得移植第二个 DSH、重新造知识整理器或用 WebView 代替原生可靠采集。

三项旧问题不是全部 scope：来源分层、重复操作无系统跳转、历史状态不冒充当前，是本合同回归保护。主动发现并修复同合同内的任何实现缺陷。发现需要改产品价值、核心旅程、数据边界、验收或路径时提交 CR，不能擅自弱化。

## 3. 技术设计和能力复用

先形成 IMPLEMENTATION_PLAN.md、CAPABILITY_REUSE_MATRIX.md、INTERFACE_CONTRACT（可用 OpenAPI/JSON Schema，但不能把 schema 当产品完成）。记录实际工作台拓扑、服务/模型/DSH/skill 版本和源码来源。当前腾讯云部署声明不是接口实测，确认隔离运行依赖，不依赖生产在线状态。

优先工作台插件接收层调用现有转写与整理；保证数据先可靠接收，再处理。支持实际插件 enable/disable/状态，验证停用后无新错误处理且再启用能恢复队列。若当前 DSH 无需源码升级即可扩展，用其真实扩展点；不可伪造 API。需要改 vendor 或新下载框架时提交技术依赖范围 CR，不让 PM 帮写代码。

先把主链文本与真实音频打通，再做离线/恢复/跨日/幂等；所有内容仍是一项完整交付，不按工作包分别宣布 Ready。

## 4. 隔离部署规则

在 Owner Mac 上新建专用集成 worktree 与数据目录，或使用已有明确授权的隔离目录；不碰生产 njx-knowledge 资料、8787 活服务、公网网关、LaunchAgent、腾讯云、真实用户会话。

配置独立 KB_ROOT/ASR 临时目录/DSH session/任务存储。只用合成测试数据，先验证整理器/Agent 不会越出隔离根和触发默认企业微信发送。可复用已有模型字节/本机凭证，但敏感凭证只能由获授权执行体从 Owner 机器安全注入，不打印、不提交。未获得凭证则说明依赖缺口，不使用假结果冒充完成。

## 5. 缺陷循环

实现→技术测试→构建→本机部署→实际点按/录音/提交/查看→发现问题→根因→修复→回归→重新构建部署。不能只看测试绿灯。

覆盖权限拒绝、离线保存、长录音、上传中断、服务器响应丢失、服务重启、插件停启、重复提交、同名不同采集、跨日/跨时区、纠正版本、断线状态补回、错误恢复、键盘/滚动/误触、旧状态残留、原始资产与正式结果关联。

如发现当前范围内缺陷，ED 有责主动修复；如无法修复则 ENGINEERING_NOT_READY，不能改成 future work 或要求 Owner 再试。

## 6. 强制派 Local Executor 子代理

ED 必须实际启动独立的 observation-only 子代理，记录工具支持的真实 parent/child context/run ID。模板名称不是独立执行证明；没有子代理/真实产品控制能力时如实 BLOCKED，不能由 ED 改名扮演 LE。

LE 在固定 final App+Workbench exact SHA 集合上 fresh materialize 两仓库，核对 tree/clean，准备允许的模型与依赖，构建、记录哈希、本机安装 App 到已声明模拟器并启动隔离工作台/插件。

LE 亲自使用 hdc/浏览器/设备控制工具操作 J01–J12。必须向 ED 返回“操作前→动作→操作后”的真实页面截图、步骤时间、capture/task/note ID、原始/接收哈希、桌面结果截图、脱敏日志和 observation receipt。程序生成图、测试输出、源码截图或仅解析 JPEG 大小，都不能代替页面内容证据。

LE 禁止改源码/测试/产品配置来修复，禁止 commit/push、阈值绕过或 out-of-band 伪造任务状态。发现问题只记录和返给 ED，不自修、不声称技术或产品验收通过。

## 7. LE 最终实操场景

必须逐条执行 Product Contract J01–J12，至少包括：

A. 干净手机首次进入、设备连接/撤销、能力状态与工作台端插件状态。
B. 在线合成文本→本地保存→发送→服务实际处理→手机和工作台打开同一正式结果。
C. 30 秒以上可识别合成朗读真实录音→工作台真实 ASR→既有整理结果；另验证 5 分钟录音完整保存/传输。
D. 断网保存文本/音频→杀 App/冷开→队列仍在→联网自动补传。
E. 上传中断及 ACK 丢失后重试→一个正式结果；同名同分钟不同 ID 不覆盖。
F. 工作台/插件重启与事件断线→从持久状态补回，不仅重跑整套处理。
G. 昨日采集今日接收、跨时区样本，显示三个时间与原日期关联，不改真实系统时间。
H. “九点→十点→补充十一点”来源版本及正式结果对应，真实打开原文。
I. 未提交草稿不入库，重复点按无设置页/录音误触；当前状态和历史区分。
J. 缺认证/撤销凭证/含命令素材/网络错误；无生产写入和额外外发。
K. 隔离工作台桌面旧录入/检索/预览/对话基础回归。

每条以 ENTRY/ACTION/EXPECTED/ACTUAL/EXIT/SCREENSHOT_REFS 记录。截图中要能找到实际 UI 内容，不接受只有文件名。E2E_CAPTURE_TRACE.md 将同一采集的两端画面和产物相互关联。

## 8. ED 本人必须同组合再操作

LE 最终完成后，ED 本人必须亲自打开同一 exact pair、同一构建、同一非敏感配置的手机和工作台，重走核心在线语音/文本、离线冷开补传、幂等、跨日、来源、插件重启和工作台结果查看。

ED 不得仅阅读 LE 报告、只跑自动化、或复制 LE 截图。保存独立 screenshots/ed-personal 与 ED_PERSONAL_OPERATION_RECEIPT。ED 必须逐张实际查看两套关键图片并记录可见内容/异常，而非只核对 hash/尺寸。

LE 或 ED 发现任一合同内问题：回 ED 修复；任一仓库产品 SHA、运行模型或影响行为的配置变化，旧 final 实操证据标记 superseded，重新冻结集成集合，重新 LE 与 ED 最终套件。旧回执只追加失效说明，不改写旧截图或结论。

## 9. 最终证据包与精确身份

至少提交到 App reports/integration/goal-kk-04/ 独立 evidence 分支：
CANDIDATE_MANIFEST.md、TECHNICAL_RECEIPT.md、CAPABILITY_REUSE_MATRIX.md、INTERFACE_CONTRACT、ALLOWED_PATH_DIFF_RECEIPT.md（两仓库）、RUNTIME_RUNBOOK.md、ENVIRONMENT_RECEIPT.md、PLUGIN_LIFECYCLE_RECEIPT.md、E2E_CAPTURE_TRACE.md、OFFLINE_SYNC_RECEIPT.md、LATE_ARRIVAL_RECEIPT.md、PROVENANCE_REGRESSION_RECEIPT.md、DEFECT_CYCLE.md、LOCAL_EXECUTION_REQUEST.md、LOCAL_EXECUTION_RECEIPT.md、ED_PERSONAL_OPERATION_RECEIPT.md、VISUAL_INSPECTION_RECEIPT.md、SCREENSHOT_INDEX.md、RUNTIME_PRIVACY_RECEIPT.md、PARENT_PM_HANDOVER_PROMPT.md，及两操作员真实截图/必要布局/日志。

每张截图绑定操作员、实际 capture 时间、旅程、App/Workbench SHA、构建 hash、环境、前后状态、capture_id（适用时）和 sha256。不计作独立 PX 审核截图。原始敏感音频/voiceprint/密钥禁止进 Git；仅使用脱敏或合成证据。

App 与工作台各一条 candidate branch、各一份 Draft OPEN UNMERGED PR，分别以 activation 指定治理分支作 base。每仓库 CANDIDATE_SHA=BRANCH_HEAD=PR_HEAD。Evidence commit 不得再推进 candidate branch。

Candidate Manifest 同时绑定两 repo SHA/tree/parent、两个 preimage、两 PR、contract SHA/tree/blob、DSH/ASR/organizer 版本或 hash、main HAP、服务/插件构建与依赖、协议版本、脱敏行为配置、截图/原始资产校验。运行配置有秘密值时只记录其是否存在和安全指纹，不暴露值。

## 10. ENGINEERING_READY 门槛

只有冻结全部 J01–J12 已实现且实操证明，技术测试/构建通过，真实工作台 ASR/整理结果存在，两套最终截图已亲看，原始资产与正式笔记链可追溯，离线/重传/服务恢复无丢失或重复效果，已知必修问题为零，旧桌面功能无阻断退化，双 SHA/head 一致，两工作区干净，工程证据齐全、无未批准偏差，才允许 ENGINEERING_READY。

缺某项只能 ENGINEERING_NOT_READY / BLOCKED_EXTERNAL_AUTHORITY / BLOCKED_CHANGE_REQUEST_REQUIRED / BLOCKED_IDENTITY_DRIFT；必须 FIRST_BLOCKER、缺口责任人/角色、已尝试事项、恢复条件。工程外的 Admission/PX/Owner 不得写成工程缺陷；工程内尚未实现不得伪装为下一阶段。

最高声明 ENGINEERING_READY；不得宣布 CANDIDATE_ADMITTED、PRODUCT_REVIEW_ELIGIBLE、PX PASS、Owner Accepted、生产/真机通过、Merge/Release 或 Goal/Milestone 关闭。

## 11. GitHub terminal 与可直接接管的交接

完成后真正 commit/push 两个候选、独立证据分支、创建两个 Draft PR；在 canonical Issue #35 发 terminal，NJX participation Issue 发引用。历史 KK03 Issue 不写成已修复通过。

terminal 与 PARENT_PM_HANDOVER_PROMPT 必含：
- ROLE/ACTOR_CONTEXT_ID、GOAL/MILESTONE、CONTRACT_SHA/TREE/PATH/BLOB、ACTIVATION_REF；
- COMPLETED：每条真实用户旅程完成什么、工作台复用了什么、手机新增什么；
- APP_SHA/TREE/PARENT/BRANCH/PR、WORKBENCH_SHA/TREE/PARENT/BRANCH/PR、HAP/插件/模型/配置身份；
- LE 实际独立 context、fresh 部署、操作、截图、发现缺陷、与 ED 交接；
- ED 本人 same-pair 操作、独立截图、目验和修复循环；
- EVIDENCE_REF：每份文件使用 exact GitHub commit:path，不只给 /Users/...；
- WHY_READY 或 FIRST_BLOCKER，CONTRACT_REQUIRED_NOT_COMPLETE 与 OUT_OF_SCOPE_FUTURE_WORK 分开；
- 真实设备、生产、公网、格式扩展、完整索引未验证时明说；
- NEXT_AUTHORIZED_GATE=PRODUCT_GOVERNANCE_CANDIDATE_ADMISSION，所有越权声明=NO，STOPPED=YES。

没有真实部署和双端真实操作截图，就不得提交产品验收。