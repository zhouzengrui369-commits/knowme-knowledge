# SCREENSHOT INDEX — PX-KK02-R3-06 Final Evidence

- CANDIDATE_SHA=3317469085d8dc10a88818369ffcc2922904079c
- BUILD_MAIN_HAP_SHA256=05111cd04294f937839345e09b1af08aadefdc8b6cac1147f7eb4202622ca7f8
- 采集方式：`hdc shell snapshot_display`（真实屏幕帧，非源码推断）
- 日期：2026-09-21

## screenshots/local-executor/（14 张，LE-KK-GOAL02-R3-PX02-P2-FINAL-20260921-A19D-01，11:35–11:47 CST）

| 文件 | 内容 |
|---|---|
| le-01-before-fixture.jpeg | LE-01 拒绝态基线 |
| le-02-after-fixture-generate.jpeg | LE-02 拒绝态生成候选，权限事实保持 |
| le-03-after-fixture-correction.jpeg | LE-03 修正后拒绝态保持 |
| le-04a-before-reject.jpeg / le-04b-after-reject.jpeg | LE-04 丢弃前后，+0 且拒绝态保持 |
| le-05a-before-confirm.jpeg / le-05b-after-confirm.jpeg | LE-05 确认前后，+1 且拒绝态保持 |
| le-06-manual-save-while-denied.jpeg | LE-06 拒绝态手动保存 |
| le-07a-before-permission-action.jpeg / le-07-permission-dialog.jpeg / le-07b-system-settings.jpeg | LE-07 CTA→系统弹窗→拒绝后深链设置 |
| le-08-after-permission-granted-return.jpeg | LE-08 授权返回刷新，数据完好 |
| le-09-after-cold-reopen.jpeg | LE-09 冷开恢复（2 条+来源+恢复标记一次） |
| le-10-final-agent-first-view.jpeg | LE-10 Agent-first 终屏+披露条 |

## screenshots/ed-personal/（19 张，ED 本人独立操作，11:48–12:01 CST）

| 文件 | 内容 |
|---|---|
| ed-01-denied-baseline.jpeg | 拒绝态基线 |
| ed-02-generate-keeps-denied.jpeg | 拒绝态生成候选，权限事实保持 |
| ed-03-correct-keeps-denied.jpeg | 修正保持拒绝态 |
| ed-04-reject-plus-zero-keeps-denied.jpeg | 丢弃 +0，拒绝态与按钮文案真实 |
| ed-05-correct-before-confirm.jpeg | 真实修正成功（含【修正】标记） |
| ed-06-confirm-plus-one-keeps-denied.jpeg | 确认 +1，拒绝态保持 |
| ed-07-manual-save-while-denied.jpeg / ed-07b-manual-count.jpeg / ed-07c-mic-status-after-manual.jpeg | 拒绝态手动保存；计数 2+来源徽标；权限事实不塌缩 |
| ed-08a-permission-dialog.jpeg / ed-08b-after-deny.jpeg | CTA→系统权限弹窗（文案=动作）；拒绝后深链系统设置 |
| ed-09a-mic-granted-settings.jpeg / ed-09b-granted-return.jpeg | 设置 Toggle 开（checked=true）；返回后「权限已授予 · 待开始」+按钮真实+数据完好 |
| ed-10-cold-reopen.jpeg | force-stop 冷开：2 条+来源+恢复标记恰好一次 |
| ed-11-agent-first-disclosure.jpeg | Agent-first 终屏+完整披露条 |
| ed-12-error-recovery-empty-input.jpeg | 空输入优雅 no-op |
| ed-13a-recording-attempt.jpeg / ed-13b-after-stop.jpeg / ed-13c-rapid-cancel.jpeg | 授权后录音开始/停止/快速取消，无崩溃无残留 |

## screenshots/defect-loop/（8 张，修复前复现 + 修复后验证）

| 文件 | 内容 |
|---|---|
| px02-repro-01-after-fixture-generate.jpeg / px02-repro-02-false-idle.jpeg | 复现：生成候选后假「空闲·未录音」、横幅消失 |
| px02-repro-03-after-reject-button.jpeg / px02-repro-04-click-goes-settings.jpeg | 复现：丢弃后按钮「点开始说话」、点击实际跳系统设置 |
| px02-fix-01-generate-keeps-required.jpeg / px02-fix-02-reject-keeps-required.jpeg / px02-fix-03-confirm-plus-one-keeps-required.jpeg / px02-fix-04-manual-save-keeps-required.jpeg | 修复后：生成/丢弃/确认+1/手动保存全程保持「需要麦克风权限」 |
