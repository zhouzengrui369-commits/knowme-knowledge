# TRANSCRIPT CANDIDATE — 转写候选与信任门拦截

## 头部标识

- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1
- PR = #32（draft, OPEN）
- DATE = 2026-09-22
- ENVIRONMENT = OpenHarmony emulator（kk02phone）, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555

## 主张

录音停止后，信任门按验证结果分流：VERIFIED 生成候选卡并明示「未入库·不会自动保存」；NOT_ENROLLED / UNCERTAIN / NOT_AVAILABLE 诚实拦截、不入库、给解释与后续选项。

## ED 本人操作证据

- **ED-06（PASS，NOT_ENROLLED）**：未录入声纹时停止录音，「本次验证:NOT_ENROLLED·相似度—」「信任门拦截:尚未注册机主声纹」，知识仍 0。截图：[ed-06-not-enrolled-intercept.jpeg](./screenshots/ed-personal/ed-06-not-enrolled-intercept.jpeg)
- **ED-09（PASS，UNCERTAIN）**：较短语句录音停止，「UNCERTAIN·相似度 0.456」「信任门拦截:无法确定是谁(UNCERTAIN),不入库」，知识仍 0（消息流见 [ed-16](./screenshots/ed-personal/ed-16-note-saved-plus1.jpeg)）。
- **ED-10（PASS，VERIFIED 候选）**：长语句（~22s）录音停止，VERIFIED 0.792，候选卡标注「转写候选(未入库 · 不会自动保存)」。截图：[ed-11-verified-candidate.jpeg](./screenshots/ed-personal/ed-11-verified-candidate.jpeg)
- **ED-21（PASS，候选丢弃）**：UNCERTAIN/拦截片段点「丢弃」，知识 +0、片段清除。截图：ed-06、ed-16 消息流。
- 另有 ED-16 中新录音 VERIFIED 0.686、ED-17 中 VERIFIED 0.741、ED-19 中 VERIFIED 0.815 的候选生成（见各旅程截图）。

## Local Execution 交叉佐证

- **LE-05b/06（PASS）**：未录入声纹停止真实录音，NOT_ENROLLED 诚实拦截、不入库。截图：[07-LE-05b-06-stop-notenrolled.jpeg](./screenshots/local-execution-run3/07-LE-05b-06-stop-notenrolled.jpeg)
- **LE-06b/c（PASS）**：展开 TEST_FIXTURE 区生成演示候选，候选卡带 TEST_FIXTURE 标注、未入库。截图：[08](./screenshots/local-execution-run3/08-LE-06b-testfixture-expanded.jpeg) [09](./screenshots/local-execution-run3/09-LE-06c-fixture-candidate-card.jpeg)
- **LE-21（PASS）**：声纹已录入后真实语音（Tingting 合成音）走主路径，VERIFIED 0.771。截图：[45-LE-21a-voice-attempt1-result.jpeg](./screenshots/local-execution-run3/45-LE-21a-voice-attempt1-result.jpeg)
- **LE-22c（OBSERVED_NATURALLY）**：纯标点/无意义转写场景自然出现且门控诚实：VERIFIED 0.663/0.713 + NOT_AVAILABLE 拦截（静音录音）。截图：[49](./screenshots/local-execution-run3/49-LE-22a-silence-attempt1-result.jpeg) [71](./screenshots/local-execution-run3/71-LE-22a-silent-result.jpeg)
- **LE-19c（PASS）**：各异常态均有解释（截图 07、08、13、17）。

## 结论

信任门三种拦截（NOT_ENROLLED / UNCERTAIN / NOT_AVAILABLE）与 VERIFIED 候选路径均按设计诚实呈现，候选明示未入库，双轨 PASS。
