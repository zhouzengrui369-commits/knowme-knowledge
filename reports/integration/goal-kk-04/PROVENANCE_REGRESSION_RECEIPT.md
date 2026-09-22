# GOAL-KK-04 — 溯源与回归回执（PROVENANCE_REGRESSION_RECEIPT，J06/J08）

> GOAL-KK-04 · PROVENANCE_REGRESSION_RECEIPT · ED context ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E
> Final pair：App `10d829195ebb7f6c4c576b0d116e45087ec2b35a` / Workbench `e548883b1d696b8245631bad129dd3737afcc5b7`
> 日期：2026-09-22

## 1. 结论

J06（幂等/冲突/同名不覆盖）与 J08（修正链，原始不动）全部实操通过：同一采集重试多次只产生一次正式效果；同 ID 不同内容显式 409；不同 ID 同名同分钟互不覆盖；修正产生新 revision，原始资产与最初转写不可变，两端 ≤2 次导航可见原始来源。

## 2. J06 幂等与冲突

### 2.1 服务端幂等（ED，实例 18231）

- 同 capture_id+rev+hash **三次提交** → 返回同一 task_id，后两次 `idempotent_replay=true`；只产生一次正式效果。
- 同 ID 不同内容（hash 不同、revision 未升）→ **409 CONTENT_CONFLICT**，不覆盖。
- revision 回退（提交更低 revision）→ 拒绝。
- 正式效果唯一性收尾核验：cap_idem_j06_01（ed-curl-check 设备）整理后确认只产生一个 note。

### 2.2 LE 复验

- R1：重放同 task_9b0cde622c1040bb + `idempotent_replay:true`；同 ID 异内容 409 CONTENT_CONFLICT。
- R2（新 pair）：cap_le2_j06_idem_0001 重放同 task_826af4d30b4a44e1 + idempotent_replay:true；异内容 409。

### 2.3 App 侧同名同分钟不覆盖（ED，截图 s51–s52）

两条「同名测试笔记」于 19:03 同分钟共存（s51/s52）；提交后 capture_id 各不相同（cap_7c20…/cap_2040…），各自独立 COMPLETED（note …-2199638c / …-98e49236），互不覆盖。

## 3. J08 修正链（原始九点/修正十点/补充十一点语义）

### 3.1 ED 实操（实例 18231，截图 s45–s50）

1. 现场修正入口 → App 进入「正在写修正版」模式（s45/s46）→ 以同 capture_id 提交 rev2（intent=correction）。
2. 服务端 captures 表 (capture_id, payload_revision) **双行**：rev1 → note 202609221848…J05…-9cb3cd6e 与 rev2 → note 202609221853…J08… 各自 COMPLETED，**rev1 原始行与产物不动**。
3. App 原始来源面板显示 revision 2 + 三时间 + sha256 + 原文（s49/s50）；≤2 次导航可达。

### 3.2 LE 复验

- R1：cap_897e80b3… rev2 intent=correction、correction_of=自身；rev1 行与 raw backup（sha256 不变）原样保留；新笔记 frontmatter 标 revision 2 + related 指回原 note（le_s24/s29）。
- R2（新 pair，链路层）：rev2 intent=correction、context_ref 指向 rev1 note；rev1 行不动（le2_s07）；rev2 整理超时 FAILED（E1，不影响链路语义）。

## 4. 回归保护映射

旧 KK03 未关闭发现 PX-KK03-01/02/03（原始来源、防误操作、当前/历史状态）映射为 J08/J06/J09 保护，本轮均在新终端重新证明，未改写旧报告。J09（当前/历史区分）证据：消息渲染 `[HH:mm·当前/早前/历史]` 前缀 + AgentContext KK04 引导文案；ED same-pair 复核目验 `[23:04·早前]` 前缀（s65 底部）。

## 5. 环境披露

- 幂等与修正链在隔离实例（18231/18232）验证；并发大规模重放压力未测。
- R2 窗口 rev2 整理遇 E1 超时属后端环境性退化（见 DEFECT_CYCLE.md），非溯源语义缺陷；rev1 不动这一核心断言在两侧三轮（ED/R1/R2）均成立。
