# GOAL-KK-03 — Engineering Handoff

```text
PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
ACTOR_ROLE=PRODUCT_GOVERNANCE

GOAL_ID=GOAL-KK-03-VOICE-TO-NOTE-FIRST-USE-PROTOTYPE
MILESTONE_ID=MILESTONE-GOAL-KK-03-VOICE-TO-NOTE-FIRST-USE-PROTOTYPE
ONE_GOAL_EQUALS_ONE_MILESTONE=true

PRODUCT_BASELINE_ID=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2
PRODUCT_BASELINE_REF=governance/PRODUCT_BASELINE.md@978ed0608bda8e278c348ad2987f6a25fa3c3c2f

PRODUCT_CONTRACT_REVISION=R1
PRODUCT_CONTRACT_COMMIT=f38e48956dfcd8820cc090f04026839132508ece
PRODUCT_CONTRACT_TREE=038e90271febcb11915b1534f4e0f7cfb33427f8
PRODUCT_CONTRACT_BLOB=20560b805f7bcdf267ed99468bbe39cba8ec45a3
PRODUCT_CONTRACT_PATH=governance/milestones/GOAL-KK-03-VOICE-TO-NOTE-FIRST-USE-PROTOTYPE/CONTRACT.md
PRODUCT_CONTRACT_STATUS=FROZEN

ENGINEERING_EXECUTION_CONTRACT_PATH=governance/milestones/GOAL-KK-03-VOICE-TO-NOTE-FIRST-USE-PROTOTYPE/ENGINEERING_EXECUTION_CONTRACT.md
ENGINEERING_EXECUTION_CONTRACT_BLOB=0540c2f6917f7daeeaf5ce0a9449c67258c73e9e

OWNER_GATE_POLICY=governance/policies/HUMAN_OWNER_FINAL_ACCEPTANCE_AT_1_0.md
OWNER_ACCEPTANCE_REQUIRED=NO
PRODUCT_EXPERIENCE_REQUIRED=YES
PRODUCT_EXPERIENCE_MODE=FULL_EXPERIENCE_REVIEW

PREDECESSOR_GOAL=GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
PREDECESSOR_STATUS=GOAL_MILESTONE_CLOSED
PREDECESSOR_CANDIDATE_SHA=3317469085d8dc10a88818369ffcc2922904079c
PREDECESSOR_CANDIDATE_TREE=c688e8d6da0fe5fdaa12f2412158eb0c6d86ee15
PREDECESSOR_CLOSURE_REF=Issue #13 comment 5759364134

ENGINEERING_DELIVERY_AUTHORITY_REPOSITORY=zhouzengrui369-commits/chatgpt-engineering-delivery
ENGINEERING_DELIVERY_AUTHORITY_COMMIT=8bcf9da58d6147fcd2345a4b465f17f7a27850fd
ENGINEERING_DELIVERY_AUTHORITY_TREE=593bacfee4910a55b9b6c7bd2f2ca56b8761d134
ENGINEERING_DELIVERY_SKILL_PATH=core/ENGINEERING_DELIVERY_SKILL.md

ENGINEERING_CONTEXT_ID=ED-KK-GOAL03-VOICE-TO-NOTE-FIRST-USE-20260921-1935-D8F4
PREVIOUS_ENGINEERING_CONTEXT_REUSE=FORBIDDEN

ENGINEERING_PREIMAGE_BRANCH=governance/goal-kk-03-voice-to-note-first-use-r1
ENGINEERING_PREIMAGE_SHA=BOUND_BY_ACTIVATION_RECEIPT
ENGINEERING_PREIMAGE_TREE=BOUND_BY_ACTIVATION_RECEIPT

NEW_ENGINEERING_BRANCH=engineering/goal-kk-03-voice-to-note-first-use-r1
NEW_DRAFT_PR=REQUIRED

ENGINEERING_ALLOWED_PATHS=prototypes/knowme-knowledge-02-voice-speaker-verification/** ; reports/prototype/knowme-knowledge-03-voice-to-note-first-use/**
ENGINEERING_FORBIDDEN_PATHS=AGENTS.md ; README.md ; PROJECT_STATUS.md ; .github/** ; governance/** ; prototypes/knowme-knowledge-01-agent-native-mate60/** ; reports/prototype/knowme-knowledge-01-agent-native-mate60/** ; formal_product_source/** ; any_other_project_or_repository/**

REAL_MATE60_REQUIRED_FOR_ENGINEERING_READY=NO
LOCAL_EXECUTOR_FINAL_SIMULATOR_RUN=MANDATORY
ED_PERSONAL_FINAL_SIMULATOR_RUN=MANDATORY
HUMAN_OWNER_ROUTINE_TESTING=FORBIDDEN_AS_REQUIRED_GATE
```

## Engineering mission

Implement the complete frozen GOAL-KK-03 product increment so the current prototype becomes a coherent first-use voice-to-note product flow rather than a developer/test surface.

The core journey is:

```text
understand product
→ voice identity setup visible
→ start recording
→ recording feedback
→ stop/cancel
→ transcript candidate
→ correct/reject/continue
→ 整理成笔记
→ edit note
→ save/cancel
→ reopen
→ inspect original transcript/source
```

Engineering must follow the separate Engineering Execution Contract exactly, including active defect discovery, Local Executor final operation and ED personal final operation.

## First-use non-negotiable

A clean-install first screen must not require engineering briefing and must not be dominated by TEST_FIXTURE logs, old test history or diagnostic text.

The primary product experience must expose the purpose of the app and obvious voice identity / recording actions.

Simulator test-transcript controls may exist only as a secondary/collapsed tool for development/review when natural simulator STT is unavailable.

## Terminal

Engineering may return only a valid Engineering terminal. On success, maximum claim is ENGINEERING_READY.

Hand back to Product Governance and stop.
