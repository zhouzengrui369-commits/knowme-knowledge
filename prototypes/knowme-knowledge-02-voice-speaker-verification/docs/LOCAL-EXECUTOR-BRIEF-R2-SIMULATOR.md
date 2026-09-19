# LOCAL EXECUTOR BRIEF — GOAL-KK-02 Contract R2 (SIMULATOR-FIRST, FINAL EXACT-SHA RUN)

> 本任务书取代旧真机版 `LOCAL-EXECUTOR-BRIEF.md`(R1 时代编写,保留为 post-1.0 真机资料)。
> Contract R2 冻结:`REAL_MATE60_REQUIRED_FOR_ENGINEERING_READY=NO`。本运行全程在 **模拟器** 完成。

## 0. 身份与边界(不可违反)

```text
ROLE=LOCAL_EXECUTOR
CONTEXT_ID=LE-KK-GOAL02-SIMULATOR-R2-FINAL-20260919-1130-C9F2
PROVISIONAL_FINAL_SHA=11e7a73(以 ED 派发时告知的冻结 SHA 为准,逐字核对)
BRANCH=engineering/goal-kk-02-simulator-first-r2
```

- **不得修代码**。发现任何 in-scope defect:如实记录进 receipt,立即报告 ED,不得自行修复。
- 不得把模拟器数据说成真实 Mate60 数据;不得把 TEST_FIXTURE 说成真实语音识别。
- 截图必须**净化**:不含宿主桌面、个人账号、路径外信息;只截模拟器屏幕(hdc snapshot_display 产物)。

## 1. Fresh exact-SHA materialization

```bash
git clone <repo> le-materialization   # 或 git worktree add
cd le-materialization
git checkout <PROVISIONAL_FINAL_SHA>
git log --oneline -1                   # 必须与冻结 SHA 逐字一致
git status                             # 必须 clean
```

## 2. 构建与安装(模拟器)

```bash
cd prototypes/knowme-knowledge-02-voice-speaker-verification
./scripts/provision-models.sh           # 必须:fresh materialization 无模型资产(不进 git),缺它注册会报「引擎未就绪」
./scripts/build-hap.sh                  # assembleHap,BUILD SUCCESSFUL
./scripts/run-unit-tests.sh             # 顺带完成单元测试:须 24/24 PASS(R2 新增 D17 回归用例)
# 上面脚本会把 main+test 两个 hap 同命令装入模拟器
```

模拟器:DevEco Emulator 实例 `kk02phone`(phone;应用 compatibleSdkVersion=4.1.0(11),模拟器镜像实测 API 版本以 `hdc shell param get const.ohos.apiversion` 为准并**如实记录**,两者不一致属预期,不得改写为一致)。
启动:`nohup /Users/njx/apps/deveco-tools/command-line-tools/bin/Emulator -start kk02phone >/tmp/emu.log 2>&1 &`
就绪判定:`hdc shell param get bootevent.boot.completed` = true。
**如实记录模拟器型号/镜像/API 版本进 receipt。**

## 3. 必经旅程(required journeys)

按序操作,每步截图(命名见 §4):

1. **voice first view**:冷启动首屏(灵犀标题、状态条、离线声明)
2. **permission state**:首次点捕获键 → 系统权限弹窗;先「不允许」→ 应用跳转设置页;设置页授予 → 返回
3. **enrollment**:开始注册采样 ×3(macOS `say -v Tingting` 播中文句,每句约 6-8s,说完点停止)→ 「注册完成(3/3)」且状态条立即显示 `ENROLLED`(R2-D14 回归点)
4. **capture + VERIFIED**:🎙 开始说话,Tingting 播一句知识类中文 → 停止 → `说话人:VERIFIED · 相似度 …` + 信任门通过
5. **transcript / proxy disclosure**:转写文本与「CoreSpeechKit 离线中文 (on-device,无云端)」同框
6. **candidate**:候选卡(未入库 · 待你确认)
7. **correction**:编辑候选文本 → 保存修正
8. **reject**:下一次捕获 → 候选卡 → 丢弃 → 「已丢弃…知识没有变化」
9. **confirm**:候选卡 → 确认入库
10. **knowledge update**:标题栏「知识 N 条」计数 +1
11. **Agent context return**:入库/丢弃后 Agent 消息即时出现
12. **UNCERTAIN**:静音或极弱音频捕获 → `说话人:UNCERTAIN` → 信任门拦截(带再验证提示)
13. **NOT_AVAILABLE + TEST_FIXTURE**:噪声捕获(afplay 白噪声)或 STT 故障 boot → VERIFIED + 无转写 → 信任门拦截 NOT_AVAILABLE → fixture 注入行出现 → 注入测试转写 → 候选卡 `TEST_FIXTURE` 标题 + 琥珀警示条 + 「转写(测试代理)」
    - fixture 触发依赖 STT 不可用;若本 boot STT 始终可用,可冷启动模拟器重试(每次 boot STT 可用性不同),如实记录尝试次数
14. **NOT_VERIFIED**:若自然可达(相似度 <0.45)截图;若模拟器声学路径不可达,如实记录 UNREACHABLE_ON_SIMULATOR 并附实测分数矩阵(机主/异嗓/噪声/静音)
15. **error recovery**:制造 STT 错误(如快速开始/停止)→ 错误条如实显示,应用不崩,可继续下一次捕获
16. **reset 确认弹窗**(R2-D15 回归点):重置声纹 → 弹窗 → 取消(档案保留)→ 再次 → 确认重置(档案删除,状态条 NOT_ENROLLED)
17. **foreground/background**:录音中 Home → 回前台 → 停止 → 状态一致无崩溃

## 4. 截图清单与落盘

至少 16 张,对应 §3 编号,文件名 `NN-<journey>.jpeg`(如 `03-enrollment-complete.jpeg`):

```text
01-first-view  02-permission  03-enrollment  04-capture  05-transcript-disclosure
06-verified    07-candidate   08-correction  09-reject   10-confirm
11-knowledge-update  12-agent-context  13-uncertain  14-not-available-fixture
15-error-recovery    16-reset-confirm
(17-not-verified 可达则附,不可达则在 receipt 说明)
```

落盘:`reports/prototype/knowme-knowledge-02-voice-speaker-verification/screenshots/local-executor/`
截图命令:`hdc shell snapshot_display -f /data/local/tmp/x.jpeg` + `hdc file recv`。

## 5. 产出

1. `reports/prototype/knowme-knowledge-02-voice-speaker-verification/LOCAL_EXECUTION_RECEIPT.md`(净化版):
   - CONTEXT_ID、exact SHA、tree、parent、构建产物 hash、模拟器环境、逐旅程 PASS/FAIL/UNREACHABLE、单元测试结果、发现的 defect(如有)、诚实声明 `REAL_DEVICE_NOT_REVIEWED=YES`
2. 上述截图目录
3. **发现 defect → 停止并报告 ED**(缺陷循环:修复后新 SHA,全部重跑)

## 6. 操作提示(ED 实测踩坑)

- 布局随 Agent 消息增多会下移:**每次点击前重新 dump 布局取坐标**,可用 `scripts/kk02_ui.py click <按钮文字>`(新鲜坐标,Button 优先)
- 输入文字后键盘遮挡按钮:`uitest uiInput keyEvent Back` 收键盘再取坐标
- 两个 hap 必须**同一条 hdc install 命令**安装,分装会互相覆盖
- macOS 音量调大:`osascript -e 'set volume output volume 100'`
