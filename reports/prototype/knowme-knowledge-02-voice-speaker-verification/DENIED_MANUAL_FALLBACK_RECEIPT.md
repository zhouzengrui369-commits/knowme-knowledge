# DENIED MANUAL FALLBACK RECEIPT — GOAL-KK-02 Contract R3 (PX-KK02-02)

## 设计

- 麦克风权限未授予/被拒绝时：不崩溃、不死路。常驻手动文本行始终可用（来源标注"手动文本"，绝不冒充语音）；横幅给出"不授权也能继续"说明 + "去系统设置开启麦克风(可选)"深链；授权后回到语音通道，上下文不丢。
- R3-D18：系统将 DENIED 塌缩为 PERMISSION_REQUIRED，导致 DENIED 专属横幅不可达 → 横幅条件扩展为 REQUIRED/DENIED 两态覆盖。
- R3-D21：手动保存触发 dismissResult() 把 micState 强制刷 IDLE，横幅+深链消失 → dismissResult 仅在 STOPPED 时回 IDLE，权限诚实状态不再被清场冲掉。

## 实证（final run2，双通道）

| 步骤 | LE | ED 本人 |
|------|-----|---------|
| 系统弹窗拒绝 → 不崩溃、有引导 | le-03a | ed2-02 |
| 拒绝态手动输入入库（来源=手动文本） | le-03b（已保存的知识 1 条） | ed2-03（1 条，横幅仍可见 = D21 本人实证） |
| 手动保存后横幅/深链持续可达 | le-18（新增 D21 回归旅程，深链点击成功跳转） | ed2-03 + ed-d21（defect-loop 首证） |
| 设置中授权 → 返回数据在、语音通道恢复 | le-04 | ed2-04 |
| 撤销权限（杀进程）→ 数据在、横幅回归 | le-15 | ed2-15 |

## 结论

mic denied → 手动输入降级路径在 final exact SHA 上双通道实证成立；授权恢复后数据与上下文完整。DENIED 与 REQUIRED 两态横幅均真实可达（D18），且不再被手动保存冲掉（D21）。
