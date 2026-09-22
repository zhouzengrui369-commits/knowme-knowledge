# GOAL-KK-04 — 移动采集桥接口合同（INTERFACE_CONTRACT）

ENGINEERING_CONTEXT_ID=ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E
PROTOCOL_NAME=lingxi-mobile-capture-bridge
PROTOCOL_VERSION=1.0.0
BASE_PATH=/api/mobile-capture/v1
BINDS_CONTRACT=knowme-knowledge@be400447c1d68062d22ae5e9ea0d169d929514df:governance/milestones/GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE/CONTRACT.md

> 本文件是手机（App）与灵犀工作台 mobile_capture_bridge 插件之间唯一协议事实源。
> HTTP 2xx 只表示传输/受理语义，不代表知识已生成；知识完成以 `processing_status=COMPLETED`
> 且 `result_refs` 非空为准。

## 1. 传输与认证

- HTTP/JSON，UTF-8；二进制资产走 `application/octet-stream` 原始 body。
- 除 `POST /devices/register` 外，所有端点要求头 `Authorization: Bearer <device_token>`。
- token 为工作台签发的可撤销设备凭证（ opaque 随机串，服务端只存 SHA-256 哈希）。
- 认证失败/撤销后：401 `{"error":{"code":"DEVICE_UNAUTHORIZED"}}`；无厂商密钥、无声纹代替认证。
- 所有时间字段为 RFC 3339 带偏移量（如 `2026-09-22T09:03:00+08:00`）；`captured_timezone`
  单独携带 IANA 名称（如 `Asia/Shanghai`）。

## 2. 统一采集对象（CaptureEnvelope）

```json
{
  "capture_id": "cap_01J…(UUID)",
  "device_id": "dev_…(UUID)",
  "schema_version": "1.0.0",
  "payload_revision": 1,
  "kind": "text | audio",
  "captured_at": "2026-09-22T09:03:00+08:00",
  "captured_timezone": "Asia/Shanghai",
  "title_hint": "可选用户标题",
  "text": "kind=text 时的正文",
  "content_hash": "sha256:<hex of canonical content bytes>",
  "content_size": 12345,
  "asset": {
    "filename": "cap_….wav",
    "mime": "audio/wav",
    "sha256": "<hex>",
    "size": 960123,
    "duration_ms": 31240
  },
  "context_ref": "可选。关联上一次 note_id/capture_id",
  "intent": "note | supplement | correction",
  "processing_policy": {
    "auto_organize": true,
    "correction_of": "可选 note_id+capture_id（现场修正）",
    "supplement_of": "可选 capture_id（后续补充）"
  },
  "client_state": "LOCAL_SAVED 提交时手机侧状态快照（诊断用）"
}
```

约束：
- `payload_revision` 从 1 开始；同一 `capture_id` 内容变化必须升 revision。
- 相同 `device_id+capture_id+payload_revision+content_hash` 重传 = 幂等（返回同一 task_id，
  不产生第二次正式效果）。
- 相同 `capture_id` 但 `content_hash` 不同且 revision 未升 = `409 CONTENT_CONFLICT`，不覆盖。
- 不同 `capture_id` 即使同名同分钟 = 两个独立采集，互不覆盖。
- `processing_policy.auto_organize=false`（显式 false）= 只可靠接收不自动整理：
  采集落盘 RECEIVED，任务停 `NEEDS_INPUT`，由 `POST /tasks/{task_id}/retry` 显式触发整理。
  缺省或 true = 接收后自动进入整理流水线。

## 3. 端点

### 3.1 设备生命周期（J01）

`POST /devices/register`（无需 token；body: `{"device_label":"…","app_version":"…","protocol_version":"1.0.0"}`）
→ `201 {"device_id","device_token","capabilities":{…},"server_time"}`
重复注册同一 `device_label+app_instance_id` 幂等返回既有 device_id 并轮换 token。

`POST /devices/revoke`（需 token）→ `200 {"revoked":true}`；撤销后该 token 全部端点 401。

`GET /capabilities`（需 token）→
```json
{
  "plugin": {"name":"mobile_capture_bridge","version":"…","status":"enabled"},
  "asr": {"engine":"mlx-whisper|openai-whisper","model":"small","available":true},
  "organizer": {"skill":"instant-note-organizer-v4","available":true},
  "dsh": {"provider":"…","model":"…","reachable":true},
  "limits": {"max_asset_bytes": 62914560, "audio_kinds":["wav"],"text_max_chars":20000},
  "processing_policy": {"auto_organize_supported":true,"external_send":"disabled-isolated"}
}
```
读出的是**实际**加载的 DSH/ASR/skill 版本，不是 README 自称。

### 3.2 采集提交与资产（J02/J03/J04/J05/J06）

`POST /captures`（需 token；body=CaptureEnvelope，kind=text 时 inline 正文；kind=audio 时只含元数据+asset 描述）
→ `202 {"task_id","capture_id","payload_revision","received_at":null,"processing_status":"PENDING","upload_token":"…"}`
仅元数据受理；`received_at` 在资产完整校验落盘后才赋值。

`PUT /captures/{capture_id}/asset?payload_revision=N`（需 token；body=原始字节；头 `Content-Sha256`）
→ 服务端校验字节数+sha256 一致并可靠落盘后：
`200 {"task_id","received_at","durable_received_at","processing_status":"RECEIVED→PENDING"}`
hash/尺寸不符 = `422 HASH_MISMATCH`，手机保留原件重传。
插件停用中 = `503 PLUGIN_DISABLED`（手机保持队列，稍后重试）。

`GET /captures?from_date=&to_date=&status=`（需 token）→ 采集清单，可按**捕获日期**查询（J07）。

`GET /captures/{capture_id}`（需 token）→
```json
{
  "capture_id":"…","payload_revision":1,"kind":"audio",
  "captured_at":"…","captured_timezone":"…",
  "received_at":"…","durable_received_at":"…","organized_at":"…|null",
  "transfer_status":"RECEIVED","processing_status":"COMPLETED",
  "task_id":"…","result_refs":{"note_id":"…","note_revision":1,
    "daily_source":"knowledge/notes/daily/….md","html":"….md.html"},
  "original_asset":{"sha256":"…","size":…,"retained":true},
  "provenance":{"initial_transcript":"…","corrected_text":"…|null"},
  "error":null,"recovery_action":null
}
```
三个时间（捕获/接收/整理）分别披露；`COMPLETED` 必须有实际产物引用。

### 3.3 任务与事件（J05/J09）

`GET /tasks/{task_id}`（需 token）→ 任务状态（PENDING/PROCESSING/NEEDS_INPUT/COMPLETED/FAILED）
+ `error`+`recovery_action`。工作台/插件重启后任务从持久存储恢复查询，不依赖内存。

`POST /tasks/{task_id}/retry`（需 token，D-KK04-05）→ 显式重试/触发整理：
仅 `FAILED`（整理失败，如工作台超时）或 `NEEDS_INPUT`（auto_organize=false 待触发）可调用；
重置为 PENDING 并立即重新调度，幂等由 `(capture_id, payload_revision)` 产物核对保证，
不产生重复正式效果。其他状态 = `409 BAD_STATE`；跨设备 = `404`。

`GET /events?cursor=N&limit=`（需 token）→ 追加式事件流：
`{"events":[{"seq":N,"type":"CAPTURE_RECEIVED|PROCESSING_STARTED|ORGANIZE_COMPLETED|ORGANIZE_FAILED|ORGANIZE_DEFERRED|RETRY_REQUESTED|RESULT_UPDATED","capture_id":"…","task_id":"…","at":"…","refs":{…}}],"next_cursor":M}`
断线后按 cursor 补拉；事件**不是**唯一完成记录（状态以 `/captures/{id}` 持久视图为准）。

### 3.4 结果与修正（J08）

`GET /results/{note_id}`（需 token）→ 工作台正式结果（标题/正文/修订版本/原始来源引用），
与工作台桌面同一 note_id 同一内容。

`POST /captures` with `intent=correction` + `processing_policy.correction_of` →
生成**新 revision**；原始资产与最初转写永不覆盖；未记录的旧层不编造。

## 4. 状态机

```
手机侧 transfer:  LOCAL_SAVED → QUEUED → UPLOADING → RECEIVED(ACK) ;失败回 QUEUED
工作台 processing: PENDING → PROCESSING → COMPLETED | FAILED | NEEDS_INPUT
```

- RECEIVED 仅在完整校验+可靠落盘后成立；ACK 丢失 = 手机重传，服务端幂等。
- 可靠 ACK 前手机原件不可删除；插件停用/重启不丢队列与任务。
- 传输重试与处理重试分离；处理重入前核对已有产物，不重复触发外发副作用（隔离环境外发=禁用）。

## 5. 安全与隔离（J10）

- 采集内容一律作为数据持久化/整理，**永不**作为 Shell/工具指令执行。
- 插件不读取生产知识；隔离部署使用独立 KB_ROOT/端口/DSH session；默认 `external_send=disabled`。
- 凭证只存哈希、日志脱敏；原始音频不进 Git。

## 6. 性能下限（合同 §4）

前台操作 1 秒内明确反馈；队列已授权+网络恢复+服务可达后 10 秒内启动同步；
处理完成后 5 秒内前台可查到状态（事件或轮询）。ASR/整理实际耗时如实记录冷/热样本。
