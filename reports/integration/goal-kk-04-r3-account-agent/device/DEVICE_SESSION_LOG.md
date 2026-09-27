# R3 真机联调证据（Mate60 / BRA-AL00）— 2026-09-26 夜间段

## 设备与环境
- 设备：HUAWEI BRA-AL00（Mate 60），HarmonyOS（Android 12 兼容层，SDK 31），arm64-v8a
- 通道：USB adb；`adb reverse tcp:18245 tcp:18245`（手机 127.0.0.1 → Mac 隔离桥）
- 隔离桥：`/tmp/kk04-r3-iso`，端口 18245，外发 disabled，LINGXI_MCB_TEST_MODE=1；生产 8787 与生产 DSH home 零写入
- 合成账户：acc-a/ws-a（绑定用）、acc-b/ws-b（隔离对照，本轮未绑）

## APK 版本链（本日真机段）
| # | sha256(前8) | 大小 | 内容 |
|---|---|---|---|
| v1 | 702bf12d | 149,791,589 | 交接时基线（首装成功） |
| v2 | acf817d0 | 149,834,049 | +debug cleartext、rememberSaveable、首页按钮接线 |
| v3 | 72ebfccd | 149,834,049 | +PairingRepository 403 透传服务端错误 |
| v4 | a8d1ef9e | 149,834,049 | +@SerialName snake_case 契约对齐（pair + capture 全链） |
| v5 | 003150b7 | (最终) | +文字采集接线（记录页 保存草稿/交给灵犀） |

## 真机实测结果
- **J01 安装/启动/配对/撤销（部分）**：
  - v1 首装 Success（Streamed Install 4m43s）✔（j01-first-launch.png）
  - 首页状态条：本机✓ 网络✓ 身份? 服务? 模型? 工具?（分项实测，符合 PX-01）
  - 配对：pair 请求经 USB 隧道到隔离桥 → 200 OK；UI 显示 账户 acc-a… / 工作区 ws-a… / 设备 dev_43df68b0cc4d4b5a ✔（j01-paired.png）
- **J02 在线文本**：手机输入合成笔记 → 保存草稿/交给灵犀（显式授权）→ 本机 Room（DRAFT→QUEUED）→ outbox 推进 → GET /capabilities 200（身份在线校验过）→ POST /captures 202 Accepted → 服务端 assets/cap-326b39d6a4cd46a58984/1/*.md 原文落盘 ✔（j02-submitted.png）
  - App 列表状态实时显示「工作台已接收」✔
  - 整理链路：task_02befdba543643d4 PROCESSING（隔离 DSH organizer 重试中，attempts=2；错误=已知 ACP session persistence flush failed；原件保全，不影响 RECEIVED 事实）

## 真机实测发现并修复的缺陷（全部为 Mac 侧 E2E 无法暴露）
1. **App**：targetSdk34 禁明文 HTTP → 任何 http:// 工作台都连不上（CLEARTEXT 报错）。修复：debug 变体 `usesCleartextTraffic=true`（release 保持严格）。
2. **服务端**：`/v2/session/pair` 错误要求 x-operator-token（配对码本身即一次性凭据；operator token 只该管管理端点）→ 手机配对必 403。修复：移除 pair 的 operator 校验（routes_v2.py）。
3. **App**：所有 403 被误报为"配对码无效或已使用"，掩盖真实错误。修复：透传服务端 message。
4. **App**：pair/capture 请求体 camelCase vs 服务端 snake_case 契约 → pair 400、captures 必然 400/解析失败。修复：@SerialName 全量对齐（含 captured_timezone、content_size、result_refs 类型 Map）。
5. **App**：首页「去绑定账户」「语音/文字/附件」均为空 onClick stub；「记录」页无文字录入。修复：导航接线 + 记录页新增文字采集（保存草稿=DRAFT 不上传 / 交给灵犀=显式授权 QUEUED→outbox→tick()）。
6. **App**：绑定表单 remember 切 Tab 即丢。修复：rememberSaveable。

## 遗留（如实记录）
- 隔离 DSH organizer 偶发 ACP session persistence flush failed（已知问题，重试机制在跑；历史 attempts=4 最终 COMPLETED）
- 首页状态条 身份/服务/模型/工具 的主动实测时机未接入 tick 后刷新（tick 已实测 capabilities，状态条在记录页操作后可见刷新）
- J03 真实麦克风录音、J13 离线 CER、J14-J23、七项 PX 回归：未开始
- 证据截图目录：reports/integration/goal-kk-04-r3-account-agent/device/


---

## 2026-09-27 晚（二轮真机段）

隔离根改持久化：`/tmp/kk04-r3-iso` 因 macOS 清 /tmp 蒸发 → `KK04_ISO_ROOT` 默认改
`/Users/njx/Project/kk04-r3-engineering/.kk04-r3-iso`（e2e runner 同步修，workbench @0ccb8e7）。

### J20/J22 退出+吊销链（PASS）
1. 先 `GET /capabilities`（旧凭据）→ 200；
2. 手机「退出当前账户」→ 服务端 `POST /devices/revoke` 200 → 界面立即翻回绑定表单（响应式修复生效）；
3. 再 `GET /capabilities`（同凭据）→ **401 DEVICE_REVOKED**。
凭据 dev_4fbafe97138045f6 撤销后改绑新设备 dev_b2c8f81be72943ec。
证据：`j20-exit-flip.png`。

### J03 语音采集+离线转写（PASS：管线；silent 空转写如实）
- 录音 11.8s（环绕声·无人声）→ WAV 原件 377,600B 保全；
- ASR 实接 sherpa-onnx（生态 V2 界面："转写中…（还没听清）"证明会話已开），结束空转写——
  **如实标 qualityWarning=transcript_empty，不伪造文字**；
- DB：capture `cap-e502acaecdaa4d9a9895`（kind=voice,DRAFT）+ revision initial_transcript(author=device-asr,len=0)；
- 证据：`j03-recording.png` / `j03-voice-draft.png`。

### 真机暴露并修复（App 仓 @303b54b）
- #7 四屏 session 一次性读→StateFlow 响应式（退出/绑定不重绘的假象）；
- #8 录音链挂 ASR + persist 语音草稿（此前 AsrStreamBus 零消费，模型只 provision 不用）；
- #9 stopCapture cancel recordJob 致 persist 挂起全丢（实测：33s wav 在、DB 无行）→ 不 cancel；中断路径 NonCancellable；
- refresh() 从 prefs.edit{} 事务内挪出。

### 遗留（如实）
- DRAFT 采集行暂无「交给灵犀」按钮（仅文字录入框可提交）；
- 工作台暂无二进制资产上传端点：语音件只能以文本（转写）交换，WAV 原件不出本机；
- 绑定态页仍残留退出提示（rememberSaveable 未随重置），小瑕疵；
- J13 离线 CER 需真人说话样本，待用户配合。

APK 演进链（新增）：
| v | sha256 | 变更 |
|---|---|---|
| v6 | b4c03424… | 响应式 StateFlow + revoke 接线 |
| v7 | 94476d5e… | bind refresh 挪出事务 |
| v8 | e93f69ae… | ASR 会話接线 + persist 语音草稿 |
| v9 | abd90fe6… | stopCapture 不 cancel + NonCancellable 中断保全 |
