<!-- EVIDENCE BINDING
GOAL_ID=GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
CONTRACT_REVISION=R3 (commit 168af57a2e7bd74385cecd97da1717982ac12ab1, blob b0ae8dbc980bc64f16bb77b30eaf5dbe9da64541)
CANDIDATE_SHA=3317469085d8dc10a88818369ffcc2922904079c
CANDIDATE_TREE=c688e8d6da0fe5fdaa12f2412158eb0c6d86ee15
CANDIDATE_BRANCH=engineering/goal-kk-02-r3-px02-p2-correction-r1
BUILD_MAIN_HAP_SHA256=05111cd04294f937839345e09b1af08aadefdc8b6cac1147f7eb4202622ca7f8
BUILD_OHOSTEST_HAP_SHA256=8a3e260725b76081a01d50938f7ac31a70945fecda8d7c1a03281106536b9c63
ED_CONTEXT_ID=ED-KK-GOAL02-R3-PX02-P2-CORRECTION-20260920-1645-A19D
EVIDENCE_TRANSPORT=evidence/goal-kk-02-r3-px02-p2-correction-r1 (independent branch; candidate PR head unmoved)
SCREENSHOTS=screenshots/local-executor/ (14 files, le-01..le-10)
-->

# LOCAL EXECUTION RECEIPT — GOAL-KK-02 Contract R3 / PX-KK02-R3-06 修复候选 Final Exact-SHA 模拟器验证

- **执行者 ID**: LE-KK-GOAL02-R3-PX02-P2-FINAL-20260921-A19D-01
- **执行日期时间**: 2026-09-21 11:35–11:47 CST
- **模式**: OBSERVATION_ONLY（未修改任何源码/测试/脚本/配置/治理文件；未做任何 git 写操作——无 commit/push/add；未自修任何问题）

## 环境核验

| 项 | 值 |
|---|---|
| worktree 路径 | `/Users/njx/Project/KnowME knowledge/KnowME knowledge/kk02-px02-le`（detached HEAD） |
| HEAD SHA 核验 | `git rev-parse HEAD` 逐字 = `3317469085d8dc10a88818369ffcc2922904079c` ✓ |
| clean 确认 | `git status --porcelain` 除 untracked `.onnx` 运行时资产外为空 ✓ |
| 模型 sha256 | `e2d2048292e055f7b61cdec3db010503f35369b245bf0b3bbad021c9a91e4053`（provision-models.sh 报 OK）✓ |
| main hap sha256 | `05111cd04294f937839345e09b1af08aadefdc8b6cac1147f7eb4202622ca7f8`（entry-default-unsigned.hap） |
| ohosTest hap sha256 | `8a3e260725b76081a01d50938f7ac31a70945fecda8d7c1a03281106536b9c63`（entry-ohosTest-unsigned.hap） |
| 单元测试实际结果 | **Tests run: 48, Failure: 0, Error: 0, Pass: 48, Ignore: 0** ✓（与期望一致） |
| 模拟器环境 | OpenHarmony API 24 手机模拟器，`hdc list targets` = `127.0.0.1:5555` |
| App bundle | `com.knowme.knowledge.voiceprototype`（版本 0.1.0） |
| 干净起点 | uninstall 后仅安装新 main hap + `aa start` 冷启动；系统麦克风权限未授予 ✓ |

## 旅程记录

### LE-01 Denied baseline
- ENTRY_STATE: 干净安装冷启动，系统麦克风未授予
- ACTION: 观察首屏
- EXPECTED: 权限未授权横幅；主按钮为权限相关动作；手动文本输入可用；TEST_FIXTURE 入口可用
- ACTUAL: 显示「麦克风未授权。不授权也能继续…」横幅 + 「去系统设置开启麦克风(可选)」；语音区状态「麦克风:需要麦克风权限」；主按钮「授权麦克风并开始说话」；手动输入框 + 「记录」按钮可用；「生成 TEST_FIXTURE 演示候选」入口可见
- EXIT_STATE: 拒绝态基线成立
- RESULT: **PASS**
- SCREENSHOT_REFS: le-01-before-fixture.jpeg

### LE-02 Generate fixture while denied
- ENTRY_STATE: 拒绝态（LE-01 出口）
- ACTION: fixture 输入框输入「今天的会议决定了采用本地优先的知识捕获架构」→ 点「生成 TEST_FIXTURE 演示候选」
- EXPECTED: 候选卡可见；麦克风状态仍「需要麦克风权限」（绝不能「空闲·未录音」）；拒绝横幅仍在；主按钮仍是权限动作
- ACTUAL: 候选卡出现（转写「今天的会议决定了…架构」+ ⚠ TEST_FIXTURE 标注 + 修正/确认/丢弃按钮）；「麦克风:需要麦克风权限」不变；「麦克风未授权」横幅仍在；主按钮仍「授权麦克风并开始说话」；知识计数 0 不变
- EXIT_STATE: 候选待确认，拒绝态保持
- RESULT: **PASS**
- SCREENSHOT_REFS: le-02-after-fixture-generate.jpeg

### LE-03 Correct while denied
- ENTRY_STATE: 候选待确认（LE-02 出口）
- ACTION: 候选编辑框追加【修正】标记（inputText 落点受键盘顶移影响，标记落于句中——按既定"追加【修正】标记"法接受）→ 点「保存修正」
- EXPECTED: 候选已修正；麦克风状态仍「需要麦克风权限」；权限 CTA 仍真实
- ACTUAL: 转写更新为「今天的会议决定了【修正】补充:优先离线场景采用本地优先的知识捕获架构」；麦克风状态与主按钮文案不变；未入库（计数 0）
- EXIT_STATE: 已修正候选待决
- RESULT: **PASS**
- SCREENSHOT_REFS: le-03-after-fixture-correction.jpeg

### LE-04 Reject while denied
- ENTRY_STATE: 已修正候选待决（LE-03 出口）
- ACTION: 点「丢弃」
- EXPECTED: 知识计数 +0；麦克风状态仍「需要麦克风权限」；主按钮仍是权限相关动作
- ACTUAL: Agent 提示「已丢弃这段语音转写,知识没有变化。」；已保存的知识(0)；「麦克风:需要麦克风权限」；主按钮「授权麦克风并开始说话」
- EXIT_STATE: 无候选，拒绝态保持
- RESULT: **PASS**
- SCREENSHOT_REFS: le-04a-before-reject.jpeg, le-04b-after-reject.jpeg

### LE-05 Confirm while denied
- ENTRY_STATE: 无候选，拒绝态（LE-04 出口）
- ACTION: fixture 输入「整理本地优先架构的设计评审纪要」→ 生成候选 → 点「确认入库」
- EXPECTED: 计数 +1；来源=TEST_FIXTURE；麦克风状态仍「需要麦克风权限」；无机主身份声明
- ACTUAL: 已保存的知识(1)，条目带来源徽标「TEST_FIXTURE 演示」；入库提示含「⚠ 来源是模拟器测试转写(TEST_FIXTURE),不是真实语音识别…真机未验证」；「麦克风:需要麦克风权限」；主按钮「授权麦克风并开始说话」；机主声纹区「注册档案:未注册 / 本次验证:—(尚未捕获)」，候选期间显示「不适用(演示候选,未采集语音)」
- EXIT_STATE: 1 条 TEST_FIXTURE 知识，拒绝态保持
- RESULT: **PASS**
- SCREENSHOT_REFS: le-05a-before-confirm.jpeg, le-05b-after-confirm.jpeg

### LE-06 Manual continuation
- ENTRY_STATE: 1 条知识，拒绝态（LE-05 出口）
- ACTION: 手动文本框输入「周五前提交季度复盘文档」→ 点「记录」
- EXPECTED: 成功入库（来源=手动文本）；麦克风状态仍「需要麦克风权限」
- ACTUAL: Agent 提示「已记下:「周五前提交季度复盘文档」(手动文本)。」；已保存的知识(2)，新条目来源徽标「手动文本」；「麦克风:需要麦克风权限」不变
- EXIT_STATE: 2 条知识（手动文本 + TEST_FIXTURE），拒绝态保持
- RESULT: **PASS**
- SCREENSHOT_REFS: le-06-manual-save-while-denied.jpeg

### LE-07 Permission action truthfulness
- ENTRY_STATE: 2 条知识，拒绝态（LE-06 出口）
- ACTION: 点主按钮「授权麦克风并开始说话」；系统弹窗出现，选「不允许」
- EXPECTED: 实际去向与按钮文案一致（系统权限请求弹窗）；选不允许后的实际行为记录
- ACTUAL: 弹出系统权限请求「允许"灵犀语音原型"访问你的麦克风？」（用途说明：用于在 Owner 明确点击开始后录制语音,完成本地中文转写与机主声纹验证）——与按钮文案一致；选「不允许」后产品深链至系统设置的应用信息页（含麦克风权限行）
- EXIT_STATE: 系统设置-应用信息页，权限仍未授予
- RESULT: **PASS**
- SCREENSHOT_REFS: le-07a-before-permission-action.jpeg, le-07-permission-dialog.jpeg（附加证据）, le-07b-system-settings.jpeg

### LE-08 Grant permission
- ENTRY_STATE: 系统设置-应用信息页（LE-07 出口）
- ACTION: uitest dump 定位麦克风 Toggle [1032,1613][1158,1683]，坐标点击，复 dump 确认 `checked=true`；`aa start` 返回产品
- EXPECTED: 权限状态刷新（如「权限已授予」）；语音按钮变真实录音动作；无残留拒绝态
- ACTUAL: Toggle checked=true 确认；返回后语音区显示「麦克风:权限已授予 · 待开始」，按钮变为「🎙 点开始说话」；首屏无「麦克风未授权」横幅；知识列表 2 条及来源徽标完好（Agent 历史对话中保留此前拒绝期的提示行，为正常对话记录）
- EXIT_STATE: 已授权，待开始
- RESULT: **PASS**
- SCREENSHOT_REFS: le-08-after-permission-granted-return.jpeg

### LE-09 Persistence regression
- ENTRY_STATE: 已授权，2 条知识（LE-08 出口）
- ACTION: `aa force-stop` + `aa start` 冷开
- EXPECTED: 已确认/手动条目仍在、来源在、计数对、「已从本地恢复」标记恰好一次
- ACTUAL: 标题「知识 2 条」；已保存的知识(2)：「手动文本 周五前提交季度复盘文档 11:42」「TEST_FIXTURE 演示 整理本地优先架构的设计评审纪要 11:41」；Agent 区「已从本地恢复 2 条已保存知识与对话上下文(0.1 原型有界本地存储,非生产备份)。」恰好出现一次；权限状态「权限已授予 · 待开始」（系统级授权保持，符合预期）
- EXIT_STATE: 持久化回归通过
- RESULT: **PASS**
- SCREENSHOT_REFS: le-09-after-cold-reopen.jpeg

### LE-10 Agent-first regression
- ENTRY_STATE: 冷开后首屏（LE-09 出口）
- ACTION: 观察最终首屏
- EXPECTED: 灵犀 Agent 对话为主；语音为附加能力区；技术诊断折叠；披露条（模拟器/非真机/≠生产认证/本地无云端）可见
- ACTUAL: 顶部「OpenHarmony 模拟器演示环境 · 非 Mate60 真机 · 真机未验证 / 原型声纹验证 ≠ 生产身份认证 · 全程本地 · 无云端上传」披露条可见；Agent 对话流占据主区域；「语音捕获(附加能力)」为次级区块；「技术诊断(引擎/模型详情)▾」保持折叠；标题含「0.1 原型 · 确定性演示(无真实 LLM)」
- EXIT_STATE: Agent-first 信息架构成立
- RESULT: **PASS**
- SCREENSHOT_REFS: le-10-final-agent-first-view.jpeg

## Defect 列表

NONE

（操作层观察、非产品 defect：① LE-03 中 inputText 落点被键盘顶移导致【修正】标记落于句中而非句尾——已知自动化坑，按既定追加标记法接受；② LE-05 首次尝试时点击「生成 TEST_FIXTURE 演示候选」在键盘弹起瞬间落空一次，重试成功；③ 系统设置页「麦克风」行文本点击不触发跳转，该行实际操作控件为行内 Toggle，按治理预案用坐标+checked 确认完成。）

## 声明

本人（LE-KK-GOAL02-R3-PX02-P2-FINAL-20260921-A19D-01）声明：本次执行为 OBSERVATION_ONLY；未修改任何源码/测试/脚本/配置/治理文件；未做任何 git 写操作（无 add/commit/push）；未自修发现的任何问题；所有截图均通过 `hdc shell snapshot_display` 采集；本回执不声明任何治理状态（不声明 Engineering Ready / Product Experience PASS 等），仅记录观察事实。
