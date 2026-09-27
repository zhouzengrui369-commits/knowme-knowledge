# INTERFACE_CONTRACT — GOAL-KK-04 R3 手机 ↔ 工作台接口合同（草案 v2）

```text
STATUS=DRAFT_STEP_1_FINAL_FIELDS_LOCK_AT_VERTICAL_SLICE
BASE=实测 WORKBENCH_PREIMAGE=852c74d0 的 mobile_capture_bridge v1 代码
PROTOCOL_BASE_PATH=/api/mobile-capture/v2（v1 保留只读兼容，不删）
```

原则：HTTP 成功 ≠ 完成；每类状态（本机保存/durable_received/processing/organized/indexed/外发）分别表达；幂等键防重复副作用；服务端永远不信客户端给的 account/workspace。

## 1. 认证与绑定

| 端点 | 说明 |
|---|---|
| `POST /v2/session/pair` | 配对码（工作台生成，一次性，≤10min 有效）→ 签发设备凭据 `device_token`，绑定 account_id+workspace_id+device_id；响应 `{device_token, account_id, workspace_id, expires_at, capabilities_url}` |
| `POST /v2/devices/revoke` | 工作台侧撤销 → 该凭据后续请求一律 401 `DEVICE_REVOKED` |
| 全盘鉴权 | `Authorization: Bearer <device_token>`；服务端由 token_hash 反查 account/workspace（**客户端传入的 account_id/workspace_id 仅作一致性比对，不一致即 403**） |

合成 A/B 账户：测试陷印（仅 debug/isolated 启动时开放）`POST /v2/test/fixtures/accounts`，生产启动不注册。

## 2. 采集主链（沿用 v1 语义升级）

| 端点 | 语义 |
|---|---|
| `POST /v2/captures` → 202 | body 含 `capture_id, device_id, schema_version=2, payload_revision, kind(text/voice/attachment), captured_at, timezone, content_hash, size, intent, policy`；幂等键 `capture_id+payload_revision`：重复提交返回同一 task_id，不产生第二效果 |
| 响应 | `{task_id, durable_received_at}` —— 仅表可靠接收 |
| `PUT /v2/captures/{id}/asset` | 原音/附件分块上传（`.part` + 原子替换 + sha256 校验，v1 同款） |
| `GET /v2/captures/{id}` | `{transfer_status, processing_status, task_id, note_id, revision, result_refs[], error}`；organized 必须带实际 note_id/result_refs |
| `GET /v2/captures?updated_since=...` | 增量拉取（恢复与列表刷新） |

## 3. 任务（新增执行端与状态机）

`GET /v2/tasks/{task_id}` →
```json
{
  "task_id": "...", "status": "draft|queued|awaiting_server|running|needs_input|completed|failed|cancel_requested|cancelled",
  "executor_side": "phone|mac",
  "steps": [{"name":"...", "status":"...", "started_at":"...", "ended_at":"..."}],
  "result_refs": [], "cancelable": true
}
```
`POST /v2/tasks/{task_id}/cancel` → cancel_requested；已发生外部动作如实报告不回滚。

**孤儿会话恢复（幂等，h 合同 M3）**：同 capture 在旧 task 失联时先回绑不重启：
- `GET /v2/results/orphan?capture_id=...` → 存在可回绑结果：200 `{task_id, note_id, revision, result_refs}`，回绑语义即复用原 task_id；
- 无结果：404 → 客户端以 `orphan_recovery: true + origin_task_id` 提交新任务；服务端优先重绑定原任务（同一 task_id 续跑），确不可恢复才新建且仍只产生一份正式成果。
- 任何路径不得为同 capture 造第二主源（PX-07）。

## 4. 知识工作副本（新增）

| 端点 | 语义 |
|---|---|
| `GET /v2/knowledge/search?q=&scope=authorized` | 服务端限权检索，命中带 note_id/revision/snippet |
| `GET /v2/knowledge/notes/{note_id}/workcopy` | `{note_id, base_revision, rendered_markdown, source_ref, captured_at, attachments[]}`；附件可单独下载 |
| `POST /v2/knowledge/notes/{note_id}/submit` | body 带 `base_revision` + 用户修订层；200=接受为新 revision；冲突按层分流（h 合同 M4）：知识/工作副本冲突 → 409 `CONFLICT_BOTH_KEPT`（双方保全，响应带对端 revision 摘要与 diff 摘要）；来源/provenance 语义冲突 → 422 `PROVENANCE_CONFLICT`（双方保留，非 authority 静默覆盖） |

## 5. 能力目录（真实性要求）

`GET /v2/capabilities` → 数组：
```json
[{"id":"knowledge.search","execute_side":"mac","requires":["service_online"],"availability":"available|degraded|unavailable"},
 {"id":"capture.organize","execute_side":"mac","requires":["service_online","organizer_ready"],"availability":"..."},
 {"id":"asr.recover","execute_side":"mac","requires":["asr_loaded"],"availability":"..."}]
```
手机侧能力（phone：local.asr/draft/search_downloaded）由 App 自己注入能力目录视图；**任何一项的 availability 必须实测，不许写死**。

## 6. 错误与恢复语义

| HTTP | code | 含义/恢复动作 |
|---|---|---|
| 401 | DEVICE_REVOKED / TOKEN_EXPIRED | 停同步，引导重新配对 |
| 403 | WORKSPACE_FORBIDDEN | 越权，记录事件不上报隐私 |
| 409 | CONFLICT_BOTH_KEPT | 知识/工作副本冲突 UI，双方保留 |
| 422 | PROVENANCE_CONFLICT | 来源层语义冲突，双方保留，提示用户裁决 |
| 422 | QUALITY_LOW | 低质输入入口级提示（PX-04） |
| 503 | SERVICE_UNAVAILABLE | 排队 outbox + 明确恢复动作 |
| 网络失败 | （本地判定） | outbox 保留，1s 内 UI 反馈，就绪后自动续 |

## 7. 兼容与版本

- v1 路由在隔离期保留供对照；正式手机只走 v2。
- schema_version 协商：服务端拒绝未知高版本（400 SCHEMA_UNSUPPORTED）。
- 全字段最终以竖切实现冻结并回填本文件 `STATUS=LOCKED`。
