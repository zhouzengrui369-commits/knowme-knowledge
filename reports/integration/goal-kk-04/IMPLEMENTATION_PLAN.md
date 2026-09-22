# GOAL-KK-04 — 工程实现计划（IMPLEMENTATION_PLAN）

ENGINEERING_CONTEXT_ID=ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E
冻结合同：CONTRACT.md + ENGINEERING_EXECUTION_CONTRACT.md @ `be400447c1d68062d22ae5e9ea0d169d929514df`
协议：见同目录 INTERFACE_CONTRACT.md（PROTOCOL_VERSION=1.0.0）

## 0. 拓扑

```
手机 App（HarmonyOS, 模拟器 127.0.0.1:5555）
  capture box（沙箱持久化）→ SyncController → HTTPS/HTTP
        ↓ /api/mobile-capture/v1（Bearer 设备凭证）
隔离工作台实例（独立 LINGXI_PORT=18787，独立 KB_ROOT=<隔离数据根>，独立 DSH home/session）
  mobile_capture_bridge 插件（APIRouter 挂载进 lingxi_server）
    → 可靠接收落盘（hash 校验）→ ASR（_mlx_transcribe 复用）
    → 今日接收主源（迟到保留 captured_at）→ lingxi_bot.handle_chat(organizer v4)
    → 产物 md/backup/html → task COMPLETED + result_refs + 事件流
```

隔离保证：独立端口/数据根/DSH session；`external_send=disabled`；不碰 8787 生产、
LaunchAgent、public_gateway、腾讯云；凭证本机注入不打印不提交；仅用合成数据。

## 1. 工作台侧（njx-knowledge，分支 engineering/goal-kk-04-mobile-capture-bridge）

新增 `lingxi/server/mobile_capture_bridge/`（纯 Python 标准库 + FastAPI）：
- `plugin.py` — 插件对象：name/version/status、enable()/disable()、manifest()；由
  lingxi_server 启动时加载注册（真实可启停、可查询状态）。
- `store.py` — 持久层（KB_ROOT/lingxi/mobile_capture/ 下 SQLite：devices/captures/tasks/events 四表；
  WAL；设备 token 只存 sha256）。
- `routes.py` — APIRouter 实现 INTERFACE_CONTRACT 全部端点。
- `pipeline.py` — 接收→校验→落盘→（音频：ffmpeg+复用 lingxi_server 的 MLX 转写函数）
  →生成今日接收主源（frontmatter 保留 captured_at/timezone/capture_id/hash/迟到关联）
  →后台线程 lingxi_bot.handle_chat 触发 instant-note-organizer-v4 →轮询产物→COMPLETED。
  重入核对已有产物；FAILED 带 recovery_action；不触发 wecom/预览副作用。
- `__init__.py`、`README.md`（插件说明）。

最小修改（授权内）：
- `lingxi/server/lingxi_server.py`：仅追加插件挂载段（try import + include_router + 状态端点
  注入），不改既有路由行为。
- `lingxi/server/dsh_acp_client.py`：硬编码生产路径改为 `os.environ.get(...)` 派生
  （LINGXI_KB_ROOT/LINGXI_DIR/LINGXI_DSH_HOME），默认值保持原生产路径不变 → 生产行为零变化。

测试 `tests/mobile_capture_bridge/`：pytest 覆盖注册/撤销/幂等/冲突/离线补传语义/
迟到适配/事件补拉/插件停启恢复/未授权拒绝/命令素材不执行。

脚本 `lingxi/scripts/mobile_capture_bridge/`：隔离实例启动/停止/状态脚本
（独立 KB_ROOT 初始化、skills 与 transcribe 脚本只读复制、vendor/dsh 字节复制、端口参数化）。

## 2. 手机侧（knowme-knowledge，分支 engineering/goal-kk-04-lingxi-mobile-capture-bridge-r1）

`prototypes/knowme-knowledge-02-voice-speaker-verification/` 内新增：
- `entry/src/main/ets/capture/CaptureCore.ets` — 纯逻辑：CaptureItem 模型（capture_id UUID、
  kind、captured_at、timezone、revision、hash）、transfer 状态机、同名不覆盖规则、
  草稿（未提交不入队）语义。无 @kit 依赖，可单测。
- `entry/src/main/ets/capture/CaptureStore.ets` — 沙箱文件持久化：资产文件 +
  Preferences 索引；杀 App 冷开后完整恢复。
- `entry/src/main/ets/bridge/LingxiBridgeClient.ets` — HTTP 客户端（注册/能力/提交/资产/状态/事件/结果）；
  base64 或 octet-stream；超时与错误分类。
- `entry/src/main/ets/bridge/SyncController.ets` — 队列调度：手动「交给灵犀」+ 网络恢复自动补传；
  幂等重传（同 capture_id+revision+hash）；ACK 前不删原件；10 秒内启动同步。
- `entry/src/main/ets/capture/WavWriter.ets` — PCM→WAV 封装（16k/mono/s16le 头）。
- `pages/Index.ets` 改造 — 首屏三区：①采集（文本输入 + 录音按钮，1 秒反馈）
  ②采集箱（本地/排队/已接收/整理中/已完成状态分明，未同步与未整理可分）
  ③灵犀结果（note_id、原始来源 ≤2 次导航可达、现场修正入口）。
  声纹入口保留但非前置门槛；诊断/TEST_FIXTURE 折叠不主导。
- `module.json5` 增加 `ohos.permission.INTERNET`（reason 字符串）。
- `ohosTest` 增加 CaptureCore/SyncController 单测；`scripts/` 增加端到端冒烟脚本。

5 分钟录音：PCM 9.6MB 内存可承受；落盘 WAV；上传 octet-stream + sha256 校验。

## 3. 迟到与跨日（J07/J08）

- 采集时间 ≠ 接收时间 ≠ 整理时间，三字段分别持久化与披露。
- 昨日采集今日上传：插件以**接收日**建立今日主源（organizer 仅处理今日），
  frontmatter 与原文件首行保留 `captured_at`/`captured_timezone` 与原捕获日期关联；
  `/captures?from_date=` 按捕获日期可查；不改系统时钟、不重写历史 daily/Wiki。
- 修正/补充：新 revision/新 capture 关联 `correction_of`/`supplement_of`；
  原始资产+最初转写不可变；两端 ≤2 次导航看到原始来源。

## 4. 实施顺序

1. 工作台插件骨架 + store + 注册/能力/幂等接收（文本主链）
2. 隔离实例启动脚本 + dsh_acp_client env 补丁 + 冒烟（文本→整理→结果）
3. 音频链路（WAV 归档→ASR→整理）
4. 手机端 CaptureCore/Store/Client/Sync + UI 三区
5. 离线/重启/中断/幂等/跨日/来源分层/停启恢复/安全 负路径
6. 缺陷循环 → 冻结 provisional final → LE final → ED 本人 final → 证据包

## 5. 已知边界（如实披露）

- 模拟器无真实麦克风输入：真实录音采用「可识别合成朗读音频经 hdc push 进采集」
  （合同 J03 允许合成朗读；ASR 仍是工作台真实 MLX Whisper）。
- 真机安装、生产、公网、多模态、完整索引不在本 Goal。
- DSH/TokenHub 凭证由本机安全注入隔离 DSH home，不进 Git、不打印。
