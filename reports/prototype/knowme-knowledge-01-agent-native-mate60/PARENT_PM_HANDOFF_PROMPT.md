# Parent PM Handoff Prompt — GOAL-KK-01 (from Engineering Delivery)

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
ENGINEERING_PR=<见 B 节,以 GitHub 实时状态为准>
CANDIDATE_SHA=<见 B 节 / Issue #3 Engineering terminal receipt>
CANDIDATE_TREE=<同上>
CANDIDATE_PARENT=fb432162e7dd099a32fec7b52ff00659982942f3
OPERATED_CANDIDATE_SHA=fb432162e7dd099a32fec7b52ff00659982942f3
PROTOTYPE_SUBTREE_TREE=9e60f229be9f8737b4db66cb1f7ea83d1b804201
```

## A. 完成了什么

- 实现了冻结合同范围内的完整交互原型:React 18 + Vite 5,portrait-first(360–520px), KnowMe Demo 深色 contextual workbench 血统 1:1 设计 token 继承。
- Journeys A–E 全部真实可操作:Agent 首遇 / 问 Agent(引用当前知识上下文 + next action)/ 文本捕获→候选知识→确认、修正、拒绝→上下文可见增长 + Agent 解释 / 知识详情→来源状态→上下文工作面→返回不丢对话 / 日历与待办打开具体 Mock 工作面、技能 PLANNED,能力状态全部诚实披露。
- 九态交互状态机(FIRST_VIEW…AGENT_CONTEXT_RESTORED)暴露在 DOM 供验证。
- 技术测试:41 条 Playwright 浏览器断言(360x780,MATE60_CLASS_SIMULATION),ED 与 Local Executor 各自独立运行均 41/41,console/page error 均为空。
- 缺陷循环:ED 运行时发现并修复 2 个合同内缺陷(D-01 叠加层遮挡阻断关闭;D-02 alert() 式语音披露),均在最终 candidate 上复测通过。
- 重大技术决策:Vite+React;Python Playwright 做浏览器断言;候选证据绑定 operated SHA,最终 commit 仅新增 reports/**(prototype 子树 tree 不变,可验证)。

## B. Exact identity

以 GitHub 实时事实为准(fresh verify,不要相信本文件之外的记忆):

```bash
gh repo view zhouzengrui369-commits/knowme-knowledge
gh pr list --repo zhouzengrui369-commits/knowme-knowledge --state all
git ls-remote https://github.com/zhouzengrui369-commits/knowme-knowledge.git engineering/goal-kk-01-agent-native-mate60-prototype-r1
```

- Engineering branch: `engineering/goal-kk-01-agent-native-mate60-prototype-r1`(从 preimage `563997a0…` 直接创建)
- Engineering PR: Draft, base `governance/goal-kk-01-agent-native-mate60-prototype-r1`, 保持 OPEN/DRAFT/UNMERGED
- CANDIDATE_SHA/TREE: branch HEAD = PR HEAD,并追加在 Issue #3 的 Engineering terminal receipt 中
- 证据绑定:全部运行证据产于 `fb432162e7dd099a32fec7b52ff00659982942f3`;最终 candidate 相对它只新增 reports/**,`prototypes/knowme-knowledge-01-agent-native-mate60` 子树 tree 恒等于 `9e60f229be9f8737b4db66cb1f7ea83d1b804201`

## C. 证据在哪里(GitHub 路径,engineering 分支)

```text
reports/prototype/knowme-knowledge-01-agent-native-mate60/CANDIDATE_MANIFEST.md
reports/prototype/knowme-knowledge-01-agent-native-mate60/TECHNICAL_RECEIPT.md
reports/prototype/knowme-knowledge-01-agent-native-mate60/RUNTIME_RUNBOOK.md
reports/prototype/knowme-knowledge-01-agent-native-mate60/BROWSER_ASSERTION_RECEIPT.md
reports/prototype/knowme-knowledge-01-agent-native-mate60/KNOWME_UI_TRACEABILITY_MATRIX.md
reports/prototype/knowme-knowledge-01-agent-native-mate60/INTERACTION_STATE_MAP.md
reports/prototype/knowme-knowledge-01-agent-native-mate60/ALLOWED_PATH_DIFF_RECEIPT.md
reports/prototype/knowme-knowledge-01-agent-native-mate60/MOCK_DATA_DISCLOSURE.md
reports/prototype/knowme-knowledge-01-agent-native-mate60/LOCAL_EXECUTION_REQUEST.md
reports/prototype/knowme-knowledge-01-agent-native-mate60/LOCAL_EXECUTION_RECEIPT.md
reports/prototype/knowme-knowledge-01-agent-native-mate60/ED_PERSONAL_PRODUCT_OPERATION_RECEIPT.md
reports/prototype/knowme-knowledge-01-agent-native-mate60/SCREENSHOT_INDEX.md
reports/prototype/knowme-knowledge-01-agent-native-mate60/ed-browser-assertions.json
reports/prototype/knowme-knowledge-01-agent-native-mate60/le-assertions.json
reports/prototype/knowme-knowledge-01-agent-native-mate60/screenshots/local-executor/LE-P01..P07 + le-run-metadata.json
reports/prototype/knowme-knowledge-01-agent-native-mate60/screenshots/ed-personal/ED-P01..P07
```

CI/tests: 仓库无 CI workflow;技术测试为本地 Playwright 套件,两套独立运行记录见上。

## D. 为什么卡

无 blocker。Engineering 范围无未决阻塞。

## E. 哪些没有完成

- NOT_IMPLEMENTED_BY_CONTRACT(合法 out-of-scope):HarmonyOS 正式实现、真实 Harness/Provider/Agent runtime/长期记忆/RAG/向量库/Wiki 索引、真实 ASR/声纹、真实导入管线、真实 Calendar/Todo 后端、Skills 能力、真实持久化、真实 Owner 数据、生产部署。
- UNRESOLVED_WITHIN_CONTRACT: 无。

## F. 已知限制

全部在冻结合同 allowed_known_limitations 内:BROWSER_PROTOTYPE_ONLY、DETERMINISTIC_MOCK_RUNTIME、NO_REAL_MODEL/HARNESS/PROVIDER、NO_REAL_PERSISTENCE_REQUIRED(刷新重置)、NO_REAL_VOICE/SPEAKER_VERIFICATION/IMPORT_PIPELINE/RAG、NO_REAL_CALENDAR_TODO_BACKEND、NO_REAL_OWNER_DATA。视口证据为 360x780 MATE60_CLASS_SIMULATION(浏览器模拟,非真机测量)。

## G. 下一 Gate

只推荐:`PRODUCT_GOVERNANCE_CANDIDATE_ADMISSION`。

Admission 要点(contract evidence_ownership.admission_required):PR head = branch head = candidate identity;candidate 源自冻结 preimage;冻结合同覆盖完整;engineering_required 证据完整;无 forbidden path 改动;无未批准产品偏差;known limitations 全部在合同内。
