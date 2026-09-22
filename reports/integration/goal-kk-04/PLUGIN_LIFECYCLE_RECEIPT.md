# GOAL-KK-04 — 插件生命周期回执（PLUGIN_LIFECYCLE_RECEIPT）

> GOAL-KK-04 · PLUGIN_LIFECYCLE_RECEIPT · ED context ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E
> Final pair：App `10d829195ebb7f6c4c576b0d116e45087ec2b35a` / Workbench `e548883b1d696b8245631bad129dd3737afcc5b7`
> 日期：2026-09-22

## 1. 结论

`mobile_capture_bridge` 是真实可加载、可启停、可查询状态的插件：由 lingxi_server 启动时挂载（try import + mount，失败不影响桌面功能），`GET /capabilities` 返回插件 name/version/status 与实际 ASR/organizer/DSH 版本。停用期间提交返回 `503 PLUGIN_DISABLED` 且服务端零落库；重新启用后手机队列在 10 秒内自动补传，`resumed_tasks` 计数真实；服务重启后任务从持久存储恢复。J05 旅程在 ED 与 LE 两侧独立实操通过。

## 2. 状态查询证据

- `GET /api/mobile-capture/v1/capabilities` 返回 `{"plugin":{"name":"mobile_capture_bridge","version":"…","status":"enabled"},"asr":{"engine":"mlx-whisper","model":"small","available":true},"organizer":{"skill":"instant-note-organizer-v4","available":true},…,"processing_policy":{"auto_organize_supported":true,"external_send":"disabled-isolated"}}`——读出的是实际加载版本，非 README 自称。

## 3. J05 实操证据（ED 实例 18231，2026-09-22 18:38–19:10）

1. `POST /plugin/disable` → 插件停用。
2. App 提交采集 → 返回 **503 PLUGIN_DISABLED**；App 采集箱显示「排队待传·工作台插件停用中，保持排队，插件启用后自动补传」（截图 s42，与网络错误文案明确区分）；服务端核验 **0 行**入库。
3. `POST /plugin/enable` → 启用；**10 秒内**自动补传 cap_9fd26eed… → RECEIVED → 真实 organizer COMPLETED（note_id 202609221848…J05…-9cb3cd6e，organized 18:49:30）；App 状态自动回「已整理」（s44）。
4. 服务重启恢复：任务/事件持久于 SQLite（WAL），重启后可查询，不依赖内存。

截图：s37–s44（J05 全段），s42 停用排队、s44 补传完成。

## 4. LE 复验（R1，实例 18232）

- disable → 503 排队 → enable **2 秒**自动补传 RECEIVED（cap_dfec0b061be3753f）。截图 le_s25–s26。该条整理遇 E1 超时 FAILED（环境性，非生命周期缺陷）。

### R2（新 pair 复验）

- disable → 503 排队（le2_s11，文案与网络错误区分）→ enable 返回 `resumed_tasks:1` → 2s 补传，cap_5397ffe959a67a1c345be04fa0ee138f。整理超时 FAILED（E1）。

## 5. 手机原件保留（合同 J05「可靠接收前不自动删除手机原件」）

SyncController 语义：ACK（RECEIVED，完整校验+可靠落盘后）前手机原件不可删除；插件停用/服务重启不丢队列与任务；网络恢复或服务可达后 10 秒内启动同步（J04 实测 ~3s，见 OFFLINE_SYNC_RECEIPT.md）。

## 6. 环境披露

全部在模拟器 + 隔离实例（18231/18232）验证；生产 8787 未做停启实验（合同禁止动生产服务）。`/plugin/disable|enable` 为插件级开关，不涉及 uvicorn 进程重启；进程级重启恢复经任务持久化核验。
