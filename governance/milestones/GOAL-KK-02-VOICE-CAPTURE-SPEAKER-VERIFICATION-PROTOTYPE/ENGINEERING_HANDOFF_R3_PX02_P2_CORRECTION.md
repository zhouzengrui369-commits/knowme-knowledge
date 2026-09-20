# GOAL-KK-02 — Engineering Handoff R3 PX02 P2 Correction

```text
PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
ACTOR_ROLE=PRODUCT_GOVERNANCE
GOAL_ID=GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
MILESTONE_ID=MILESTONE-GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
ONE_GOAL_EQUALS_ONE_MILESTONE=true

PRODUCT_BASELINE_ID=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2
PRODUCT_BASELINE_REF=governance/PRODUCT_BASELINE.md@978ed0608bda8e278c348ad2987f6a25fa3c3c2f

PRODUCT_CONTRACT_REVISION=R3
PRODUCT_CONTRACT_PATH=governance/milestones/GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE/CONTRACT-R3.md
PRODUCT_CONTRACT_COMMIT=168af57a2e7bd74385cecd97da1717982ac12ab1
PRODUCT_CONTRACT_TREE=ae8c768218a7f517bd951a1b1a3f5b9354bcc932
PRODUCT_CONTRACT_BLOB=b0ae8dbc980bc64f16bb77b30eaf5dbe9da64541
PRODUCT_CONTRACT_STATUS=FROZEN_UNCHANGED

CHANGE_REQUEST_REQUIRED=NO
CHANGE_REQUEST_REASON=PX_KK02_R3_06_IS_ALREADY_WITHIN_R3_AO_R3_05_AND_AO_R3_02_IMPLEMENTATION_SCOPE

PREDECESSOR_CANDIDATE_SHA=06b013cf776d308737cf6726afcff7ee4831f5f4
PREDECESSOR_CANDIDATE_TREE=7cb5983766875d982df4ff8795a1aa3a3bac96fc
PREDECESSOR_CANDIDATE_PR=#24
PREDECESSOR_CANDIDATE_ADMISSION_REF=Issue #13 comment 5747829096
PREDECESSOR_REVIEW_ELIGIBILITY_REF=Issue #13 comment 5747856343

PX_REVIEW_PR=#25
PX_REVIEW_COMMIT=c40eed63860d0e94d041b0de5bb4ff329b826c8e
PX_REVIEW_REF=Issue #13 comment 5748639444
PX_REVIEWER_VERDICT=READY_WITH_MANDATORY_FIXES
CANONICAL_LIFECYCLE_RESULT=PRODUCT_EXPERIENCE_FAIL
CANONICAL_MAPPING_REASON=MANDATORY_IN_SCOPE_P2_REMAINS_AND_PRODUCT_EXPERIENCE_PASS_WAS_NOT_ISSUED

CLOSED_FINDINGS=PX-KK02-01;PX-KK02-02;PX-KK02-03;PX-KK02-04
PARTIALLY_FIXED_FINDING=PX-KK02-05
OPEN_FINDING=PX-KK02-R3-06
OPEN_FINDING_SEVERITY=P2

ENGINEERING_EXECUTION_CONTRACT_PATH=governance/milestones/GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE/ENGINEERING_EXECUTION_CONTRACT_R3.md
ENGINEERING_DELIVERY_AUTHORITY_REPOSITORY=zhouzengrui369-commits/chatgpt-engineering-delivery
ENGINEERING_DELIVERY_AUTHORITY_COMMIT=8bcf9da58d6147fcd2345a4b465f17f7a27850fd
ENGINEERING_DELIVERY_AUTHORITY_TREE=593bacfee4910a55b9b6c7bd2f2ca56b8761d134

ENGINEERING_CONTEXT_ID=ED-KK-GOAL02-R3-PX02-P2-CORRECTION-20260920-1645-A19D
PREVIOUS_ENGINEERING_CONTEXT_REUSE=FORBIDDEN
ENGINEERING_PREIMAGE_BRANCH=governance/goal-kk-02-r3-px02-p2-correction-r1
ENGINEERING_PREIMAGE_SHA=BOUND_BY_ACTIVATION_RECEIPT
ENGINEERING_PREIMAGE_TREE=BOUND_BY_ACTIVATION_RECEIPT

NEW_ENGINEERING_BRANCH=engineering/goal-kk-02-r3-px02-p2-correction-r1
NEW_DRAFT_PR=REQUIRED

LOCAL_EXECUTOR_FINAL_SIMULATOR_RUN=MANDATORY
ED_PERSONAL_FINAL_SIMULATOR_RUN=MANDATORY
REAL_MATE60_REQUIRED_FOR_ENGINEERING_READY=NO
NEXT_PRODUCT_EXPERIENCE_MODE=FOCUSED_RETEST
```

## Engineering objective

Perform the smallest complete R3 implementation correction for `PX-KK02-R3-06` while preserving all behavior already closed in the focused retest.

The remaining defect is:

> While system microphone permission is denied, creating a TEST_FIXTURE candidate clears the denied/permission-required presentation and shows the microphone as idle. After rejecting the candidate, the UI says `点开始说话`, but the next action actually routes to system permission settings because microphone permission is still off.

## Required behavior

When microphone permission is denied or required:

- creating, correcting, rejecting, confirming or dismissing a TEST_FIXTURE candidate must not mutate or visually erase the real microphone permission state;
- the UI must continue to communicate that microphone permission is unavailable/required;
- the primary voice action must describe the action that will actually occur (for example permission/settings action rather than implying immediate recording);
- manual text continuation remains available;
- TEST_FIXTURE correct/reject/confirm remains available;
- reject remains +0;
- confirm remains exactly +1;
- reopening permission settings and granting permission must update the visible state correctly;
- no trust-gate weakening, no threshold manipulation, no fake VERIFIED state.

## Regression protections

Do not regress the four closed P1 findings:

- PX-KK02-01 persistence/recovery;
- PX-KK02-02 mic-denied manual continuation;
- PX-KK02-03 TEST_FIXTURE correct/reject/confirm;
- PX-KK02-04 Agent-first default surface.

Also preserve:

- simulator / not-real-device disclosure;
- enrollment profile vs current-verdict separation;
- explicit-confirm semantics;
- local/no-silent-cloud claim ceiling;
- D1-D21 regressions relevant to the touched state path.

## Mandatory real-product proof

Engineering Ready cannot be based on source/test changes alone.

After the fix, ED must freeze one provisional final exact SHA and dispatch a fresh Local Executor to deploy that SHA to the declared simulator and operate at minimum:

1. system microphone OFF / denied visible;
2. generate TEST_FIXTURE while mic remains denied;
3. correct candidate and verify denied state remains truthful;
4. reject candidate and verify +0 and denied state/action wording remains truthful;
5. generate another fixture and confirm +1 while denied state remains truthful;
6. manual text save remains available while mic denied;
7. tap the permission-related action and verify it goes to settings with wording consistent with that action;
8. grant permission and return; verify state updates correctly;
9. force-stop/cold reopen and inspect previously saved items;
10. Agent-first surface remains primary.

Local Executor must capture before/after screenshots for each critical state and may not repair the product.

After Local Executor PASS, ED personally operates the same exact SHA/build and independently repeats the core correction path with its own screenshots. Any in-scope defect found by either operator reopens Engineering; any candidate SHA/tree change invalidates prior final LE/ED evidence and requires fresh final runs.

## Evidence required

At minimum add/update exact evidence for:

- Candidate Manifest;
- Technical Receipt;
- PX-KK02-R3-06 regression receipt/matrix;
- Local Executor receipt and screenshots;
- ED personal operation receipt and screenshots;
- permission-state / fixture-state before-after screenshots;
- admission-safe exact candidate identity;
- runtime error / privacy / network boundary receipts as affected.

Use independent evidence transport so evidence commits do not move the candidate PR Head.

## Engineering Ready hard gate

Only return `ENGINEERING_READY` when:

```text
PX_KK02_R3_06_ENGINEERING_REGRESSION=PASS
PX_KK02_01_04_REGRESSION=PASS
MIC_PERMISSION_STATE_TRUTHFUL_THROUGH_FIXTURE_FLOW=YES
FIXTURE_REJECT_PLUS_ZERO=PASS
FIXTURE_CONFIRM_PLUS_ONE=PASS
MANUAL_FALLBACK_WHILE_DENIED=PASS
PERMISSION_ACTION_WORDING_MATCHES_ACTUAL_ACTION=PASS
PERMISSION_GRANT_RETURN_REFRESH=PASS
LOCAL_EXECUTOR_FINAL_EXACT_SHA_OPERATION=PASS
ED_PERSONAL_SAME_SHA_OPERATION=PASS
KNOWN_IN_SCOPE_BLOCKING_DEFECTS=NONE
CANDIDATE_SHA=BRANCH_HEAD=PR_HEAD
WORKTREE_CLEAN=YES
ENGINEERING_REQUIRED_EVIDENCE=COMPLETE
UNAPPROVED_DEVIATIONS=NONE
```

## Claim ceiling

Still:

```text
REAL_DEVICE_NOT_REVIEWED=YES
NOT_REAL_DEVICE_VALIDATED=YES
MATE60_COMPATIBILITY_CLAIMED=NO
REAL_DEVICE_ASR_CLAIMED=NO
REAL_DEVICE_SPEAKER_VERIFICATION_CLAIMED=NO
PRODUCTION_PERSISTENCE_CLAIMED=NO
```

## Terminal handoff

After completion, commit/push, create a new Draft OPEN UNMERGED Engineering PR, publish an exact `ENGINEERING_READY` terminal to Issue #13, and output `PARENT_PM_HANDOVER_PROMPT` stating:

- what was changed;
- exact candidate SHA/tree/parent/branch/PR;
- Local Executor exact operation and screenshots;
- ED personal exact operation and screenshots;
- defects found/fixed;
- evidence refs;
- blockers;
- contract-required not complete;
- out-of-scope future work;
- claim ceiling;
- `NEXT_AUTHORIZED_GATE=PRODUCT_GOVERNANCE_CANDIDATE_ADMISSION`.

Do not claim Candidate Admission, Product Review Eligibility, Product Experience PASS/FAIL, Human Owner Acceptance, merge/release or Goal/Milestone closure.