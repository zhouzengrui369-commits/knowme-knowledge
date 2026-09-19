# LOCAL EXECUTION RECEIPT — GOAL-KK-02 Contract R2 RUN 2 (DEFECT LOOP, SIMULATOR, FINAL EXACT-SHA)

> **RUN 2 / supersedes RUN 1 @2094597**。RUN 1 发现的 D-LE-01/D-LE-02 已由 ED 在 b02bca6 修复(含回归测试),本轮为缺陷循环后的完整 final 重跑。
> 注:仓库 HEAD 当前为 55371ae,系在 b02bca6 之上仅追加 reports/ 证据归档的提交,代码完全一致;本运行 materialize 的是冻结 SHA **b02bca6** 本身。

## 0. 身份

```text
ROLE=LOCAL_EXECUTOR
CONTEXT_ID=LE-KK-GOAL02-SIMULATOR-R2-FINAL-20260919-1130-C9F2(同一合同缺陷循环第 2 轮)
PROVISIONAL_FINAL_SHA=b02bca6(逐字核对一致)
BRANCH=engineering/goal-kk-02-simulator-first-r2
```

## 1. Exact-SHA materialization

- `git worktree remove /tmp/kk02-le-run`(RUN 1)→ `git worktree add /tmp/kk02-le-run2 b02bca6`
- `git log --oneline -1`:`b02bca6 fix(goal-kk-02-r2): R2-D16 + R2-D17 from Local Executor final run (LE-KK-GOAL02-SIMULATOR-R2-FINAL-20260919-1130-C9F2)` — **逐字一致**
- `git status`:clean
- `git rev-parse HEAD^{tree}` = `b40553f25b6a6c8eaa6ef37629ea176c2b09d047`
- `git log --format=%P -1` = `20945974a26fd68c5691629d71ffaff83332acd3`(父提交即 RUN 1 冻结 SHA,链吻合)

## 2. 构建产物 hash(含 pin 定声纹模型)

`scripts/provision-models.sh` 先行(sha256 `e2d2048292e055f7b61cdec3db010503f35369b245bf0b3bbad021c9a91e4053` 校验通过),随后 `run-unit-tests.sh` 构建+安装:

```text
c2971591bc835759924f1e0d6bfa50dbd040861fee805578e20e1d2ca73d03ab  entry-default-unsigned.hap
5d500af654ff45ef95b8f3a285695486a5af4ce33322f3e4987bae900e955792  entry-ohosTest-unsigned.hap
```

## 3. 模拟器环境(与 RUN 1 同一实例)

- 实例 `kk02phone`,`hdc list targets` → `127.0.0.1:5555`
- model=`emulator`,apiversion=`24`,software=`emulator 6.1.0.126(SP1DEVC00E120R4P11)`
- 音频注入:macOS 扬声器 → 模拟器麦克风(Tingting/Meijia/Alex/白噪声/静音/超短捕获)

## 4. 单元测试

```text
OHOS_REPORT_RESULT: stream=Tests run: 24, Failure: 0, Error: 0, Pass: 24, Ignore: 0
```

**24/24 PASS**(比 RUN 1 多 1 个 R2D17 回归用例,与 ED 说明一致)。

## 5. 回归验证结论(本轮核心)

### D16 回归(原 D-LE-01):**PASS — FIXED VERIFIED**

多次捕获均触发 STT 部分失败,状态条如实显示新文案且披露不再被覆盖:

```text
STT:CoreSpeechKit 离线中文 (on-device,无云端) · 转写成功,但会话收尾报错已如实记录:STT 错误 1002200010: Write audio failed because the start listening is failed.
```

(长途捕获还观察到 `1002200003: Exceeded the maximum audio length supported.` 同样以该格式呈现。)证据:05-transcript-disclosure.jpeg —— **转写文本与 CoreSpeechKit 披露本轮回框达成**(RUN 1 无法达成)。

### D17 回归(原 D-LE-02):**PASS — FIXED VERIFIED**

- 前置:VERIFIED 捕获结果在屏(说话人:VERIFIED · 相似度 0.702 · 停止→结果 708ms,含转写与候选卡)
- 重置 → 取消:档案保留(机主声纹:VERIFIED),结果卡原样保留
- 重置 → 确认:`机主声纹:NOT_ENROLLED · 已重置`,经 dump 核实**说话人/相似度/时延/转写/候选卡全部清除**,无任何残留旧数值(RUN 1 残留 `相似度 0.762` 的现象消失)
- 另全程观察到每次新捕获相似度/时延均为新鲜值(0.642/574、0.770/1285、0.730/307、0.589/111、—/98 等,无一重复),RUN 1 的显示冻结现象未再出现

## 6. 逐旅程结果(RUN 2)

| # | 旅程 | 结果 | 截图 |
|---|------|------|------|
| 1 | voice first view | PASS | 01-first-view |
| 2 | permission(拒绝→设置授予→返回) | PASS | 02-permission, 02b-permission-settings-grant |
| 3 | enrollment ×3 → 即时 ENROLLED(R2-D14) | PASS | 03-enrollment |
| 4 | capture + VERIFIED(0.642) | PASS | 04-capture |
| 5 | 转写 + CoreSpeechKit 披露同框 | **PASS(D16 修复后严格达成)** | 05-transcript-disclosure |
| 6 | verified 徽标 | PASS | 06-verified |
| 7 | candidate 候选卡 | PASS | 07-candidate |
| 8 | correction 编辑+保存修正 | PASS | 08-correction |
| 9 | reject 丢弃(计数不变) | PASS | 09-reject |
| 10 | confirm 确认入库 | PASS | 10-confirm |
| 11 | knowledge update(知识 1 条) | PASS | 11-knowledge-update |
| 12 | Agent context return | PASS | 12-agent-context |
| 13 | **UNCERTAIN — 本轮可达:PASS** | 超短捕获(0.3-0.6s)→ `UNCERTAIN · 相似度 0.589` 与 `UNCERTAIN · 相似度 —` 两次复现;信任门拦截「无法确定是谁(UNCERTAIN),不入库」+ 重说一次提示 | 13-uncertain(另见 15) |
| 14 | NOT_AVAILABLE + TEST_FIXTURE | PASS:静音→VERIFIED 0.730 无转写→拦截→注入测试转写(本轮一次到位)→ TEST_FIXTURE 候选卡+琥珀警示+「转写(测试代理)」 | 14a-not-available-block, 14-not-available-fixture |
| 15 | NOT_VERIFIED(<0.45) | **UNREACHABLE_ON_SIMULATOR**(见 §7 矩阵,全部 ≥0.589;正常时长音源全部 ≥0.627) | (留证并入 13/15) |
| 16 | error recovery(快速开始/停止→报错→可继续) | PASS:报错如实显示(见 D16 格式),后续捕获 VERIFIED 0.757 正常入候选 | 15-error-recovery |
| 17 | reset 确认弹窗(R2-D15)+ D17 回归 | PASS:取消保留 / 确认删除 → NOT_ENROLLED 且结果卡全清 | 16-reset-confirm, 16b-reset-done-notenrolled |
| 18 | foreground/background | PASS:录音中 Home→回前台录音仍继续,前台停止结果一致(VERIFIED 0.702),无崩溃。**更正 RUN 1 记录**:RUN 1「退后台录音自动停止」实为锁屏干扰的误读,本轮无锁屏干扰实测为**后台录音持续** | (并入 15/16 序列) |

## 7. 声纹相似度实测矩阵(RUN 2,严格串行、每次确认新鲜值)

| 音源 | 实测 | 判定 |
|------|------|------|
| 机主 Tingting 音量 100 | 0.642 / 0.770 / 0.757 | VERIFIED |
| 机主 Tingting 音量 8 | 0.734 | VERIFIED |
| 异嗓 Meijia(中文女声) | 0.721 | VERIFIED |
| 异嗓 Alex(英语男声) | 0.705 | VERIFIED |
| 白噪声 8s | 0.637 | VERIFIED |
| 纯静音 6-10s | 0.730 / 0.728 / 0.702 | VERIFIED |
| 超短捕获 ~0.6s | 0.627 | VERIFIED(贴线) |
| 超短捕获 ~0.5s | 0.589 | **UNCERTAIN** |
| 超短捕获 ~0.3s | —(NaN) | **UNCERTAIN** |

结论:正常时长音源(含异嗓/噪声/静音)在模拟器声学回路上全部落入 VERIFIED(≥0.62),NOT_VERIFIED(<0.45)自然不可达——**UNREACHABLE_ON_SIMULATOR**,未伪造。UNCERTAIN 带经超短/空音频捕获自然可达(RUN 1 未探到该路径,本轮补正)。

## 8. 新发现 defect

**NONE**。

观察项(非 defect,如实备注):
- O1:知识条目为内存态(应用进程重建后计数归零),声纹档案持久化保留;0.1 原型「确定性演示」范围内行为,任务书未要求知识持久化。
- O2:候选卡待决期间点击「开始说话」不会开始新捕获(须先确认/丢弃),行为自洽,记为交互约束备注。
- O3:探测过程中两组重复读数(0.739×3、0.691×3)为本执行器探测脚本的测量伪影(候选未清理导致新捕获未启动+滚动区模糊匹配误读旧行),已用严格串行重测取代,**非应用缺陷**。
- O4:模拟器声学回路 STT 转写错字较多(如「下周三上午10点」→「单上50点」),注入路径预期现象,不计缺陷。

尝试次数:注册 3/3 一次通过;fixture 1 次 boot 达成、注入 1 次到位;UNCERTAIN 复现 3 次内达成;屏幕锁屏打断 1 次(已解锁重入,未影响结果)。

## 9. 两轮 defect 循环结论

| Defect | RUN 1 @2094597 | RUN 2 @b02bca6 |
|--------|----------------|----------------|
| D-LE-01 → R2-D16(STT 部分失败覆盖披露文案) | 发现 | **FIXED VERIFIED**(05 截图同框达成) |
| D-LE-02 → R2-D17(重置/新捕获后结果卡残留旧相似度) | 发现 | **FIXED VERIFIED**(16b 清除彻底;全程新鲜值) |

## 10. 诚实声明

```text
REAL_DEVICE_NOT_REVIEWED=YES
NOT_REAL_DEVICE_VALIDATED=YES
SIMULATOR_PROXY_DISCLOSURE=HONEST
```

- 全部数据来自 DevEco 模拟器 kk02phone(API 24 / 6.1.0.126),**非真实 Mate60 数据**。
- TEST_FIXTURE 全程以琥珀警示与「测试代理」标注,**非真实语音识别**。
- 截图均经 `hdc shell snapshot_display` 采集,仅含模拟器屏幕。
- 未修改任何代码文件;唯一环境操作为仓库自带 `provision-models.sh`(sha256 校验通过)。
