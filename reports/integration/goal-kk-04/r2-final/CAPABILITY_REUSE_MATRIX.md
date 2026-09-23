# GOAL-KK-04 R2-final — CAPABILITY_REUSE_MATRIX

> 2026-09-23 · ED context ED-KK04-FINAL-EVIDENCE-COMPLETION-20260923-A1F7
> 合同要求：优先复用既有能力，禁止平行重造。本轮增量（缺陷修复）为零新组件，全部在既有模块内修补。

## 1. App 端

| 能力 | 复用/新建 | 说明 |
|---|---|---|
| 采集箱/持久队列 | 复用（R1 已建 CaptureCore/CaptureStore） | 本轮零改动 |
| 同步控制 | 复用（SyncController/LingxiBridgeClient） | 本轮零改动 |
| 页面与状态机 | 复用修补（Index.ets） | D-LE2-01/04/05 与版本链视图，均为既有页面内状态与文案修补，无新页面 |
| 声纹/语音会话 | 复用（KK-03 遗产，本轮未动） | AgentContext/VoiceSessionController 各 4 行适配（R1 时） |
| 消息前缀（历史/早前/当前） | 复用（KK-03 PX01 修复遗产） | KK-04 沿用 tag 逻辑（OBS-ED-01 如实记录其可达性） |

## 2. Workbench 端

| 能力 | 复用/新建 | 说明 |
|---|---|---|
| 插件框架 | 复用（lingxi_server 插件挂载，既有机制） | plugin.py 注册，无框架改动 |
| DSH 调用 | 复用（dsh_acp_client，15 行参数适配） | 无新 LLM 通道 |
| ASR | 复用（vendor mlx-whisper/small，vendor/ 零改动） | — |
| organizer | 复用（instant-note-organizer-v4 既有技能） | 零改动 |
| 接收持久化 | 复用（store.py sqlite WAL，R1 已建） | 本轮零改动 |
| 整理串行化 | 复用修补（pipeline.py `_organize_lock`） | 语言级互斥锁，无新基础设施 |
| 隔离部署 | 复用修补（isolated.sh 增前端模板部署 6 行） | — |
| 测试 | 复用扩充（test_bridge.py +28 行） | 13/13 PASS |

## 3. 结论

本轮缺陷修复未引入任何新依赖、新服务、新页面、新通道；全部在 R1 已审模块内完成。R1 全量新建清单见旧包（SUPERSEDED）同名单元；其复用判定（协议/插件/ASR/organizer/DSH 全部复用既有）在本轮依然成立且未扩大表面积。
