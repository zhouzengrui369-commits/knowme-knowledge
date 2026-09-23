# E2E_CAPTURE_TRACE — r3-gap-closure

2026-09-23 ｜ 端到端采集追踪：设备 → 队列 → ASR/整理 → 笔记落盘 → 前端可见

## ED 侧主链样本（J02 文本，cap_62c67e143bca99a4427b900769d74234）

1. 20:49:07 App 键入文本（截图 ed3_s02）→「保存到采集箱」→「交给灵犀」。
2. 20:49:13 captured_at 入信封（captured_timezone=America/Chicago 环境怪相已披露）。
3. 服务端 CAPTURE_RECEIVED → task_baffc2b4521b4706 PROCESSING（attempts=1）。
4. 20:53:12 ORGANIZE_COMPLETED；events 表 CAPTURE_RECEIVED→PROCESSING_STARTED→ORGANIZE_COMPLETED 序列完整。
5. 落盘三件套：assets/cap_62c67e14…/r1/cap_….md（原始）+ knowledge/notes/daily/202609232049…-69d74234.md（整理）+ .raw-transcript.backup.md（备份）。
6. 前端知识视图可见（J11 探查时 NOTE 列表含全部本轮采集；工作记录 31→32 随 J11 新增递增）。

## 音频链样本（J03，cap_74910c64985eea87a3e398871dd7e6ac）

- 30s 合成朗读 wav（1,024,078B）→ 真实 ASR（MLX 转写）→ 真实整理 → 笔记落盘（202609232054…-1dd7e6ac.md）。COMPLETED 20:56:56 attempts=1。

## LE 侧

- 13 条采集全链 COMPLETED，含 5min 音频（337,299ms，三端 hash 一致 8dbc7bae…，首轮看门狗超时→产品内重试成功 attempts=2）。详见 le3/LE_RECEIPT.md 终态总账。

## 串行化实证（前轮修复点复核）

- ED 14 task 的 ORGANIZE_COMPLETED 时间逐一相继不重叠（pipeline 串行化生效）；零 LOCKED_SKIP、零看门狗 600s 超时残留 FAILED。

## 结论

文本/音频/离线/修正四类链路端到端全部真实走通，无 mock、无 API 替代（J11 工作台侧同理，见 J11_WORKBENCH_UI_RECEIPT）。
