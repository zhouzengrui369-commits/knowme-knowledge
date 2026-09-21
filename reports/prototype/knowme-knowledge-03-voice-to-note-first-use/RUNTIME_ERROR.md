# RUNTIME ERROR — 运行时错误观察

## 头部标识

- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1
- PR = #32（draft, OPEN）
- DATE = 2026-09-22
- ENVIRONMENT = OpenHarmony emulator（kk02phone）, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555

## run3 运行时结论

- **无 APP_FREEZE**：LE run3（22/22 旅程）与 ED 本人操作（21/21）全程未发生应用冻结。
- **无崩溃**：全程无 crash；DEFECTS_FOUND = NONE（双轨）。
- 录音时钟长时间持续走动不冻结（LE-04：00:01→00:35，截图 [05](./screenshots/local-execution-run3/05-LE-04-recording-clock-ticks.jpeg)；ED-04：00:02→00:10，截图 [ed-04](./screenshots/ed-personal/ed-04-recording-clock-ticking.jpeg)）。

## D-LE-01 冻结缺陷修复后的长采样回归

- 缺陷原貌（run1 @4771c85）：~67s 声纹采样停止后主线程阻塞，APP_FREEZE 被系统杀掉；faultlog 栈：sherpa compute←extract←addEnrollmentSample←stopSession。
- 修复（→15ff3a8）：`boundedAnalysisPcm` 10 秒上限。
- 回归证据：
  - run2 @15ff3a8：73s 长采样回归无冻结（该轮证据后因 D-KK03-03 候选变动按 §28 作废，回归由 run3 重验继承）。
  - run3 @d02014f：LE-20，70 秒+采样不冻结、计数正常（02:06）、录入完成(3/3)。截图：[39](./screenshots/local-execution-run3/39-LE-20a-enroll-sampling-started.jpeg) [40](./screenshots/local-execution-run3/40-LE-20b-enroll-mid-sampling-38s.jpeg) [41](./screenshots/local-execution-run3/41-LE-20c-enroll-after-70s-before-stop.jpeg) [42](./screenshots/local-execution-run3/42-LE-20d-enroll-sample1-done.jpeg) [43](./screenshots/local-execution-run3/43-LE-20e-enroll-sample2-done.jpeg) [44](./screenshots/local-execution-run3/44-LE-20f-enroll-complete-3of3.jpeg)。

## 模拟器 STT 间歇报错 1002200010（环境噪声说明）

- 现象：诊断区如实记录「STT 错误 1002200010: Write audio failed because the start listening is failed」（截图 [46-LE-21b-verified-note-saved.jpeg](./screenshots/local-execution-run3/46-LE-21b-verified-note-saved.jpeg)）。
- 定性：**模拟器环境噪声，非应用缺陷**。模拟器上 STT 引擎间歇性启动失败，同一台模拟器上 STT 有时成功（LE-21、LE-22a 重录第 1/3 次）有时失败（LE-22b、LE-22a 静音那次）。
- 应用行为：对两种结果均正确——成功 → 真实候选；失败 → NOT_AVAILABLE 诚实拦截 + 解释，无云端回退。ED 回执非缺陷观察 N1 同样记录该间歇性（每次 boot 识别可用性不同）。
- 其他环境噪声（非缺陷，如实记录）：合成语音 STT 错字（如「测试转写后选流程」「第2季祝您」「青春我在测试英雄。」）；软键盘遮挡保存按钮（Back 可收起，平台通用行为）；模拟器时钟与宿主机时区偏差。

## 结论

冻结候选 run3 运行期无冻结、无崩溃；历史冻结缺陷（D-LE-01）有 70s+/73s 长采样回归证据；唯一持续观察到的报错为模拟器 STT 环境噪声，应用如实披露并诚实拦截。
