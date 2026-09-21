# ED PERSONAL OPERATION RECEIPT — KnowME Knowledge GOAL-KK-03 冻结候选

## 头部标识

- ENGINEERING_DELIVERY_CONTEXT_ID = ED-KK-GOAL03-VOICE-TO-NOTE-FIRST-USE-20260921-1935-D8F4
- OPERATOR = Engineering Delivery 本人（非 Local Executor 子代理；独立重新操作，不复用 LE 截图）
- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1（BRANCH_HEAD = PR_HEAD = SHA，操作前后均已核对）
- PR = #32（draft, OPEN）
- WORKTREE_CLEAN = YES（操作结束后 `git status --porcelain` 为空，HEAD = d02014f）
- BUILD_IDENTITY_HAP_SHA256 = 11570648fada5a99bbca2f45ed79c4439260fe8185a9ba6515bfafdad8efcab8（与 LOCAL EXECUTION run3 回执记录同一构建产物，操作前 shasum 复核一致）
- DEPLOYMENT = uninstall + install 干净安装（hdc），非覆盖升级
- ENVIRONMENT = OpenHarmony emulator kk02phone, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555
- BUNDLE = com.knowme.knowledge.voiceprototype / EntryAbility
- 操作时间 = 2026-09-22 00:20 ~ 00:45 CST（模拟器时钟 12:21~12:43，时区偏差为模拟器设置，不影响证据）
- SCREENSHOT_COUNT = 21（hdc snapshot_display 原始 jpeg，全部逐张目验；仅模拟器屏幕；全部输入为合成数据）
- INPUT_DATA = 全部合成：`say -v Tingting` 合成中文语音 + 手工注入的测试文本；无任何真实个人语音/数据

## 总体结论

- RESULT = **PASS**
- DEFECTS_FOUND = **NONE**
- 与 LE run3 同一构建身份（hap sha256 一致）、独立干净安装、独立截图目录 `kk03-ed-final-screenshots/`，未复用任何 LE 截图。

## 逐项操作记录

| # | 旅程 | 操作 | 期望 | 实际 | 结果 | 截图 |
|---|---|---|---|---|---|---|
| ED-01 | 首屏 FIRST_VIEW | 干净安装后冷启 | 产品目的可读、大录音按钮、声纹入口不滚动可达、TEST_FIXTURE/诊断折叠、诚实横幅 | 一致：「灵犀·把语音变成笔记」、知识 0 条、「0.1 原型·OpenHarmony 模拟器演示(非 Mate60 真机)·全程本地·无云端上传」横幅、Agent 自我介绍、手动文本兜底、两个折叠区 | PASS | ed-01 |
| ED-02 | 麦克风权限 | 点「授权麦克风并开始录音」 | 系统权限弹窗，文案说明用途 | 一致：「允许"灵犀语音原型"访问你的麦克风？用于在 Owner 明确点击开始后录制语音,完成本地中文转写与机主声纹验证」 | PASS | ed-02 |
| ED-03 | 录音中状态 RECORDING_STATE | 授权后观察 | 红色「●正在录音」+ mm:ss 时钟 + 停止/取消按钮 | 一致：00:02 | PASS | ed-03 |
| ED-04 | 录音时钟 | 继续等待 8s | 时钟持续走动不冻结 | 一致：00:02 → 00:10 | PASS | ed-04 |
| ED-05 | 取消录音 | 点「取消录音」 | 回到空闲、知识 +0、无候选残留 | 一致：知识 0 条，界面回到开始录音 | PASS | ed-05 |
| ED-06 | 未录入声纹拦截 | 录音（say 合成语音）后停止 | NOT_ENROLLED 诚实拦截、不入库、给重说/丢弃选项 | 一致：「本次验证:NOT_ENROLLED·相似度—」「信任门拦截:尚未注册机主声纹」，知识仍 0（转写「青春我在测试英雄。」为模拟器 STT 错字，见非缺陷观察 N1） | PASS | ed-06 |
| ED-07 | 声纹入口语义 VOICE_IDENTITY_ENTRY | 打开声纹管理面板 | 「档案≠本次验证」语义、原型声明 | 一致：「机主声纹(原型验证,非生产身份认证)」「声纹档案是你的长期身份状态;「本次验证」只是某一次录音的结果,两者互不代表。」 | PASS | ed-07 |
| ED-08 | 声纹录入 | 3 段采样（say 合成语音，每段 ~16s） | 采样计数正常、录入完成(3/3)、回声标注非本次验证 | 一致：「声纹档案:已录入(本地声纹档案)·录入完成(3/3)」「注册采样回声(非本次验证)」（首次尝试因操作脚本按钮名错误取消重来，属操作噪声非缺陷） | PASS | ed-08-1/2/3 |
| ED-09 | UNCERTAIN 拦截 | 较短语句录音停止 | 低相似度被信任门诚实拦截，不入库 | 一致：「UNCERTAIN·相似度 0.456」「信任门拦截:无法确定是谁(UNCERTAIN),不入库」，知识仍 0 | PASS | （消息流见 ed-16） |
| ED-10 | VERIFIED 候选 TRANSCRIPT_CANDIDATE | 长语句（~22s）录音停止 | VERIFIED + 相似度 + 候选卡「未入库·不会自动保存」 | 一致：VERIFIED 0.792，候选卡标注「转写候选(未入库 · 不会自动保存)」 | PASS | ed-11 |
| ED-11 | 整理成笔记 TRANSCRIPT_TO_NOTE | 点「整理成笔记」 | 显式转换进草稿编辑器，确定性整理声明 | 一致：「笔记草稿(未保存 · 保存 +1 / 取消 +0)」「确定性整理(非真实 LLM):只重排你说过的话,不新增内容」 | PASS | ed-12 |
| ED-12 | 溯源 NOTE_PROVENANCE | 展开「查看原始转写与来源」 | 来源 + 原始转写可见且不被整理覆盖 | 一致：「来源:机主本人语音(验证状态 VERIFIED)」「原始转写(整理不会覆盖它):「…」」 | PASS | ed-13, ed-14 |
| ED-13 | 编辑草稿 | 标题内插入「（已编辑）」 | 标题可编辑 | 一致：标题变为「我是这台设备的主（已编辑）人您天上午10点要和产品…」 | PASS | ed-15 |
| ED-14 | 保存笔记 SAVE | 点「保存笔记」 | 恰好 +1、Agent 解释入库与溯源 | 一致：「已保存笔记…,知识 +1(现在共 1 条)」，列表条目带「本人语音·已验证」徽标 | PASS | ed-16 |
| ED-15 | 条目详情 | 点开已存条目 | 标题/正文/来源/原始转写四要素齐全；原始转写保持未编辑原文 | 一致：正文、来源「机主本人语音(验证状态 VERIFIED),你明确保存后入库。」、原始转写为编辑前原文 | PASS | ed-17 |
| ED-16 | 取消笔记 CANCEL | 新录音 VERIFIED 0.686 → 整理 → 取消 | 知识 +0、候选一并丢弃、Agent 解释 | 一致：「已取消,这条笔记没有保存。知识没有变化(+0);原始转写候选也已丢弃。」知识仍 1 条 | PASS | ed-18, ed-19 |
| ED-17 | 防重复保存 SAVE_CANCEL_DEDUP | 新录音 VERIFIED 0.741 → 整理 → 快速双击「保存笔记」 | 恰好 +1，无重复入库 | 一致：「知识 +1(现在共 2 条)」，列表恰好多 1 条 | PASS | ed-20 |
| ED-18 | 冷启恢复 RECOVERY | aa force-stop → 冷启 | 已存知识与声纹档案持久恢复 | 一致：知识 2 条、声纹档案已录入、「已从本地恢复 2 条已保存知识与对话上下文(0.1 原型有界本地存储,非生产备份)。」 | PASS | ed-21 |
| ED-19 | 未保存草稿边界 | 新录音 VERIFIED 0.815 → 整理成草稿（不保存）→ force-stop → 冷启 | 草稿不复活、知识不变 | 一致：冷启后无草稿卡、知识仍 2 条、无草稿内容入库 | PASS | ed-22, ed-23 |
| ED-20 | Agent 首面 AGENT_FIRST_SURFACE | 全程观察消息流 | 每个状态变化都有 Agent 解释，无静默变化 | 一致：拦截/整理/保存/取消/恢复消息均有解释（见 ed-16、ed-19、ed-21、ed-23 消息流） | PASS | ed-16 等 |
| ED-21 | 候选丢弃 | UNCERTAIN/拦截片段点「丢弃」 | 知识 +0、片段清除 | 一致（ED-09 及多次重试前置操作中执行） | PASS | ed-06, ed-16 消息流 |

## 已知非缺陷观察（如实记录，不构成缺陷）

- N1：模拟器 STT 错字率高（如「青春我在测试英雄。」「您天上午」），且每次 boot 识别可用性不同（间歇报 1002200010）；属模拟器音频通路限制，产品侧对转写质量无夸大声明。
- N2：模拟器上声纹相似度对合成语音波动（0.45~0.82），短句易 UNCERTAIN；信任门按设计诚实拦截，重试长句即可通过——拦截行为本身是需求。
- N3：软键盘弹出时会遮住保存按钮，Back 键可收起；属平台通用行为。
- N4：ED-08 首次录入尝试因操作脚本使用了不存在的按钮名（「结束采样」而非「停止」）导致采样被拉长，取消后重来成功；属操作噪声，非应用缺陷。
- N5：模拟器系统时钟与宿主机时区不同（屏显 12:xx vs 宿主机 00:xx CST），不影响证据一致性。

## 合规确认

- 全程未修改任何源码/配置；未在候选分支 commit/push 任何内容；操作后 HEAD=d02014f、worktree 干净。
- 截图仅经 hdc snapshot_display 从模拟器屏幕获取；所有输入为合成语音/测试文本。
- 本回执与截图独立于 LE run3 证据（kk03-le-final3-screenshots/），未复用。
