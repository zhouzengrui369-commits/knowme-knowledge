# REGRESSION RECEIPT — GOAL-KK-02 Contract R3 (D1-D17 + R3-D18..D21)

D1-D17 定义出处：git 历史提交说明（cedc8e4=D1-D5, 1d44589=D6-D7, ef5d668=D8-D9, d721093=D10-D11, 2a4364c=D12-D13, 2bd6652=R2-D14, 6bf181a=R2-D15, b02bca6=R2-D16/D17）。本候选 SHA 仓内无独立 D 清单文件（R2 REGRESSION_RECEIPT 存在于历史提交 1c2f257），如实记录。

## 逐条结论（final run2 @ 06b013c，LE + ED 双通道）

| 编号 | 主题 | 结论 | 依据 |
|------|------|------|------|
| D1 | 重复捕获引擎复用 | OK | le-13/ed2-13 四次快速交替无资源耗尽、无崩溃 |
| D2 | 重启档案加载（TextDecoder） | OK | le-05/15、ed2-05/15 冷开加载正常 |
| D3 | 麦克风启动失败诚实标注 | OK | le-03/ed2-02 denied 走授权引导，未误标 |
| D4 | 录音中 startSession 重入保护 | OK | 快速再点开始无双会话、无卡死 |
| D5 | STT beginSession 失败如实上报 | OK | le-12/ed2-12 NOT_AVAILABLE 如实显示为拦截原因 |
| D6 | 权限拒绝死路 | OK | 深链+Agent 引导+手动文本路径均可用（le-03/18、ed2-02/03） |
| D7 | 会话陈旧不渲染 | OK | Agent 消息全链即时渲染 |
| D8 | 前台权限刷新 | OK | le-04/ed2-04 设置往返即刷"权限已授予" |
| D9 | 注册后声纹状态刷新 | OK | le-11/ed2-10 第 3 采样停止即"已注册(3/3)" |
| D10 | STT NOT_AVAILABLE 降级手动入口 | OK | 拦截卡给手动路径，不伪造转写 |
| D11 | dismissResult 清场 | OK | 确认/丢弃/重置后卡片清场无残留（D21 后保留权限诚实态） |
| D12 | Agent 消息即时渲染 | OK | 修正→保存→确认消息即时出现 |
| D13 | onPageShow 冲掉 live verdict | OK | le-15/ed2-15 设置往返不冲状态 |
| R2-D14 | 注册/重置后状态条陈旧 | OK | le-11/16、ed2-10/16 即时刷新 |
| R2-D15 | 重置需确认 | OK | le-16/ed2-16 弹窗取消保留/确认删除语义正确 |
| R2-D16 | STT 部分失败覆盖披露文案 | OK | 拦截消息给出真实原因（NOT_AVAILABLE），披露未被覆盖 |
| R2-D17 | 重置/新捕获后旧结果卡残留 | OK | le-16b/le-17、ed2-16b 重置后"本次验证:—(尚未捕获)"无残留 |

## R3 新增 defect 回归

| 编号 | 主题 | 结论 | 依据 |
|------|------|------|------|
| R3-D18 | DENIED 塌缩 REQUIRED 致横幅不可达 | FIXED VERIFIED | 横幅覆盖 REQUIRED/DENIED 两态；ed-21（探索期）、le-03/18、ed2-02/03 |
| R3-D19 | 注册采样回声误标为本次验证 | FIXED VERIFIED | 结果卡与声纹区均标"注册采样回声(非本次验证)"；ed-23/24（探索期）、le-11、ed2-10 |
| R3-D20 | 恢复标记跨重启累积 | FIXED VERIFIED | ephemeral 过滤 + restore 拒绝泄漏；单测 ×2；le-05/15、ed2-05/15 四次恢复标记均恰好一次 |
| R3-D21 | 手动保存冲掉拒绝横幅/深链 | FIXED VERIFIED | dismissResult 仅 STOPPED→IDLE；单测 ×1；le-18、ed2-03、ed-d21 |

## 单元测试总账

46/46 PASS（Hypium 设备端，final run2，exact SHA 06b013c）：VoiceCore 14 + FixtureTranscript 10 + AgentContextPersistence 10 + FixtureDemo 12。

## 结论

D1-D17 无回归；R3 defect loop 发现的 D18-D21 全部修复并双通道实证。
