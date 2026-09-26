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
