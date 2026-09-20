# PX FINDINGS REGRESSION MATRIX — GOAL-KK-02 Contract R3

PX 报告：`reports/product-review/2026-09-19-knowme-knowledge-goal02-owner-review/REVIEW.md` @ commit `56d005c1c76df26cdaf36675de2ba7d60d0006d4`（核验一致）。接受的 findings：PX-KK02-01..05。

| Finding | 修复实现（候选 06b013c） | 单元测试 | LE run2 验证 | ED 本人验证 |
|---------|--------------------------|----------|--------------|-------------|
| **PX-KK02-01** force-stop/冷开/权限撤销后已确认知识与上下文丢失 | AgentContext snapshot/restore（version=3，防御性恢复，id 连续）+ AgentContextStore 沙盒持久化；仅已确认/手动条目可跨进程；未确认/拒绝/丢弃候选按构造不入快照 | AgentContextPersistence 10 例（含 D20 回归 ×2） | le-05（冷开恢复）、le-15（撤销杀进程恢复）、le-27 类（未确认候选不复活）✅ | ed2-05（冷开）、ed2-15（撤销杀进程）✅；探索期 ed-27（候选不复活）✅ |
| **PX-KK02-02** mic denied 无降级路径 | 常驻手动文本行（来源标注手动文本）+ 未授权/拒绝横幅（REQUIRED/DENIED 两态，D18）+ 系统设置深链（D6）+ 拒绝后深链可达（D21） | FixtureDemo D21 回归用例 | le-03a/b（拒绝→手动入库）、le-18（手动保存后横幅/深链仍在）✅ | ed2-02/03（拒绝→手动，横幅持续）✅ |
| **PX-KK02-03** TEST_FIXTURE 不可达 | VoiceSessionController.fixtureDemo + startFixtureCandidate（IDLE/无候选/非空才允许，不产生 speaker 判决，gate=null）；界面直接演示入口 + 三重披露 | FixtureDemo 12 例 | le-07（入口+披露）、le-08（修正）、le-09（确认 +1）、le-10（拒绝 +0）✅ | ed2-06..09（同链路本人操作）✅ |
| **PX-KK02-04** 非 Agent-first、动词误导、披露不足 | Index.ets 重写：灵犀对话为首屏，语音捕获降为附加能力区；动词"点开始说话/点停止"；常态披露条（模拟器/非真机、≠生产认证、本地无云端）；技术诊断默认折叠 | —（界面层） | le-01（Agent-first 首屏）、le-02（披露条）✅ | ed2-01（首屏+披露）✅ |
| **PX-KK02-05** 注册态与本次验证混淆 | 机主声纹区"注册档案"与"本次验证"两行独立；注册采样回声标注"注册采样回声（非本次验证）"（D19），永不显示为验证结果 | —（界面层，session purpose 判定有 VoiceCore 测试覆盖） | le-11a/b（注册 3/3 完成，本次验证保持"尚未捕获"）✅ | ed2-10（同场景本人操作）✅ |

## Trust gate 未弱化证明

- `CandidateTrustClass`：VOICE 类确认规则与 R2 逐字相同；FIXTURE 类仅获得与"手动文本"同级的确认资格（DRAFT/CORRECTED 可确认），不产生任何 speaker 判决。
- 实证：le-12 / ed2-12 真实捕获 VERIFIED 0.626/0.656 仍因 NOT_AVAILABLE 被拦截不入库；UNCERTAIN 0.595（le run1）拦截不入库。
- 未使用任何内部状态修改/阈值修改伪造候选路径。

## 结论

5/5 findings 已实现并被 LE + ED 双通道实证；不声明 PRODUCT_EXPERIENCE_PASS（越权），仅声明工程侧 ENGINEERING_READY 所需的修复完成与证据齐备。
