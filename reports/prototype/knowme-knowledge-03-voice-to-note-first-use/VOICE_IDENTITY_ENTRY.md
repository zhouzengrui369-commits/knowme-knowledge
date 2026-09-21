# VOICE IDENTITY ENTRY — 声纹身份入口语义

## 头部标识

- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1
- PR = #32（draft, OPEN）
- DATE = 2026-09-22
- ENVIRONMENT = OpenHarmony emulator（kk02phone）, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555

## 主张

声纹入口语义清晰：「声纹档案」是长期身份状态，「本次验证」只是某一次录音的结果，两者互不代表；录入面板明示原型边界。

## ED 本人操作证据

- **ED-07（PASS）**：打开声纹管理面板，实际一致：「机主声纹(原型验证,非生产身份认证)」「声纹档案是你的长期身份状态;「本次验证」只是某一次录音的结果,两者互不代表。」截图：[ed-07-voiceprint-panel.jpeg](./screenshots/ed-personal/ed-07-voiceprint-panel.jpeg)
- **ED-08（PASS）**：3 段采样录入（say 合成语音，每段 ~16s），采样计数正常，显示「声纹档案:已录入(本地声纹档案)·录入完成(3/3)」，回声标注「注册采样回声(非本次验证)」。截图：[ed-08-enroll-sample-1of3.jpeg](./screenshots/ed-personal/ed-08-enroll-sample-1of3.jpeg)、[ed-08-enroll-sample-2of3.jpeg](./screenshots/ed-personal/ed-08-enroll-sample-2of3.jpeg)、[ed-08-enroll-sample-3of3.jpeg](./screenshots/ed-personal/ed-08-enroll-sample-3of3.jpeg)

## Local Execution 交叉佐证

- **LE-02（PASS）**：打开声纹录入面板，面板标明「档案≠本次验证」语义。截图：[02-LE-02-enroll-panel.jpeg](./screenshots/local-execution-run3/02-LE-02-enroll-panel.jpeg)
- **LE-19d（PASS）**：空闲态复查录入面板声明，与 LE-02 一致（截图同 02）。
- **LE-20（PASS）**：录入声纹 >70s 采样不冻结、计数正常（02:06）、录入完成(3/3) 并显示已录入。截图：39-LE-20a ~ 44-LE-20f（[39](./screenshots/local-execution-run3/39-LE-20a-enroll-sampling-started.jpeg) [40](./screenshots/local-execution-run3/40-LE-20b-enroll-mid-sampling-38s.jpeg) [41](./screenshots/local-execution-run3/41-LE-20c-enroll-after-70s-before-stop.jpeg) [42](./screenshots/local-execution-run3/42-LE-20d-enroll-sample1-done.jpeg) [43](./screenshots/local-execution-run3/43-LE-20e-enroll-sample2-done.jpeg) [44](./screenshots/local-execution-run3/44-LE-20f-enroll-complete-3of3.jpeg)）

## 结论

「档案≠本次验证」语义在面板与录入回声两处均可见且一致；录入流程双轨 PASS。LE-20 的 70 秒+长采样同时构成 D-LE-01 冻结修复的回归证据（见 REGRESSION.md / RUNTIME_ERROR.md）。
