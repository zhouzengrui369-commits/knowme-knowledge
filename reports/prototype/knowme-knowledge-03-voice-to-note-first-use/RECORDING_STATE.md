# RECORDING STATE — 录音状态与权限

## 头部标识

- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1
- PR = #32（draft, OPEN）
- DATE = 2026-09-22
- ENVIRONMENT = OpenHarmony emulator（kk02phone）, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555

## 主张

麦克风权限经系统弹窗明确用途；录音中状态可见（红色「●正在录音」+ mm:ss 时钟 + 停止/取消）；时钟持续走动不冻结；取消录音干净回到空闲。

## ED 本人操作证据

- **ED-02（PASS）**：点「授权麦克风并开始录音」，系统权限弹窗文案说明用途：「允许"灵犀语音原型"访问你的麦克风？用于在 Owner 明确点击开始后录制语音,完成本地中文转写与机主声纹验证」。截图：[ed-02-permission-dialog.jpeg](./screenshots/ed-personal/ed-02-permission-dialog.jpeg)
- **ED-03（PASS）**：授权后显示红色「●正在录音」+ mm:ss 时钟（00:02）+ 停止/取消按钮。截图：[ed-03-recording-state.jpeg](./screenshots/ed-personal/ed-03-recording-state.jpeg)
- **ED-04（PASS）**：继续等待 8s，时钟 00:02 → 00:10 持续走动不冻结。截图：[ed-04-recording-clock-ticking.jpeg](./screenshots/ed-personal/ed-04-recording-clock-ticking.jpeg)
- **ED-05（PASS）**：点「取消录音」回到空闲、知识 +0、无候选残留。截图：[ed-05-cancel-recording-idle.jpeg](./screenshots/ed-personal/ed-05-cancel-recording-idle.jpeg)

## Local Execution 交叉佐证

- **LE-03（PASS）**：未授权时点开始录音，系统权限弹窗；授权后进入录音并显示「●正在录音 mm:ss」。截图：[03-LE-03-permission-dialog.jpeg](./screenshots/local-execution-run3/03-LE-03-permission-dialog.jpeg)、[04-LE-03-recording-mmss.jpeg](./screenshots/local-execution-run3/04-LE-03-recording-mmss.jpeg)
- **LE-04（PASS）**：录音时钟 00:01→00:35 持续递增，不冻结。截图：[05-LE-04-recording-clock-ticks.jpeg](./screenshots/local-execution-run3/05-LE-04-recording-clock-ticks.jpeg)
- **LE-05（PASS）**：取消录音回到空闲且无候选残留。截图：[06-LE-05a-cancel-idle-no-candidate.jpeg](./screenshots/local-execution-run3/06-LE-05a-cancel-idle-no-candidate.jpeg)
- **LE-19a（PASS）**：设置中撤销麦克风权限→应用诚实降级并引导去设置→授权返回后状态刷新。截图：[28](./screenshots/local-execution-run3/28-LE-19a-settings-home.jpeg) [29](./screenshots/local-execution-run3/29-LE-19a-appinfo.jpeg) [30](./screenshots/local-execution-run3/30-LE-19a-mic-revoked-in-settings.jpeg) [31](./screenshots/local-execution-run3/31-LE-19a-app-honest-no-permission.jpeg) [35](./screenshots/local-execution-run3/35-LE-19a-mic-re-granted.jpeg) [36](./screenshots/local-execution-run3/36-LE-19a-return-refreshed-granted.jpeg)

## 结论

权限请求用途明示、录音状态可见可取消、时钟不冻结、权限撤销后诚实降级——双轨均 PASS。
