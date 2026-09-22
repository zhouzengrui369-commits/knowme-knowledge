# GOAL-KK-04 — 运行时隐私回执（RUNTIME_PRIVACY_RECEIPT，J10）

> GOAL-KK-04 · RUNTIME_PRIVACY_RECEIPT · ED context ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E
> Final pair：App `10d829195ebb7f6c4c576b0d116e45087ec2b35a` / Workbench `e548883b1d696b8245631bad129dd3737afcc5b7`
> 日期：2026-09-22

## 1. 结论

凭证哈希存储、草稿不入库、无对外发送、注入素材零执行（J10）、生产无污染——五项隐私/安全断言全部经实操验证通过。

## 2. 逐项证据

### 2.1 凭证哈希存储与认证拒绝（J01/J10）

- 设备 token 为 opaque 随机串，服务端 SQLite devices 表**只存 SHA-256 哈希**；无厂商密钥、无声纹代替认证。
- 无凭证/假凭证：全部端点 **401** `DEVICE_UNAUTHORIZED`（ED 与 LE 双侧实测）。
- 撤销后：App 真实凭证 GET /captures 立即 401（服务端日志坐实）；curl 读/写均 401 且 cap_revoke_test_01 未入库；revoked_at=2026-09-22T18:38:59 落库；重连后 revoked_at 清除、token 轮换（截图 s33–s36；LE R1 s02–s05）。

### 2.2 草稿不入库（J02/J04）

未提交草稿仅存手机沙箱（CaptureStore），服务端 0 行——ED 实操与 LE R1/R2 独立核验一致。

### 2.3 无对外发送（合同 §4/J10）

- 隔离环境 `external_send=disabled`；插件刻意不复用 `/api/add-knowledge` 的 `_trigger_organize`（其完成后自动发企业微信+写全局 `_PENDING_PREVIEW`），实现自有窄路径。
- 自首次冒烟（cap_smoke001）起核验：全流程无企业微信外发、无额外分发；不碰 public_gateway、腾讯云、公网配置。

### 2.4 注入素材零执行（J10）

- ED：curl 设备 dev_9e8a85e3d92f46ac 提交含 `$(touch /tmp/mcb_pwned)` 等命令文本 → 202 RECEIVED → COMPLETED（note_id 202609221858…J10…-0_cmd_01）；**/tmp 三个副作用文件均不存在**；命令文本逐字落为数据（raw asset + 笔记 3 处引用），未作为 Shell/工具指令执行。
- LE R1：cap_le_j10_inject_0001 仅作数据落库整理，/tmp 无任何副作用文件（3 次检查）；LE R2：cap_le2_j10_inject_0001 全程 /tmp 无副作用文件。

### 2.5 生产无污染

- 生产 8787 全程健康（多轮 `curl /api/health` 200）；生产 daily/知识库无 KK04 数据写入；LaunchAgent/公网网关/腾讯云未动（J11 回归双侧核验）。
- 隔离边界：独立 KB_ROOT（ED kk04-ed/runtime/kb-root / LE kk04-ed/le/runtime/kb-root）、独立端口（18231/18232）、独立 DSH home/session；跨设备查询返回空（设备隔离正确）。
- 凭证注入：DSH/TokenHub 凭证由本机安全注入隔离 DSH home，不进 Git、不打印、不提交；vendor/dsh 字节复制亦不进 Git。
- 唯一越界级事件：ED 复核时一条文本误落 LE 库（cap_641da01c…，App 会话曾指向 18232）——隔离环境内、同 pair 代码，已纠正并如实记录（ED_PERSONAL_OPERATION_RECEIPT.md §2），生产零影响。

## 3. 环境披露

全部验证在模拟器 + 本机隔离实例上进行；公网入口、生产部署下的安全姿态未验证。日志脱敏口径：证据中出现的 token 均以截断/省略形式披露。
