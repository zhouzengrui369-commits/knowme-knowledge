# LOCAL EXECUTION RECEIPT — KnowME Knowledge 冻结候选验收

## 头部标识

- LOCAL_EXECUTOR_CONTEXT_ID = LE-KK-GOAL03-FINAL-20260921-2310-R5T9
- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PR = #32（draft, OPEN，head 已核对 = d02014f）
- WORKTREE = /Users/njx/Project/KnowME knowledge/KnowME knowledge/kk03-le-final3
- WORKTREE_CLEAN = YES（验收结束后 `git status --porcelain` 为空，HEAD/TREE 与上述一致）
- BUILD = BUILD SUCCESSFUL（hvigor）
- UNIT_TESTS = 67/67 PASS
- BUILD_IDENTITY_HAP_SHA256 = 11570648fada5a99bbca2f45ed79c4439260fe8185a9ba6515bfafdad8efcab8
- MODEL_SHA256 = e2d2048292e055f7b61cdec3db010503f35369b245bf0b3bbad021c9a91e4053
- ENVIRONMENT = OpenHarmony emulator, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555
- BUNDLE = com.knowme.knowledge.voiceprototype / EntryAbility
- DEPLOYMENT = uninstall + install 成功（hdc）
- JOURNEYS_OPERATED = LE-01 ~ LE-22（含 a/b/c 子项）
- SCREENSHOT_COUNT = 76（hdc snapshot_display，jpeg，见文末清单）
- OBSERVATION_ONLY = YES：未修改任何源码/配置；未 commit / push；截图仅经 hdc snapshot_display；全部输入为合成数据（`say -v Tingting` 合成语音 + 手工键入的测试文本）。

## 总体结论

- RESULT = **PASS**
- 旅程通过：22 / 22（LE-22c 为 OBSERVED_NATURALLY，见矩阵）
- DEFECTS_FOUND = **NONE**

## 逐项旅程矩阵

| JOURNEY_ID | ENTRY_STATE | ACTION | EXPECTED | ACTUAL | EXIT_STATE | RESULT | SCREENSHOT_REFS |
|---|---|---|---|---|---|---|---|
| LE-01 | 冷启首屏 | 打开应用 | 首屏可理解，声纹/录音入口可见，TEST_FIXTURE 折叠 | 一致：标题+副标题、原型/模拟器/本地声明横幅、开始录音、声纹档案入口 | 空闲 | PASS | 01 |
| LE-02 | 空闲 | 打开声纹录入面板 | 面板标明「档案≠本次验证」语义 | 一致 | 面板打开 | PASS | 02 |
| LE-03 | 未授权麦克风 | 点开始录音 | 系统权限弹窗；授权后进入录音并显示 ●正在录音 mm:ss | 一致 | 录音中 | PASS | 03, 04 |
| LE-04 | 录音中 | 等待 | 时钟持续走动 | 00:01→00:35 持续递增，不冻结 | 录音中 | PASS | 05 |
| LE-05 | 录音中 | 取消录音 | 回到空闲且无候选残留 | 一致 | 空闲 | PASS | 06 |
| LE-05b/06 | 未录入声纹 | 停止一次真实录音 | 被 NOT_ENROLLED 诚实拦截，不入库 | 一致：真实 STT 未录入时诚实拦截 | 拦截卡 | PASS | 07 |
| LE-06b/c | 空闲 | 展开 TEST_FIXTURE 区并生成演示候选 | 候选卡带 TEST_FIXTURE 标注，未入库 | 一致 | 演示候选 | PASS | 08, 09 |
| LE-07 | 候选 | 修正转写并保存修正 | 保存修正，知识 +0 | 一致 | 候选(已修正) | PASS | 10, 11 |
| LE-08 | 候选 | 丢弃 | 知识 +0，Agent 解释不入库原因 | 一致 | 空闲 | PASS | 12 |
| LE-09/10 | 候选 | 整理成笔记 | 进入草稿编辑器（确定性整理声明） | 一致 | 草稿 | PASS | 13 |
| LE-11 | 草稿 | 编辑标题/正文 | 标题正文均可编辑 | 一致（首次正文输入未命中字段属操作噪声，重试成功，见非缺陷观察） | 草稿(已编辑) | PASS | 14, 15, 17 |
| LE-12 | 草稿 | 查看来源 | 来源+原始转写可见且不被整理覆盖 | 一致 | 草稿 | PASS | 18 |
| LE-13 | 草稿 | 取消 | 知识 +0 | 一致 | 空闲 | PASS | 19 |
| LE-14 | 草稿 | 保存笔记并连点 | 恰好 +1，无重复入库 | 一致：+1 且连点无重复 | 空闲 | PASS | 20, 21, 22 |
| LE-15 | 已保存 | 打开条目详情 | 四要素（标题/正文/来源/原始转写）齐全 | 一致 | 详情 | PASS | 23, 24 |
| LE-16 | 有已存知识 | force-stop 后冷启 | 知识持久恢复 | 一致 | 空闲 | PASS | 25 |
| LE-17 | 有未保存草稿 | force-stop 后冷启 | 未保存草稿不复活 | 一致 | 空闲 | PASS | 26, 27 |
| LE-18 | 全流程 | 观察消息流 | 每个动作都有 Agent 解释，无静默状态变化 | 一致 | — | PASS | 19, 22, 25 等消息流 |
| LE-19a | 已授权 | 设置中撤销麦克风权限并返回 | 应用诚实降级；引导去设置；授权返回后状态刷新 | 一致（撤销→诚实提示→设置→授权→返回刷新） | 已授权 | PASS | 28~31, 35, 36 |
| LE-19b | 无麦克风权限 | 手动文本兜底 | 手动文本可入库并标注来源 | 一致 | 空闲(+1) | PASS | 32, 33, 34 |
| LE-19c | 各异常态 | 观察 | 异常路径均有解释 | 一致 | — | PASS | 07, 08, 13, 17 |
| LE-19d | 空闲 | 查看录入面板声明 | 声明与 LE-02 一致 | 一致 | — | PASS | 02 |
| LE-19e | 空闲 | 展开诊断区 + 查 module.json5 | 诊断区声明「离线时…绝不静默走云端」；权限仅 ohos.permission.MICROPHONE when:inuse | 一致 | — | PASS | 37, 38 |
| LE-20 | 已授权 | 录入声纹（>70s 采样） | 采样不冻结、计数正常、3/3 完成并显示已录入 | 一致：70 秒+采样，计数 02:06，录入完成(3/3) | 声纹已录入 | PASS | 39~44 |
| LE-21 | 声纹已录入 | 真实语音（Tingting 合成音）走主路径 | VERIFIED→整理→保存恰好 +1，来源「本人语音·已验证」 | 一致：VERIFIED 0.771，知识 2→3 | 空闲(3 条) | PASS | 45, 46 |
| LE-22a | VERIFIED + NOT_AVAILABLE 拦截 | 注入测试转写→整理→保存 | 注入成功并全程标注 TEST_FIXTURE；保存 +1 | 一致：VERIFIED 0.713 + NOT_AVAILABLE→注入成功→候选卡标「TEST_FIXTURE 测试转写·未入库」→草稿→保存，知识 3→4；保存消息带 ⚠️「来源是模拟器测试转写(TEST_FIXTURE),不是真实语音识别」；列表条目带「TEST_FIXTURE 演示」徽标 | 空闲(4 条) | PASS | 71, 72, 73, 74, 75（前置操作轨迹 60~70） |
| LE-22b | VERIFIED + NOT_AVAILABLE 拦截 | 空输入点「注入测试转写」 | 拒绝且解释原因，不静默 | 一致：「注入被拒绝:请输入测试转写文本;若已有真实转写,请先丢弃再试。」 | 拦截卡保持 | PASS | 49~54 |
| LE-22c | — | 观察纯标点/无意义转写场景 | 该场景自然出现且门控诚实 | 自然出现：VERIFIED 0.663/0.713 + NOT_AVAILABLE 拦截（静音录音） | — | OBSERVED_NATURALLY | 49, 71 |

## 已知非缺陷观察（均不构成 DEFECT）

1. **STT 1002200010 收尾报错**：诊断区如实记录「STT 错误 1002200010: Write audio failed because the start listening is failed」（截图 46）。模拟器上 STT 引擎间歇性启动失败，应用如实披露并走 NOT_AVAILABLE 诚实拦截，无云端回退——符合设计。
2. **模拟器 STT 间歇性**：同一台模拟器上 STT 有时成功（LE-21、LE-22a 重录第 1/3 次）有时失败（LE-22b、LE-22a 静音那次）。应用对两种结果均行为正确：成功→真实候选；失败→NOT_AVAILABLE 拦截+解释。LE-22a 的操作轨迹因此较长：先丢弃残留真实转写（注入被拒绝时消息明确指引「请先丢弃再试」，截图 60/61/63），重录两次得到真实候选（丢弃，截图 66/70），再录静音得到 VERIFIED 0.713 + NOT_AVAILABLE（71），注入一次成功（72/73）。
3. **合成语音 STT 错字**：`say -v Tingting` 注入的转写含错字（如「测试转写后选流程」「第2季祝您」），属真实 STT 噪声，非应用缺陷。
4. **LE-11 正文首次输入未命中字段**：首次点击未聚焦正文输入框，重试成功；属 uitest 坐标操作噪声，非应用缺陷。
5. **注入拒绝消息的去重**：多次拒绝产生多条相同消息（截图 60/61 可见四条），每条对应一次真实点击，非重复渲染。

## 合规声明

- 未修改任何源码、配置或资源文件；worktree 验收前后均干净（git status 为空）。
- 未执行任何 commit / push。
- 设备侧仅使用 hdc snapshot_display 取证，未拉取/修改应用私有数据目录。
- 全部输入为合成数据：macOS `say -v Tingting` 合成语音与手工键入的测试文本；未使用任何真实个人数据。
- 知识库终态 4 条：TEST_FIXTURE 演示（LE-06b/c）、手动文本兜底（LE-19b）、本人语音·已验证（LE-21）、TEST_FIXTURE 注入（LE-22a）。

## 截图清单（文件名 → 旅程）

| 文件 | 旅程 |
|---|---|
| 01-LE-01-coldstart-first-screen | LE-01 |
| 02-LE-02-enroll-panel | LE-02 / LE-19d |
| 03-LE-03-permission-dialog / 04-LE-03-recording-mmss | LE-03 |
| 05-LE-04-recording-clock-ticks | LE-04 |
| 06-LE-05a-cancel-idle-no-candidate | LE-05 |
| 07-LE-05b-06-stop-notenrolled | LE-05b/06 / LE-19c |
| 08-LE-06b-testfixture-expanded / 09-LE-06c-fixture-candidate-card | LE-06b/c |
| 10-LE-07a-candidate-corrected-editing / 11-LE-07b-correction-saved-knowledge+0 | LE-07 |
| 12-LE-08-discard-knowledge+0-after | LE-08 |
| 13-LE-09-organize-draft-editor | LE-09/10 |
| 14-LE-11a-title-edited / 15-LE-11b-body-edited / 16-LE-11c-back-to-app-draft-state / 17-LE-11d-body-edit-attempt | LE-11 |
| 18-LE-12-source-and-raw-transcript | LE-12 |
| 19-LE-13-draft-cancel-knowledge+0 | LE-13 / LE-18 |
| 20-LE-14-save-note-exactly+1 / 21-LE-14-pre-save-draft / 22-LE-14-saved-exactly+1-no-dup | LE-14 |
| 23-LE-15-entry-detail / 24-LE-15-entry-detail-raw-transcript | LE-15 |
| 25-LE-16-coldstart-persistence | LE-16 |
| 26-LE-17a-unsaved-draft-before-kill / 27-LE-17b-coldstart-no-draft-revive | LE-17 |
| 28-LE-19a-settings-home / 29-LE-19a-appinfo / 30-LE-19a-mic-revoked-in-settings / 31-LE-19a-app-honest-no-permission / 35-LE-19a-mic-re-granted / 36-LE-19a-return-refreshed-granted | LE-19a |
| 32-LE-19b-manual-text-input / 32-LE-19b-scrolled-to-manual-input / 33-LE-19b-manual-text-typed / 34-LE-19b-manual-candidate-created | LE-19b |
| 37-LE-19e-diagnostics-expanded / 38-LE-19e-diagnostics-detail | LE-19e |
| 39-LE-20a-enroll-sampling-started / 40-LE-20b-enroll-mid-sampling-38s / 41-LE-20c-enroll-after-70s-before-stop / 42-LE-20d-enroll-sample1-done / 43-LE-20e-enroll-sample2-done / 44-LE-20f-enroll-complete-3of3 | LE-20 |
| 45-LE-21a-voice-attempt1-result / 46-LE-21b-verified-note-saved | LE-21 |
| 47-LE-22b-empty-injection-refused / 48-LE-22-fixture-section-scrolled / 53-LE-22b-empty-injection-refused-explained / 54-LE-22b-refusal-message | LE-22b |
| 49-LE-22a-silence-attempt1-result / 50-LE-22a-blocked-state-injection-visible / 51-LE-22a-injection-control / 52-LE-22a-blocked-card-with-injection | LE-22a/c 前置状态 |
| 55-LE-22a-injection-text-typed ~ 70-LE-22a-retry3-result | LE-22a 操作轨迹（含两次被拒绝的操作现象与丢弃/重录过程） |
| 71-LE-22a-silent-result（VERIFIED 0.713 + NOT_AVAILABLE + 注入控件）/ 72-LE-22a-inject-final / 73-LE-22a-inject-done（注入成功，TEST_FIXTURE 候选卡）/ 74-LE-22a-organized（草稿）/ 75-LE-22a-saved（+1 共 4 条，TEST_FIXTURE 演示徽标） | LE-22a 成功路径 |

（全部 76 张均为 hdc snapshot_display 原始 jpeg，与本回执同目录。）
