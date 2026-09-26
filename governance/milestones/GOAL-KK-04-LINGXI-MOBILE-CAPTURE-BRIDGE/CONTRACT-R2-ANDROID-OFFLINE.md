# GOAL-KK-04 R2 — 灵犀离线优先 Android 客户端设计与 APK 交付合同

PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
GOAL_ID=GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
MILESTONE_ID=MILESTONE-GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
ONE_GOAL_EQUALS_ONE_MILESTONE=true
CONTRACT_REVISION=R2-ANDROID-OFFLINE
STATUS=FROZEN_PENDING_EXACT_PAIR_ACTIVATION
VERSION_HORIZON=PRE_1_0
CANONICAL_ISSUE=knowme-knowledge#35
PARTICIPATION_ISSUE=njx-knowledge#6
BASELINE_ID=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260926-v4-ANDROID-OFFLINE-WORKCLIENT
APPROVED_CR=CR-KK-20260926-ANDROID-OFFLINE-APP
ACTOR_CONTEXT_ID=PG-KK04-ANDROID-OFFLINE-R2-20260926-3CFB7E80

## 1. 目标和交付边界

交付一个可在 Owner 已确认支持 APK 的现有 Mate60 上安装的私人测试签名 APK，使用户能断网冷开、录音、本机中文转写、编辑/保存/检索本地记录及指定知识副本，服务恢复后可靠同步至同一灵犀工作台，并在手机上使用其在线 Agent、查询知识及查看结果/来源。

不是远程网页壳，不是另造知识后台，不是仅设计稿，不是把整个 DSH 搬到手机，不是要求 Owner 升级系统。APK 可安装是 Owner 给定约束；具体系统/API/ABI、权限和模型能力由 ED 实测作为选型输入，不再以泛泛的“是否支持 APK”反复询问 Owner。

本文件完整替代 R1 的后续工程执行合同及此前 HAP 路线的 activation；历史文档不修改。一个 Goal 的两个仓库工作包，只有一份 integrated manifest、一次准入、一次独立完整体验审核。

## 2. 产品界面设计

### 2.1 导航和首屏

四个目的地：“灵犀 / 记录 / 知识 / 我的”。首页主要内容是 Agent 会话、当前任务与结果；底部保持单手可达的语音/文字/附件入口。连接状态为轻量提示，可点开同步详情，不以工程诊断、历史测试或设备配置占据首页。手机不照搬桌面三栏，不要求用户横向拖动整个工作区。

在线：当前工作台和能力可用状态、会话上下文、真实任务进度、结果/来源入口。离线：明确“离线可用”，显示本机录入/编辑入口、已下载内容及待同步数量；远程能力标为待连接，而不是消失或反复报错。网络已连接但服务不可达、身份失效、识别资源不可用必须分别表达。

### 2.2 录音与记录

录音面有明确开始/暂停/继续/停止、计时、输入活动反馈、录音状态和设备转写状态；不自动开启常听。完成后显示原音频、可编辑转写、标题/日期/标签、仅保存在手机/交给灵犀。默认保存草稿，提交意图独立。低音量/近静音/过短时提示质量风险及重新录音/继续保存，不生成肯定的虚假文本。

记录列表按捕获时间稳定排序，连点不会操作错行。条目清楚区分“已保存在手机、待同步、正在上传、工作台已接收、整理中、已完成、需处理”，展开可查看历史而不把历史错误当当前状态。原音频/来源在结果页两次导航内可达。

文本笔记可离线修改、撤销当前编辑并保留版本；拍照/文件选择/系统分享先保存原件与来源，解析状态另行显示。第一版只承诺正文文本可编辑；不承诺直接编辑 PDF、Word、Excel、PPT、视频内容。

### 2.3 知识与会话

在线检索沿用工作台已有能力；下载明确选择的笔记/结果后可离线阅读及本地文本检索。离线搜索明确范围是“本机已下载内容”，无命中不伪称整个知识库无资料。知识详情展示缓存时间、基准 revision、附件是否已下载。手机修改的是工作副本，联网提交带基准版本，不能抢占服务器正式知识权威。

在线 Agent 会话和任务结果复用工作台真实能力；通过手机新增会话/提问并打开对应工作面，不能依赖桌面当前窗口。离线能读已下载会话、写问题草稿、明确排队待发送；不把离线回显伪装成 DSH 已执行。任务执行侧仍在工作台。

## 3. 必须实现的手机能力

A. 原生可访问的麦克风及本地音频保存；真实录音至少 30 秒主链及独立 5 分钟完整性链。用户主动录音后可切后台/锁屏，按系统支持的机制保持录音和可见提示；系统终止、权限撤销、存储不足时提示并保全已完成片段，不声称永不被杀。

B. 本机普通话语音转文字：飞行模式完成，不调用远程识别。可用系统离线识别或随包本地模型，由 ED 选择；不假设安装 APK 就有系统 ASR，不假设可用 Google 服务、特定 NPU/GPU 或厂商私有接口。验收资源必须已在本机且能冷启动，不得等待首次云端模型下载。记录引擎/模型版本、资源 hash、许可、CPU/内存/耗时及实际使用加速器；不无依据承诺芯片性能。

C. 本地持久工作区：录音、文本、元数据、修订和队列先写本地；未同步内容不进入可自动清理的缓存。关闭重开、断网和重启后保留。用户点击清理下载缓存不能删除草稿或待同步内容。已同步下载副本可受控清理，明确影响范围。

D. 摄像/文件选择/系统分享作为原生采集入口；权限按需请求，不申请全盘、通讯录或短信权限，不读取未选择的私人资料。拒绝相机/麦克风不影响文字记录。对不支持的解析格式诚实保留附件；OCR/复杂多模态离线理解不在本轮。

## 4. 同步、协议和正式结果

保留并扩展已有 mobile_capture_bridge，复用身份、可靠接收、任务恢复、DSH/整理及结果路由，不重写引擎。ED 在开工设计中形成兼容能力矩阵和协议；接口名不由 PG 臆造。

手机渲染以持久工作副本为基础，不等网络才能显示。草稿、授权 outbox、可清理下载副本相互分离。连接恢复并且服务可达/身份有效时推进已授权队列；服务关机、会话过期或弱网时继续本地工作，显示恢复动作。后台只按系统允许执行，不承诺强停后实时补传；前台恢复必须继续。

capture_id/device_id/schema_version/payload_revision/captured_at/timezone/received_at/hash/size/原始资产/本地初次转写/用户修订/context/intent/policy 必須可追踪；工作台回传 task_id/durable_received_at/processing_status/note_id/revision/result_refs/error。收到 HTTP 成功不能直接标注完成。

同 device/capture/revision 重传最多产生一个正式提交效果；同 ID 不同内容显式冲突；不同采集即使同名同分钟也互不覆盖。原始资料一经捕获不可被自动整理或修订覆盖。手机人工改文优先作为显式用户修正层，工作台再转写只能生成有来源的新层，不抹去用户修正。

手机本地识别优先用于即时编辑及工作台整理输入，原始音频仍保留。工作台真实 ASR 可用于用户选择的补转写/质量恢复，不能每次重复耗时又不说明，也不能用预制转写冒充真实转写。至少验证一次手机本地转写→真实工作台整理及一次真实工作台 ASR 恢复路径。

正式笔记修改带 base revision；冲突显示双方，保留未同步修订，不以最后写入静默覆盖。未接收/未确认数据不得自动删手机原件。采集、接收、处理三类时间分开，迟到资料沿用兼容适配，不修改系统时钟或重算历史日记。资料中的指令文本不触发工具执行。

## 5. 验收旅程

以下是新要求与真实验收目标，不是已通过结果。R1 J01-J12 的用户价值保护继续成立，以 APK 和本轮能力重新执行，不能搬用旧 HAP 截图或旧 PASS。

| ID | 本轮实操 | 必须达到 |
|---|---|---|
| J01 接入/撤销 | 安装 APK，连接隔离工作台，再撤销测试设备 | 状态真实；未授权不能远程读取/提交；无厂商密钥下发；离线文字仍可保存 |
| J02 在线文本 | 手机输入合成笔记并交给灵犀 | 本地落盘→可靠接收→真实整理；同 note_id 双端打开，实际产物可查 |
| J03 真实语音 | 目标手机真实麦克风短样本及 5 分钟样本 | 原音频完整/可听/hash，设备转写可编辑，真实工作台整理；另验证工作台 ASR 恢复；不用导入 fixture 替代麦克风 |
| J04 离线冷开 | 飞行模式下关闭重开，记录/编辑，再重启手机 | 草稿、修订、原音频、授权队列均保留；未提交草稿不误上传 |
| J05 故障恢复 | 中断上传/丢失 ACK/工作台重启/服务不可达 | 任务恢复、原件保全、错误有动作；联网不冒充服务可达 |
| J06 幂等 | 同条重复提交至少三次，再提交同名不同 ID | 一条提交一个正式效果，不同采集不覆盖，无重复外发或误操作 |
| J07 跨日 | 昨日采集今日同步及合成跨时区元数据 | 原捕获日期与接收处理时间可追，不改写历史主源 |
| J08 来源/修订 | 原话九点→手机改十点→工作台补充十一点 | 各层可追、用户改文不丢、两端两次导航内见原始来源 |
| J09 当前状态 | 失败再成功、断线重连及重开 | 当前状态不受历史错误污染；结果已完成须有实际产物 |
| J10 权限/隔离 | 拒绝权限、过期登录、恶意素材、清缓存 | 不越权、不外发、不误删待同步数据，文字功能仍可用 |
| J11 桌面回归 | 隔离桌面新增、检索、预览与会话 | 既有接口和知识规则不破坏，不影响生产服务 |
| J12 无说明使用 | fresh 操作员不读工程说明使用手机 | 能发现录入、离线保存、提交、结果、恢复；不被诊断项主导 |
| J13 本地转写 | 资源就绪后飞行模式冷开；10 段真实普通话朗读，总长≥5分钟 | 无远程识别请求；逐段可编辑文本；按预先固定转录参照计算总 CER≤20%；归一化规则和错误样本公开到合成证据；这是真机测试目标不是准确率宣传 |
| J14 离线知识 | 下载指定笔记及会话→断网→查阅/文本检索/编辑→两端冲突 | 展示缓存范围/时间；无网可用；冲突保留双方和手工修订，不静默覆盖 |
| J15 Agent 协作 | 在线提问/看任务结果；离线写待发问题，再联网 | 复用真实工作台会话；排队和执行状态分开，用户可取消；敏感动作遵循额外确认 |
| J16 安装/升级/锁屏 | 同一签名 APK 安装、离线使用、受控升级保留数据；5分钟录音含后台/锁屏区间 | 可安装可启动，无生产账号前置；升级不要求卸载丢数据；被终止时诚实报停，未同步记录可恢复 |
| J17 原生附件 | 合成照片、选定文件、系统分享各一次，断网保存再同步 | 使用真实系统入口、保全原件与来源；格式能力披露；取消/拒绝不误提交 |

J13 CER 以 (替换+删除+插入)/参照字数计算；参照在测试前固定，只允许事先写明的标点/空白规范化，不删除错误句或事后改参照。样本为清晰普通话，包含时间和一般工作记录；不要求本轮实现所有方言和行业词典。失效时“先保录音、联网补转写”是正确恢复但不是 J13 PASS；达不到需真实回报，不得自行豁免。

保留受控性能要求：操作 1 秒内有反馈；前台已授权队列在网络/服务/身份均就绪后 10 秒内启动同步；服务完成后前台 5 秒内更新。设备转写须显示进度且可取消，记录每段和冷/热启动耗时，不用无限转圈掩盖卡死；性能实测进入体验评估，不伪造帧率/内存/电量数值。

## 6. 允许工程路径和环境

App 允许：apps/lingxi-mobile-android/**；reports/integration/goal-kk-04-r2-android/**。该 App 子目录内可以有源码、测试、构建/依赖和所选移动框架，但 PG 不写这些内容。旧 prototypes/knowme-knowledge-02-voice-speaker-verification/** 只读复用参考，本轮不继续修 HAP、不删除旧源码/报告。模块之外任何必须变动先提出准确路径请求，禁止以工程便利扩张全仓权限。

Workbench 允许：lingxi/plugins/mobile_capture_bridge/**；lingxi/server/mobile_capture_bridge/**；lingxi/scripts/mobile_capture_bridge/**；tests/mobile_capture_bridge/**；reports/integration/goal-kk-04-r2-android/**。仅兼容挂载/新增移动会话与知识副本接口/隔离返回路由，可最小改 lingxi/server/lingxi_server.py、lingxi/server/dsh_acp_client.py、lingxi/server/lingxi_bot.py、lingxi/server/lingxi_ai.py。桌面 UI 源可只读查阅和有血统地复用到 App 目录；不改工作台 UI 或知识内核。

禁止 ED 改 AGENTS、governance、PROJECT_STATUS、.github、生产网关/public_access 脚本、kbctl.py、既有 skills/**、lingxi/vendor/**、真实 raw/knowledge/wiki/state/secret、旧报告和其他产品。测试数据/模型下载缓存/签名密钥/APK 构建产物在本机专用隔离目录，不把真实隐私或密钥提交 Git。

只构建部署到非生产 data root/端口/DSH session/home/测试凭证。联网模型调用只沿用本机已授权配置，禁止静默 Provider 替换；本机执行体提供凭据，不打印。允许私测 APK 生成和受控安装；没有设备连接/系统权限时报告证据缺口，不冒充已经授权或已测试。独立执行体可以是已授权本机 Runner/Local Executor，不能用付费 GitHub-hosted admission 强制阻塞；不得由 PG 修改构建流水线。

## 7. 工程顺序与复用要求

先读精确权威和旧 PX 修复矩阵，再盘点工作台真实 API/会话/知识结果及手机硬件、离线识别；选型由 ED 给出复用理由。先做“飞行模式冷开→真实录音→本机中文转写→编辑保存→杀进程重开”的最小竖切，再接可靠同步和在线工作面，最后补附件、可用性与最终同一候选回归。

必须提交 OLD_PX_BEHAVIOR_MAPPING，覆盖 PX-KK04-01..07 及已有稳定排序、防错行、质量提示、来源、外发真实性、跨日/单主源修复；旧测试仅供回归设计，不当新候选 PASS。提交 WORKBENCH_CAPABILITY_REUSE_MATRIX：每个入口注明复用哪个真实能力、是否在线、离线副本规则、未连接表现；不能把“未来插件”画成已连接。

手机常用核心操作不能依赖桌面全局 pending-preview、桌面当前会话或滚动位置。需要的少量返回适配在允许路径实现。若实际接口缺失或需要超出授权目录，先回报准确缺口，由 PG 决定 CR，不能反过来删除已要求的用户价值。

## 8. 证据归属与独立性

engineering_required：技术方案/选型/协议/复用与旧 PX 矩阵、允许路径 diff、技术测试、目标机能力与本地 ASR 证据、J01-J17 真实操作和故障恢复、性能记录、隔离/隐私证明、APK 安装签名升级验证、完整集成 Manifest/Technical Receipt。fresh observation-only Local Executor 在最终 exact pair/APK 上完整操作并截图；ED 本人在同一 exact pair/APK 独立实操并截图、亲自查看两套图片。缺任一必需证据不能 ENGINEERING_READY。

admission_required：PG 核对精确双候选 SHA/tree/parent/branch/PR、前向血统、合同及 CR 覆盖、候选与 APK/模型/配置绑定、证据完整、角色独立，无越权。不是 PG 自行跑技术测试。

review_required：有可操作隔离运行环境、固定 APK 和模型资源及脱敏配置、完整证据、实际独立 reviewer 身份、精确 referral；不得由 PG 虚构新运行上下文已建立。

product_experience：独立 reviewer code-blind 操作实际 App，评判手机易用性、离线独立工作、转写编辑、原生输入、同步恢复、Agent/知识连贯性，提交自己截图和 PASS/FAIL/BLOCKED；工程或 PM 不预写结论。

human_owner：本 PRE_1_0 不要求 Owner 做例行回归；设备/敏感权限为 Owner 所有。最终完整 1.0 必须再做绑定 exact candidate 的 Human Owner Acceptance；本次方向同意不是它。

## 9. APK 交付包

必须实际提供一个可取回的签名 APK，而非仅源码链接或 build PASS 文本。包内含完整离线 UI 和可用中文离线识别路径；无密码、厂商密钥和固定临时公网地址。记录 APK 文件名/大小/SHA-256/package ID/versionName/versionCode/minSdk/targetSdk/ABI/签名证书指纹与构建类型；同一私测签名持久保管以支持升级，私钥不提交。

提供实际可访问的私有构建产物位置及下载/安装说明；验证其内容是最终签名 APK 而不是 unsigned/APK 外壳或旧 HAP。首次连接向导、离线资源检查、权限说明、断网恢复及已知限制一并提供。可创建私人测试构建产物，不自动创建公开 Release、不上架、不部署生产。

integrated manifest 绑定 APP_SHA/TREE/PARENT/PR + WORKBENCH_SHA/TREE/PARENT/PR + APK_HASH + 本地 ASR 引擎/模型资源 HASH + 工作台 DSH/ASR/organizer 身份 + 协议/脱敏配置 HASH + 精确合同/基线。行为、APK 或模型/配置变化须重新冻结并重跑最终证据；证据另存独立 transport，避免自指 SHA。

## 10. 开工权威与关闭

沿用锁定中央 PG fc4872d9ba33325cf43a0778bb3ea01aea050c0f/tree 3acdba332db5cb58236a8abe87065846cf3ab8a0；ED skill 8bcf9da58d6147fcd2345a4b465f17f7a27850fd/tree 593bacfee4910a55b9b6c7bd2f2ca56b8761d134/core/ENGINEERING_DELIVERY_SKILL.md；reviewer 4253deb55a04de20fca6ac50a47b42a6d4489c04，实际运行独立性仍须验证。

最终 Issue #35 receipt 将固定本合同 COMMIT/TREE/BLOB、双治理前镜像/PR 和唯一 fresh ED handoff，之后 fresh ED 自报真实上下文及子代理 ID；未发布此 receipt 不开工。建议分支 engineering/goal-kk-04-r2-android-offline，分别以最终治理分支为 PR base；不得继承此前 ED 的运行上下文或让 PM 同时写产品代码。

工程最高终态 ENGINEERING_READY，其后是 PG 准入→review eligibility/referral→独立完整体验评审→合同门禁满足后 Goal/Milestone 同时关闭。MERGE、RELEASE、PRODUCTION 均不在本次自动授权中。APK 编译成功≠工程完整≠体验通过≠Owner 接受≠发布授权。

## 11. 外部可行性参考（不是本机验证）

核查日期 2026-09-26。Android offline-first 架构：https://developer.android.com/topic/architecture/data-layer/offline-first 。设备识别能力探测：https://developer.android.com/reference/android/speech/SpeechRecognizer 。麦克风前台服务约束：https://developer.android.com/develop/background-work/services/fgs/service-types 。离线 ASR 可复用实现示例：https://k2-fsa.github.io/sherpa/onnx/android/prebuilt-apk.html ，模型/许可/芯片适配需 ED 重新核查。APK 签名：https://source.android.com/docs/security/features/apksigning 。这些资料只支持技术存在与约束，不证明当前 APK 或目标机已通过。
