# CAPABILITY_REUSE_MATRIX — GOAL-KK-04 R3 能力复用矩阵

```text
STATUS=STEP_1_DESIGN_BASELINE
盘点对象=WORKBENCH_PREIMAGE 852c74d0 真实代码（gh API 直读，SHA 绑定）
原则：每个入口注明复用哪个真实能力、在线与否、离线副本规则、未连接表现；不把"未来插件"画成已连接。
```

## 1. 工作台既有能力盘点（实测存在于前镜像）

| 能力 | 真实位置（852c74d0） | 形状 | 复用决定 |
|---|---|---|---|
| 移动采集桥（协议 v1） | `lingxi/server/mobile_capture_bridge/`：routes.py(25.6KB) / pipeline.py(23.2KB) / store.py(12.7KB) / plugin.py(3.4KB) | FastAPI APIRouter，`/api/mobile-capture/v1`：devices/register·revoke、captures(202/PUT asset/GET)、tasks/{id}·retry、capabilities、demo-audio、plugin enable/disable | **复用并扩为 v2**（加账户/工作区，见 §3 缺口） |
| 采集持久层 | 同上 store.py：SQLite 四表 devices/captures/tasks/events + meta | 双状态位 transfer_status / processing_status；event log per device | 复用表结构演进（加列，不重建） |
| 主服务 | `lingxi/server/lingxi_server.py`（618KB） | 既有桌面 API/知识/会话全部入口 | 不动；bridge 以插件挂载，仅按授权最小兼容改动 |
| DSH ACP | `lingxi/server/dsh_acp_client.py`（36.5KB） | 手机不经此直连 DSH；桥内整理链已复用 | 保持 |
| 灵犀 AI/Bot | `lingxi/server/lingxi_ai.py`(76KB) / `lingxi_bot.py`(46KB) | CP 工具、消息桥 | 不动 |
| 离线 ASR（电脑侧） | `lingxi/scripts/mlx_transcribe.py`、`whisper_transcribe.py` | mlx-whisper small（R1 实测链路） | 工作台 ASR 质量恢复路径复用 |
| 整理管线 | instant-note-organizer-v4 skill（既有，禁改） | 采集→正式 MD/HTML | 复用，手机只提交采集不代替整理 |
| 隔离启动 | `lingxi/scripts/mobile_capture_bridge/isolated.sh` | 独立 data root/端口/DSH home | 复用到隔离验证 |

## 2. 手机端能力（新建，nutshell）

| 能力 | 复用什么 | 新建什么 |
|---|---|---|
| 离线中文 ASR | sherpa-onnx AAR（k2-fsa，Apache-2.0，预编译 arm64）+ Zipformer 中英双语小模型随包 | Android 会话封装/质量检测/进度取消 |
| 录音与锁屏 | Android FGS（microphone 类型） | CaptureSession + 片段保全 |
| 本地库 | Room/SQLite 原生 | devices 无关：本地草稿/修订/outbox/下载副本四域 |
| 手机 Agent | 无（否决 DSH 直接移植，见 IMPLEMENTATION_PLAN §5） | 轻量 plan-tool 循环 + OpenAI 兼容客户端 + ≥2 本地工具 |
| 远端工具调用 | bridge v2 能力目录 + tasks API | 手机侧工作面/执行端标注/取消 |
| 账户/工作区 | devices 表 token 机制（R1 已有） | **服务端强制 workspace 校验 —— 当前缺口，见 §3** |

## 3. 缺口清单（新代码，不冒充已有）

| 缺口 | 现状 | R3 处理 |
|---|---|---|
| `account_id`/`workspace_id` 列与服务端强制 | 现 schema 只有 device token；客户端可传任意 workspace —— 不满足 R3「不能只信任客户端」 | store 加列 + 凭据↔workspace 绑定 + 路由层强制；合成 A/B 验证 |
| 配对/凭据生命周期 | devices/register 已有雏形 | 配对码换 token、撤销即时 401、过期语义 |
| 会话/任务工作副本接口 | 现仅采集-任务 | 新增 `/v2/knowledge/*`、`/v2/tasks` 扩展状态机（executor_side 等） |
| 结果回绑（PX-07） | 现有 retry，无孤儿结果回绑 | 恢复流程先查 orphan result → 回绑，禁第二主源 |
| 能力目录真实性 | v1 capabilities 静态探测 | v2 声明 execute_side/requires/availability 实测 |

## 4. 未连接表现（合同硬要求的诚实表达）

| 能力 | Mac 不可达 | 完全离线 |
|---|---|---|
| 全量知识检索 | 标灰 + 最后同步时间 | 仅已下载副本，明确范围 |
| 整理/ASR 恢复 | 排队 outbox，恢复自动续 | 同左 |
| 手机 Agent | 可用（手机有网时调模型 API + 本地工具） | 不可用，诚实置灰 |
| 远端工具 | 等待/排队/取消三选 | 不可用 |
