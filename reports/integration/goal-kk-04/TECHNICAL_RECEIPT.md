# GOAL-KK-04 — 技术实现回执（TECHNICAL_RECEIPT）

> GOAL-KK-04 · TECHNICAL_RECEIPT · ED context ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E
> Final pair：App `10d829195ebb7f6c4c576b0d116e45087ec2b35a` / Workbench `e548883b1d696b8245631bad129dd3737afcc5b7`
> 日期：2026-09-22

## 1. 结论

工作台侧以真实可启停、可查询状态的插件 `mobile_capture_bridge` 落地「可靠接收 → 真实 ASR → 真实 organizer 整理 → 结果/事件回传」全链路；手机侧新增采集箱（capture）与桥接（bridge）两组模块及首屏三区 UI。既有内核（DSH、organizer、ASR、桌面 API）零改写，仅合同授权的最小挂载改动。设计细节见同目录 IMPLEMENTATION_PLAN.md / CAPABILITY_REUSE_MATRIX.md / INTERFACE_CONTRACT.md（索引引用，不重复）。

## 2. 工作台插件四模块（lingxi/server/mobile_capture_bridge/）

| 模块 | 职责 | 关键事实 |
|---|---|---|
| `plugin.py` | 插件对象：name/version/status、enable()/disable()、manifest()；由 lingxi_server 启动时挂载注册 | 停用期间提交返回 `503 PLUGIN_DISABLED`；启用后队列任务自动恢复（resumed_tasks）；真实启停经 J05 实操验证（见 PLUGIN_LIFECYCLE_RECEIPT.md） |
| `store.py` | 持久层：KB_ROOT/lingxi/mobile_capture/ 下 SQLite，devices/captures/tasks/events 四表，WAL | 设备 token 只存 sha256；任务/事件持久化，服务重启后可恢复查询（J05/J09）；捕获/接收/整理三时间分别落库（J07） |
| `routes.py` | APIRouter 实现 INTERFACE_CONTRACT 全部端点 | 设备注册/撤销、能力查询、提交/资产上传（hash+尺寸校验，422 HASH_MISMATCH）、幂等（同 capture_id+revision+hash 重放返回同 task_id + idempotent_replay）、409 CONTENT_CONFLICT、/tasks/{id}/retry（D-KK04-05）、事件流 cursor 补拉、demo-audio 端点（认证+防穿越） |
| `pipeline.py` | 接收→校验→可靠落盘→（音频）ffmpeg+复用 lingxi_server 的 MLX 转写函数→生成「今日接收主源」→后台线程 lingxi_bot.handle_chat 触发 instant-note-organizer-v4→轮询产物→COMPLETED | 先归档原始资产再转写（原 /api/transcribe 会删临时文件）；frontmatter 保留 captured_at/timezone/capture_id/hash；重入核对已有产物保证幂等；FAILED 带 recovery_action；不触发企业微信/全局预览副作用 |

刻意不复用：`/api/add-knowledge` + `_trigger_organize` 完成后会自动发企业微信并写全局 `_PENDING_PREVIEW`，插件实现自有窄路径，隔离环境 `external_send=disabled`（合同 §4/J10）。

## 3. App 侧模块（prototypes/knowme-knowledge-02-voice-speaker-verification/）

| 模块 | 职责 |
|---|---|
| `capture/CaptureCore.ets` | 纯逻辑：CaptureItem 模型（capture_id UUID、kind、captured_at、timezone、revision、hash）、transfer 状态机（LOCAL_SAVED→QUEUED→UPLOADING→RECEIVED）、同名同分钟不覆盖规则、草稿（未提交不入队/不入库）语义。无 @kit 依赖可单测 |
| `capture/CaptureStore.ets` | 沙箱文件持久化：资产文件 + Preferences 索引；杀 App 冷开完整恢复（J04 验证） |
| `capture/WavWriter.ets` | PCM→WAV 封装（16k/mono/s16le 头） |
| `bridge/LingxiBridgeClient.ets` | HTTP 客户端：注册/能力/提交/资产（octet-stream + Content-Sha256）/状态/事件/结果/demo-audio 下载；超时与错误分类（503 插件停用与网络错误文案区分） |
| `bridge/SyncController.ets` | 队列调度：手动「交给灵犀」+ 网络恢复自动补传（≤10s 启动）；幂等重传；ACK 前不删原件；D-KK04-03 修复（pullEvents/refreshPending 更新后 notify） |

UI 改造：`pages/Index.ets` 首屏三区（①采集：文本输入+录音，1 秒反馈；②采集箱：本地/排队/已接收/整理中/已完成状态分明；③灵犀结果：note_id、原始来源 ≤2 次导航、现场修正入口、「重试整理」按钮 D-KK04-05）；J09 消息渲染加 `[HH:mm·当前/早前/历史]` 前缀；诚实标注横幅（KK-04 原型/模拟器/隔离工作台/无对外发送/合成音频披露/草稿不入库）。

## 4. 允许的最小挂载改动（逐条）

合同授权范围：「仅插件挂载、新增兼容 API、隔离数据根/会话和返回路由允许最小修改：lingxi_server.py、dsh_acp_client.py、lingxi_bot.py、lingxi_ai.py」。实际改动仅两处（lingxi_bot.py / lingxi_ai.py **未改**）：

1. **`lingxi/server/lingxi_server.py`**（M）：文件尾部纯追加插件挂载段——`try: from mobile_capture_bridge.plugin import mount_mobile_capture_bridge; MCB_PLUGIN = mount_mobile_capture_bridge(app)`，挂载失败仅打印告警、置 `MCB_PLUGIN=None`，不影响任何既有桌面功能与路由行为。diff 仅 +12/-0 行（追加块）。
2. **`lingxi/server/dsh_acp_client.py`**（M）：四个硬编码生产路径改为 env 可覆盖——`LINGXI_DIR`/`DSH_BIN`/`DSH_HOME`/`KB_ROOT` 由 `LINGXI_DIR`/`LINGXI_KB_ROOT`/`LINGXI_DSH_BIN`/`LINGXI_DSH_HOME` 派生，**默认值与原硬编码逐字一致**（含此前「/runtime 缺失」修复后的正确路径），生产行为零变化；隔离环境通过 env 指向独立 KB_ROOT/DSH home。

App 侧无「挂载改动」概念，全部改动在合同允许的 prototype 路径内（含 module.json5 新增 `ohos.permission.INTERNET` 与 `ohos.permission.GET_NETWORK_INFO`，授权明确允许）。

## 5. 证据锚点

- 冒烟（隔离实例 18231）：文本 cap_smoke001 → 真实 organizer v4 COMPLETED、三件产物齐全、无企业微信外发；音频 cap_smoke_audio01（23s 合成朗读 wav 753,106B sha 130e8815…）→ 真实 MLX ASR → COMPLETED
- 12 用例单测全过（起草时复跑确认）；App build-hap.sh BUILD SUCCESSFUL（HAP 39,201,171 B）
- J01–J12 逐旅程证据：见本目录 E2E_CAPTURE_TRACE / OFFLINE_SYNC / LATE_ARRIVAL / PROVENANCE_REGRESSION / PLUGIN_LIFECYCLE / VISUAL_INSPECTION 各回执与 SCREENSHOT_INDEX.md

## 6. 环境披露

全部验证在模拟器 + 本机隔离实例（18231 ED / 18232 LE）上完成；真机、生产环境部署、公网入口未验证。DSH/TokenHub 后端存在时段性 600s 看门狗超时（E1，详见 DEFECT_CYCLE.md），属环境性风险，非本 Goal 代码缺陷。
