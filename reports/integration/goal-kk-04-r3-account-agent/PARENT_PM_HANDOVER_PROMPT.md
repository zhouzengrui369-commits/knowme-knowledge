# PARENT_PM_HANDOVER_PROMPT — GOAL-KK-04 R3（交付中期版）

```text
ROLE=ENGINEERING_DELIVERY
VERSION=INTERIM_NOT_TERMINAL
DATE=2026-09-26
GOAL_ID=GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
MILESTONE_ID=MILESTONE-GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
CONTRACT_REVISION=R3-ACCOUNT-AGENT
ENGINEERING_DELIVERY_RESULT=IN_PROGRESS（未声明任何终态）
```

下面内容可直接交给独立 Parent PM / Product Governance。**交接目的是让新的 PM 不看工程聊天也能接管**；本文件不是终态包。

你接班先读：两仓 AGENTS.md、Issue #35 comment 5843589291（R3 开工授权）与全部进度回执（5843816382→5846323558，按时间序）、R3 产品合同与 ED 执行合同（governance/milestones/GOAL-KK-04-*/）、主设计方案 v5、R2 冻结附录。GitHub 是唯一事实源，不要相信任何聊天转述或旧 PR 正文。

---

## A．完成了什么

### 已冻结权威与开工（全部核验一致）

- R3 开工授权 comment 5843589291 实测存在；App 前镜像 `c6739191c5fe29eb6b16610fb67eeaf2d83f622e`（tree d73d8861…）；Workbench 前镜像 `852c74d05858119e6c35ea69bae9c4c1280d5963`（tree 90d3131c…）；两治理 PR（App #41 / Workbench #10）OPEN/DRAFT/UNMERGED；参与授权 njx-knowledge#6 comment 5843590411。
- 本 ED 开工回执 5843816382，此后进度回执 5844412838、5845193176、5846080984、5846323558，均未声明任何准入资格。

### 技术方案（合同 §3.1，已完成）

在 App 仓 `reports/integration/goal-kk-04-r3-account-agent/`：

- **IMPLEMENTATION_PLAN.md**：Kotlin+Compose 原生 App；sherpa-onnx 随包模型（J13 飞行冷开）；**否决完整 DSH 移植 Android 并如实披露 NON_DSH_PLUGIN_EQUIVALENCE**；轻量手机 Agent 运行时。
- **CAPABILITY_REUSE_MATRIX.md**：bridge v1 真实代码盘点；account_id/workspace_id 服务端强制是**新建缺口**（v1 schema 没有这两列——这是合同核心要求的实证根因）。
- **UI_TRACEABILITY_MATRIX.md**：React 原型 01 组件级血统 15/15；SensingStrip 否决（违背不常听原则）；R1 审核 PX-01/03/06 病灶预防设计。
- **INTERFACE_CONTRACT.md**：/api/mobile-capture/v2 端到端语义，含孤儿任务幂等回绑（同 task_id 续跑、禁第二主源，吸收了 KnowMe Wave-1 修正清单 M3/M4）。

### App 工程（PR #42，工作进行中）

- `apps/lingxi-mobile-android/`：Gradle 工程成套（AGP 8.5.2/Kotlin 2.0.20/Compose BOM 2024.09.02，minSdk 26/targetSdk 34/arm64-v8a，wrapper 锁定）；`assembleDebug` 构建通过。
- 四目的地 UI 骨架（灵犀/记录/知识/我的）+ 六项分项状态条（实测驱动、带时间戳，防 PX-01）。
- Room 四域持久层（captures/revisions/outbox/downloaded_notes），账户行级隔离，outboxId 唯一索引。
- FGS 录音服务：PCM 分段落盘 + WAV 收尾，系统终止→INTERRUPTED 保全片段。
- sherpa-onnx v1.13.8 接入（kotlin-api 源码 tag 固定直引 + arm64 预编译库）；模型 zipformer bilingual **mobile** 变体（约 130MB）随包资产 + 首启后台 provision；未就位如实 NOT_PROVISIONED。
- 轻量手机 Agent 骨架（本地工具→用户自配 OpenAI 兼容 API→本地草稿）。
- Robolectric 单测 6/6 PASS。debug APK 149,791,589B，sha256=`702bf12d4a45dafaca7dce0920da90733656fb2050da43e34dd2a4da3e1f06bb`（**开发态 debug 签名，非候选 canonical**）。

### 工作台工程（PR #11，工作进行中）

- `mobile_capture_bridge` v2：`store_v2.py`（accounts/workspaces/pair_codes 三新表 + devices/captures/tasks 增列 account_id/workspace_id，workspaces.account_id NOT NULL+FK）；`routes_v2.py`（配对一次性码 + operator token 门控、凭据反查服务端强制、越权 403、幂等采集、设备撤销、孤儿回绑、任务执行端标注、能力目录）；v1 全部保留并存。
- 测试 26/26 PASS：合成 A/B 账户隔离、配对单用、legacy 401、伪造 workspace 403、幂等重提同 task、孤儿回绑、端到端链（pair→capture→received→task→cancel→disable 503→revoke 401）。
- organizer 真实整理链（DSH + instant-note-organizer）**未做真实集成验证**，单元/链路测试均如实 stub。

### 复用了什么 / 没复用什么

- 复用：bridge v1 代码与 pipeline、isolated.sh 机制、原型 01 的 UI 血统、中央 ED/PG 冻结技能、KnowMe Wave-1 的 M1-M4 修正清单。
- 未复用：原型 02 旧 HAP（路线已撤销）、旧截图/旧 16/16 PASS、桌面全局会话（不依赖）。

---

## B．证据在哪里

| 证据 | 位置 |
|---|---|
| 开工与进度回执 ×5 | knowme-knowledge#35 comments 5843816382 / 5844412838 / 5845193176 / 5846080984 / 5846323558 |
| 技术方案四件套 | App 仓 PR #42 @`3c5af2e` · `reports/integration/goal-kk-04-r3-account-agent/` |
| App 源码 + 构建配置 | 同 PR · `apps/lingxi-mobile-android/` |
| 工作台 v2 源码 | 工作台仓 PR #11 @`1b43b00` · `lingxi/server/mobile_capture_bridge/{store_v2,routes_v2,plugin}.py` |
| 工作台测试 | 同 PR · `tests/mobile_capture_bridge/`（26/26 PASS） |
| 模型血统 | App assets/asr/PROVENANCE.md；tarball sha256=`45b8d04f…`（official size=346965352 一致）/ sherpa 包 sha256=`2ff63469…`（official size=46093321 一致） |
| 构建产物（开发态） | 本机 `apps/.../app-debug.apk` sha256=`702bf12d…`（不入 git，本地可取） |

**尚缺失的证据（接管时必须知道）**：候选 Manifest、Technical Receipt、canonical 签名 APK 及其哈希链、CANDIDATE_* 全套（§7.2 清单 30+ 文件）、LE/ED 双套实操截图与视频目验、设计走查截图（shots/design-walkthrough/）、性能实测（J13 CER、1s/10s/5s 指标）、J23 真实底座连接回执、真机旅程 J01–J23 全部证据。**当前零截图证据**，全部验证仍是代码级（编译过+单测过+TestClient 过）。

---

## C．为什么卡（不是 Ready）

**ENGINEERING_DELIVERY_RESULT=IN_PROGRESS**。按合同 §3 顺序，已完成步骤 1（盘点与技术方案）与步骤 2/3 的代码骨架、存储与测试层，**未触达任何需要 Owner 设备/外部授权的硬环节**。当前卡点全部是工程自身工序，不是外部授权：

1. **真实联调未做**：App↔工作台仅在 TestClient 内存级联通；cel化 lingxi_server 隔离实例 + 真 organizer（DSH + instant-note-organizer）端到端未做。
2. **手机 Agent / 远端工具未联通**：手机端轻量 Agent 是骨架代码，没经过任何一方真实调用。
3. **真机旅程一片空白**：J01–J23 零实操证据；合同要求 fresh LE + ED 本人双套实操+截图+目验，都未启动。**需 Owner 连接 Mate60**（Owner 已确认机器支持 APK，责任边界 = ED 等硬件接入）。
4. **J23 真实底座连接未开始做**：需 Owner 明确选择资料 + 本机授权。
5. **canonical APK 未冻结**：当前只有 debug 产物；签名、升级验证、哈希链未定。
6. **设计走查截图未补**：合同 §3.1 末段要求。

```text
FIRST_BLOCKER=工件工程自身工序未完成（真实联调/真机旅程/J23）
WHO_OWNS_BLOCKER=
ENGINEERING_DELIVERY（前两项）；ENGINEERING_DELIVERY×HUMAN_OWNER（真机接入与 J23 授权选择）
WHAT_WAS_ATTEMPTED=代码层全部打穿（构建+单测 32/32+memo_链路测试 26/26）
RECOVERY_CONDITION=完成真实联调后请 Owner 连接 Mate60 并明确 J23 资料选择
```

---

## D．哪些没有完成

### CONTRACT_REQUIRED_NOT_COMPLETE（合同内必交，未完成）

- 真实联调（App↔restlingxi_server ↔ organizer）
- 手机 Agent 实际编排验证（Mac 不可达路径 J20）/ 远端工具 J21
- 账户切换实操（J18）/ 三态运行 J19 / 锁屏后台录音 J16 的真机证据
- J01–J23 全旅程（当前 0/23 实操）
- 七项旧 PX 的新 APK 行为映射证实（OLD_PX_BEHAVIOR_MAPPING 字段已写设计，但零真机证实）
- canonical 签名 APK + 升级保留数据验证（J16）
- 双证实操：fresh Local Executor 全套 + ED 本人全套（§5/§6）
- SECURITY/性能实测（J13 CER≤20%、1s/10s/5s）
- ALLOWED_PATH_DIFF_RECEIPT、RUNTIME_PRIVACY_RECEIPT、 OWNER_KNOWLEDGE_CONNECTION_RECEIPT（J23）
- CANDIDATE_MANIFEST.md / TECHNICAL_RECEIPT.md / DEFECT_CYCLE.md 及 §7.1 证据包其余全部

### OUT_OF_SCOPE_FUTURE_WORK（合同明确排除，不属于本轮缺口）

- 完整 DSH 插件等价的手机运行时、通用电脑安装器、本地通用大模型推理、商业账户平台、NAS/云托管、应用商店发布、OCR/多模态离线理解、企业 RBAC、常听

---

## 接管后的合法动作边界

```text
你是 PRODUCT_GOVERNANCE / PARENT_PM：
- 可以：核验本交接引用的 GitHub 事实、回答 ED 的 CR 请求、处理真机接入时机、推进 J23 的 Owner 选择、要求 ED 补齐证据
- 不可以：改产品源码/测试/构建、宣布任何 Ready/通过、替 Owner 接受、merge/release、
  用这份交接里的「已完成」代替独立验证
- 交接时 ED 仍在工作：不要并发干预同一分支；工程分支的下一个动作是真实联调
```

工程交接联系人：本 ED 上下文（WorkBuddy session），ASSIGNED_HANDOFF_ID=ED-KK04-R3-ACCOUNT-AGENT-20260926-A9DFC906。
