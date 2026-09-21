# PRIVACY & NETWORK BOUNDARY — 隐私与网络边界

## 头部标识

- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1
- PR = #32（draft, OPEN）
- DATE = 2026-09-22
- ENVIRONMENT = OpenHarmony emulator（kk02phone）, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555

## 权限声明（可 grep 验证）

候选树 `prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/module.json5` 的 `requestPermissions` 仅声明一项：

```
"name": "ohos.permission.MICROPHONE",
"reason": "$string:microphone_reason",
"usedScene": { "abilities": ["EntryAbility"], "when": "inuse" }
```

验证命令（2026-09-22 在 evidence 分支上实跑）：

```
git show d02014f:prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/module.json5 | grep -i 'MICROPHONE\|INTERNET'
git grep -n -i 'ohos.permission' d02014f -- 'prototypes/knowme-knowledge-02-voice-speaker-verification/'
```

结果：仅 `ohos.permission.MICROPHONE`（when: inuse）；**无 `ohos.permission.INTERNET` 等任何网络权限声明**。ohosTest 的 module.json5 同样仅声明 MICROPHONE。

## 界面层声明（截图证据）

- **首屏横幅**：「0.1 原型·OpenHarmony 模拟器演示(非 Mate60 真机)·全程本地·无云端上传」（ED-01，[ed-01-first-view.jpeg](./screenshots/ed-personal/ed-01-first-view.jpeg)；LE-01，[01-LE-01-coldstart-first-screen.jpeg](./screenshots/local-execution-run3/01-LE-01-coldstart-first-screen.jpeg)）。
- **诊断区**：展开后声明「离线时…绝不静默走云端」（LE-19e，截图 [37-LE-19e-diagnostics-expanded.jpeg](./screenshots/local-execution-run3/37-LE-19e-diagnostics-expanded.jpeg)、[38-LE-19e-diagnostics-detail.jpeg](./screenshots/local-execution-run3/38-LE-19e-diagnostics-detail.jpeg)）。
- **声纹档案本地存储**：录入完成显示「声纹档案:已录入(本地声纹档案)」（ED-08，[ed-08-enroll-sample-3of3.jpeg](./screenshots/ed-personal/ed-08-enroll-sample-3of3.jpeg)）。
- **权限用途明示**：系统权限弹窗文案「用于在 Owner 明确点击开始后录制语音,完成本地中文转写与机主声纹验证」（ED-02，[ed-02-permission-dialog.jpeg](./screenshots/ed-personal/ed-02-permission-dialog.jpeg)）。
- **恢复消息如实声明存储性质**：「0.1 原型有界本地存储,非生产备份」（ED-18，[ed-21-cold-restart-recovery.jpeg](./screenshots/ed-personal/ed-21-cold-restart-recovery.jpeg)）。

## 行为层证据

- 模拟器 STT 间歇失败时报 1002200010，应用如实披露并走 NOT_AVAILABLE 诚实拦截，**无云端回退**（LE 回执非缺陷观察 1；RUNTIME_ERROR.md）。
- 麦克风权限被系统撤销后，应用诚实降级并引导去设置，不绕过（LE-19a，截图 28~31、35、36）。

## 数据合规

- 全部测试输入为**合成数据**：macOS `say -v Tingting` 合成语音 + 手工键入的测试文本；未使用任何真实个人语音/数据（双轨回执合规声明一致）。
- 取证仅经 `hdc snapshot_display` 从模拟器屏幕获取，未拉取/修改应用私有数据目录。

## 结论

权限最小化（仅麦克风 when:inuse）、无网络权限、界面与行为双重一致地声明并执行「全程本地」边界，双轨 PASS。
