# LOCAL EXECUTION RECEIPT — GOAL-KK-02 Contract R2 (SIMULATOR-FIRST, FINAL EXACT-SHA RUN)

## 0. 身份

```text
ROLE=LOCAL_EXECUTOR
CONTEXT_ID=LE-KK-GOAL02-SIMULATOR-R2-FINAL-20260919-1130-C9F2
PROVISIONAL_FINAL_SHA=2094597(逐字核对一致)
BRANCH=engineering/goal-kk-02-simulator-first-r2
```

## 1. Exact-SHA materialization

- 方式:`git worktree add /tmp/kk02-le-run 2094597`(detached HEAD)
- `git log --oneline -1`:`2094597 docs(goal-kk-02-r2): LOCAL-EXECUTOR-BRIEF-R2-SIMULATOR — simulator-first final exact-SHA run brief (16-screenshot matrix, fixture journey with STT-failure retry note, D14/D15 regression points, sanitization + honesty requirements); supersedes real-device R1 brief for R2` — **逐字一致**
- `git status`:clean(构建产物为未跟踪输出,不改源码)
- `git rev-parse HEAD^{tree}` = `694a235927e40c42130f35df45b7caac7b93577f`
- `git log --format=%P -1` = `11e7a73170ad120a86e674c3aad8c4286b7b733c`

## 2. 构建产物 hash(含声纹模型的最终构建)

第一次构建未含声纹模型(fresh worktree 无 rawfile 资产),注册采样报「引擎未就绪」;按仓库自带脚本 `scripts/provision-models.sh` 下载 pin 定模型(sha256 `e2d2048292e055f7b61cdec3db010503f35369b245bf0b3bbad021c9a91e4053`,匹配)后重建重装。以下为**最终安装在模拟器上、用于全部旅程的构建**:

```text
a02ca66130a56d3b7f6b2db764c334aaa5716720c5aed005db2448b8e701107c  entry-default-unsigned.hap
41b8c4dc0f5ad6987702fc198fabffb711e2a1e3e2212efa3830d991f33bfb7a  entry-ohosTest-unsigned.hap
```

(首次无模型构建 hash 备查:main `8044e46d…b1d0f`,ohosTest `e4b2f358…77cff`。)

## 3. 模拟器环境(如实记录)

- 实例名:`kk02phone`(DevEco Emulator,phone)
- 连接:`hdc list targets` → `127.0.0.1:5555`
- `const.product.model` = `emulator`
- `const.ohos.apiversion` = `24`
- `const.product.software.version` = `emulator 6.1.0.126(SP1DEVC00E120R4P11)`
- 音频注入:macOS 扬声器 → 模拟器麦克风(`say -v Tingting/Meijia/Alex`、`afplay` 白噪声、静音)
- **注意**:任务书 §2 写的是「API 11 / 4.1.0(11)」,实测镜像为 API 24 / 6.1.0.126。如实记录,以实测为准。

## 4. 单元测试

```text
OHOS_REPORT_RESULT: stream=Tests run: 23, Failure: 0, Error: 0, Pass: 23, Ignore: 0
OHOS_REPORT_CODE: 0
```

**23/23 PASS**(含模型重建后复跑,同样 23/23)。hvigor onDeviceTest 覆盖率步骤的 "signed.hap does not exist" 为预期良性错误(未签名构建),脚本已忽略。

## 5. 逐旅程结果

| # | 旅程 | 结果 | 截图 | 备注 |
|---|------|------|------|------|
| 1 | voice first view | PASS | 01-first-view | 灵犀标题、状态条、离线声明确认 |
| 2 | permission | PASS | 02-permission, 02b-permission-settings-grant | 「不允许」→ 应用内跳转设置页 → 授予 → 返回后「权限已授予」;重装 hap 会重置权限(已记录) |
| 3 | enrollment | PASS | 03-enrollment | 3/3 完成,状态条立即 `ENROLLED · 注册完成(3/3)` — **R2-D14 回归点 PASS** |
| 4 | capture + VERIFIED | PASS | 04-capture | `VERIFIED · 相似度 0.724 · 停止→结果 405ms`,信任门通过 |
| 5 | transcript / proxy disclosure | PASS-WITH-NOTE | 05-transcript-disclosure | 录音中截图含 `STT:CoreSpeechKit 离线中文 (on-device,无云端)` + sherpa-onnx + 全程本地披露;停止后该行被错误文本覆盖(见 D-LE-01),转写与披露无法在同一停止后画面同框 |
| 6 | candidate | PASS | 06-verified, 07-candidate | 候选卡「未入库 · 待你确认」+ 三按钮 |
| 7 | correction | PASS | 08-correction | 编辑候选文本(插入「补充:会议地点在3号会议室。」)→ 保存修正生效 |
| 8 | reject | PASS | 09-reject | 丢弃 → 「已丢弃这段语音转写,知识没有变化」,计数不变 |
| 9 | confirm | PASS | 10-confirm | 确认入库 → 「已入库:…是你确认后才进入知识的」 |
| 10 | knowledge update | PASS | 11-knowledge-update | 标题栏「知识 1 条」(后含手动文本共 2 条) |
| 11 | Agent context return | PASS | 12-agent-context | 入库/丢弃后 Agent 消息即时出现 |
| 12 | UNCERTAIN | **UNREACHABLE_ON_SIMULATOR** | 13-uncertain-UNREACHABLE-on-simulator | 见 §6 分数矩阵;8+ 次变体尝试全部 ≥0.62 → VERIFIED |
| 13 | NOT_AVAILABLE + TEST_FIXTURE | PASS | 14a-not-available-block, 14-not-available-fixture | 静音捕获 → VERIFIED + 无转写 → 信任门拦截 NOT_AVAILABLE → fixture 注入行 → 注入 → `候选知识(TEST_FIXTURE 测试转写)` + 琥珀警示条 + 「转写(测试代理)」全程标注。**本 boot 即触发,冷启动重试 0 次** |
| 14 | NOT_VERIFIED | **UNREACHABLE_ON_SIMULATOR** | (无,见 13 留证) | 见 §6 分数矩阵,全部音源 ≥0.62,>0.45 阈值 |
| 15 | error recovery | PASS | 15-error-recovery | 快速开始/停止 ×2 → `STT 错误 1002200010` 如实显示,应用不崩;下一次捕获成功(VERIFIED + 转写 + 候选) |
| 16 | reset 确认弹窗 | PASS | 16-reset-confirm, 16b-reset-done-notenrolled | 弹窗 → 取消(回到主界面,档案保留)→ 再次 → 确认重置 → `NOT_ENROLLED · 已重置` — **R2-D15 回归点 PASS** |
| 17 | foreground/background | PASS-WITH-NOTE | (并入 15/16 序列) | 录音中 Home → 麦克风自动停止(「待开始」)→ 回前台状态一致,无崩溃,可停止/继续 |

## 6. 声纹相似度实测矩阵(旅程 12/14 不可达证据)

阈值(源码 `VoiceCore.ets`,contract-frozen):VERIFIED ≥ 0.62;UNCERTAIN [0.45, 0.62);NOT_VERIFIED < 0.45。

| 音源 | 条件 | 实测相似度 | 判定 |
|------|------|-----------|------|
| 机主 Tingting(中文) | 音量 100 | 0.724 / 0.781 | VERIFIED |
| 机主 Tingting | 音量 25 | 0.635 | VERIFIED |
| 机主 Tingting | 音量 8 | 0.751 | VERIFIED |
| 异嗓 Meijia(中文女声) | 音量 60 | 0.662 | VERIFIED |
| 异嗓 Alex(英语男声) | 音量 60 | 0.773 | VERIFIED |
| 白噪声(8s) | 音量 60 | 0.712 | VERIFIED |
| 白噪声 | 音量 8 | 0.779 | VERIFIED |
| 纯静音 4s / 10s | 音量 0 | 0.762 / 0.823 | VERIFIED |
| 静音(fixture 旅程) | — | 0.685 / 0.785 | VERIFIED |

实测区间 0.635–0.823,全部 ≥ 0.62。模拟器扬声器→麦克风回路对不同音源的嵌入区分度不足,UNCERTAIN 带与 NOT_VERIFIED 在本模拟器声学路径上**自然不可达**,与 ED 预注一致。未伪造任何截图。

## 7. 发现的 defect(如实记录,未自行修复)

- **D-LE-01(显示层)**:每次成功捕获停止后,STT 状态行持续显示 `STT 错误 1002200010: Write audio failed because the start listening is failed.`,覆盖本应常驻的「CoreSpeechKit 离线中文 (on-device,无云端)」引擎说明;而转写实际成功。影响:任务书旅程 5 要求的「转写文本与 CoreSpeechKit 披露同框」只能在录音中画面达成(05 截图)。疑似每次 capture start 的 writeAudio 抢跑产生残留错误文案。
- **D-LE-02(显示层)**:结果卡「说话人:… · 相似度 X · 停止→结果 Yms」疑似 stale:多次不同新捕获后仍显示完全相同的 `0.762 / 211ms`(转写行已更新为新内容);重置声纹后仍显示 `说话人:NOT_ENROLLED · 相似度 0.762 · 停止→结果 211ms`(相似度应为 —)。
- **观察项(非 defect)**:模拟器声学回路 STT 转写质量差(「快速捕捉灵感」→「坏速捕捉灵感」等),属扬声器→麦克风注入路径预期,不计缺陷。
- **观察项(环境)**:fresh worktree 不含未提交的模型资产,首构建注册报「引擎未就绪」;按仓库脚本 provision 后解决。建议 ED 在任务书 §2 补上 `provision-models.sh` 步骤。

尝试次数记录:注册采样 4 次(1 次无模型无效 + 3 次有效);fixture 旅程 1 次 boot 即达成(冷启动重试 0 次),注入操作 2 次(第 1 次误入上方手动文本框,产生一条「手动文本」知识,使计数为 2 条;第 2 次滚动至 fixture 专用行注入成功);UNCERTAIN/NOT_VERIFIED 探测捕获共 9 次(矩阵如上)。

## 8. 诚实声明

```text
REAL_DEVICE_NOT_REVIEWED=YES
NOT_REAL_DEVICE_VALIDATED=YES
SIMULATOR_PROXY_DISCLOSURE=HONEST
```

- 全部数据来自 DevEco 模拟器 `kk02phone`(API 24 / 6.1.0.126),**不是真实 Mate60 数据**。
- TEST_FIXTURE 流程全程以界面琥珀警示与「测试代理」标注呈现,**不是真实语音识别**。
- 截图全部经 `hdc shell snapshot_display` 采集,仅含模拟器屏幕,无宿主桌面/个人账号信息。
- 未修改任何代码文件;唯一环境补全为运行仓库自带 `scripts/provision-models.sh` 下载 pin 定模型资产(sha256 校验通过)。
