# GOAL-KK-02 — Engineering Handoff R2 — Simulator-First

```text
PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
ACTOR_ROLE=PRODUCT_GOVERNANCE
GOAL_ID=GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
MILESTONE_ID=MILESTONE-GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
ONE_GOAL_EQUALS_ONE_MILESTONE=true

PRODUCT_BASELINE_ID=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2
PRODUCT_BASELINE_REF=governance/PRODUCT_BASELINE.md@978ed0608bda8e278c348ad2987f6a25fa3c3c2f

SIMULATOR_FIRST_POLICY=governance/policies/SIMULATOR_FIRST_UNTIL_1_0.md
CHANGE_REQUEST=governance/change-requests/CR-KK-02-SIMULATOR-FIRST-UNTIL-1.0.md

CONTRACT_PATH=governance/milestones/GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE/CONTRACT-R2.md
CONTRACT_COMMIT=335e4b9e6c64c9e6a9b69fcc2d2e49b5a0c0d69c
CONTRACT_TREE=044335819236d003c941134a6414f4507b41dc6b
CONTRACT_BLOB=f05b84a90dc8644e2e368283409508f8003dfa0e
CONTRACT_STATUS=FROZEN

SUPERSEDES_ENGINEERING_HANDOFF=governance/milestones/GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE/ENGINEERING_HANDOFF.md
PRIOR_ENGINEERING_HEAD_REUSED_AS_SUCCESSOR_LINEAGE=f89fe669?NO
CURRENT_IMPLEMENTATION_PREIMAGE_SHA=549fad6f0c15cf85a35541e222467027725960aa
CURRENT_IMPLEMENTATION_PREIMAGE_ROLE=PRIOR_R1_ENGINEERING_WORK_REUSED_FORWARD_ONLY

ENGINEERING_DELIVERY_AUTHORITY_REPOSITORY=zhouzengrui369-commits/chatgpt-engineering-delivery
ENGINEERING_DELIVERY_AUTHORITY_COMMIT=8bcf9da58d6147fcd2345a4b465f17f7a27850fd
ENGINEERING_DELIVERY_AUTHORITY_TREE=593bacfee4910a55b9b6c7bd2f2ca56b8761d134
ENGINEERING_DELIVERY_SKILL_PATH=core/ENGINEERING_DELIVERY_SKILL.md

ENGINEERING_CONTEXT_ID=ED-KK-GOAL02-SIMULATOR-FIRST-R2-20260919-0925-B4E7
PREVIOUS_ENGINEERING_CONTEXT_REUSE=FORBIDDEN
ENGINEERING_PREIMAGE_BRANCH=governance/goal-kk-02-simulator-first-r2
ENGINEERING_PREIMAGE_SHA=BOUND_BY_ACTIVATION_RECEIPT
ENGINEERING_PREIMAGE_TREE=BOUND_BY_ACTIVATION_RECEIPT

NEW_ENGINEERING_BRANCH=engineering/goal-kk-02-simulator-first-r2
NEW_DRAFT_PR=REQUIRED

REAL_MATE60_REQUIRED_FOR_ENGINEERING_READY=NO
SIMULATOR_FINAL_EXACT_SHA_REQUIRED=YES
LOCAL_EXECUTOR_SIMULATOR_OPERATION_REQUIRED=YES
ED_PERSONAL_SIMULATOR_OPERATION_REQUIRED=YES
FORMAL_PX_REVIEW_ENVIRONMENT=SIMULATOR_OR_CONTROLLED_DEV_ENV
REAL_DEVICE_VALIDATION_DEFERRED_UNTIL_AFTER_1_0=YES
```

## Mission

Continue from the preserved R1 implementation lineage and make one exact successor candidate fully satisfy Contract R2 in the declared simulator/development environment. Do not wait for Mate60 connection.

Engineering must actively find and repair in-scope defects until the final exact SHA is technically complete for the simulator contract.

## Required execution loop

```text
fresh R2 authority read
→ inspect inherited implementation from 549fad6
→ repair any R2 contract gaps
→ technical tests
→ simulator build/install
→ Local Executor fresh exact-SHA simulator operation + screenshots
→ ED personal operation of same exact SHA/build + independent screenshots
→ defects return to ED
→ new SHA invalidates old final evidence
→ repeat until no blocking in-scope defect
→ ENGINEERING_READY
```

## Mandatory simulator journeys

- voice entry and honest permission/capability state;
- enrollment start/cancel/complete/reset;
- transcript/result path using actual simulator runtime when available or clearly disclosed simulator proxy/test fixture when not;
- VERIFIED / NOT_VERIFIED / UNCERTAIN / NOT_AVAILABLE trust semantics;
- correction / reject / explicit confirm;
- permission denial and recovery;
- NOT_AVAILABLE fallback/manual path;
- repeated capture and state reset;
- Agent context preserved;
- no intentional silent cloud audio fallback.

## Claim ceiling

Engineering evidence must state:

```text
REAL_DEVICE_NOT_REVIEWED=YES
NOT_REAL_DEVICE_VALIDATED=YES
MATE60_COMPATIBILITY_CLAIMED=NO
REAL_DEVICE_ASR_CLAIMED=NO
REAL_DEVICE_SPEAKER_VERIFICATION_CLAIMED=NO
```

## Local Executor

Dispatch a fresh Local Executor sub-agent against the final exact SHA. It must fresh-materialize, build/install on the declared simulator, operate required journeys, capture privacy-safe screenshots, and return observation receipts. It must not repair source/tests.

## ED personal operation

After Local Executor evidence is complete, ED personally operates the same exact SHA/build in the simulator and produces separate screenshots/receipt. Any observed in-scope defect reopens Engineering.

## Evidence package

At minimum:

- CANDIDATE_MANIFEST.md
- TECHNICAL_RECEIPT.md
- ALLOWED_PATH_DIFF_RECEIPT.md
- SIMULATOR_ENVIRONMENT_RECEIPT.md
- LOCAL_EXECUTION_RECEIPT.md
- ED_PERSONAL_OPERATION_RECEIPT.md
- RUNTIME_ERROR_RECEIPT.md
- NETWORK_BOUNDARY_RECEIPT.md
- PRIVACY_EVIDENCE_RECEIPT.md
- REGRESSION_RECEIPT.md
- SCREENSHOT_INDEX.md
- screenshots/local-executor/**
- screenshots/ed-personal/**

Existing real-device templates may remain historical/planning material but cannot be represented as completed evidence.

## Engineering terminal

Only declare ENGINEERING_READY when all Contract R2 engineering_required evidence is complete on one exact SHA. If a simulator/runtime prerequisite is genuinely unavailable, use the truthful locked Engineering terminal.

Never claim Candidate Admission, Product Review Eligibility, Product Experience, Human Owner Acceptance, real-device validation, merge/release or Goal closure.

Hand back to Product Governance and stop.