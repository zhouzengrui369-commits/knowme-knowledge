# Parent PM Handoff Prompt — GOAL-KK-01 PX02 Disclosure Correction R1 (from Engineering Delivery)

```text
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR15_HEAD=NO
```

Self-contained handoff for a fresh Product Governance / Parent PM context.
No dependency on the Engineering Delivery chat.

---

你是 KnowME Knowledge 的全新独立 Product Governance / Parent PM。

本轮从 `ENGINEERING_READY` 开始,只负责:fresh Exact Candidate Admission(以及之后按门禁顺序的后续决策)。你不是 Engineering Delivery,不是 Product Experience Reviewer,不是 Human Owner;你无权宣告 PRODUCT_EXPERIENCE_PASS / HUMAN_OWNER_ACCEPTED / MERGE / RELEASE / GOAL_MILESTONE_CLOSED。注意:这是一个**后继 candidate**——PX1 的 ENGINEERING_READY / CANDIDATE_ADMITTED / PRODUCT_REVIEW_ELIGIBLE 均不继承,必须重新 admission。

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
NEW_CHANGE_REQUEST_REQUIRED=NO (你方已裁定,Issue #3 comment 5706266611)
CORRECTION_AUTHORITY=Issue #3 comment 5706266611 (ENGINEERING_CORRECTION_AUTHORIZED, 冻结范围:仅 KK-PX-R5-02 残留 + 回归保护)
FAILED_PX_ADJUDICATION=Issue #3 comment 5700717563 / PR #14 (PX1 candidate 0e859d9 → PRODUCT_EXPERIENCE FAIL)
EXPLORATORY_FINDINGS=PR #11 @ e095af1fa6bfc988360c252bd16e6dbdef2262ee (evidence only)

CANDIDATE_SHA=f89fe6695ebdbfa69e6b569447247120fab0c360
CANDIDATE_TREE=3b1d2a678d945d886df9185459fca6a76f332bf6
CANDIDATE_PARENT=0e859d93960e630965a5b71a3ff4c07e631d8570 (exact preimage, forward-only)
OPERATED_CANDIDATE_SHA=f89fe6695ebdbfa69e6b569447247120fab0c360
ENGINEERING_BRANCH=engineering/goal-kk-01-px02-disclosure-correction-r1
ENGINEERING_PR=#15 (Draft, OPEN, UNMERGED)
PREVIOUS_CANDIDATE=0e859d93960e630965a5b71a3ff4c07e631d8570 (PR #12, failed-PX history, unmoved)

EVIDENCE_BRANCH=evidence/goal-kk-01-non-candidate-r2 (NON_CANDIDATE_EVIDENCE)
SUPERSEDES=Issue #3 comment 5699088488 (PX1 receipt, candidate 0e859d9)
```

## A. 完成了什么

- 按你方授权(Issue #3 comment 5706266611)修正 PX1 复测裁定的**唯一阻断残留**(冻结范围,无新增 CR,无范围扩张):
  1. **KK-PX-R5-02 残留:ON 态 sheet 内感知条披露被截断** — 浮层内感知条重构为两行:第一行 = 信号 + 状态文案(后台持续感知中/感知已暂停)+ **独立不截断披露 chip**「模拟 · 无真实 ASR」(data-testid=sheet-sensing-disclosure, flex-shrink:0)+ 暂停/恢复;第二行 = 动态感知行(允许省略号)。reviewer 实测的截断(clientWidth=254 / scrollWidth=404)已消除:五个浮层(知识/详情/工作面/日历/待办)× ON/PAUSED 两态,披露在 360x780 下全部完整可读(10 条新断言 PX02_DISCLOSURE_FULL_*,逐态截图各 10 张)。
  2. **回归保护**:其余产品行为零改动;KK-PX-R5-01/03/04 与两项 P3 修复保持 0e859d9 原状,原断言全部通过。
- 技术测试:125 条 Playwright 断言(360x780 MATE60_CLASS_SIMULATION,115→125,+10),Local Executor(精确 SHA tarball 物化,端口 5174)与 ED 本人(提交后 HEAD 复核,端口 5173)各自独立运行均 **125/125**,console/page error 均为空;单文件 HTML 经 file:// 同套件 **125/125**。
- ED 用户视角价值闭环复验:PX02 披露验收(5 表面×2 态)逐项真实操作 + PX1 四项/R5 回归抽查。
- 缺陷:本轮首轮全过,最终 SHA 上无未决缺陷。

## B. Exact identity(以 GitHub 实时事实为准)

```bash
gh pr view 15 --repo zhouzengrui369-commits/knowme-knowledge --json headRefOid,state,isDraft
git ls-remote https://github.com/zhouzengrui369-commits/knowme-knowledge.git engineering/goal-kk-01-px02-disclosure-correction-r1 evidence/goal-kk-01-non-candidate-r2
```

- Engineering branch head = PR #15 head = `f89fe6695ebdbfa69e6b569447247120fab0c360`
- PR #9 / PR #12 / PR #14 保持不动;candidate 只含 code+tests;全部证据在 evidence 分支。
- 两套操作证据均产于最终精确 candidate 本身,无父 commit 证据转移。
- R1–PX1 历史证据在 `r1..r5-historical-superseded/` 与 `px1-historical-superseded/`,原样保留,不可用于本 candidate admission。

## C. 证据在哪里(GitHub,evidence 分支)

分支 `evidence/goal-kk-01-non-candidate-r2`,路径
`reports/prototype/knowme-knowledge-01-agent-native-mate60/`:

```text
README.md · CANDIDATE_MANIFEST.md · TECHNICAL_RECEIPT.md · RUNTIME_RUNBOOK.md
BROWSER_ASSERTION_RECEIPT.md · KNOWME_UI_TRACEABILITY_MATRIX.md
INTERACTION_STATE_MAP.md · ALLOWED_PATH_DIFF_RECEIPT.md · MOCK_DATA_DISCLOSURE.md
LOCAL_EXECUTION_REQUEST.md · LOCAL_EXECUTION_RECEIPT.md
ED_PERSONAL_PRODUCT_OPERATION_RECEIPT.md · SCREENSHOT_INDEX.md
le-assertions.json (125/125) · ed-browser-assertions.json (125/125)
screenshots/local-executor/PX2-LE-P01..P12 + PX2-LE-PX02-* ×10 · screenshots/ed-personal/PX2-ED-* 同(共 44 张,sha256 表在 SCREENSHOT_INDEX.md)
deliverable/KnowME-Knowledge-01-Prototype.html (sha256 fff5fe15…eaf539) + file-protocol-assertions.json (125/125)
px1-historical-superseded/ · r5-historical-superseded/ · r4-historical-superseded/ · r3-historical-superseded/(含 UI 权威拷贝)· r2 · r1
```

## D. 为什么卡

无 blocker。Engineering 范围无未决阻塞。

## E. 哪些没有完成

- NOT_IMPLEMENTED_BY_CONTRACT:HarmonyOS 正式实现、真实 Harness/Provider/Agent runtime/长期记忆/RAG/向量库/Wiki 索引、真实 ASR/声纹、真实导入管线、真实 Calendar/Todo 后端、Demo 2D 关系/3D 星海图谱、Skills、真实持久化、真实 Owner 数据、生产部署。
- UNRESOLVED_WITHIN_CONTRACT: 无。

## F. 已知限制

全部在冻结合同 allowed_known_limitations 内;视口证据为 360x780 MATE60_CLASS_SIMULATION。

## G. 下一 Gate

只推荐:`PRODUCT_GOVERNANCE_CANDIDATE_ADMISSION`(fresh,对后继 candidate `f89fe66…`)。

Admission 要点:PR #15 head = branch head = candidate identity(三者同为 f89fe66,操作证据直接产于它);candidate 由精确 preimage 0e859d9 前向派生;冻结修正范围内无范围扩张(仅 KK-PX-R5-02 残留 + 回归断言);无 forbidden path 改动;known limitations 全部在合同内;PX1 的 lifecycle 状态不继承,需你重新裁定。
