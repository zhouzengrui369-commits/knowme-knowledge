# KnowME Knowledge / 灵犀移动采集 — Owner 授权独立体验审核

## 1. Owner Decision Brief

**结论：NOT_READY / PRODUCT_EXPERIENCE_FAIL。修复后由独立审核官复验，当前不支持关闭 GOAL-KK-04。**

这次已实际使用模拟器和隔离工作台：采集文本、真实录音、主动提交、双端查看、断连与冷启动、插件停启、丢 ACK、上传中断、撤销重连、同名双采集和三层来源。核心闭环确实存在，但用户还不能稳定相信连接状态、点中的对象、工作台来源及外发回执。工程 READY、准入和这份体验 FAIL 可以同时成立。

```yaml
review_mode: FULL_EXPERIENCE_REVIEW
review_date: 2026-09-24
actor_role: INDEPENDENT_PRODUCT_EXPERIENCE_REVIEWER
actual_context: Owner 直接授权的当前 Codex 审核任务；继承旧体验审核上下文
stage_a: PRIMED_COGNITIVE_WALKTHROUGH
candidate_app: c0171d4fa5a988272afa76cabd42b4b6ddbaea8d
candidate_workbench: 92892d66d059211113379b7e49d7f034b7ec921c
artifact_sha256: a73022244985e93a3f227b967bd771e8070dd562d499d16ddca4a91b8d721549
product_experience_verdict: NOT_READY
lifecycle_result: PRODUCT_EXPERIENCE_FAIL
release_evidence_verdict: BLOCKED_INCOMPLETE_EVIDENCE
prototype_concept_verdict: NO_PROTOTYPE_REVIEWED
prototype_to_runtime_parity: PARITY_PARTIAL
core_promise_holds: PARTIAL
confirmed_p0: 0
required_p1: 6
key_p2: 1
human_owner_gate: NOT_REQUIRED_FOR_THIS_PRE_1_0_GOAL
merge_authorized: false
release_authorized: false
goal_milestone_closed: false
```

正向证据：文本真正进入既有整理流程并产生可打开的 MD/HTML；手机和工作台共享 note 身份；原文九点、修正十点、补充十一点各有版本；五分钟录音文件完整；授权队列恢复补传，未提交草稿没有误上传；两个同名同分钟采集没有相互覆盖；撤销凭证后请求被拒绝。

必修：PX-KK04-01 状态失真；02 连点错入其他采集；03 工作台来源/卡片错配；04 低质量录音仍以普通“已整理”收尾；05 未外发却声称已发企业微信。06 为关键 P2：结果阅读和首次使用的信息层级；07 为收尾新增 P1：恢复任务没有接回已生成的结果，产生同采集第二份来源，随后超时失败但未找回旧结果。

建议：**修复后定向复验这七项，同时补齐 J03/J05/J07 及受控性能证据，再按 Goal04 合同覆盖完整 J01–J12**。不要把新 Goal 的完整验收缩成只关旧 Goal03 三个问题。此处没有替 Owner 作最终 1.0 接受，也没有增加例行 Owner 点击验收。

## 2. Candidate Identity 与权威链

| 字段 | App | Workbench |
|---|---|---|
| 仓库 | zhouzengrui369-commits/knowme-knowledge | zhouzengrui369-commits/njx-knowledge |
| PR | [#37](https://github.com/zhouzengrui369-commits/knowme-knowledge/pull/37) | [#8](https://github.com/zhouzengrui369-commits/njx-knowledge/pull/8) |
| branch | engineering/goal-kk-04-lingxi-mobile-capture-bridge-r1 | engineering/goal-kk-04-mobile-capture-bridge |
| SHA | c0171d4fa5a988272afa76cabd42b4b6ddbaea8d | 92892d66d059211113379b7e49d7f034b7ec921c |
| tree | 4c88cf33614e93a1b9dc64be12929cd64dd019e7 | b527133111112abea4831fa6b4be2c251e7927be |
| parent | 10d829195ebb7f6c4c576b0d116e45087ec2b35a | e548883b1d696b8245631bad129dd3737afcc5b7 |
| 实测身份 | PR head = branch head = 本地 HEAD；clean | PR head = branch head = 本地 HEAD；clean |

HAP：39,206,998 B，SHA256 `a73022244985e93a3f227b967bd771e8070dd562d499d16ddca4a91b8d721549`。使用工程已冻结 canonical 包；本轮没有构建。构建时间/命令来自工程 receipt：2026-09-23 13:09 +08 唯一真实构建，18:45 no-op；`scripts/build-hap.sh` / `hvigorw --mode module -p product=default -p buildMode=debug assembleHap --no-daemon`。构建血统是工程声明，包 hash 和实际安装为本轮核验。

环境：macOS 26.2 (25C56) arm64；kk02phone / 1256×2760 HarmonyOS 模拟器，`6.1.0.126(SP1DEVC00E120R4P11)`；bundle `com.knowme.knowledge.voiceprototype`。隔离工作台 `http://127.0.0.1:18251/`，独立 data root / DSH home，device 18256→host18251。J05 额外使用18257→18252→18251仅传输故障代理，之后恢复直连。没有修改产品文件、模型或 Provider 来修复体验。

处理身份：mobile_capture_bridge 1.0.0；`/api/mobile-capture/v1`；mlx-whisper/small；既有 DSH / TokenHub `tencent-tokenhub` + `deepseek/deepseek-flash`（DeepSeek-V4.1-Flash），instant-note-organizer-v4 / schema v4.0；隔离 external_send=disabled。初次受限进程启动出现 Metal 不可用及 fallback 日志，**未用于语义审核**；按原脚本在正常本机会话重启，MLX 预热完成后开始语音样本。没有把失败启动或 provider 配置文字当作有效路由证明。完整会话未抓包，不能声称全链无外发已通过网络审计。

权威顺序及读取副本见 [authority-index.json](evidence/authority-index.json)：

- GitHub AGENTS、治理锁、基线 v3、Goal04 冻结合同优先于聊天/旧 PR 文案。中央锁 `fc4872d9ba33325cf43a0778bb3ea01aea050c0f`，v0.4.0-alpha；旧 ecosystem-policy 中0.3字样不覆盖此锁。
- Baseline/Contract：`be400447c1d68062d22ae5e9ea0d169d929514df` / tree `48b4f641c5ba6a9bdcbf899dba79c27160666dac`；contract blob `19c950767a799d4c04712820f643cb46ab9e0077`。基线 `PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260922-v3-LINGXI-CAPTURE-DEVICE`，CR `CR-KK-20260922-LINGXI-CAPTURE-REBASELINE`。
- [Issue35 ED terminal](https://github.com/zhouzengrui369-commits/knowme-knowledge/issues/35#issuecomment-5796518601)、[ADMITTED](https://github.com/zhouzengrui369-commits/knowme-knowledge/issues/35#issuecomment-5797265869)、[Review Eligibility / referral](https://github.com/zhouzengrui369-commits/knowme-knowledge/issues/35#issuecomment-5806928405)。Issue 标题仍写旧 BLOCKED、PR正文含旧 SHA，不能替代最新回执/实际 head。
- 工程证据 `b44d11b8ffe594666721510a3b9cd9e97015415f` 只作部署和背景；本报告截图全部是 reviewer 新采，未挪用 LE/ED 图。
- 执行 [product-experience-reviewer-skill](https://github.com/zhouzengrui369-commits/product-experience-reviewer-skill/tree/4253deb55a04de20fca6ac50a47b42a6d4489c04)，tree `eaa62967737b17cc8ad07e46e297e0a52b2c3092`。

`core_sha256: 041a475d8cbc3404ed1e6df66c52377aecfcd631721d18a0ec9de59783f2b676`

[reviewer-identity.json](evidence/reviewer-identity.json) 记录结束时重新核验的 GitHub/local 身份。仅读 git 元信息、治理/运行文档、界面和合成测试产物，没有查看产品实现或测试来决定体验结论；未 author、技术 gate 或 admit 该候选。使用审核取证脚本与故障代理不等于改产品代码。referral 请求的新上下文名 `PX-KK04-FULL-EXPERIENCE-C0171D4-20260924-1121-R1` 不是本工具实际提供的全新 context；本轮如实声明继承旧 reviewer 历史，不伪造 context 独立性或盲测资格。

## 3. Review Mode、Stage A Frozen Output

按 Owner 明确要求与新基线重大路径变化执行 **FULL_EXPERIENCE_REVIEW**，不只复验 Goal03。Stage A 于17:05:19+08冻结，文件 [stage-a.md](evidence/stage-a.md) SHA256 `8ec01f3199c1517bc5976cf0aaab807fae81854c1cab1d740749125e8c80a8bb`，其字节保持不变。

阶段 A 已读当前 referral / 部署资料且继承先前体验上下文，初始11条为 ED 合成采集，所以明确 **PRIMED_COGNITIVE_WALKTHROUGH**。未读本轮完整基线/合同即冻结：手机看起来是先本地采集、再交灵犀的工具；主要文字/录音动作可发现；绿字“本地会话恢复”未证明当前连接；演示按钮截断和信息负担明显。实际输入“PX24 首次体验：会议原定九点。”并本地保存，01–05有记录。后来87–93做真实卸载/同包新装并复验首屏，但不能把后来的新装倒称盲测。

## 4. Stage B Positioning Reconciliation

| Core 五项 | 本轮判断 |
|---|---|
| 用户自然感受到的产品 | 有本地采集箱、有同步/整理阶段的手机采集器；结果更像技术 Markdown 阅读器。 |
| 设计者要传达的产品 | 灵犀工作台是产品主体和知识权威，手机是离线采集入口。 |
| 当前真正承诺 | 冻结 J01–J12：真实文本/语音进入旧工作台流程、授权队列恢复、幂等、跨日、来源分层、可信状态、原桌面功能保持。 |
| 文档有但本轮未兑现/未充分证明 | 有意义的真实麦克风语音语义闭环；一致跨时区样本；双端两次导航可靠原始来源；精确1秒/5秒反馈上限；插件卸载恢复。 |
| 实际偏差 | 移动和后端主链已经工作；前台仍混入静态卡片/旧日期/示例来源和假外发回执。问题在用户可相信的结果表达，不是缺第二套手机知识后台。 |

产品理念已部分进入真实体验，不能降格为“只是静态原型”，也不能因为处理真的跑通而忽略错误来源。

## 5. Scope & N/A

J01–J12、受控性能、状态/出处表达均为 **IN_CURRENT_RELEASE_SCOPE**。真机 Mate60、真实私人资料、相机/分享/网页解析、生产迁移/发布、手机 LLM/向量库、多设备协同和完整历史日终重算为 **OUT_OF_CURRENT_RELEASE_SCOPE / N/A**，不扣分也不计入分母。Goal03 是 SUSPENDED 的历史范围，不因本轮成功样本自动关闭。没有以企业级防线、多租户或生产发布标准阻塞本地产品价值。

## 6. Runtime User Journey Walkthrough

所有步骤绑定第2节同一 exact pair。时间均为主机 +08:00；序号是实际采集顺序，不是测试通过数量。每项“截图 nn”均可在 [Evidence Index](EVIDENCE.md) 找到。

| Journey / 实际动作及时间顺序 | 预期 | 实际结果、用户影响与证据 | Verdict |
|---|---|---|---|
| J01 06–11连接；81–86撤销/重连；87–94新装接入，17:05–17:43 | 能力/连接真实、撤销阻断、无厂商密钥 | 接入可用，撤销变未连接；缺失/无效/已撤销凭证均401；重连成功。已撤销时点旧结果没有新的可见解释；81仍写插件停用，尽管后端已恢复且有完成结果。59断连时绿字已连接。用户难以判断现在是否能传。auth receipt + 截图59/81/82/86/93。 | PARTIAL；01 |
| J02 03本地保存→12主动提交17:08:42→25结果→wb02–04搜索/来源→wb11真实HTML | 工作台完成、MD/HTML可打开、双端同一结果 | B27…896d20de r1于17:11:26完成，九点原文和结果存在，同note_id；wb11实际打开该移动结果HTML。手机展示原始YAML/Markdown；工作台来源说明错误。核心链成立，可信表达未通过。 | PARTIAL；03/06 |
| J03 16–23真实录音，18允许麦克风后计时，21五分钟→22停止313s→23上传；35–37结果 | 原音不丢且真实ASR，标题/来源不凭空编造 | WAV 313.34s/10,026,924B，phone/server hash相等；不是导入5分钟按钮。电脑合成朗读经实际录音输入，录音极弱，ASR产生重复普通话/好朋友句子，与朗读不符。整理正文提示高重复、未归因，卡片仍普通已整理。43昨日合成音频及99导入音频经真实ASR正确提供另一条证据，但不是麦克风成功证明。 | FAIL 语义/质量恢复；04；录制持久性PASS |
| J04 45–51插件停用文本队列/草稿；52–60录音尾段停服+保存文本、强停冷开；61–62恢复；75–77音频队列冷开恢复 | 原件/意图持久，已授权自动补传，草稿不提交 | 文本授权队列恢复约3.25s接收；第二次音频授权队列约1.5s接收。草稿文本和音频保持草稿直到真实主动提交。52录音开始时服务器尚在线，末段停服，不称全段离线录音。冷开绿字仍已连接。capture-state、fault log、59/62/73/76/77。 | PASS 持久和意图；状态FAIL归01 |
| J05 17:30服务恢复、17:36插件再启；98丢ACK；101–103资产送达前断开；中断后104起恢复 | ACK前保留原件、恢复续跑 | ACK已达服务器202但客户端收不到，手机先排队后已接收，一个正式结果。第二音频1,024,078B在代理收齐但未转发上游时断连，102提示原件保留/自动重试；4s后服务器收到。不是后端逐字节partial-write测试。尾项被审核环境进程退出打断，最终结果见final-runtime-receipt，不能把17:49的PROCESSING当完成。实际停用/再启已做；未做插件卸载。 | FAIL；07；已验证ACK/原件恢复，不等于任务完成 |
| J06 33、40同坐标连续3次提交；45/49两份同名同分钟不同ID；74第二份提交 | 一份一个正式结果，无错跳/误操作 | 文本r2一个task/result；两个同正文ID分别完成、note不同。**连点第2/3下落到重排后的其他控件，41进入“正在修正录音313秒”**。没有保存错误编辑；不能宣称三个网络提交都发给同一ID。用户存在改错素材风险。39–42、twin-capture-ids、final结果索引。 | FAIL；02 |
| J07 43导入显式昨日capture→44上传→wb09查看，17:25–17:29 | 原捕获日期与收到/处理时间分别可查 | captured9/23、received9/24保留；整理承认迟到和ASR文本日期冲突。模拟器timezone=America/Chicago与captured_at+08矛盾且状态栏慢12h，属于已披露环境限制，未形成第二套一致跨时区样本。工作台卡片09.09另为UI错日期。 | PARTIAL / 跨时区BLOCKED；03 |
| J08 27原九点→28–40修十点→64–69补十一点→78–79版本链；wb12搜索 | 原始/修正/补充/结果分别可追，双端最多2次导航看到原始来源 | 手机一次展开原始来源后滚动可见r1/r2/r3；三个正式note和raw backups保留，wb12找到三份，wb11原结果仍九点。工作台“查看来源说明”却给固定旧来源，不能认定双端两步原文达标。69–71打开的source面板还保留r2直到重新打开。 | PARTIAL；01/03 |
| J09 失败→恢复、队列冷开、r3结果查看 | 当前状态和历史分开，错误有恢复动作 | 上传中断有保留/重试说明，93早前/当前分开是改善。但59/81/69状态分别绿字已连接、旧停用、旧修订；需用户猜测与重新打开。 | FAIL；01 |
| J10 82撤销、401探针；带“发送企业微信”引文的双采集 | 认证拒绝、素材不当指令、无静默切换/外发 | 缺失/无效/撤销401；引文作为资料保留；隔离manifest记录SKIPPED、wecom-cli未调用。无基于时间过期凭证样本；无完整抓包，所以不声称网络级无外发已证实。wb07却称“已发企业微信”与manifest不符。 | PARTIAL；05（回执FAIL） |
| J11 wb05原桌面添加→wb08检索→wb07预览→wb06/07会话→wb11移动HTML | 原功能真实可用、来源和结果可信 | 实际新增合成桌面note，MD/HTML存在且浏览器展示；对话引用移动原文九点。卡片旧标题/新正文错配、09.09、manifest成为NOTE、HTML标签直接显示、静态源说明/示例声明混杂。对话擅加上午09:00，对另含九点材料称无关，是单样本语义偏差。无法证明由插件新引入，**当前集成候选的可见缺陷**仍未满足体验合同。 | FAIL；03/05/06 |
| J12 87真正卸载并同HAP安装→88–90首条→91–93连接 | 首屏发现采集/本地保存，不被诊断主导 | 0条空箱、不连接也可保存，连接后草稿不自动交付；主按钮明确。演示动作及技术说明仍占显著空间/截断。审核者已被资料primed，不能宣称独立盲人成功率。 | PARTIAL（认知观察）；06 |

### 性能、录音和最终恢复的证据边界

第一条文本 durable_received 17:08:42→organized17:11:26（164s，含端到端整理，不等于纯模型耗时）。前述两个网络恢复样本均在10秒内开始接收。hdc截图/布局带工具等待，本轮没有精确证明所有保存动作1秒反馈、后端完成后5秒内前台更新；不能用截图相邻序号或总命令耗时冒充指标。没有跨模型对比或凭几个样本给出准确率。

313.34秒样本，16000Hz/mono/16-bit，SHA256 `176f7799a329b205e916981605eee40e2693e1be944a4dcf5f9224f693fd76a2`。228.44秒样本7,310,124B，SHA256 `4e7d31698fef00b34e4e8864d99dfe7d3335e25e16b0d92193f87013c00800ed`。前者幅度仅约-19…15/32768，解释了输入不成立风险；不据此裁定真机ASR准确率。朗读第一次发生在麦克风授权前不算录入，授权后第二次才是尝试；[synthetic-audio-playback.jsonl](evidence/synthetic-audio-playback.jsonl)保留原时序。

故障代理首版对带查询参数的asset路径未命中，所以99的第一份音频并未受到上传故障；修正**审核适配器**路径匹配后101–102才是有效用例。此前55一次“提交”点中重排后的文本，音频仍为草稿，75才真实提交，不倒写操作成功。17:59发现审核中断使模拟器/隔离进程已退出；恢复原环境用于最终只读/前台核验，不能把此事件无依据归因产品崩溃。收尾时10/11采集修订COMPLETED，最后1项FAILED；手机18:12已给出超时和重试入口，不称无尽转圈。已有17:46版本MD/HTML与18:00重复来源、未回绑手机的事实仍构成PX-KK04-07。最终UI、task终态、耗时及补证见 [final-runtime-receipt.json](evidence/final-runtime-receipt.json)。

## 7. Prototype Review 与 Prototype-to-Runtime Parity

没有独立打开或评分设计稿/静态prototype：**NO_PROTOTYPE_REVIEWED**。候选自称“原型”不取消已经真实运行的backend证据；演示音频是明确披露的合成资产，不是预制TEST_FIXTURE转写。

| Experience | Where |
|---|---|
| In Runtime | 文字本地保存、5分钟原音、主动提交/队列、真实ASR/整理、双端note、3层来源、认证撤销、实际HTML |
| Only in Prototype | 本轮无独立prototype证据，不加分 |
| Divergent | 工程素材/静态日期来源混在真实卡片，手机技术Markdown结果，外发回执不真实 |
| Not yet demonstrated/productized | 有意义的实时麦克风语义样本、清楚的低质量恢复、完全可信状态、双端简单原文追溯、一致跨时区、严格性能证据 |

## 8. Inheritance Matrix

旧 [PR #33](https://github.com/zhouzengrui369-commits/knowme-knowledge/pull/33) / `bb2c33595e6100750ec35110c5cd13b2d556f4ac` 审核的是 Goal03 `d02014f…`，不能用其 NOT_READY 阻止新 Goal 实操，也不能沿用 ED 的“回归PASS”关闭问题。

| Issue | Prior | Current | Evidence | Closed? / Regressed? |
|---|---|---|---|---|
| PX-KK03-01 原文被修正版遮蔽 | P1 OPEN | PARTIALLY_FIXED：新手机三层可见；WB来源入口仍错 | 27/63/79、wb11/12、raw backups | 未整体关闭；Goal03为N/A_CURRENT_SCOPE，不追溯验收 |
| PX-KK03-02 连点意外设置跳转 | P2 OPEN | OPEN 风险：旧设置跳转未复现，但本轮连点错入其他录音编辑 | 39–42 | 不能报无副作用PASS；不同表现，不虚称同根因 |
| PX-KK03-03 旧状态冒充当前 | P2 OPEN | PARTIALLY_FIXED：早前/当前分开；连接/能力/来源修订仍滞后 | 59/69/81/93 | 未关闭；PX-KK04-01承接 |

## 9. Runtime Scoring

只用本轮runtime证据；1–5是解释性评分，不是通过阈值，均值不能覆盖必修P1。

| Dimension | Score | Applicable | Evidence | Reason |
|---|---:|---|---|---|
| 核心价值闭环 | 3 | YES / IN_CURRENT_RELEASE_SCOPE | 25、wb11、final-results | 主链有真实产物，语音质量及可信展示未闭环 |
| 首次发现/理解 | 3 | YES / IN_CURRENT_RELEASE_SCOPE | 87–93 | 本地保存清楚；演示/技术词与结果格式负担 |
| 操作稳定性 | 2 | YES / IN_CURRENT_RELEASE_SCOPE | 39–42 | 连点实际进入错误对象 |
| 持久化与恢复 | 3 | YES / IN_CURRENT_RELEASE_SCOPE | 59/62/76/77/102 | 原件与意图保留；尾项恢复产生重复来源且未接回结果 |
| 来源可信/可追溯 | 2 | YES / IN_CURRENT_RELEASE_SCOPE | 79、wb04/12 | 分层存在但桌面来源入口误导 |
| 当前状态/失败恢复表达 | 2 | YES / IN_CURRENT_RELEASE_SCOPE | 59/81、wb07 | 断连、能力与外发回执不真实 |
| AI结果实用与不确定性 | 2 | YES / IN_CURRENT_RELEASE_SCOPE | 35–37、wb07 | 无效音频仍普通完成；正文有质量提示是缓解项 |
| 视觉和阅读 | 2 | YES / IN_CURRENT_RELEASE_SCOPE | 25、wb08/11 | HTML预览可读，卡片与手机raw结果参差 |
| 认证与有限授权 | 4 | YES / IN_CURRENT_RELEASE_SCOPE | auth receipt、82/86、manifest | 撤销有效/素材不执行；无全链抓包不等于全面安全验收 |
| 真机/多人/生产发行 | — | N/A — OUT_OF_CURRENT_RELEASE_SCOPE | 冻结合同§2 | 排除归一化，不借此加企业级门槛 |

## 10. Issues P0–P3 / 可直接交付的修复合同

本轮 **P0=0、P1=6、关键P2=1**。没有证据确认原件丢失、错改已提交素材或未经授权实际外发。虚假外发提示虽然严重，外发不是本 Goal 核心承诺且真实处理/产物存在，因此列P1；若后续证明真实未授权外发、错覆盖或无提示的可信事实捏造，应另报P0，不被本次分级排除。下列所有 Issue 的 Evidence 均绑定第2节双SHA及HAP，Current Scope均为IN_CURRENT_RELEASE_SCOPE。

### PX-KK04-01 / 当前连接、插件能力及展开来源状态滞后

Severity: P1

Journey: J01/J04/J08/J09

User Promise Violated: 冻结合同要求已连接/不可用真实，当前传输任务与历史分开。

Observed Behavior: 服务已停且请求失败，59/104冷开仍绿字“已连接（本地会话恢复）”；81能力写插件停用但已于17:36启用并完成；69–71展开来源仍r2，需关闭重开才r3。

Expected Behavior: 已保存会话与已验证连接分别表达；能力/所选修订与当前对象一致。

Evidence: 截图59/69/71/79/81/104，environment-fault-actions、capture-state及操作日志；exact pair见§2。

Likely User Impact: 用户等待不会上传的采集，或把旧来源当最新提交，反复重试。

Current Scope: IN_CURRENT_RELEASE_SCOPE

Required Behavior: 断连显示不可达/待校验和恢复动作；插件与来源视图随有效状态刷新，历史带时间与归属。

Acceptance Criteria: 已连后停服→冷启不得显示有效在线；恢复与停启后能力符合实际；r2面板保持展开提交r3后不能冒充r3来源；旧回执不得成为当前操作指令。

Focused Retest Steps: 连接→停服→提交→冷启→恢复；插件停启；展开r2→补r3→查看来源，每步从UI核对当前capture/revision。

Required Retest Evidence: 每个转折截图/带时间短录屏、恢复动作、当前/历史对象、脱敏任务/能力回执；精确5秒刷新计时。

Regression Risk: 离线草稿可用性、自动补传和来源缓存不能因刷新被丢失。

### PX-KK04-02 / 连点提交因列表重排进入另一条录音的编辑

Severity: P1

Journey: J06/J08

User Promise Violated: 同一采集重复提交不得引出不相关导航或副作用。

Observed Behavior: 39确认文本r2提交按钮位置后40连续3次实际点击，41显示正在修正“录音313秒”；33另见同类错入。未保存错误编辑，原数据未证实被改。

Expected Behavior: 连点只作用于用户原来选择的采集，结束仍能辨认同一对象。

Evidence: 39/40/41/42 + operation-log；任务记录只证明r2一次效果，不证明3请求均命中原对象。

Likely User Impact: 把会议修正写到录音等其他材料；此轮未造成覆盖并不消除错误对象操作风险。

Current Scope: IN_CURRENT_RELEASE_SCOPE

Required Behavior: 同一连续提交手势不能因状态排序/控件移动转为其他记录的修正、设置或录音。

Acceptance Criteria: 含在处理录音和文本的列表，真实连续点击≥3次，终态仍是原对象且一正式结果；同时两不同ID同名同分钟内容各保留一份。

Focused Retest Steps: 在后台任务将完成时定位文本提交→连点3次→检查页面对象和每个capture；再做不同ID同名双采集。

Required Retest Evidence: 点击前后短录屏及坐标/对象，capture/task/note映射、单次正式效果与无意外编辑/录音/导航证明。

Regression Risk: 排序、状态按钮切换、恢复自动提交及列表滚动位置。

### PX-KK04-03 / 工作台真实笔记混入旧标题、旧日期和静态来源

Severity: P1

Journey: J02/J07/J08/J11

User Promise Violated: 同一正式结果双端可见，原日期/原始来源可理解并最多两次导航找到。

Observed Behavior: wb04“查看来源说明”写2026-09-09每日笔记、尚未连通实时库；09/24真实笔记卡片标09.09；wb08/12旧MOC标题卡片映射新内容，organize-manifest成为NOTE，部分HTML标签作为文字显示。真正HTML文件能打开（wb11），不等于卡片来源已正确。

Expected Behavior: 标题、时间、摘要、来源和打开对象属于同一note/revision；来源入口显示实际原文/资产及明确日期。

Evidence: wb03/04/08/09/11/12截图与AX，三份原始备份及final-results。

Likely User Impact: 检索到错误语境/日期，不知道九点、十点、十一点哪条来自何时，无法凭界面完成可信回源。

Current Scope: IN_CURRENT_RELEASE_SCOPE

Required Behavior: 真实数据路径不混入无关静态卡片或内部manifest；正确渲染摘要和日期；双端原始来源最多两次导航可达。

Acceptance Criteria: 搜索896d20de只呈对应版本及明确关系；点每个卡片标题/来源/HTML均匹配其ID；昨日capture显示原日期与今日接收；建立一致跨时区样本并保留原时区。

Focused Retest Steps: 全新隔离工作台→手机九/十/十一三版本→搜索逐项打开来源；昨日+另一一致时区→检索；原桌面添加/预览/对话回归。

Required Retest Evidence: 双端两步路径录屏、标题/ID/原始备份映射、捕获/接收/处理三时间与时区、无幽灵/manifest卡片截图。

Regression Risk: 不可为修卡片重写已接受的工作台布局；不修改历史资料或以手机另建正式库。

### PX-KK04-04 / 低质量录音与普通完成状态未形成可靠用户恢复

Severity: P1

Journey: J03/J09

User Promise Violated: 真实ASR进入整理后，标题与来源不凭空编造，失败/不可用需可恢复。

Observed Behavior: 真录313.34s文件完整但幅度极低，朗读不在有效转写中；反复普通话/好朋友句子被整理成正式note，采集卡片仅“已整理”。结果正文明确高重复、未归因等质量提示，故不宣称毫无提示的可信幻觉。

Expected Behavior: 输入无效/可疑时，用户在完成入口就知道质量问题并能重录、修正或只保留原音；不能把普通完成当语义成功。

Evidence: 18/21/22/35/37，real-recording-313s、phone-asset-hashes、synthetic-audio-playback、生成音频note。模拟器限制不等于真机ASR通用失败。

Likely User Impact: 以为五分钟会议已成为可用知识，直到阅读长结果才发现无关转写，浪费等待且污染检索。

Current Scope: IN_CURRENT_RELEASE_SCOPE

Required Behavior: 显著标注当前结果质量/不确定性及可执行恢复；补一段≥30s内容可核对的真实麦克风采集闭环，与导入合成音频分开。

Acceptance Criteria: 有效短朗读标题/来源能回原音核验；5分钟原件完整且反馈不冻结；近静音/高重复样本不能无警告进入普通可用结果状态；修正原音仍保留。

Focused Retest Steps: 明确有效输入设备→真实录≥30s并回听核对→提交；另录≥5min；近静音→观察完成入口与恢复，独立操作员亲自走全链。

Required Retest Evidence: 原始/接收hash与时长、录制/结果/质量入口截图、必要合成原音可控附件、已知朗读内容与ASR对照；不以fixture或导入按钮替代实时录音。

Regression Risk: 不能以强制声纹/额外Owner门槛阻断资料采集；也不能静默换Provider改善结果。

### PX-KK04-05 / 未外发却显示“已发企业微信”

Severity: P1

Journey: J09/J10/J11

User Promise Violated: 发送/预览策略显式，隔离默认不外发，当前回执真实。

Observed Behavior: 原桌面新增合成记录完成后，wb07界面“已发企业微信 · 已打开预览”；对应本run manifest写wecom_broadcast=SKIPPED、wecom-cli未调用。预览确已打开；两种副作用不能一并宣称成功。

Expected Behavior: 禁止/未授权外发时显示未发送/按策略跳过；只有实际成功才报已发。

Evidence: wb07截图及AX；review-generated-artifacts中的organize-manifest；isolated external_send=disabled。这是相互矛盾的回执证据，不是抓包证明无实际发送。

Likely User Impact: 用户误以为信息已投递而漏做后续，也会担心应用越权发送；损害对其他完成状态的信任。

Current Scope: IN_CURRENT_RELEASE_SCOPE

Required Behavior: 按每项真实副作用分别显示预览、整理、发送结果；素材中的发送指令不得被执行。

Acceptance Criteria: disabled环境新增/手机提交完成→界面不得说已发送；含发送命令的引文只作为素材；失败/跳过必须区分。

Focused Retest Steps: 现有桌面新增→完成与预览→读取发送状态；同样做手机引文采集；授权发送不在本轮范围，禁止借复验真的向别人发消息。

Required Retest Evidence: 完成页截图、对应任务/发送回执和配置脱敏快照，证明界面与实际一致。

Regression Risk: 保持已有新增/预览/对话路径，不将外发失败误报为整理失败。

### PX-KK04-06 / 普通用户阅读结果和首次使用仍被技术格式打断

Severity: P2（关键）

Journey: J02/J03/J11/J12

User Promise Violated: 用户能看懂采集到的知识与下一步，诊断/测试项不主导。

Observed Behavior: 25结果先展示YAML字段/路径和原始Markdown，普通会议事实需滚动查找；87首屏三项导入/模拟器说明占显著区域，部分按钮标签截断；17首次麦克风授权仍沿用声纹用途解释。

Expected Behavior: 直接阅读整理正文与出处，必要技术细节次级可查；采集、提交、结果是主要路径，权限解释与当前用途一致。

Evidence: 17/25/37/87/93、wb08/11；真实HTML预览可读是可保留的正向样例。

Likely User Impact: 首次使用要学习内部字段，难分“保存原件”和“正式知识已生成”，录音用途解释冲突。

Current Scope: IN_CURRENT_RELEASE_SCOPE

Required Behavior: 默认可读正文/来源/状态，技术元数据不先占满结果；诊断入口次级但仍可访问，标签和授权用途完整。

Acceptance Criteria: 新装无工程说明能完成首条采集并辨识本地/已接收/已整理；打开结果无需读YAML即可找到会议事实和原文；小屏按钮不截断主要动作。

Focused Retest Steps: 清空仅审核合成状态/同包新装→首条→提交→打开結果→来源；实际麦克风权限页面；保持既有工作台布局回归。

Required Retest Evidence: 首屏、权限、结果首屏、两步回源截图/操作序列；真实隔离参与者缺失时继续标primed而非盲测。

Regression Risk: 隐藏诊断不能同时隐藏故障恢复；不能为阅读层修复改变原始备份或新建第二结果库。

### PX-KK04-07 / 已生成结果未回传，重启又创建同一采集的第二份来源

Severity: P1

Journey: J05/J06/J09

User Promise Violated: 冻结合同§3“整理任务重入前核对已有实际产物/状态”；可靠恢复、不重复正式效果，§4默认有超时/失败/重试提示。

Observed Behavior: cap_7da867189fd368e1f349283ad0ebd0f1 revision1 的17:46主源已于17:50生成整理MD和HTML，但17:53/17:58仍PROCESSING。审核环境进程中断后恢复，18:00又出现同ID/revision的另一份主源/backup。18:10手机仍“灵犀整理中”；18:12最终109变“整理失败 / >600s未见HTML产物”并提供重试，仍无本条结果入口；工作台wb13–15实际可找到两项并打开旧整理正文。只读状态last note_id为空，日志有dsh-acp init超时。原音未丢；尚未证明第二份完成整理或重复对外发送。

Expected Behavior: 重启后对同一采集接回已有结果，任务/手机/工作台身份一致；无法恢复时进入可理解的失败状态和恢复动作。

Evidence: 102/103/108/109、wb13/14/15、final-runtime-receipt.json、final-results.json及两组同ID产物；实际环境中断时间未知；18:12手机明确失败，最后只读快照时间以回执为准。

Likely User Impact: 一份录音在桌面变成两个条目，手机却拿不到已经存在的结果，用户无法判断要等还是重交。

Current Scope: IN_CURRENT_RELEASE_SCOPE

Required Behavior: 重入先辨认同capture/revision已有产物并恢复对应任务；原件不丢，不生成误导的第二主源；结束等待或明确失败/重试。

Acceptance Criteria: 在产物已生成但完成通知未回传的窗口中断并重启→仍一份正式结果、双端note一致；无法初始化处理器时给出有界失败及可操作重试，不永久停在普通处理中；重试不会重复外发。

Focused Retest Steps: 同一exact候选完成一次正常音频；受控丢响应/处理末段重启；从手机冷开与工作台检索看同ID；在可控处理器不可用情形观察失败和实际UI重试。需保留中断前后产物证据，不能清库掩盖重复。

Required Retest Evidence: 故障时间线、两端实际截图/录屏、task/capture/note和全部同ID文件hash、失败到重试到结果终态；原件保留证明。本轮已证实超时失败和重试按钮存在，不报无限转圈；未再次触发长任务重试，不声称重试能找回旧结果，也不从日志推断源码根因。

Regression Risk: 断点续跑、幂等、已有结果辨认、状态事件/轮询、桌面索引不得互相矛盾。

## 11. Acceptance Criteria & Focused Retest / 给 Parent 的执行边界

七个Issue必须满足各自Acceptance Criteria、完整Retest Evidence、由下一独立审核官重放，且无新P0/关键P1；开发者口述和技术PASS不能关体验问题。J05已看到失败和重试入口，仍需补插件卸载/队列保留以及重试后正确绑定既有结果的终态；J07需一致跨时区；1秒反馈/10秒补传/5秒更新需受控实测，不把本报告的局部10秒样本扩大为全部性能PASS。

Parent 应将问题交独立 ED 对话；只要求用户行为，不由本 reviewer 指定产品源码实现。如确需改变范围/基线/处理策略，先CR，不能用“模拟器怪相”“已知静态文案”改写冻结阈值。新候选必须重新冻结双SHA/tree/parent、HAP、Provider/协议/行为配置、manifest/receipt并经准入/转审。若只改文档声称修好而字节或运行未变，不接受。

## 12. Four Verdicts 与 Human Owner Gate

| Verdict | Value | Reason |
|---|---|---|
| Product Experience Verdict | **NOT_READY** / PRODUCT_EXPERIENCE_FAIL | 六项必修P1，有真实主链也不通过 |
| Release Evidence Verdict | **BLOCKED_INCOMPLETE_EVIDENCE** | 身份可绑定；缺完整真实麦克风语义/一致跨时区/严格性能等，不伪称发布证据完备 |
| Prototype Concept Verdict | **NO_PROTOTYPE_REVIEWED** | 无独立设计稿/原型评分 |
| Prototype-to-Runtime Parity | **PARITY_PARTIAL** | 文本/队列/来源版本真实，可信前台表达未完全兑现 |

Human Owner Gate：遵循Owner明确授权及GitHub冻结合同§7，**NOT_REQUIRED_FOR_THIS_PRE_1_0_GOAL**。Skill通用“P0=0后HUMAN_OWNER_GATE_REQUIRED”在本项目被更具体的pre-1.0委托政策覆盖；没有因此把例行复验退给Owner。最终1.0 Human Owner Acceptance仍保留，当前没有Human Owner Accepted、Merge/Release Authorized或Goal/Milestone Closed结论。Reviewer只提交审核FAIL，不替Parent改变冻结合同或关闭状态。

## 13. Evidence Index 与收尾

完整检索入口 [EVIDENCE.md](EVIDENCE.md)，包含像素一致PNG精选、全部原始UI布局压缩包、真实操作/故障日志、独立结果映射、权威副本与hash、冻结StageA。截图和布局为相邻采样非原子；无效命令如17:59 hdc无设备保留在日志，不能当成实际点击完成。

凭据、device.json、DB、原始录音/HAP、私有DSH home和整个local-runtime均不上传；只发布合成reviewer内容及脱敏证据。没有修改历史审核回执；本次是新增报告。Skill validator仅验证报告结构/Core匹配，不代表产品测试。没有由 reviewer 执行技术测试或修产品代码；工作台自身整理器运行的内部门禁/自测属于产品流程输出，不当作 reviewer 验收PASS。

[Parent可直接复制提示词](PARENT_HANDOFF.md)。
