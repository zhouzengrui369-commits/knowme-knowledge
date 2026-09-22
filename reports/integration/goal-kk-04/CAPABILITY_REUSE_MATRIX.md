# GOAL-KK-04 — 能力复用矩阵（CAPABILITY_REUSE_MATRIX）

ENGINEERING_CONTEXT_ID=ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E
调查基线：App `be400447` + Workbench `0f559579`（exact preimage 实测读取，非 README 自称）

| 合同能力 | 现状（真实来源） | 复用方式 | 复用类别 |
|---|---|---|---|
| 手机 PCM 录音 16k/mono/s16le | `AudioCaptureController.ets`（AudioCapturer，显式 start/stop/cancel） | 直接复用类；新增 WAV 封装器写文件 | 原样复用 |
| 手机录音权限状态机 | `VoiceCore.ets` MicState 状态机 + `PermissionController.ets` | 原样复用 | 原样复用 |
| 声纹验证（Sherpa eres2net） | `SpeakerVerificationController.ets` / `SherpaSpeakerEngine.ets` | 保留 UI；**不作为采集/上传前置门槛**（baseline §3） | 保留不阻断 |
| 手机首屏 UI | `pages/Index.ets`（1110 行单页） | 重构首屏为「采集 / 采集箱 / 灵犀结果」三区；诊断与测试项折叠 | 窄适配改造 |
| 手机端确定性笔记流 | `note/NoteFlow.ets` | KK04 不在手机生成正式笔记；NoteFlow 仅保留为历史本地草稿语义，不作为正式结果 | 降级保留 |
| 手机持久化 | 无采集箱（KK03 仅有界原型持久化） | 新增 `capture/CaptureStore.ets`（应用沙箱文件 + Preferences 索引） | 新增 |
| 手机→工作台传输 | 无（KK02/KK03 无网络） | 新增 `bridge/LingxiBridgeClient.ets`（@kit.NetworkKit http）+ `ohos.permission.INTERNET` | 新增 |
| 离线队列/自动补传 | 无 | 新增 `bridge/SyncController.ets`（队列持久化、网络恢复监听、幂等重传、ACK 前不删原件） | 新增 |
| 工作台 HTTP 服务 | `lingxi/server/lingxi_server.py`（FastAPI/uvicorn，`LINGXI_PORT`/`LINGXI_KB_ROOT` 已 env 化） | 插件以 APIRouter 挂载；仅最小改动注册路由 | 窄适配挂载 |
| 真实 ASR | `/api/transcribe` 内部链路：ffmpeg→16k wav→`_mlx_transcribe`（MLX GPU small，模型常驻）回退 openai-whisper 子进程 | 插件直接调用同模块函数 `_mlx_available/_mlx_transcribe/_read_wav_16k/_ffmpeg_bin`；**先归档原始资产再转写**（原接口转写后删临时文件，插件自持原件） | 函数级复用 |
| 笔记整理 | `skills/instant-note-organizer-v4`（仅处理 KB_ROOT/knowledge/notes/daily/ 今日主源；产出 md+raw backup+html 三件） | 插件生成「今日接收主源」（迟到采集保留 captured_at/timezone 与原日期关联，受控适配，合同 §5），通过 `lingxi_bot.handle_chat` 按 SKILL.md 触发 | 窄适配复用 |
| DSH 智能体通道 | `lingxi/server/dsh_acp_client.py`（ACP v1，per-call spawn；TokenHub deepseek-flash） | **最小补丁**：硬编码生产路径改为 `LINGXI_KB_ROOT/LINGXI_DIR` env 派生；隔离环境独立 DSH home/session | 最小修改（已授权） |
| 添加知识入口 | `/api/add-knowledge` + `_trigger_organize` | **不直接复用**：其完成后自动发企业微信+写全局 pending-preview。插件实现自有「接收→落盘→触发整理」路径，隔离环境 `external_send=disabled`，不碰 `_PENDING_PREVIEW` | 刻意不复用（副作用隔离） |
| 知识结果查看 | `/api/note`、`/api/doc-raw`、`/api/notes` | 插件 `/results/{note_id}` 读取同一 daily 产物文件，同一 note_id 双端可见 | 数据级复用 |
| 企业微信外发 | `lingxi_wecom.py` | 隔离环境插件默认禁用；不调用 | 禁用 |
| 公网网关 | `public_gateway.py` | 不修改、不启用 | 不触碰 |
| 生产服务 8787 | `lingxi/lingxi.sh` LaunchAgent | 不重启不修改；隔离实例独立端口 | 不触碰 |

## 版本与身份（实测）

- 工作台服务：FastAPI + uvicorn，`lingxi/server/lingxi_server.py`（10027 行），端口 env `LINGXI_PORT`
- ASR：mlx-whisper（`mlx-community/whisper-small-mlx`），`lingxi/scripts/mlx_transcribe.py` / `whisper_transcribe.py`；ffmpeg 转 16k 单声道
- DSH：`lingxi/vendor/dsh`（gitignored，隔离环境从本机复制字节）；模型 pin `tencent-tokenhub / deepseek/deepseek-flash`
- Organizer：`skills/instant-note-organizer-v4`（SKILL.md + scripts/ino_render.py、ino_gate.py，/usr/bin/python3 标准库）
- App：HarmonyOS ArkTS，compatibleSdkVersion 4.1.0(11)，DevEco SDK 6.1.1，hvigor 构建，hdc 3.2.0d 部署
