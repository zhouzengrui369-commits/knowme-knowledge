# AGENT FIRST SURFACE — Agent 首面消息流

## 头部标识

- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1
- PR = #32（draft, OPEN）
- DATE = 2026-09-22
- ENVIRONMENT = OpenHarmony emulator（kk02phone）, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555

## 主张

Agent 是第一交互面：每个状态变化都有 Agent 消息解释，无静默状态变化。

## ED 本人操作证据

- **ED-20（PASS）**：全程观察消息流，拦截/整理/保存/取消/恢复消息均有解释（消息流见 [ed-16](./screenshots/ed-personal/ed-16-note-saved-plus1.jpeg)、[ed-19](./screenshots/ed-personal/ed-19-cancel-note-plus0.jpeg)、[ed-21](./screenshots/ed-personal/ed-21-cold-restart-recovery.jpeg)、[ed-23](./screenshots/ed-personal/ed-23-draft-not-revived.jpeg)）。
- 首屏即有 Agent 自我介绍（ED-01，[ed-01](./screenshots/ed-personal/ed-01-first-view.jpeg)）。
- 典型解释文案实例：
  - 拦截：「信任门拦截:尚未注册机主声纹」（ED-06）／「信任门拦截:无法确定是谁(UNCERTAIN),不入库」（ED-09）
  - 保存：「已保存笔记…,知识 +1(现在共 1 条)」（ED-14）
  - 取消：「已取消,这条笔记没有保存。知识没有变化(+0);原始转写候选也已丢弃。」（ED-16）
  - 恢复：「已从本地恢复 2 条已保存知识与对话上下文(0.1 原型有界本地存储,非生产备份)。」（ED-18）

## Local Execution 交叉佐证

- **LE-18（PASS）**：全流程观察消息流，每个动作都有 Agent 解释，无静默状态变化（截图 19、22、25 等消息流）。
- **LE-19c（PASS）**：各异常路径均有解释（截图 07、08、13、17）。
- **LE-22b（PASS）**：空输入点「注入测试转写」被拒绝且解释原因、不静默：「注入被拒绝:请输入测试转写文本;若已有真实转写,请先丢弃再试。」截图：[53](./screenshots/local-execution-run3/53-LE-22b-empty-injection-refused-explained.jpeg) [54](./screenshots/local-execution-run3/54-LE-22b-refusal-message.jpeg)
- **LE-22a（PASS）**：保存 TEST_FIXTURE 注入笔记时消息带 ⚠️ 来源警示（截图 [75](./screenshots/local-execution-run3/75-LE-22a-saved.jpeg)）。

## 结论

正常路径与全部异常/拒绝路径均有 Agent 解释，双轨 PASS。LE-22b 的拒绝解释同时是 D-KK03-03 修复的回归证据（见 REGRESSION.md）。
