# IMPLEMENTATION_PLAN — GOAL-KK-04 R3 账户化移动工作台

```text
ROLE=ENGINEERING_DELIVERY
GOAL_ID=GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
CONTRACT_REVISION=R3-ACCOUNT-AGENT
APP_PREIMAGE=c6739191c5fe29eb6b16610fb67eeaf2d83f622e
WORKBENCH_PREIMAGE=852c74d05858119e6c35ea69bae9c4c1280d5963
STATUS=STEP_1_TECHNICAL_DESIGN
DATE=2026-09-26
```

本文为合同 §3 第 1 步「盘点与技术方案」主文档。所有选型均为 ED 技术决定；凡偏离合同预期之处显式标注。

---

## 1. 总体架构决定

```text
手机 App          手机本机能力                个人服务器（Mac mini）
┌──────────────┐  ┌────────────────────┐   ┌──────────────────────────┐
│ Kotlin+Compose│  │ sherpa-onnx 离线 ASR│   │ lingxi_server +          │
│ 单 Activity   │  │ Room 本地库+文件系统 │   │ mobile_capture_bridge    │
│ 灵犀/记录/    │──│ 轻量 Agent 运行时    │──▶│ （扩展：账户/工作区校验、  │
│ 知识/我的     │  │ （OpenAI 兼容 API）  │   │  会话/任务/知识副本接口）  │
└──────────────┘  └────────────────────┘   │ DSH / ASR / organizer    │
        HTTPS+设备凭据（局域网直连）          └──────────────────────────┘
```

关键决定：

1. **App 语言/框架：原生 Kotlin + Jetpack Compose，单 Activity。** 理由：录音前台服务（FGS mic 类型）与锁屏/后台区间、原生分享/相机入口、sherpa-onnx AAR 原生集成，均为合同硬要求；跨端框架在音频链路与后台行为上增加不可控桥接风险。不用 React Native / Flutter / WebView 壳。
2. **离线 ASR：sherpa-onnx（k2-fsa）预编译 Android AAR + Zipformer 中英双语流式小模型。** Apache-2.0 许可，arm64-v8a 原生库，无需 GMS、无需 NDK 自编译。模型资源随 APK 资产或首次受控下载预置——合同 J13 要求飞行模式冷开可用，故**模型文件打进 APK 资产**（接受包体增大），不做首次联网下载。Android 系统 SpeechRecognizer 依赖 GMS，Mate60 不假设可用，**否决**。
3. **手机 Agent：自研轻量运行时（Kotlin）**，实现：多步任务编排（plan→tool→observe 循环，上限步数）、调用用户自配的 OpenAI 兼容模型 API、至少两个真实本地工具（已下载知识全文检索、本地草稿创建）。**完整 DSH 在 Android 上本轮不承运**——评估见 §5，按合同 §1.3 如实披露"不具备完整 DSH 插件等价"。
4. **本地持久层：Room（SQLite）+ 应用私有文件目录。** 草稿/未同步修订/原始录音写 `filesDir` 持久区，绝非 `cacheDir`；可重取下载副本才进受控缓存，两者分库分目录，清缓存不碰待同步数据。
5. **账户模型：服务端签发的设备凭据（bearer token，绑定 account+workspace+device_id，可撤销、可过期）。** 首次绑定走 Mac 工作台生成的配对码（手机扫码或手输短码）或同网段手动确认，不假设公共注册中心。合成 A/B 账户凭据由测试陷印口（仅 debug 构建）注入。

## 2. 账户 / 工作区 / 设备 / 服务器识别协议

| 对象 | 标识 | 服务端校验 |
|---|---|---|
| account | `account_id`（服务端签发 UUID）+ 显示名（不构成凭证） | 设备凭据反查，不信客户端传值 |
| workspace | `workspace_id`（服务端权威） | 凭据↔workspace 绑定关系服务端强制 |
| device | `device_id`（App 首启生成）+ 平台/型号自述 | 撤销列表实时生效 → 401 |
| server | 用户配置的 base URL（局域网 IP:port，可改） | TLS 可选（局域网自签），不写死 |

- 未登录：通用壳 + 引导 + 明确标注的合成演示数据；不出现任何真实知识。
- 已授权离线：本机解锁进入该账户工作副本，显示最后同步时间；远端授权待验证单独标注。
- 退出/切换：账户维度目录隔离（`files/accounts/<account_id>/`），切换前未同步内容停在原账户 outbox；新账户零继承。
- 撤销：服务端拒绝 → App 进入"待重新授权"，本地副本保留并如实说明边界。

## 3. 同步与任务协议（草案，最终字段以 INTERFACE_CONTRACT.md 为准）

通道复用并扩展既有 `mobile_capture_bridge` 形状（`/api/mobile-capture/v1/...`，R1 曾跑通），本轮升级为 `/api/mobile-capture/v2/...` 并在服务端做账户强制：

- `POST /v2/session/pair` 配对换设备凭据（一次性配对码 → token）。
- `POST /v2/captures` 提交采集（幂等键 `capture_id+payload_revision`；回信 `durable_received_at`，≠ 完成）。
- `GET  /v2/captures/{id}` 状态：`received/processing/organized/failed + note_id/revision/result_refs`。
- `GET  /v2/tasks/{task_id}` 任务状态机：draft→queued→running→needs_input/completed/failed/cancel_requested/cancelled；`executor_side=phone|mac` 显式标注执行端。
- `POST /v2/tasks/{task_id}/cancel`；恢复时先 `GET /v2/tasks?result_orphan=1` 回绑已有结果，不造第二主源。
- `POST /v2/knowledge/search`（服务端限权检索）、`GET /v2/knowledge/notes/{note_id}/workcopy`（带基准 revision 的工作副本）、`POST /v2/knowledge/notes/{note_id}/submit`（带 base revision；409 → 冲突保全双方）。
- `GET /v2/capabilities` 能力目录：每项声明 execute_side、requires、current_availability。

对象模型沿用 R2 §4 冻结字段：capture_id/device_id/schema_version/payload_revision/captured_at/timezone/received_at/hash/size/原始资产/初次本机转写/用户修订层/context/intent/policy → 服务端回 task_id/durable_received_at/processing_status/note_id/revision/result_refs/error。原始层只读，后续每层新 revision，不覆盖。

## 4. 离线竖切（§3.2 第一交付物）

顺序与验证目标：

1. 账户绑定（合成账户 A）→ 杀进程。
2. 飞行模式冷开 → 进入 A 工作副本（无网络请求）。
3. 录音 ≥30s（FGS + 通知），本机 sherpa 流式转写，编辑正文，保存草稿。
4. 杀进程重开：录音文件、转写、修订、outbox 全在。
5. 切飞行模式关，outbox 自动推送 → 服务端 durable_received → 真实整理 → 双端同 note_id。

随后：J13 五分钟即可辨普通话转写、J14 离线知识副本与冲突、J18-J19 账户隔离与三态、J20-J21 手机 Agent 与远端工具、J16-J17 升级锁屏与附件、J22-J23 收尾。

## 5. 端侧运行时评估（合同 §1.3 强制）

| 选项 | 评估 | 结论 |
|---|---|---|
| 完整 DSH（DeepSeek Harness，Python ACP 栈）直接跑 Android | DSH 依赖 CPython 进程模型、插件子进程、本机文件/socket 约定；Android 无官方 CPython 运行时，Chaquopy/Termux 路线对插件生态（mlx-whisper、外部 CLI）不可控，包体与冷启动不可接受 | **否决并如实披露**：本轮手机端不具备完整 DSH 插件等价（合同允许的轻量替代路线） |
| Termux 用户态 | 属第三方 App 环境，非本 APK 可交付能力 | 否决 |
| Chaquopy 嵌入 CPython | 可行但插件链（mlx、torch 生态）在 arm64 Android  wheels 缺口大；冷启动与内存不可控 | 否决 |
| 自研轻量 Kotlin Agent 循环 + OpenAI 兼容 API + 本地工具 | 满足合同最低手机 Agent 行为（多步编排、真实模型 API、真实本地工具、执行端提示、可取消） | **采用**；声明 NON_DSH_PLUGIN_EQUIVALENCE |

Mac 在线时，完整 DSH/ASR/organizer 能力经 `mobile_capture_bridge` 服务端调用，手机只持工作面。

## 6. 手机体验与 UI 血统

四目的地「灵犀 / 记录 / 知识 / 我的」（R3 §1.2、R2 §2 冻结）。视觉与交互血统来自 `prototypes/knowme-knowledge-01-agent-native-mate60`（React 原型，1231 行，组件清单见 UI_TRACEABILITY_MATRIX.md）：保留其"状态显性化（StateChip：AVAILABLE / NOT_CONNECTED / PLANNED / PROTOTYPE_ONLY → 映射为本机保存/网络/身份/服务/模型/工具分项状态）、采集→候选→确认的对话流、知识地图 DimensionMap"三样东西；纠正其在 R1 审核中暴露的问题：状态单一绿点化（→分项状态条）、诊断信息占首屏（→诊断收进"我的"）、正文原始 YAML（→默认渲染正文，技术视图折叠）。

过程截图与交互走查将在可运行 Compose 界面骨架完成后补充到 `shots/design-walkthrough/`（本步骤内完成，作为后续竖切的界面基线）。

## 7. 七项旧 PX 的新 APK 行为设计映射

详见 OLD_PX_BEHAVIOR_MAPPING.md（竖切阶段随实现更新）。设计期既定：

- PX-01 状态滞后 → 状态存算分离：UI 只读 `ConnectionStateStore`（实测驱动，非记忆），历史状态永不渲染为当前。
- PX-02 连点错对象 → 列表项以稳定 `capture_id` 为 key（Compose `LazyColumn key()`），点击事件携带 item id 而非坐标；禁止重排后复用索引。
- PX-03 来源错配 → 卡片/标题/摘要全部由 note 当前 revision 派生，无静态示例卡片进入正式列表。
- PX-04 低质录音 → 入口级质量检测（振幅/时长/ASR 置信），低质时卡片显式"质量风险"+恢复动作，不出普通完成。
- PX-05 虚假发送 → 外发三态独立（未发/跳过/已发），未发不渲染已发。
- PX-06 难读 → 首屏四目的地 + 单手录入；正文默认渲染。
- PX-07 结果失联 → 恢复流程第一步 `result_orphan` 回绑；同 capture 不产生第二主源。

## 8. 构建与签名

- Gradle wrapper 8.x + AGP 8.x，JDK 17（本机 brew openjdk@17 实测存在）。
- minSdk 26 / targetSdk 34；ABI arm64-v8a 单包。
- 签名：本地隔离目录生成私测 keystore（不进 Git、不进证据包），证书指纹记录入 APK_DELIVERY_RECEIPT；同一 keystore 供升级验证。
- 依赖锁定：gradle.lockfile 提交，公开来源（Maven Central / k2-fsa GitHub Release AAR 固定版本 + sha256 记录）。

## 9. 测试策略

- JVM/Robolectric 单测：outbox、状态存算、协议解析、幂等合并、账户隔离目录。
- 仪器测试（连真机后）：Room 迁移、FGS 录音生命周期、ASR 会话、协议 happy path（指向隔离工作台）。
- 合成 A/B 工作区 fixture：服务端校验、越权拒绝、切换不串。
- 全部真机旅程 J01–J23 由 fresh LE + ED 本人两套实操完成（合同 §5-§6），技术测试不代替产品操作。

## 10. 明确不本轮交付（合同 §10.3-D 对应）

完整 DSH 插件等价的手机运行时、通用电脑安装器、本地通用大模型推理、商业账户平台、NAS/云托管、应用商店发布、OCR/多模态离线理解、企业 RBAC。

## 11. 当前未决项（开工期如实记录）

1. Android SDK 组件尚未安装（本机 SDK 目录为空）——竖切前完成 cmdline-tools/platform-34/build-tools 安装，属环境准备非阻塞。
2. Mate60 未连接——设备能力实测（API/ABI/存储/麦克风/后台限制）在设备接入后更新到 TECHNICAL_RECEIPT，选型已按不依赖 GMS/私有 NPU 设计。
3. 工作台实际运行部署身份未实测——隔离环境验证先行，生产兼容结论在 WORKBENCH_COMPATIBILITY_RECEIPT 给出。
