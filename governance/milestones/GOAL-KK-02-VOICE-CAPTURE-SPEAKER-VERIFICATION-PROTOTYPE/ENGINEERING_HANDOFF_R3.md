# GOAL-KK-02 — Engineering Handoff R3 — PX Findings Correction

```text
PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
ACTOR_ROLE=PRODUCT_GOVERNANCE
GOAL_ID=GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
MILESTONE_ID=MILESTONE-GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
ONE_GOAL_EQUALS_ONE_MILESTONE=true

PRODUCT_BASELINE_ID=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2
PRODUCT_BASELINE_REF=governance/PRODUCT_BASELINE.md@978ed0608bda8e278c348ad2987f6a25fa3c3c2f

CHANGE_REQUEST_ID=CR-KK-02-PX01-R3
CHANGE_REQUEST_PATH=governance/change-requests/CR-KK-02-PX01-R3.md

PRODUCT_CONTRACT_REVISION=R3
PRODUCT_CONTRACT_PATH=governance/milestones/GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE/CONTRACT-R3.md
PRODUCT_CONTRACT_COMMIT=168af57a2e7bd74385cecd97da1717982ac12ab1
PRODUCT_CONTRACT_BLOB=b0ae8dbc980bc64f16bb77b30eaf5dbe9da64541
PRODUCT_CONTRACT_STATUS=FROZEN

ENGINEERING_EXECUTION_CONTRACT_PATH=governance/milestones/GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE/ENGINEERING_EXECUTION_CONTRACT_R3.md
ENGINEERING_EXECUTION_CONTRACT_COMMIT=674f895af6dfd492334bdceb0a846c390d6b4896

PX_FAIL_REF=Issue #13 comment 5742173191
PX_REPORT_COMMIT=56d005c1c76df26cdaf36675de2ba7d60d0006d4
PX_REPORT_PATH=reports/product-review/2026-09-19-knowme-knowledge-goal02-owner-review/REVIEW.md
ACCEPTED_PX_FINDINGS=PX-KK02-01;PX-KK02-02;PX-KK02-03;PX-KK02-04;PX-KK02-05

PREDECESSOR_CANDIDATE_SHA=b02bca6e5e84e98e5b4c99bc43d3599946089e83
PREDECESSOR_CANDIDATE_TREE=b40553f25b6a6c8eaa6ef37629ea176c2b09d047
PREDECESSOR_CANDIDATE_PR=#21
PREDECESSOR_PX_RESULT=NOT_READY

ENGINEERING_DELIVERY_AUTHORITY_REPOSITORY=zhouzengrui369-commits/chatgpt-engineering-delivery
ENGINEERING_DELIVERY_AUTHORITY_COMMIT=8bcf9da58d6147fcd2345a4b465f17f7a27850fd
ENGINEERING_DELIVERY_AUTHORITY_TREE=593bacfee4910a55b9b6c7bd2f2ca56b8761d134
ENGINEERING_DELIVERY_SKILL_PATH=core/ENGINEERING_DELIVERY_SKILL.md

ENGINEERING_CONTEXT_ID=ED-KK-GOAL02-PX01-CORRECTION-R3-20260920-0750-C61A
PREVIOUS_ENGINEERING_CONTEXT_REUSE=FORBIDDEN
ENGINEERING_PREIMAGE_BRANCH=governance/goal-kk-02-px01-correction-r3
ENGINEERING_PREIMAGE_SHA=BOUND_BY_ACTIVATION_RECEIPT
ENGINEERING_PREIMAGE_TREE=BOUND_BY_ACTIVATION_RECEIPT

NEW_ENGINEERING_BRANCH=engineering/goal-kk-02-px01-correction-r3
NEW_DRAFT_PR=REQUIRED

REAL_MATE60_REQUIRED_FOR_ENGINEERING_READY=NO
LOCAL_EXECUTOR_FINAL_SIMULATOR_RUN=MANDATORY
ED_PERSONAL_FINAL_SIMULATOR_RUN=MANDATORY
PX_FINDINGS_REGRESSION_MATRIX=MANDATORY
NEXT_PRODUCT_EXPERIENCE_MODE=FOCUSED_RETEST
```

## Engineering mission

Produce one exact successor candidate that fully satisfies Contract R3, closes all accepted PX findings in Engineering evidence, actively fixes any additional in-scope implementation defects, and proves the final product through both a fresh Local Executor run and ED personal operation.

Do not treat the PX bug list as the whole scope; Contract R3 is the sole product target.

## Required correction set

- `PX-KK02-01`: bounded persistence/recovery of explicitly saved synthetic knowledge + bounded Agent context across Home, permission settings, force-stop/cold reopen; rejected/unconfirmed content must not reappear.
- `PX-KK02-02`: direct manual text continuation while microphone is denied/unavailable, without reauthorization; honest source labeling.
- `PX-KK02-03`: repeatable visible TEST_FIXTURE candidate route in the simulator when natural speech cannot reach candidate; separate correct/reject/confirm; reject +0, confirm +1; no trust-gate weakening.
- `PX-KK02-04`: Agent-first default surface/context/result inspection; diagnostics secondary; no real LLM/RAG required.
- `PX-KK02-05`: clear normal-state simulator/not-real-device disclosure; enrollment state separated from current verdict; action labels match actual interaction.

## Required execution loop

```text
fresh R3 authority read
→ inspect predecessor candidate b02bca6
→ implement complete R3 successor
→ technical tests
→ build/install simulator
→ ED exploratory operation and active defect discovery
→ repair/regression loops
→ provisional final exact SHA
→ fresh Local Executor exact-SHA deploy + R3 operation + screenshots
→ defects back to ED; candidate change invalidates final evidence
→ fresh Local Executor rerun as needed
→ ED personally operates same final SHA/build + independent screenshots
→ any defect reopens Engineering
→ exact candidate package
→ ENGINEERING_READY
```

## Engineering evidence

Follow `ENGINEERING_EXECUTION_CONTRACT_R3.md` exactly. In particular, final evidence must include persistence recovery, denied-manual fallback, fixture candidate flow, Agent-first surface, disclosure/state, PX findings regression matrix, Local Executor final run, ED personal final run and screenshot index.

## Claim ceiling

```text
REAL_DEVICE_NOT_REVIEWED=YES
NOT_REAL_DEVICE_VALIDATED=YES
MATE60_COMPATIBILITY_CLAIMED=NO
REAL_DEVICE_ASR_CLAIMED=NO
REAL_DEVICE_SPEAKER_VERIFICATION_CLAIMED=NO
PRODUCTION_PERSISTENCE_CLAIMED=NO
```

## Engineering terminal

Only issue `ENGINEERING_READY` when all Contract R3 engineering-required evidence is complete on one exact SHA, `CANDIDATE_SHA=BRANCH_HEAD=PR_HEAD`, worktree is clean, and known in-scope blockers are none.

Engineering may never claim Candidate Admission, Product Review Eligibility, Product Experience verdict, Human Owner Acceptance, real-device validation, merge/release, or Goal/Milestone closure.

Hand back to Product Governance and stop.