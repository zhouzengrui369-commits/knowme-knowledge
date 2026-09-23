# GOAL-KK-04 R2-final — ENVIRONMENT_RECEIPT

> 2026-09-23 · 双实例环境身份登记（ED 18241 / LE 18242），与生产完全隔离。

## 1. 拓扑

| 项 | ED 实例 | LE 实例 |
|---|---|---|
| 端口 | 18241 | 18242 |
| KK04_ROOT | kk04-ed2（本工作区根） | kk04-ed2/le2 |
| KB_ROOT | kk04-ed2/runtime/kb-root（本轮起手重置为干净） | kk04-ed2/le2/runtime/kb-root |
| 设备转发 | hdc rport tcp:18246 → tcp:18241 | hdc rport tcp:18245 → tcp:18242 |
| App 配置地址 | http://127.0.0.1:18246 | http://127.0.0.1:18245 |
| 用途 | ED 本人 §8/§13 套件 | LE（agent-2）R2 全旅程 |

两端共用同一台 OpenHarmony 模拟器（127.0.0.1:5555）但 KB_ROOT、DB、端口、转发完全分开；LE 数据与 ED 数据互不污染（ED 箱 10 条 / LE 箱独立计数可交叉印证）。

## 2. 隔离与不外发核验

- 插件 v1.0.0 enabled、external_send=disabled（两实例启动横幅与 /plugin/status 一致）。
- KB_ROOT 全程独立；生产 /Users/njx/njx-knowledge 与生产 8787 零写入（收尾只读健康检查 200）。
- DSH 出口仅为 TokenHub API（整理/ASR 之外的对外发送不存在；J10 注入文本未触发任何动作）。

## 3. 组件版本（App 设置页与服务端双确认）

- mobile_capture_bridge v1.0.0；ASR mlx-whisper/small；organizer instant-note-organizer-v4（schema v4.0）；DSH TokenHub DeepSeek-V4.1-Flash。

## 4. 已知环境怪相（如实）

- D-LE3-01：LE 实例工作台进程曾遭 macOS jetsam 杀（内存压力），产品按设计持久恢复，非产品缺陷。
- D-LE3-03：模拟器状态栏时钟慢约 12h；`hdc date` 与全部业务时间戳（+08:00）正确。
- 模拟器 region=America/Chicago 而 captured_at 偏移 +08:00 正确（系统时钟怪相，继承前轮披露）。

## 5. 环境终态

- 两轮实操完成后：ED 实例 DB tasks 11/11 COMPLETED；LE 实例 9/9 COMPLETED。截图、日志、DB、KB 文件全部保留于 kk04-ed2/{ed,le2,runtime} 备查；证据包内为原样复制件。
