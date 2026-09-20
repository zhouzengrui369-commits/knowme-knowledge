# CANDIDATE FIXTURE FLOW RECEIPT — GOAL-KK-02 Contract R3 (PX-KK02-03)

## 设计

- 界面直接可达的 TEST_FIXTURE 演示入口（语音捕获附加能力区内）：输入代理文本 → 生成演示候选。
- 披露链完整：入口说明、生成时 Agent 消息、候选卡标题、入库来源 chip 四处均明示"TEST_FIXTURE ≠ 真实语音识别 / 不代表机主身份 / 真机未验证 / 仅演示流程"。
- 不产生任何 speaker 判决（fixtureDemo 下 gate=null，不参与声纹验证）。
- 修正 / 拒绝 / 确认是三个独立操作；reject = +0，confirm = 恰好 +1 且 source=fixture。
- Trust gate 未弱化：VOICE 类规则逐字不变；FIXTURE 类仅与手动文本同级（CandidateTrustClass 分流，VoiceCore 单测覆盖）。

## 实证（final run2，双通道）

| 步骤 | LE | ED 本人 | 结果 |
|------|-----|---------|------|
| 入口可达 + 披露 | le-07 | ed2-06 | ✅ |
| 生成候选（未入库、待确认） | le-07/08 | ed2-06 | ✅ |
| 修正候选（保存修正即时更新） | le-08 | ed2-07 | ✅（自动化 inputText 落点错位为已知自动化坑，非应用缺陷，两处如实记录） |
| 确认 = +1（fixture 来源标识） | le-09（1→2） | ed2-08（1→2） | ✅ |
| 拒绝 = +0（计数不变，有提示） | le-10（仍 2） | ed2-09（仍 2，"知识没有变化"） | ✅ |
| 候选持久化边界 | 未确认候选不跨重启（见 PERSISTENCE_RECOVERY_RECEIPT） | 探索期 ed-26→27 | ✅ |

## 单元测试

FixtureDemo.test.ets 12 例：入口条件（录音中/已有候选/空文本拒绝）、无 speaker 判决、修正独立、reject +0、confirm +1 source=fixture、VOICE trust gate 不变、dismiss/cancel 清场、D21 回归。46/46 PASS。

## 结论

TEST_FIXTURE 演示候选全链路（可达→生成→修正→拒绝/确认）在 final exact SHA 上双通道实证成立，披露链完整，计数语义精确。
