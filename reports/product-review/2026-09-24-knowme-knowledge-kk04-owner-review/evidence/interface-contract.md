# INTERFACE_CONTRACT — r3-gap-closure

2026-09-23 ｜ context ED-KK04-ADMISSION-GAP-CLOSURE-20260923-B2C4 ｜ 协议 v1 ｜ BASE_PATH=/api/mobile-capture/v1

协议 v1 自 R2-final 冻结后**本轮零改动**（R3 零源码改动，ALLOWED_PATH_DIFF_RECEIPT 实证）。端点清单与行为不变式沿用 R2-final 同名单元的实读核对结论；本轮在双实例（ED 18241 / LE 18243）上重新实证下列端点行为，无偏移。

## 1. 端点清单（routes.py @router 实读核对，R2 起未变）

| 方法 | 路径 | 语义 | 鉴权 |
|---|---|---|---|
| GET | /plugin/status | 插件状态（enabled/disabled、版本、ASR/organizer 能力） | 设备凭证 |
| POST | /plugin/enable | 启用（恢复时 resumed_tasks 自动补处理） | 管理 |
| POST | /plugin/disable | 停用（此后 POST /captures 返回 503，数据不丢） | 管理 |
| POST | /devices/register | 设备注册签发凭证（201） | 开放（隔离实例） |
| POST | /devices/revoke | 撤销设备凭证（此后上传/读取 DEVICE_UNAUTHORIZED） | 设备凭证 |
| GET | /capabilities | 能力声明（插件版本/ASR/organizer/模态） | 设备凭证 |
| POST | /captures | 提交采集元数据+文本（202） | 设备凭证 |
| PUT | /captures/{capture_id}/asset | 上传音频资产（sha256 校验） | 设备凭证 |
| GET | /demo-audio · /demo-audio/{name} | 合成演示音频（内容合成已披露） | 设备凭证 |
| GET | /captures | 采集列表 | 设备凭证 |
| GET | /captures/{capture_id} | 单采集详情：返回全部 revisions + text_body（版本链视图数据源） | 设备凭证 |
| GET | /tasks/{task_id} | 整理任务状态 | 设备凭证 |
| POST | /tasks/{task_id}/retry | 产品内「重试整理」（attempts 累计如实） | 设备凭证 |
| GET | /events | 事件流（cursor 分页，App 轮询状态同步） | 设备凭证 |
| GET | /results/{note_id} | 整理结果（frontmatter/正文/html_available/raw_backup 路径） | 设备凭证 |

## 2. 数据模型要点

- capture：capture_id（内容寻址后缀）、payload_revision、kind(text/audio)、captured_at+captured_timezone、content_hash(sha256)、intent(note/correction)+correction_of、transfer/processing 双状态、received_at/durable_received_at/organized_at 三时间。
- task：capture_id+payload_revision 维度，status(PENDING/PROCESSING/COMPLETED/FAILED)、attempts、error、recovery_action。
- event：CAPTURE_ACCEPTED/CAPTURE_RECEIVED/PROCESSING_STARTED/ORGANIZE_COMPLETED/…（seq 单调，游标分页）。本轮 ED 实例终态分布：CAPTURE_ACCEPTED 2 / CAPTURE_RECEIVED 14 / PROCESSING_STARTED 15 / ORGANIZE_COMPLETED 15（14 采集 + J06b 修正副产物各计入）。

## 3. 行为不变式（本轮双侧重实证）

- 停用期间 POST /captures → 503 + App 端保持排队，enable 后自动补传（J05 双侧实证）。
- 资产 sha256 三端一致（手机原件/服务端存储/笔记 frontmatter，E2E_CAPTURE_TRACE）。
- 整理串行：`_ORGANIZE_TIMEOUT=600s` 看门狗仅计量真实整理时长，排队不判超时（J06 双侧实证，零 LOCKED_SKIP）。
- 结果路径契约：knowledge/notes/daily/{note_id}.md（+.raw-transcript.backup.md +.md.html），raw asset 独立保存不覆盖。

## 4. 兼容性

协议版本 v1 未变；R3 为纯证据补闭环轮，零端点/字段改动。
