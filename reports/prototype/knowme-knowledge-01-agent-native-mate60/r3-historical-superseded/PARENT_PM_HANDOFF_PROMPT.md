# Parent PM Handoff Prompt — GOAL-KK-01 R3 (from Engineering Delivery)

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
CANDIDATE_SHA=e6e9c3d87a1c87fa0614aa1a4ec44e354117adde
CANDIDATE_TREE=beeb0d6e136419036fb71fe5bd31aa8863f9227f
CANDIDATE_PARENT=9f3071e22def4f99cbf3a4589349e628e9e15a97
OPERATED_CANDIDATE_SHA=e6e9c3d87a1c87fa0614aa1a4ec44e354117adde
PROTOTYPE_SUBTREE_TREE=0641d2e4ee000aac79f9ef2f4f36d1d8c61a53f9

EVIDENCE_BRANCH=evidence/goal-kk-01-non-candidate-r2 (NON_CANDIDATE_EVIDENCE)
UI_AUTHORITY=KnowMe-NJX-Demo.html (Owner-provided 2026-09-16, sha256 3ef8605a…fc7d9f, copy at r3-ui-authority/)
SUPERSEDES=Issue #3 comment 5692104046 (R2 receipt, candidate 9f3071e)
```

## A. 完成了什么

- R1:合同范围原型(Journeys A–E,KnowMe Demo 深色 workbench 血统,41 断言)。
- R2:Owner 亲自操作后指示四项修改(持续后台感知条 / 知识按日历查看 / 知识导航 / 日程待办关联可视化日历),57 断言。
- **R3(本轮)**:Owner 提供权威原型 KnowMe-NJX-Demo.html(「这个才是knowme的原型」)并指示:
  1. **知识导航包括五维知识地图和九维认知图谱** — 知识导航 tab 顶部现为五维知识地图(工作记录/生活感悟/人生规划/系统思考/行业洞察,真实计数,可展开真实条目)与九维认知图谱(01 身份角色…09 动态与情景,同上),下方保留 MOC/WIKI/NOTE 分组;计数全部实时计算,零维度诚实标注。
  2. **日历有月/周/日三种视图** — 日历 sheet 日/周/月切换:月视图(2026 年 9 月网格,星期一起始的真实星期,今天高亮,有日程/待办的日子带圆点,点格子深开日视图)、周视图(周一至周日整周行,每日日程+关联待办计数,点行进日视图)、日视图(原有日程+当日关联待办)。
  3. 顺带修正:R2 fixture 把 2026-09-16 错标为周二(实为周三),已按真实星期修正并把「周四装机窗口」叙事对齐到 09-17。
- 技术测试:67 条 Playwright 断言(360x780 MATE60_CLASS_SIMULATION),Local Executor(全新 clone 精确 SHA,端口 5174)与 ED 本人(提交后 HEAD 复核,端口 5173)各自独立运行均 **67/67**,console/page error 均为空。
- ED 用户视角价值闭环复验:捕获→入库→知识增长→五维/九维地图与日历立即可见→Agent 引用→工作面→日历三视图→待办深链→返回不丢上下文。
- 缺陷:R1 D-01/D-02 保持修复;R2/R3 均无新缺陷(首轮全过)。

## B. Exact identity(以 GitHub 实时事实为准)

```bash
gh pr view 9 --repo zhouzengrui369-commits/knowme-knowledge --json headRefOid,state,isDraft
git ls-remote https://github.com/zhouzengrui369-commits/knowme-knowledge.git engineering/goal-kk-01-agent-native-mate60-prototype-r1 evidence/goal-kk-01-non-candidate-r2
```

- Engineering branch head = PR #9 head = `e6e9c3d87a1c87fa0614aa1a4ec44e354117adde`
- Candidate 只含 code+tests;全部证据在 evidence 分支。
- 两套操作证据均产于最终精确 candidate 本身,无父 commit 证据转移。
- R2/R1 历史证据在 evidence 分支 `r2-historical-superseded/` 与 `r1-historical-superseded/`,原样保留,不可用于本 candidate admission。

## C. 证据在哪里(GitHub,evidence 分支)

分支 `evidence/goal-kk-01-non-candidate-r2`,路径
`reports/prototype/knowme-knowledge-01-agent-native-mate60/`:

```text
README.md · CANDIDATE_MANIFEST.md · TECHNICAL_RECEIPT.md · RUNTIME_RUNBOOK.md
BROWSER_ASSERTION_RECEIPT.md · KNOWME_UI_TRACEABILITY_MATRIX.md
INTERACTION_STATE_MAP.md · ALLOWED_PATH_DIFF_RECEIPT.md · MOCK_DATA_DISCLOSURE.md
LOCAL_EXECUTION_REQUEST.md · LOCAL_EXECUTION_RECEIPT.md
ED_PERSONAL_PRODUCT_OPERATION_RECEIPT.md · SCREENSHOT_INDEX.md
le-assertions.json (67/67) · ed-browser-assertions.json (67/67)
screenshots/local-executor/R3-LE-P01..P12 · screenshots/ed-personal/R3-ED-P01..P12 (sha256 表在 receipt 内)
r3-ui-authority/KnowMe-NJX-Demo.html (Owner 权威原型,sha256 3ef8605a…fc7d9f)
r2-historical-superseded/ · r1-historical-superseded/
```

截图按 Owner 要求上传 GitHub(ChatGPT Parent PM 无法查看本地浏览器);两组 24 张均可在 evidence 分支直接查看。

## D. 为什么卡

无 blocker。Engineering 范围无未决阻塞。

## E. 哪些没有完成

- NOT_IMPLEMENTED_BY_CONTRACT:HarmonyOS 正式实现、真实 Harness/Provider/Agent runtime/长期记忆/RAG/向量库/Wiki 索引、真实 ASR/声纹、真实导入管线、真实 Calendar/Todo 后端、Demo 的 2D 关系/3D 星海图谱渲染(desktop-parlor 视觉,合同未要求)、Skills 能力、真实持久化、真实 Owner 数据、生产部署。
- UNRESOLVED_WITHIN_CONTRACT: 无。

## F. 已知限制

全部在冻结合同 allowed_known_limitations 内:BROWSER_PROTOTYPE_ONLY、DETERMINISTIC_MOCK_RUNTIME、NO_REAL_MODEL/HARNESS/PROVIDER、NO_REAL_PERSISTENCE_REQUIRED、NO_REAL_VOICE/SPEAKER_VERIFICATION/IMPORT_PIPELINE/RAG、NO_REAL_CALENDAR_TODO_BACKEND、NO_REAL_OWNER_DATA。视口证据为 360x780 MATE60_CLASS_SIMULATION。

## G. 下一 Gate

只推荐:`PRODUCT_GOVERNANCE_CANDIDATE_ADMISSION`。

Admission 要点:PR head = branch head = candidate identity(三者同为 e6e9c3d,操作证据直接产于它);candidate 源自冻结 preimage;合同覆盖完整;engineering_required 证据完整;无 forbidden path 改动;known limitations 全部在合同内;**R2/R3 的 Owner-directed 修改是否需要正式 Change Request,由你在 admission 时裁定**(Engineering 已如实披露,未自行宣称批准)。
