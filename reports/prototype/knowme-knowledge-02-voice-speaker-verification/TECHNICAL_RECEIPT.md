# TECHNICAL RECEIPT — PX-KK02-R3-06 Root Cause / Fix / Tests

- ED_CONTEXT_ID=ED-KK-GOAL02-R3-PX02-P2-CORRECTION-20260920-1645-A19D
- CANDIDATE_SHA=3317469085d8dc10a88818369ffcc2922904079c
- 日期：2026-09-21

## Finding (authority: PR #25 REVIEW.md, P2)

> 在系统麦克风关闭时，生成 TEST_FIXTURE 候选会消去当前拒绝提示，显示"空闲·未录音"；丢弃后按钮写"点开始说话"，点击却跳系统权限设置。

违反 Contract R3 AO-R3-02（权限状态必须是设备事实）与 AO-R3-05（CTA 文案必须与实际动作一致）。

## Root Cause

`VoiceSessionController.startFixtureCandidate()` 在生成演示候选时无条件执行 `micState = IDLE`。当设备事实是 PERMISSION_DENIED / PERMISSION_REQUIRED / UNAVAILABLE 时，该赋值把权限事实塌缩成假"空闲·未录音"，拒绝横幅随状态消失；候选被丢弃后 `cancelSession()` 同样塌缩，主按钮按 IDLE 渲染为"点开始说话"，但点击时权限检查仍跳系统设置——文案与动作脱节。

## Fix (2 files, +71/-2)

1. 新增 `idleKeepingPermissionFact()`：仅当当前 micState 为真正空闲类状态时才塌缩为 IDLE；若当前状态是 PERMISSION_DENIED / PERMISSION_REQUIRED / UNAVAILABLE（设备事实），保持原状不动。
2. `startFixtureCandidate()` 与 `cancelSession()` 改用 `idleKeepingPermissionFact()`，fixture 候选的生成/丢弃不再触碰权限事实。
3. 按钮文案无需改动：`captureButtonLabel()` 既有映射 DENIED→"麦克风已拒绝·点这里去设置开启"、REQUIRED→"授权麦克风并开始说话"，状态保持真实后文案自动真实。
4. `clearResultForReset` 不涉及 micState，未改动。

## Regression Tests Added (FixtureDemo.test.ets, +2 cases → 48 total)

- fixture 生成自 PERMISSION_DENIED / PERMISSION_REQUIRED / UNAVAILABLE 时权限状态保持（不清 IDLE）。
- 全链 generate → correct → reject → confirm → dismiss 全程保持 DENIED；reject=+0、confirm=+1 语义不变。

## Test / Build Result

```text
UNIT_TESTS=48 run / 48 pass / 0 failure / 0 error（设备端 Hypium，候选 SHA 干净 worktree 内执行）
BUILD=entry-default-unsigned.hap sha256 05111cd04294f937839345e09b1af08aadefdc8b6cac1147f7eb4202622ca7f8
OHOSTEST=entry-ohosTest-unsigned.hap sha256 8a3e260725b76081a01d50938f7ac31a70945fecda8d7c1a03281106536b9c63
```

## Device Verification (pre-final, defect loop)

- 复现（修复前，preimage 行为）：px02-repro-01..04（生成候选后假空闲、横幅消失、丢弃后按钮"点开始说话"、点击跳设置）。
- 修复后同路径：px02-fix-01..04（生成/丢弃/确认/手动保存全程保持"需要麦克风权限"，计数语义正确）。

## Additional In-Scope Defects Found by ED During This Round

NONE。ED 在修复后探索（拒绝态全链、手动回退、权限往返、冷启动、空输入、快速开始/取消录音）未发现新的合同内 defect；LE final 亦报告 DEFECTS=NONE。
