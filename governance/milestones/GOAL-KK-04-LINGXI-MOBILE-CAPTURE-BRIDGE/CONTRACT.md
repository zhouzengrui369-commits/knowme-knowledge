# GOAL-KK-04 — 灵犀移动采集插件真实闭环冻结合同 R1

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
goal_id: GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
milestone_id: MILESTONE-GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
one_goal_equals_one_milestone: true
contract_revision: R1
status: FROZEN
version_horizon: PRE_1_0
task_class: REAL_CROSS_REPOSITORY_PRODUCT_INTEGRATION
canonical_repository: zhouzengrui369-commits/knowme-knowledge
canonical_issue: 35
product_subject: LINGXI_WORKBENCH
knowledge_authority: NJX_KNOWLEDGE_RUNTIME
baseline_path: governance/PRODUCT_BASELINE.md
change_request: CR-KK-20260922-LINGXI-CAPTURE-REBASELINE
owner_acceptance_policy: DELEGATED_TO_PRODUCT_EXPERIENCE
```

## 1. 用户价值与唯一路径

用户随时通过手机采集文本或语音，即使离线也不丢；联网后已授权采集自动交给灵犀，由既有工作台转写、整理、入库，手机与工作台能查看同一结果及原始来源。手机不重建知识处理后台。

两个仓库为同一个 Goal 的两个工程工作包。基础产品代码：手机继承 knowme-knowledge@02329efa8b41e5242a0e457d836d27051a2f5bbe；工作台继承 njx-knowledge@8421841e82f44257233039c3cf7f6e5394803a10。真正开工 preimage 必须使用最终 activation 绑定的两个治理提交，不能使用 moving main。

## 2. 冻结范围

手机：文本与录音采集（至少一段真实 5 分钟录音不冻结/不丢失）、本地持久采集箱、主动“交给灵犀”、自动补传已授权队列、清晰传输/处理状态、查看本次结果/来源、可选现场修正。无需先在手机生成正式笔记。声纹 UI 可保留但不得作为资料采集及上传的普遍前置门槛，不把非本人资料自动归因本人。

工作台：可实际注册/启停的 mobile-capture 插件；设备认证/能力查询；可靠接收与任务恢复；复用 transcribe、既有 DSH/instant-note-organizer-v4 和结果预览；统一 capture/task/note 身份；移动结果回传；隔离测试，无生产影响。只允许窄适配，不重写 DSH 内核/整理器/索引器。

不在本 Goal：相机/系统分享/网页全文抓取、多模态解析、完整日程待办远控、任意 Shell 工具下发、手机端 LLM/向量库、生产多设备协同、迁移生产数据、腾讯云部署/公网入口调整、真实私人资料、真机安装、生产发布。它们不因本次联网授权而自动进入。

## 3. 接口行为合同（技术路由由 ED 设计并冻结 OpenAPI/协议产物）

接入插件提供设备注册/撤销与能力查询、采集清单/附件传输、完整接收确认、处理启动/查询、结果/事件补拉；不要求某个未核实的 DSH SDK API 名称。读出实际 vendored DSH manifest/version 并建立适配血统，不以 README 自称插件替代真实加载证明。

采集字段必须保留 capture_id、device_id、schema_version、payload_revision、kind、captured_at、timezone、received_at、hash/size、原始资产、最初转写、用户修正版、context_ref、intent、processing_policy。工作台签发 task_id、durable_received_at、状态、note_id/revision/result_refs。原始资料一旦接收不被用户修正或模型整理覆盖。

相同 device/capture/revision 幂等；同 ID 不同内容必须显式冲突，不覆盖。至少保证正式提交效果一次；传输可重试，不承诺网络层 exactly-once。整理任务重入前核对已有实际产物/状态，不重复调用外发副作用。HTTP 2xx 不等于知识已生成。

实时事件断线后可按游标/状态查询补回；事件不能是唯一完成记录。手机所有端点不得依赖桌面 DOM、共享的全局 pending-preview 或另一设备的当前窗口。

## 4. 必须通过的用户旅程与验收

| ID | 真实操作 | 必须达到的结果 |
|---|---|---|
| J01 接入 | 新装手机，授权连接隔离工作台，查看能力；撤销设备后重试 | 已连接/不可用真实；撤销后不能继续上传/读取；无厂商密钥下发 |
| J02 在线文本 | 手机输入合成文本并交给灵犀 | 本地已保存→可靠接收→真实工作台整理；MD/HTML 实际存在且可打开；同一 note_id 双端可见，不在手机造第二套正式结果 |
| J03 在线语音 | 录真实合成朗读音频并上传；另录 5 分钟内容验证完整性 | 原始音频 hash 保留；工作台真实 ASR 产出并进入既有整理流程；短样本至少核对标题与来源不凭空编造；不能用 TEST_FIXTURE 文本替代主闭环 |
| J04 离线与重启 | 断网采集文本/音频，关闭并重新打开 App，再恢复网络 | 原件、队列、提交意图仍在；已授权项自动补传，草稿不误提交 |
| J05 弱网/服务恢复 | 上传中断、响应丢失、工作台重启、插件停用/再启用后恢复 | 接收任务及原始资料可恢复；可靠 ACK 以前不删除手机副本；不会因插件卸载丢队列 |
| J06 幂等与副作用 | 同一采集重试/连点提交至少 3 次，再提交同名同分钟但不同 ID 的两份内容 | 同一采集一个正式结果；不同采集互不覆盖；无设置页跳转、自动录音或重复企业微信发送 |
| J07 跨日 | 使用显式合成元数据：昨日采集今日上传，再试跨时区 | 捕获/接收/处理时间分别可查，按捕获日期查看；不把昨日事件伪装今日；不越过既有技能“仅今天”规则直接改历史资料 |
| J08 来源分层 | 原始“九点”→现场修正“十点”→工作台结果；后续补充“十一点” | 原始资产、最初转写、修正/补充和结果各有版本；新授权结果可更新但原文不丢，两端最多两次导航看到原始来源；未记录的旧层不编造 |
| J09 当前状态 | 请求失败再成功、断线再接通、未提交草稿冷重启 | 当前传输/任务与历史明确分开，已失效提示不冒充可操作指令；错误带恢复动作 |
| J10 隔离与权限 | 缺认证/过期认证、含命令文字的素材、额外发送请求 | 拒绝非法请求；素材不作为 Shell 指令；不读取生产知识/私人声纹；无静默 Provider 切换/外发 |
| J11 工作台回归 | 隔离克隆工作台原桌面新增/检索/预览及会话样本 | 已有桌面接口形状与行为保持，不因移动插件改变生产使用方式 |
| J12 无说明首次使用 | 独立操作员不读工程说明进入手机 | 首屏能发现采集及本地保存，采集箱能分清未同步与未整理；诊断/测试项不主导 |

受控性能下限：前台保存/点击需 1 秒内出现明确反馈（不要求 1 秒完成整理）；队列已授权、网络恢复且服务可达时 10 秒内启动同步；工作台处理完成后前台 5 秒内通过事件或轮询更新。实际 ASR/整理耗时记录冷/热样本，不虚构准确率；默认必须有超时、失败、重试提示，不能无尽转圈。

上传成功不等于整理成功；整理成功不等于 Wiki/索引全部刷新。后续工作台任务未完成时分别披露，不能升级完成状态。发送/预览继承策略要显式：隔离测试默认不外发、不控制生产桌面。

## 5. 迟到资料适配与能力复用

当前 organizer 只处理今日 daily 主源。允许插件为迟到采集建立今日接收主源并原样保留原始 captured_at/timezone 和原日期关联，使用显式迟到资料适配上下文；不得修改系统时钟、伪造捕获时间或无授权重写旧 daily/Wiki。必须实测手机与工作台能查到原日期关联；完整历史日终重算不在此 Goal。

复用旧整理脚本、框架和产物校验；若隔离环境需要路径适配，仅在插件封装/启动环境处理，不修改 kbctl.py 或旧 skill 的内容规范。真实 DSH/ASR 依赖缺失须 ENGINEERING_NOT_READY/BLOCKED，不得用手机确定性整理器或人工预制结果交付。

## 6. 路径与环境授权

App ED 可改：prototypes/knowme-knowledge-02-voice-speaker-verification/**；reports/integration/goal-kk-04/**。网络权限、采集箱存储、测试、模块内依赖/构建属于允许实现。

NJX ED 可改：lingxi/plugins/mobile_capture_bridge/**；lingxi/server/mobile_capture_bridge/**；lingxi/scripts/mobile_capture_bridge/**；tests/mobile_capture_bridge/**；reports/integration/goal-kk-04/**。仅为挂载插件/新增兼容 API/数据根与结果路由隔离，可最小修改 lingxi/server/lingxi_server.py、lingxi/server/dsh_acp_client.py、lingxi/server/lingxi_bot.py、lingxi/server/lingxi_ai.py；不能改变旧桌面接口合同或重写业务实现。已有运行权限/配置缺口需在隔离环境解决，不改个人运行 settings。

两仓库其他路径默认不可改，尤其 AGENTS、governance、PROJECT_STATUS、.github、工作台 public_gateway.py、scripts/kbctl.py、skills/**、lingxi/vendor/**、已有知识/原始资产/状态/secret、旧报告、其他产品。必要越界提交 CR。构建产物/临时隔离数据置于 Owner 机器专用外部目录，禁止混进生产库或 Git。

只部署固定组合到非生产环境：独立 data root、独立端口、独立 DSH session/home、测试凭证，运行前确认不能触发生产文件和企业微信发送；不能直接调用生产 add-knowledge。无需 Owner 提前连接 Mate60，也不能阻塞于生产签名材料。

## 7. 证据归属

engineering_required：完整基线/合同映射、双仓库技术方案/协议定义、实际 DSH/ASR/技能版本、能力复用矩阵、路径 diff、技术测试、部署隔离、J01–J12 实操与性能记录、故障循环、Local Executor final 部署与截图、ED 本人 same-pair 独立操作截图、capture/task/note 关联、原始哈希/产物及原文版本、错误/隐私回执、集成 Candidate Manifest/Technical Receipt。

admission_required：PG 独立检查两个候选 SHA/tree/parent/branch/PR 一致、前向祖先、合同覆盖、证据完整、已批准 CR、无越界，旧发现映射真实，无候选作者兼任接纳。

review_required：exact 双候选和运行构建/非敏感配置身份、可操作隔离环境、从干净状态的用户旅程、实际 Reviewer context 独立性声明（不得由 PM 代造）、正式转审。

product_experience：独立 Reviewer 亲自操作 J01–J12 用户价值，重点在线真实处理、离线不丢、重复不多、跨日不误、来源可追、状态可理解，生成自己的截图和报告。

human_owner：本 Goal 无例行验收项；敏感权限按需单独授权不等于产品接受；1.0 才要求 final Owner Acceptance。

## 8. Candidate 与关闭

集成候选是一个不可拆分集合：APP_SHA/TREE/PARENT + WORKBENCH_SHA/TREE/PARENT + 两个 PR + main HAP hash + 插件/服务构建身份 + DSH/ASR/organizer 身份 + 协议版本 + 脱敏配置 hash。任一产品组件/配置/模型变化使此前 final 双实操证据失效，ED 必须重跑受影响且完整覆盖本合同的最终套件；不得引用旧候选截图抵数。

关闭条件：fresh ENGINEERING_READY → PG 对 exact pair 准入 → PG 资格与转审 → 独立 FULL_EXPERIENCE_REVIEW PASS → 无必修问题/漂移 → PG 同时关闭 Goal/Milestone。Owner 例行 Gate=false；Release=false。ED 最高只能 ENGINEERING_READY。历史回执不可重写，旧 PASS 不继承。