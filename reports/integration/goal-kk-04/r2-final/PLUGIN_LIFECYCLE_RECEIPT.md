# GOAL-KK-04 R2-final — PLUGIN_LIFECYCLE_RECEIPT

> 2026-09-23 · 插件 mobile_capture_bridge v1.0.0 全生命周期实证。

## 1. 生命周期事件与证据

| 阶段 | 证据 | 结果 |
|---|---|---|
| 安装/注册 | 插件经 lingxi_server 既有挂载机制注册（lingxi_server.py +12 行），无框架改动 | PASS |
| 初始化 | isolated.sh init：KB_ROOT 初始化、DB 建表（captures/tasks/events）、插件 enabled、external_send=disabled、前端模板部署（D-LE2-02） | PASS |
| 能力声明 | GET /capabilities 与 App 设置页一致：插件 1.0.0 / ASR mlx-whisper/small / organizer v4 / 隔离不外发（ED s02、LE j01_01） | PASS |
| 设备注册/撤销 | register 201 → revoke 后上传/读取 DEVICE_UNAUTHORIZED（R1 证，架构未变）；撤销后 App 原位红字指引（D-LE2-01，LE j01_04） | PASS |
| 停用 | POST /plugin/disable → 期间 POST /captures 503；App「⚠ 工作台插件停用中·保持排队，插件启用后自动补传」+ 重新同步按钮（ED s13/s14、LE j05_01） | PASS |
| 启用恢复 | POST /plugin/enable → resumed_tasks（ED=7、LE=2）自动补处理；ED 侧 3s 内自动补传 RECEIVED，最终全部 COMPLETED（LE j05_02 条目转「灵犀整理中」） | PASS |
| 崩溃恢复 | LE 实例进程遭 jetsam 杀（D-LE3-01 环境事件）→ isolated.sh restart → captures/tasks/notes 全量持久（4→8 条增长无丢失），中断的 r2 自动补传成功 | PASS |
| 升级路径 | 本轮协议 v1 纯增量扩充（get_capture 返回 revisions/text_body），向后兼容，无需迁移 | PASS |

## 2. 数据持久性

- sqlite WAL 持久化；插件停用/进程死亡/实例重启均不丢数据（三轮实证：停用、jetsam、冷开）。
- ACK 前手机副本不删（离线链实证）；服务端 raw asset 与原文备份独立保存不覆盖（J08 三层实证）。

## 3. 结论

插件生命周期（安装/初始化/能力声明/设备管理/停用/启用/崩溃恢复/升级兼容）全链路实证通过，无悬空状态、无数据丢失、无静默失败。
