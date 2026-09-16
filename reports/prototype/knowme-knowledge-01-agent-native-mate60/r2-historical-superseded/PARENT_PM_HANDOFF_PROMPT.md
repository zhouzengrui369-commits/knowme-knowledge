# Parent PM Handoff Prompt — GOAL-KK-01 R2 (from Engineering Delivery)

```text
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
```

Self-contained handoff for a fresh Product Governance / Parent PM context.
No dependency on the Engineering Delivery chat.

---

你是 KnowME Knowledge 的全新独立 Product Governance / Parent PM。

本轮从 `ENGINEERING_READY` 开始,只负责:Exact Candidate Admission(以及之后按门禁顺序的后续决策)。你不是 Engineering Delivery,不是 Product Experience Reviewer,不是 Human Owner;你无权宣告 PRODUCT_EXPERIENCE_PASS / HUMAN_OWNER_ACCEPTED / MERGE / RELEASE / GOAL_MILESTONE_CLOSED。

```text
PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
REPOSITORY=zhouzengrui369-commits/knowme-knowledge
GOAL_ID=GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
MILESTONE_ID=MILESTONE-GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
PRODUCT_BASELINE=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v1

PRODUCT_CONTRACT_COMMIT=563997a0eca61800c8c72d23a83888821a6e0841
PRODUCT_CONTRACT_TREE=2b3c70f106b0b96f724af315955f2a859a1994c0
PRODUCT_CONTRACT_BLOB=02b75109f12cac49a3a996a57993d4d0b5ddb091
PRODUCT_CONTRACT_PATH=governance/milestones/GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE/CONTRACT.md

ENGINEERING_BRANCH=engineering/goal-kk-01-agent-native-mate60-prototype-r1
ENGINEERING_PR=#9 (Draft, OPEN, UNMERGED)
CANDIDATE_SHA=9f3071e22def4f99cbf3a4589349e628e9e15a97
CANDIDATE_TREE=b165a075f4e6a3784c6fc7794fc8c5581dc539c0
CANDIDATE_PARENT=d8290e7a216b647ec2853f9f4522d97f77129281
OPERATED_CANDIDATE_SHA=9f3071e22def4f99cbf3a4589349e628e9e15a97
PROTOTYPE_SUBTREE_TREE=e0c147e48aa6407dcf7b6da323ef01e00492659b

EVIDENCE_BRANCH=evidence/goal-kk-01-non-candidate-r2 (NON_CANDIDATE_EVIDENCE)
SUPERSEDES=Issue #3 comment 5691532300 (R1 receipt, candidate d8290e7,
           blocked by comment 5691624112
           FINAL_EXACT_CANDIDATE_OPERATION_EVIDENCE_IDENTITY_MISMATCH)
```

## A. 完成了什么

- R1 已完成合同范围原型(React 18 + Vite 5,portrait-first,KnowMe Demo 深色 contextual workbench 血统 1:1 token 继承),Journeys A–E 全部真实可操作。
- **R2(本轮)**:Owner 亲自操作 R1 原型后,在对话中直接指示四项产品修改,全部实现并验证:
  1. **语音录入持续后台运行**:Agent 主面常驻感知条(后台持续感知中 + 模拟感知流跳动),麦克风键暂停/恢复持续感知,跨 sheet 开关存活;全程诚实标注「模拟感知 · 无真实 ASR」(无麦克风访问)。
  2. **知识可按日历查看**:知识 sheet 新增「按日历查看」tab,按天分组;本会话确认入库的知识落在「今天 2026-09-16」。
  3. **知识导航**:知识 sheet 首个 tab「知识导航」,MOC/WIKI/NOTE 分组(Map-of-Content 血统)。
  4. **日程/待办关联可视化日历**:日历 sheet 5 天 week strip + 当日日程 + 当日关联待办;待办深链 `todo-calendar-link-t-3` 跳到日历对应日。
- 四项修改全部为 deterministic mock、在冻结合同 allowed_known_limitations 内(NO_REAL_VOICE / NO_REAL_CALENDAR_TODO_BACKEND 等),未改 Journeys A–E、验收结果或 NOT_IMPLEMENTED_BY_CONTRACT 边界。**是否需正式 Change Request 由 Governance 裁定**,Engineering 如实披露为 OWNER_DIRECTED。
- 技术测试:57 条 Playwright 断言(R1 41 条 + R2 新增 16 条),360x780 MATE60_CLASS_SIMULATION,**Local Executor 与 ED 各自在最终精确 candidate 9f3071e 上独立运行均 57/57**,console/page error 均为空。
- ED 以用户视角完成价值闭环验证:捕获→确认入库→知识增长(计数+Agent 解释)→知识导航与按日历查看立即可见→Agent 引用→知识详情→上下文工作面→日历(周四装机窗口)+当日关联待办→待办深链回日历→返回 Agent,对话与感知条全程不丢。
- 缺陷:R1 修复 D-01/D-02 仍保持修复;R2 首轮 57/57 通过,无新缺陷。

## B. Exact identity(以 GitHub 实时事实为准)

```bash
gh repo view zhouzengrui369-commits/knowme-knowledge
gh pr view 9 --repo zhouzengrui369-commits/knowme-knowledge --json headRefOid,state,isDraft
git ls-remote https://github.com/zhouzengrui369-commits/knowme-knowledge.git engineering/goal-kk-01-agent-native-mate60-prototype-r1 evidence/goal-kk-01-non-candidate-r2
```

- Engineering branch head = PR #9 head = `9f3071e22def4f99cbf3a4589349e628e9e15a97`
- **Candidate 只含 code+tests**(reports/ 已从 candidate 中移除);全部运行证据在 evidence 分支,与 candidate bytes 完全分离。
- 证据绑定:两套操作证据(LE + ED)均产于最终精确 candidate `9f3071e` 本身,**无父 commit 证据转移**。
- R1 历史证据(fb43216/d8290e7)原样保留于 evidence 分支 `r1-historical-superseded/`,已 supersede,不可用于本 candidate admission。

## C. 证据在哪里(GitHub,evidence 分支)

分支 `evidence/goal-kk-01-non-candidate-r2`,路径
`reports/prototype/knowme-knowledge-01-agent-native-mate60/`:

```text
README.md · CANDIDATE_MANIFEST.md · TECHNICAL_RECEIPT.md · RUNTIME_RUNBOOK.md
BROWSER_ASSERTION_RECEIPT.md · KNOWME_UI_TRACEABILITY_MATRIX.md
INTERACTION_STATE_MAP.md · ALLOWED_PATH_DIFF_RECEIPT.md · MOCK_DATA_DISCLOSURE.md
LOCAL_EXECUTION_REQUEST.md · LOCAL_EXECUTION_RECEIPT.md
ED_PERSONAL_PRODUCT_OPERATION_RECEIPT.md · SCREENSHOT_INDEX.md
le-assertions.json (57/57) · ed-browser-assertions.json (57/57)
screenshots/local-executor/R2-LE-P01..P10 + le-run-metadata.json (sha256 表在 receipt 内)
screenshots/ed-personal/R2-ED-P01..P10 (sha256 表在 receipt 内)
r1-historical-superseded/ (R1 全量历史证据 + SUPERSEDED_NOTICE.md)
```

截图因 ChatGPT Parent PM 无法查看本地浏览器而按 Owner 要求上传 GitHub;两组 20 张均可在 evidence 分支直接查看,sha256 与 receipt 内表一一对应。

CI/tests: 仓库无 CI workflow;技术测试为本地 Playwright 套件,两套独立运行记录见上。

## D. 为什么卡

无 blocker。Engineering 范围无未决阻塞。R1 的 identity-mismatch blocker(5691624112)已由本轮 R2 的"最终精确 SHA 双操作 + 证据外置"结构闭环。

## E. 哪些没有完成

- NOT_IMPLEMENTED_BY_CONTRACT(合法 out-of-scope):HarmonyOS 正式实现、真实 Harness/Provider/Agent runtime/长期记忆/RAG/向量库/Wiki 索引、真实 ASR/声纹(感知条为模拟)、真实导入管线、真实 Calendar/Todo 后端、Skills 能力、真实持久化、真实 Owner 数据、生产部署。
- UNRESOLVED_WITHIN_CONTRACT: 无。

## F. 已知限制

全部在冻结合同 allowed_known_limitations 内:BROWSER_PROTOTYPE_ONLY、DETERMINISTIC_MOCK_RUNTIME、NO_REAL_MODEL/HARNESS/PROVIDER、NO_REAL_PERSISTENCE_REQUIRED(刷新重置)、NO_REAL_VOICE/SPEAKER_VERIFICATION/IMPORT_PIPELINE/RAG、NO_REAL_CALENDAR_TODO_BACKEND、NO_REAL_OWNER_DATA。视口证据为 360x780 MATE60_CLASS_SIMULATION(浏览器模拟,非真机测量)。

## G. 下一 Gate

只推荐:`PRODUCT_GOVERNANCE_CANDIDATE_ADMISSION`。

Admission 要点(contract evidence_ownership.admission_required):PR head = branch head = candidate identity(本轮三者同为 9f3071e,且操作证据直接产于它);candidate 源自冻结 preimage;冻结合同覆盖完整;engineering_required 证据完整;无 forbidden path 改动;known limitations 全部在合同内;**Owner-directed R2 四项修改是否需要正式 Change Request,由你在 admission 时裁定**(Engineering 已如实披露,未自行宣称批准)。
