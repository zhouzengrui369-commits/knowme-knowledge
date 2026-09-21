# REGRESSION — 缺陷回归证据

## 头部标识

- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1
- PR = #32（draft, OPEN）
- DATE = 2026-09-22
- ENVIRONMENT = OpenHarmony emulator（kk02phone）, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555

## 单元测试基线

- **67 / 67 PASS**（冻结候选 d02014f，hvigor 构建 BUILD SUCCESSFUL 后执行）。新增测试覆盖 NoteFlow（+253 行）、FixtureTranscript（+21 行）、VoiceCore（+44 行），见 ALLOWED_PATH_DIFF_RECEIPT.md。

## 缺陷回归明细

### D-KK03-01 — 纯标点转写曾放行成为候选

- 发现：ED 探索轮，@4771c85 修复前。
- 修复：`hasMeaningfulTranscript` 门控——纯标点（如「。」）等无意义转写按无可用转写诚实拦截，不再放行成为候选。
- 回归证据（d02014f）：**LE-22c（OBSERVED_NATURALLY）**——纯标点/无意义转写场景自然出现且门控诚实：VERIFIED 0.663/0.713 + NOT_AVAILABLE 拦截（静音录音）。截图：[49-LE-22a-silence-attempt1-result.jpeg](./screenshots/local-execution-run3/49-LE-22a-silence-attempt1-result.jpeg)、[71-LE-22a-silent-result.jpeg](./screenshots/local-execution-run3/71-LE-22a-silent-result.jpeg)。

### D-KK03-02 = D-LE-01 — 长采样停止后主线程冻结

- 发现：LE run1 @4771c85：~67s 声纹采样停止后主线程阻塞，APP_FREEZE 被系统杀掉（faultlog 栈：sherpa compute←extract←addEnrollmentSample←stopSession）。
- 修复：`boundedAnalysisPcm` 10 秒上限——分析用 PCM 有界化，停止采样后不再全量重算；候选变动 → 15ff3a8。
- 回归证据：
  - run2 @15ff3a8：**73s 长采样回归无冻结**（run2 整体 21/21 PASS；后因 D-KK03-03 候选再变动，run2 证据按 §28 作废，回归结论由 run3 继承重验）。
  - run3 @d02014f：**LE-20（PASS）**——70 秒+声纹采样，计数正常（02:06），不冻结，录入完成(3/3)。截图：[39](./screenshots/local-execution-run3/39-LE-20a-enroll-sampling-started.jpeg) [40](./screenshots/local-execution-run3/40-LE-20b-enroll-mid-sampling-38s.jpeg) [41](./screenshots/local-execution-run3/41-LE-20c-enroll-after-70s-before-stop.jpeg) [42](./screenshots/local-execution-run3/42-LE-20d-enroll-sample1-done.jpeg) [43](./screenshots/local-execution-run3/43-LE-20e-enroll-sample2-done.jpeg) [44](./screenshots/local-execution-run3/44-LE-20f-enroll-complete-3of3.jpeg)。

### D-KK03-03 — 注入测试转写误拒且静默

- 发现：ED 本人 @15ff3a8：注入测试转写路径在纯标点场景被 `length>0` 误拒，且按钮静默无反应。
- 修复：改为只在已有有意义转写时拒绝 + 拒绝时给解释文案；候选变动 → d02014f（冻结候选）。
- 回归证据（d02014f，LE run3）：
  - **LE-22a（PASS）**：VERIFIED 0.713 + NOT_AVAILABLE 拦截态下注入成功，全程 TEST_FIXTURE 标注（候选卡「TEST_FIXTURE 测试转写·未入库」→ 草稿 → 保存知识 3→4；保存消息带 ⚠️ 来源警示；列表条目带「TEST_FIXTURE 演示」徽标）。截图：[71](./screenshots/local-execution-run3/71-LE-22a-silent-result.jpeg) [72](./screenshots/local-execution-run3/72-LE-22a-inject-final.jpeg) [73](./screenshots/local-execution-run3/73-LE-22a-inject-done.jpeg) [74](./screenshots/local-execution-run3/74-LE-22a-organized.jpeg) [75](./screenshots/local-execution-run3/75-LE-22a-saved.jpeg)（前置操作轨迹 60~70）。
  - **LE-22b（PASS）**：空输入点「注入测试转写」被拒绝且解释原因、不静默：「注入被拒绝:请输入测试转写文本;若已有真实转写,请先丢弃再试。」截图：[47](./screenshots/local-execution-run3/47-LE-22b-empty-injection-refused.jpeg) [53](./screenshots/local-execution-run3/53-LE-22b-empty-injection-refused-explained.jpeg) [54](./screenshots/local-execution-run3/54-LE-22b-refusal-message.jpeg)
  - **LE-22c（OBSERVED_NATURALLY）**：纯标点门控自然观察到（见 D-KK03-01）。

## 结论

三个缺陷均在冻结候选 d02014f 上有正向回归证据；run3 全程 DEFECTS_FOUND = NONE；单元测试 67/67 PASS。
