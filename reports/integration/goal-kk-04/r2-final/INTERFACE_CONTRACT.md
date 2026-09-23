# GOAL-KK-04 R2-final — INTERFACE_CONTRACT

> 2026-09-23 · 协议 v1 · BASE_PATH=/api/mobile-capture/v1 · 实现：mobile_capture_bridge v1.0.0（候选 92892d66 routes.py 实读核对）

## 1. 端点清单（实读 routes.py @router 装饰器逐条核对）

| 方法 | 路径 | 语义 | 鉴权 |
|---|---|---|---|
| GET | /plugin/status | 插件状态（enabled/disabled、版本、ASR/organizer 能力） | 设备凭证 |
| POST | /plugin/enable | 启用（恢复时 resumed_tasks 自动补处理） | 管理 |
| POST | /plugin/disable | 停用（此后 POST /captures 返回 503，数据不丢） | 管理 |
| POST | /devices/register | 设备注册签发凭证（201） | 开放（隔离实例） |
| POST | /devices/revoke | 撤销设备凭证（此后上传/读取 DEVICE_UNAUTHORIZED） | 设备凭证 |
| GET | /capabilities | 能力声明（插件版本/ASR/organizer/模态） | 设备凭证 |
| POST | /captures | 提交采集元数据+文本（202；文本直入队，音频先元数据后资产） | 设备凭证 |
| PUT | /captures/{capture_id}/asset | 上传音频资产（sha256 校验） | 设备凭证 |
| GET | /demo-audio · /demo-audio/{name} | 合成演示音频（模拟器无麦克风路径，内容合成已披露） | 设备凭证 |
| GET | /captures | 采集列表 | 设备凭证 |
| GET | /captures/{capture_id} | 单采集详情：**返回全部 revisions + text_body**（本轮 D-LE2-04 修复，版本链视图数据源） | 设备凭证 |
| GET | /tasks/{task_id} | 整理任务状态 | 设备凭证 |
| POST | /tasks/{task_id}/retry | 产品内「重试整理」（E1 路径，attempts 累计如实） | 设备凭证 |
| GET | /events | 事件流（cursor 分页，App 轮询状态同步） | 设备凭证 |
| GET | /results/{note_id} | 整理结果（note frontmatter/正文/html_available/raw_backup 路径） | 设备凭证 |

## 2. 数据模型要点

- capture：capture_id（内容寻址后缀）、payload_revision（同 ID 修正/补充递增）、kind(text/audio)、captured_at+captured_timezone、content_hash(sha256)、text_body/asset_*、intent(note/correction)+correction_of、transfer/processing 双状态、received_at/durable_received_at/organized_at 三时间。
- task：capture_id+payload_revision 维度，status(PENDING/PROCESSING/COMPLETED/FAILED)、attempts、error、recovery_action。
- event：CAPTURE_ACCEPTED/CAPTURE_RECEIVED/PROCESSING_STARTED/ORGANIZE_COMPLETED/…（seq 单调，游标分页）。

## 3. 行为不变式（协议层）

- 停用期间 POST /captures → 503 + App 端「保持排队」，enable 后自动补传（两轮实证）。
- 无凭证/已撤销 → DEVICE_UNAUTHORIZED（R1 已证，架构未变）。
- 资产 sha256 三端一致（手机原件/服务端存储/笔记 frontmatter）。
- 整理串行：`_ORGANIZE_TIMEOUT=600s` 看门狗仅计量真实整理时长（拿锁后起算），排队不判超时。
- 结果路径契约：knowledge/notes/daily/{note_id}.md（+.raw-transcript.backup.md +.md.html），raw asset 独立保存不覆盖。

## 4. 兼容性

协议版本 v1 自 R1 冻结后未变；本轮新增仅为 get_capture 响应字段扩充（revisions/text_body，向后兼容的纯增量）。
