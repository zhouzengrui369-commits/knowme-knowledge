# SCREENSHOT INDEX — GOAL-KK-02 Contract R3 FINAL (run2 @ 06b013c)

全部截图经 `hdc shell snapshot_display` 采集（仅模拟器屏幕，无 macOS 截屏）。两套 final 证据相互独立采集；defect-loop 截图为探索期/修复期补充（拍摄构建已注明）。

## screenshots/local-executor/（LE-KK-GOAL02-R3-FINAL-20260920-C61A-01，22 张）

| 文件 | 内容 |
|------|------|
| le-01-agent-first-home.jpeg | Agent-first 首屏（干净起点） |
| le-02-emulator-disclosure.jpeg | 常态披露条 |
| le-03a-mic-denied-banner.jpeg | 拒绝权限后横幅 |
| le-03b-manual-entry-saved.jpeg | 拒绝态手动入库（1 条） |
| le-04-permission-restored-data-intact.jpeg | 授权返回数据在 |
| le-05-cold-reopen-data-restored.jpeg | 冷开恢复（标记一次） |
| le-06-agent-context-return.jpeg | 对话上下文返回 |
| le-07-test-fixture-entry.jpeg | TEST_FIXTURE 入口+披露 |
| le-08-candidate-corrected.jpeg | 候选修正 |
| le-09-confirm-plus-one.jpeg | 确认 +1（fixture chip） |
| le-10-reject-no-change.jpeg | 拒绝 +0 |
| le-11a-enrolled.jpeg | 注册完成(3/3) |
| le-11b-enroll-vs-verify-separate.jpeg | 注册档案/本次验证两行分离 |
| le-12a-recording.jpeg | 真实捕获录音中 |
| le-12b-trust-gate-blocked.jpeg | VERIFIED 仍被 NOT_AVAILABLE 拦截 |
| le-13-rapid-toggle-recovered.jpeg | 快速交替后回空闲 |
| le-14-entry-detail-source.jpeg | 条目展开来源详情 |
| le-15-permission-revoked-data-intact.jpeg | 撤销权限（杀进程）数据在 |
| le-16a-reset-dialog.jpeg | 重置确认弹窗 |
| le-16b-reset-confirmed.jpeg | 重置后未注册、知识保留 |
| le-17-regression-final-state.jpeg | 回归核对最终状态 |
| le-18-d21-banner-persists-after-manual-save.jpeg | R3-D21 回归：手动保存后横幅+深链仍在 |

LE run1（SHA 2d4e14e）截图 21 张已按合同作废，存档于 LE 执行机 `/tmp/kk02-r3-le/invalidated-run1/`（未入 Git）。

## screenshots/ed-personal/（ED 本人，同 SHA 同构建，17 张）

| 文件 | 内容 |
|------|------|
| ed2-01-agent-first-home.jpeg | Agent-first 首屏+披露 |
| ed2-02-mic-denied-banner.jpeg | 拒绝权限横幅 |
| ed2-03-denied-manual-saved-banner-persists.jpeg | 手动保存后横幅持续（D21 本人实证） |
| ed2-04-permission-granted-data-intact.jpeg | 授权后数据在 |
| ed2-05-cold-reopen-data-context-restored.jpeg | 冷开数据+上下文恢复（标记一次） |
| ed2-06-fixture-candidate-created.jpeg | fixture 候选生成 |
| ed2-07-candidate-corrected.jpeg | 候选修正 |
| ed2-08-confirm-plus-one.jpeg | 确认 +1 |
| ed2-09-reject-plus-zero.jpeg | 拒绝 +0 |
| ed2-10-enrolled-vs-verification-separate.jpeg | 注册完成 vs 本次验证分离 |
| ed2-11-recording.jpeg | 真实捕获录音中 |
| ed2-12-trust-gate-blocked.jpeg | VERIFIED 0.656 被 NOT_AVAILABLE 拦截 |
| ed2-13-rapid-toggle-recovered.jpeg | 快速交替错误恢复 |
| ed2-14-entry-detail-expanded.jpeg | 条目展开来源详情 |
| ed2-15-permission-revoked-data-intact.jpeg | 撤销权限数据在（标记一次） |
| ed2-16a-reset-dialog.jpeg | 重置弹窗 |
| ed2-16b-reset-confirmed-knowledge-kept.jpeg | 确认重置后知识保留 |

## screenshots/defect-loop/（探索期/修复期补充，拍摄于候选前构建，仅作 defect loop 记录）

| 文件 | 内容 | 对应 defect |
|------|------|-------------|
| ed-21-banner-fixed.jpeg | D18 修复后横幅两态可达 | R3-D18 |
| ed-23-enrollment-echo-verdict-fixed.jpeg | D19 修复后回声不再误标（结果卡） | R3-D19 |
| ed-24-enrollment-echo-both-fixed.jpeg | D19 修复（声纹区） | R3-D19 |
| ed-25-fast-stop-recovery.jpeg | 86ms 极短会话诚实结果 | 错误恢复 |
| ed-27-cold-reopen-no-candidate-revive.jpeg | 未确认候选重启不复活 | PX-KK02-01 边界 |
| ed-31-reset-dialog.jpeg | 重置弹窗（探索期） | R2-D15 |
| ed-d21-banner-persists-after-manual-save.jpeg | D21 修复后首次实证 | R3-D21 |
