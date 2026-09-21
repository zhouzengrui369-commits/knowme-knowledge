# SCREENSHOT INDEX — 截图完整清单

## 头部标识

- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1
- PR = #32（draft, OPEN）
- DATE = 2026-09-22
- ENVIRONMENT = OpenHarmony emulator（kk02phone）, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555

## 计数说明

- LE run3 截图：**76 张**（与回执 SCREENSHOT_COUNT = 76 一致），目录 [screenshots/local-execution-run3/](./screenshots/local-execution-run3/)。
- ED 本人操作截图：**实际 23 张**（回执声明 SCREENSHOT_COUNT = 21；差异来自 ed-08 三段采样拆为 3 张文件，回执按旅程计数。以实际文件为准），目录 [screenshots/ed-personal/](./screenshots/ed-personal/)。
- 合计实际 jpeg 文件 = **99 张**，均为 hdc snapshot_display 原始 jpeg，全部逐张目验。

## LE run3 截图清单（76 张，文件名 → 旅程 / 内容）

| 文件 | 旅程 | 内容一句话 |
|---|---|---|
| 01-LE-01-coldstart-first-screen.jpeg | LE-01 | 冷启首屏：标题+横幅+录音/声纹入口，TEST_FIXTURE 折叠 |
| 02-LE-02-enroll-panel.jpeg | LE-02 / LE-19d | 声纹录入面板「档案≠本次验证」语义声明 |
| 03-LE-03-permission-dialog.jpeg | LE-03 | 系统麦克风权限弹窗 |
| 04-LE-03-recording-mmss.jpeg | LE-03 | 授权后进入录音「●正在录音 mm:ss」 |
| 05-LE-04-recording-clock-ticks.jpeg | LE-04 | 录音时钟 00:01→00:35 持续递增不冻结 |
| 06-LE-05a-cancel-idle-no-candidate.jpeg | LE-05 | 取消录音回空闲、无候选残留 |
| 07-LE-05b-06-stop-notenrolled.jpeg | LE-05b/06 / LE-19c | 未录入声纹停止真实录音被 NOT_ENROLLED 诚实拦截 |
| 08-LE-06b-testfixture-expanded.jpeg | LE-06b | 展开 TEST_FIXTURE 区 |
| 09-LE-06c-fixture-candidate-card.jpeg | LE-06c | TEST_FIXTURE 演示候选卡（未入库） |
| 10-LE-07a-candidate-corrected-editing.jpeg | LE-07 | 候选上修正转写编辑中 |
| 11-LE-07b-correction-saved-knowledge+0.jpeg | LE-07 | 保存修正，知识 +0 |
| 12-LE-08-discard-knowledge+0-after.jpeg | LE-08 | 丢弃候选，知识 +0，Agent 解释不入库原因 |
| 13-LE-09-organize-draft-editor.jpeg | LE-09/10 | 整理成笔记进入草稿编辑器（确定性整理声明） |
| 14-LE-11a-title-edited.jpeg | LE-11 | 草稿标题已编辑 |
| 15-LE-11b-body-edited.jpeg | LE-11 | 草稿正文已编辑 |
| 16-LE-11c-back-to-app-draft-state.jpeg | LE-11 | 返回应用后草稿状态保持 |
| 17-LE-11d-body-edit-attempt.jpeg | LE-11 | 正文编辑尝试（首次未命中字段，操作噪声） |
| 18-LE-12-source-and-raw-transcript.jpeg | LE-12 | 草稿中来源+原始转写可见且不被整理覆盖 |
| 19-LE-13-draft-cancel-knowledge+0.jpeg | LE-13 / LE-18 | 草稿取消，知识 +0（含消息流） |
| 20-LE-14-save-note-exactly+1.jpeg | LE-14 | 保存笔记恰好 +1 |
| 21-LE-14-pre-save-draft.jpeg | LE-14 | 保存前草稿状态 |
| 22-LE-14-saved-exactly+1-no-dup.jpeg | LE-14 | 连点保存无重复入库（含消息流） |
| 23-LE-15-entry-detail.jpeg | LE-15 | 已存条目详情 |
| 24-LE-15-entry-detail-raw-transcript.jpeg | LE-15 | 条目详情中原始转写四要素齐全 |
| 25-LE-16-coldstart-persistence.jpeg | LE-16 | force-stop 冷启后知识持久恢复（含消息流） |
| 26-LE-17a-unsaved-draft-before-kill.jpeg | LE-17 | kill 前未保存草稿状态 |
| 27-LE-17b-coldstart-no-draft-revive.jpeg | LE-17 | 冷启后未保存草稿不复活 |
| 28-LE-19a-settings-home.jpeg | LE-19a | 系统设置首页（去撤销权限） |
| 29-LE-19a-appinfo.jpeg | LE-19a | 应用信息页 |
| 30-LE-19a-mic-revoked-in-settings.jpeg | LE-19a | 设置中撤销麦克风权限 |
| 31-LE-19a-app-honest-no-permission.jpeg | LE-19a | 应用诚实降级提示无权限并引导去设置 |
| 32-LE-19b-manual-text-input.jpeg | LE-19b | 手动文本兜底输入区 |
| 32-LE-19b-scrolled-to-manual-input.jpeg | LE-19b | 滚动至手动输入区 |
| 33-LE-19b-manual-text-typed.jpeg | LE-19b | 手动文本已键入 |
| 34-LE-19b-manual-candidate-created.jpeg | LE-19b | 手动文本候选生成并标注来源 |
| 35-LE-19a-mic-re-granted.jpeg | LE-19a | 设置中重新授权麦克风 |
| 36-LE-19a-return-refreshed-granted.jpeg | LE-19a | 返回应用后权限状态刷新 |
| 37-LE-19e-diagnostics-expanded.jpeg | LE-19e | 展开诊断区 |
| 38-LE-19e-diagnostics-detail.jpeg | LE-19e | 诊断区声明「离线时…绝不静默走云端」 |
| 39-LE-20a-enroll-sampling-started.jpeg | LE-20 | 声纹录入采样开始 |
| 40-LE-20b-enroll-mid-sampling-38s.jpeg | LE-20 | 采样进行中 38s 不冻结 |
| 41-LE-20c-enroll-after-70s-before-stop.jpeg | LE-20 | 70 秒+采样停止前（计数 02:06） |
| 42-LE-20d-enroll-sample1-done.jpeg | LE-20 | 采样 1 完成 |
| 43-LE-20e-enroll-sample2-done.jpeg | LE-20 | 采样 2 完成 |
| 44-LE-20f-enroll-complete-3of3.jpeg | LE-20 | 录入完成(3/3)，显示已录入 |
| 45-LE-21a-voice-attempt1-result.jpeg | LE-21 | 真实语音（Tingting 合成音）VERIFIED 结果 |
| 46-LE-21b-verified-note-saved.jpeg | LE-21 | VERIFIED 0.771 整理保存，知识 2→3（含 STT 1002200010 诊断记录） |
| 47-LE-22b-empty-injection-refused.jpeg | LE-22b | 空输入注入被拒绝 |
| 48-LE-22-fixture-section-scrolled.jpeg | LE-22b | 滚动至 TEST_FIXTURE 注入区 |
| 49-LE-22a-silence-attempt1-result.jpeg | LE-22a/c | 静音录音 VERIFIED 0.663 + NOT_AVAILABLE（纯标点门控自然出现） |
| 50-LE-22a-blocked-state-injection-visible.jpeg | LE-22a/c | 拦截态下注入控件可见 |
| 51-LE-22a-injection-control.jpeg | LE-22a/c | 注入控件特写 |
| 52-LE-22a-blocked-card-with-injection.jpeg | LE-22a/c | 拦截卡与注入控件同框 |
| 53-LE-22b-empty-injection-refused-explained.jpeg | LE-22b | 空输入拒绝并解释原因（D-KK03-03 回归） |
| 54-LE-22b-refusal-message.jpeg | LE-22b | 拒绝消息特写「注入被拒绝:请输入测试转写文本…」 |
| 55-LE-22a-injection-text-typed.jpeg | LE-22a | 注入文本已键入 |
| 56-LE-22a-back-to-app-check-state.jpeg | LE-22a | 返回应用检查状态 |
| 57-LE-22a-injection-typed-verify.jpeg | LE-22a | 注入文本确认 |
| 58-LE-22a-injection-candidate-created.jpeg | LE-22a | 注入候选生成尝试 |
| 59-LE-22a-retyped-before-click.jpeg | LE-22a | 点击前重新键入 |
| 60-LE-22a-inject-result.jpeg | LE-22a | 注入被拒绝（已有真实转写，消息指引先丢弃） |
| 61-LE-22a-inject-retry.jpeg | LE-22a | 注入重试仍被拒（多条拒绝消息各对应一次真实点击） |
| 62-LE-22a-card-top.jpeg | LE-22a | 候选卡顶部状态 |
| 63-LE-22a-after-discard.jpeg | LE-22a | 丢弃残留真实转写后 |
| 64-LE-22a-rerecord-result.jpeg | LE-22a | 重录结果 |
| 65-LE-22a-stop-result.jpeg | LE-22a | 停止录音结果 |
| 66-LE-22a-candidate-top.jpeg | LE-22a | 真实候选顶部 |
| 67-LE-22a-retry2-result.jpeg | LE-22a | 重试第 2 次结果（真实候选，丢弃） |
| 68-LE-22a-retry2-top.jpeg | LE-22a | 重试第 2 次候选顶部 |
| 69-LE-22a-idle-top.jpeg | LE-22a | 回到空闲顶部 |
| 70-LE-22a-retry3-result.jpeg | LE-22a | 重试第 3 次结果 |
| 71-LE-22a-silent-result.jpeg | LE-22a/c | 静音录音 VERIFIED 0.713 + NOT_AVAILABLE + 注入控件 |
| 72-LE-22a-inject-final.jpeg | LE-22a | 最终注入操作 |
| 73-LE-22a-inject-done.jpeg | LE-22a | 注入成功，TEST_FIXTURE 候选卡「测试转写·未入库」 |
| 74-LE-22a-organized.jpeg | LE-22a | 注入候选整理成草稿 |
| 75-LE-22a-saved.jpeg | LE-22a | 保存 +1（知识 3→4），⚠️ 来源警示 + TEST_FIXTURE 演示徽标 |

（另：LOCAL_EXECUTION_RECEIPT.md 与本目录同路径，为上述截图的验收回执。）

## ED 本人操作截图清单（23 张，文件名 → 旅程 / 内容）

| 文件 | 旅程 | 内容一句话 |
|---|---|---|
| ed-01-first-view.jpeg | ED-01 | 干净安装冷启首屏：产品目的、诚实横幅、折叠区 |
| ed-02-permission-dialog.jpeg | ED-02 | 系统权限弹窗，文案说明麦克风用途 |
| ed-03-recording-state.jpeg | ED-03 | 红色「●正在录音」+ 00:02 + 停止/取消 |
| ed-04-recording-clock-ticking.jpeg | ED-04 | 时钟 00:02→00:10 持续走动不冻结 |
| ed-05-cancel-recording-idle.jpeg | ED-05 | 取消录音回空闲、知识 0、无候选残留 |
| ed-06-not-enrolled-intercept.jpeg | ED-06 / ED-21 | NOT_ENROLLED 诚实拦截，知识仍 0（含丢弃消息流） |
| ed-07-voiceprint-panel.jpeg | ED-07 | 声纹面板「档案≠本次验证」+ 原型声明 |
| ed-08-enroll-sample-1of3.jpeg | ED-08 | 声纹录入采样 1/3 |
| ed-08-enroll-sample-2of3.jpeg | ED-08 | 声纹录入采样 2/3 |
| ed-08-enroll-sample-3of3.jpeg | ED-08 | 录入完成(3/3)，「已录入(本地声纹档案)」+ 回声标注非本次验证 |
| ed-11-verified-candidate.jpeg | ED-10 | VERIFIED 0.792 候选卡「未入库·不会自动保存」 |
| ed-12-note-draft-editor.jpeg | ED-11 | 草稿编辑器「确定性整理(非真实 LLM)」声明 |
| ed-13-note-provenance.jpeg | ED-12 | 展开「查看原始转写与来源」 |
| ed-14-note-provenance-detail.jpeg | ED-12 | 来源 VERIFIED + 原始转写不被整理覆盖 |
| ed-15-note-title-edited.jpeg | ED-13 | 标题插入「（已编辑）」可编辑 |
| ed-16-note-saved-plus1.jpeg | ED-14 / ED-20 / ED-09 | 保存 +1（共 1 条）+「本人语音·已验证」徽标（含 UNCERTAIN 拦截等消息流） |
| ed-17-item-detail.jpeg | ED-15 | 已存条目四要素齐全、原始转写为编辑前原文 |
| ed-18-cancel-journey-draft.jpeg | ED-16 | 取消旅程中的草稿（VERIFIED 0.686） |
| ed-19-cancel-note-plus0.jpeg | ED-16 / ED-20 | 取消 +0、候选一并丢弃、Agent 解释（消息流） |
| ed-20-save-doubleclick-dedup.jpeg | ED-17 | 快速双击保存仍恰好 +1（VERIFIED 0.741，共 2 条） |
| ed-21-cold-restart-recovery.jpeg | ED-18 / ED-20 | force-stop 冷启恢复 2 条知识+声纹档案（恢复消息流） |
| ed-22-unsaved-draft-before-kill.jpeg | ED-19 | kill 前未保存草稿（VERIFIED 0.815） |
| ed-23-draft-not-revived.jpeg | ED-19 / ED-20 | 冷启后草稿不复活、知识仍 2 条（消息流） |

（另：ED_PERSONAL_OPERATION_RECEIPT.md 与本目录同路径，为上述截图的操作回执。）
