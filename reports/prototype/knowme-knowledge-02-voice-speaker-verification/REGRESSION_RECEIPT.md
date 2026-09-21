# REGRESSION RECEIPT — D1-D21 + PX-KK02-R3-06（Contract R3 设计契约回归）

- ED_CONTEXT_ID=ED-KK-GOAL02-R3-PX02-P2-CORRECTION-20260920-1645-A19D
- CANDIDATE_SHA=3317469085d8dc10a88818369ffcc2922904079c
- 日期：2026-09-21

## 方法

三层回归：① 设备端 Hypium 单元/契约测试（候选 SHA 干净 worktree 内 48/48 PASS，含本轮新增 2 个 R3-06 用例）；② Local Executor final exact-SHA 10 旅程（LE-01..LE-10 全 PASS）；③ ED 本人同 SHA/build 13 组独立操作（ed-01..ed-13 全 PASS）。D1-D21 设计契约条目由测试套件与上述真实产品操作共同覆盖；本轮候选仅改动 fixture 会话权限事实保持逻辑与对应测试，D1-D21 既有实现未触碰。

## 关键条目抽验（真实产品操作层）

| 契约点 | 证据 | 结果 |
|---|---|---|
| Agent-first 首屏（Agent 对话为主，语音为附加能力） | le-10, ed-11 | PASS |
| 模拟器/非真机披露条常驻 | le-10, ed-11（「OpenHarmony 模拟器演示环境 · 非 Mate60 真机 · 真机未验证 / 原型声纹验证 ≠ 生产身份认证 · 全程本地 · 无云端上传」） | PASS |
| mic denied → 手动输入可达且来源标注正确 | le-06, ed-07/07b/07c | PASS |
| 权限恢复后数据仍在 | le-08, ed-09b | PASS |
| force-stop / cold reopen 后数据仍在 + 恢复标记恰好一次 | le-09, ed-10 | PASS |
| 注册状态 / 本次验证状态分离 | ed-08a/ed-09b（注册档案:未注册；本次验证:—(尚未捕获)） | PASS |
| TEST_FIXTURE UI 可达 + 披露充分 | le-02, ed-02（候选卡 ⚠ 标注：非真实语音识别、不代表机主身份、真机未验证） | PASS |
| candidate correction 可达 | le-03, ed-03/ed-05 | PASS |
| candidate reject = +0 | le-04b, ed-04 | PASS |
| candidate confirm = +1 | le-05b, ed-06 | PASS |
| Agent context return（权限往返后对话上下文保留） | le-08, ed-09b | PASS |
| 错误恢复（空输入、快速开始/取消、录音停止） | ed-12, ed-13a/13b/13c, le-13（上轮路径同设计） | PASS |
| fixture 流权限事实真实（R3-06） | px02-fix-01..04, le-02..05b, ed-02..06 | PASS |
| CTA 文案=实际动作（R3-06） | le-07a/07/07b, ed-08a/08b | PASS |
| 授权返回刷新（R3-06） | le-08, ed-09a/09b | PASS |

## 结论

```text
PX_KK02_01_04_REGRESSION=PASS
PX_KK02_R3_06_ENGINEERING_REGRESSION=PASS
D1_D21_NO_NEW_REGRESSION=PASS（本轮 diff 外行为不变，测试+双操作层证据支持）
KNOWN_IN_SCOPE_BLOCKING_DEFECTS=NONE
```
