# PX FINDINGS REGRESSION MATRIX — GOAL-KK-02 Contract R3（含 PX-KK02-R3-06）

- ED_CONTEXT_ID=ED-KK-GOAL02-R3-PX02-P2-CORRECTION-20260920-1645-A19D
- CANDIDATE_SHA=3317469085d8dc10a88818369ffcc2922904079c
- BUILD_MAIN_HAP_SHA256=05111cd04294f937839345e09b1af08aadefdc8b6cac1147f7eb4202622ca7f8
- 矩阵日期：2026-09-21

| finding | prior status | current implementation | technical test | Local Executor operation | ED operation | screenshot refs | final engineering status |
|---|---|---|---|---|---|---|---|
| PX-KK02-01（手动文本直达入库、来源标注） | CLOSED @ PR24 (06b013c) | 首屏手动输入框+「记录」，来源徽标「手动文本」 | 单元测试 48/48 含手动保存路径 | LE-06 拒绝态手动保存 PASS | ed-07 拒绝态手动保存、计数 2、来源正确 | le-06-manual-save-while-denied; ed-07/07b/07c | REGRESSION=PASS，保持关闭 |
| PX-KK02-02（TEST_FIXTURE 候选 UI：修正/拒绝/确认 + 充分披露） | CLOSED @ PR24 | 「生成 TEST_FIXTURE 演示候选」入口+候选卡+⚠标注 | 单元测试含 fixture 全链 | LE-02/03/04/05 生成/修正/丢弃/确认 PASS | ed-02/03/04/05/06 同链 PASS，reject=+0、confirm=+1 | le-02..le-05b; ed-02..ed-06 | REGRESSION=PASS，保持关闭 |
| PX-KK02-03（权限拒绝横幅/状态真实 + 深链设置） | CLOSED @ PR24 | 拒绝横幅+「去系统设置开启麦克风(可选)」+状态行 | 单元测试含权限状态机 | LE-01/07 横幅与深链 PASS | ed-01 基线、ed-08a 权限弹窗、ed-08b 拒绝后深链设置 | le-01, le-07a/07b; ed-01, ed-08a/08b | REGRESSION=PASS，保持关闭 |
| PX-KK02-04（有界本地持久化 + 冷启动恢复标记一次） | CLOSED @ PR24 | 有界本地存储+「已从本地恢复 N 条…」标记 | 单元测试含持久化往返 | LE-09 force-stop 冷开恢复 PASS | ed-10 冷开：2 条+来源+恢复标记恰好一次 | le-09; ed-10 | REGRESSION=PASS，保持关闭 |
| PX-KK02-05（Agent-first 信息架构 + 模拟器/非真机披露） | CLOSED @ PR24 | Agent 对话主区域+语音为附加能力+顶部披露条 | 单元测试+UI 结构 | LE-10 Agent-first 终屏 PASS | ed-11 首屏 Agent 优先+披露条完整 | le-10; ed-11 | REGRESSION=PASS，保持关闭（语义项，持续守护） |
| PX-KK02-R3-06（fixture 流塌缩权限事实→假"空闲·未录音"+按钮文案失真） | OPEN P2 @ PR25 | `idleKeepingPermissionFact()`：fixture 生成/取消不再触碰 DENIED/REQUIRED/UNAVAILABLE 设备事实 | 新增 2 用例：三拒绝态生成保持+全链保持 DENIED；48/48 PASS | LE-02/03/04/05 生成/修正/丢弃/确认全程「需要麦克风权限」PASS；LE-06 手动回退 PASS | ed-02..ed-07 全程保持拒绝态；ed-08 CTA 真实（弹窗→拒绝→深链）；ed-09 授权返回刷新 | px02-repro-01..04（复现）; px02-fix-01..04（修复）; le-02..le-06; ed-02..ed-09 | ENGINEERING_REGRESSION=PASS，工程侧关闭（待 PX 定向复验裁定） |

补充说明：

- PX-KK02-05 为语义/架构守护项，无单行代码对应，按披露条与信息架构持续核验。
- 声纹 trust gate 未在本候选中触碰；拒绝态下录音/声纹区行为与 PR24 一致。
- 任何后续 SHA 变更将作废本矩阵对应的 LE/ED final 证据。
