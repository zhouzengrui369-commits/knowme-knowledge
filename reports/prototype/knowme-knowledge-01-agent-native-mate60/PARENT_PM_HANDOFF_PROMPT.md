# Parent PM Handoff Prompt — GOAL-KK-01 PX Findings Correction R1 (from Engineering Delivery)

```text
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR12_HEAD=NO
```

Self-contained handoff for a fresh Product Governance / Parent PM context.
No dependency on the Engineering Delivery chat.

---

你是 KnowME Knowledge 的全新独立 Product Governance / Parent PM。

本轮从 `ENGINEERING_READY` 开始,只负责:fresh Exact Candidate Admission(以及之后按门禁顺序的后续决策)。你不是 Engineering Delivery,不是 Product Experience Reviewer,不是 Human Owner;你无权宣告 PRODUCT_EXPERIENCE_PASS / HUMAN_OWNER_ACCEPTED / MERGE / RELEASE / GOAL_MILESTONE_CLOSED。注意:这是一个**后继 candidate**——R5 的 ENGINEERING_READY / CANDIDATE_ADMITTED / PRODUCT_REVIEW_ELIGIBLE 均不继承,必须重新 admission。

```text
PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
REPOSITORY=zhouzengrui369-commits/knowme-knowledge
GOAL_ID=GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
MILESTONE_ID=MILESTONE-GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
PRODUCT_BASELINE=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2
PRODUCT_CONTRACT_REVISION=R2
PRODUCT_CONTRACT_COMMIT=978ed0608bda8e278c348ad2987f6a25fa3c3c2f
PRODUCT_CONTRACT_TREE=db0be0e4ac22b9780cf5cf3c80998d3cfd15731d
PRODUCT_CONTRACT_BLOB=05bc2ca7cce5e8645301994b348f702f2286d3f3
PRODUCT_CONTRACT_PATH=governance/milestones/GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE/CONTRACT-R2.md
APPROVED_CHANGE_REQUEST=CR-KK-01-OWNER-DIRECTED-R2-R3
NEW_CHANGE_REQUEST_REQUIRED=NO (你方已裁定,Issue #3 comment 5698309228)
CORRECTION_AUTHORITY=Issue #3 comment 5698309228 (ENGINEERING_CORRECTION_AUTHORIZED)
EXPLORATORY_FINDINGS=PR #11 @ e095af1fa6bfc988360c252bd16e6dbdef2262ee (evidence only)

CANDIDATE_SHA=0e859d93960e630965a5b71a3ff4c07e631d8570
CANDIDATE_TREE=f93f4cfa9c539c22873e228df2738a21cb2bd1b9
CANDIDATE_PARENT=40063afd16a36674e8660f6b4a05315d51f4e546 (exact preimage, forward-only)
OPERATED_CANDIDATE_SHA=0e859d93960e630965a5b71a3ff4c07e631d8570
ENGINEERING_BRANCH=engineering/goal-kk-01-px-findings-correction-r1
ENGINEERING_PR=#12 (Draft, OPEN, UNMERGED)
PREVIOUS_CANDIDATE=40063af… (PR #9, historical, unmoved)

EVIDENCE_BRANCH=evidence/goal-kk-01-non-candidate-r2 (NON_CANDIDATE_EVIDENCE)
SUPERSEDES=Issue #3 comment 5694766498 (R5 receipt, candidate 40063af)
```

## A. 完成了什么

- 按你方授权修正四项 Contract R2 缺陷(冻结范围,无新增 CR):
  1. **KK-PX-R5-01 知识语义错配** — Agent 回答与工作面只渲染所选/所中条目自身的标题/摘要/结论;无可模拟结论时诚实说明;未知主题诚实空白且零无关引用;冲突计数不再虚构(0 项·无虚构)。
  2. **KK-PX-R5-02 感知条被遮挡** — 每个工作浮层(知识/详情/工作面/日历/待办)内置感知条:状态+模拟·无真实 ASR 披露+暂停/恢复,与全局条同步;ON/PAUSED 两态均验证。
  3. **KK-PX-R5-03 修正/确认冲突** — 采用模型 A:保存修正只更新候选并返回候选卡(附可预期提示),入库只能由显式「确认入库」触发;已确认条目不再带「待确认」。
  4. **KK-PX-R5-04 返回目标不一致** — 采用方案 A:「返回 Agent 对话」在两条进入路径(知识导航 / Agent next action)下都真正直接返回 Agent 对话,上下文不丢。
  5. 两个授权内低风险 P3 一并修复:顺延后日程按时间排序;引用回复日期不再重复。
- 技术测试:115 条 Playwright 断言(360x780 MATE60_CLASS_SIMULATION,80→115,+35),Local Executor(全新 clone 精确 SHA,端口 5174)与 ED 本人(提交后 HEAD 复核,端口 5173)各自独立运行均 **115/115**,console/page error 均为空;单文件 HTML 经 file:// 同套件 **115/115**。
- ED 用户视角价值闭环复验:四项验收标准逐项真实操作 + R5 全回归价值闭环。
- 缺陷:最终 SHA 上无未决缺陷;defect loop 中发现的 1 个测试编排问题(仅测试)已在取证前修正,产品字节未再变动。

## B. Exact identity(以 GitHub 实时事实为准)

```bash
gh pr view 12 --repo zhouzengrui369-commits/knowme-knowledge --json headRefOid,state,isDraft
git ls-remote https://github.com/zhouzengrui369-commits/knowme-knowledge.git engineering/goal-kk-01-px-findings-correction-r1 evidence/goal-kk-01-non-candidate-r2
```

- Engineering branch head = PR #12 head = `0e859d93960e630965a5b71a3ff4c07e631d8570`
- PR #9 / 旧分支保持不动;candidate 只含 code+tests;全部证据在 evidence 分支。
- 两套操作证据均产于最终精确 candidate 本身,无父 commit 证据转移。
- R1–R5 历史证据在 `r1..r5-historical-superseded/`,原样保留,不可用于本 candidate admission。

## C. 证据在哪里(GitHub,evidence 分支)

分支 `evidence/goal-kk-01-non-candidate-r2`,路径
`reports/prototype/knowme-knowledge-01-agent-native-mate60/`:

```text
README.md · CANDIDATE_MANIFEST.md · TECHNICAL_RECEIPT.md · RUNTIME_RUNBOOK.md
BROWSER_ASSERTION_RECEIPT.md · KNOWME_UI_TRACEABILITY_MATRIX.md
INTERACTION_STATE_MAP.md · ALLOWED_PATH_DIFF_RECEIPT.md · MOCK_DATA_DISCLOSURE.md
LOCAL_EXECUTION_REQUEST.md · LOCAL_EXECUTION_RECEIPT.md
ED_PERSONAL_PRODUCT_OPERATION_RECEIPT.md · SCREENSHOT_INDEX.md
le-assertions.json (115/115) · ed-browser-assertions.json (115/115)
screenshots/local-executor/PX1-LE-P01..P12 · screenshots/ed-personal/PX1-ED-P01..P12 (sha256 表在 receipt 内)
deliverable/KnowME-Knowledge-01-Prototype.html (sha256 9db96a26…a2a02) + file-protocol-assertions.json (115/115)
r5-historical-superseded/ · r4-historical-superseded/ · r3-historical-superseded/(含 UI 权威拷贝)· r2 · r1
```

## D. 为什么卡

无 blocker。Engineering 范围无未决阻塞。

## E. 哪些没有完成

- NOT_IMPLEMENTED_BY_CONTRACT:HarmonyOS 正式实现、真实 Harness/Provider/Agent runtime/长期记忆/RAG/向量库/Wiki 索引、真实 ASR/声纹、真实导入管线、真实 Calendar/Todo 后端、Demo 2D 关系/3D 星海图谱、Skills、真实持久化、真实 Owner 数据、生产部署。
- UNRESOLVED_WITHIN_CONTRACT: 无。

## F. 已知限制

全部在冻结合同 allowed_known_limitations 内;视口证据为 360x780 MATE60_CLASS_SIMULATION。

## G. 下一 Gate

只推荐:`PRODUCT_GOVERNANCE_CANDIDATE_ADMISSION`(fresh,对后继 candidate `0e859d9…`)。

Admission 要点:PR #12 head = branch head = candidate identity(三者同为 0e859d9,操作证据直接产于它);candidate 由精确 preimage 40063af 前向派生;冻结修正范围内无范围扩张;无 forbidden path 改动;known limitations 全部在合同内;R5 的 lifecycle 状态不继承,需你重新裁定。
