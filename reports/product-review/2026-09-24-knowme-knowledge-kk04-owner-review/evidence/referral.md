## Product Governance — GOAL-KK-04 Product Review Eligibility + Full Experience Review Referral

```text
PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
ACTOR_ROLE=PRODUCT_GOVERNANCE
ACTOR_CONTEXT_ID=PG-KK04-REVIEW-ELIGIBILITY-20260924-1121-SOL56
INPUT_STATE=CANDIDATE_ADMITTED
OUTPUT_STATE=PRODUCT_REVIEW_ELIGIBLE

GOAL_ID=GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
MILESTONE_ID=MILESTONE-GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE
ONE_GOAL_EQUALS_ONE_MILESTONE=true

PRODUCT_BASELINE_ID=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260922-v3-LINGXI-CAPTURE-DEVICE
CONTRACT_COMMIT=be400447c1d68062d22ae5e9ea0d169d929514df
CONTRACT_TREE=48b4f641c5ba6a9bdcbf899dba79c27160666dac
CONTRACT_PATH=governance/milestones/GOAL-KK-04-LINGXI-MOBILE-CAPTURE-BRIDGE/CONTRACT.md
CONTRACT_BLOB=19c950767a799d4c04712820f643cb46ab9e0077
CONTRACT_CHANGE=NONE

CANDIDATE_ADMISSION_REF=Issue_35_comment_5797265869
ENGINEERING_TERMINAL_REF=Issue_35_comment_5796518601

APP_CANDIDATE_SHA=c0171d4fa5a988272afa76cabd42b4b6ddbaea8d
APP_CANDIDATE_TREE=4c88cf33614e93a1b9dc64be12929cd64dd019e7
APP_CANDIDATE_PARENT=10d829195ebb7f6c4c576b0d116e45087ec2b35a
APP_PR=37
APP_BRANCH=engineering/goal-kk-04-lingxi-mobile-capture-bridge-r1
APP_PR_STATE=OPEN_DRAFT_UNMERGED
APP_PR_HEAD_FRESH_CHECK=c0171d4fa5a988272afa76cabd42b4b6ddbaea8d

WORKBENCH_CANDIDATE_SHA=92892d66d059211113379b7e49d7f034b7ec921c
WORKBENCH_CANDIDATE_TREE=b527133111112abea4831fa6b4be2c251e7927be
WORKBENCH_CANDIDATE_PARENT=e548883b1d696b8245631bad129dd3737afcc5b7
WORKBENCH_PR=8
WORKBENCH_BRANCH=engineering/goal-kk-04-mobile-capture-bridge
WORKBENCH_PR_STATE=OPEN_DRAFT_UNMERGED
WORKBENCH_PR_HEAD_FRESH_CHECK=92892d66d059211113379b7e49d7f034b7ec921c

CANDIDATE_IDENTITY_DRIFT=NONE
NO_CANDIDATE_MUTATION_AFTER_ADMISSION=YES

REVIEW_MODE=FULL_EXPERIENCE_REVIEW
REVIEW_SCOPE=GOAL_KK04_J01_TO_J12_FULL_USER_VALUE_REVIEW

REVIEW_BUILD_IDENTITY=entry-default-unsigned.hap@sha256:a73022244985e93a3f227b967bd771e8070dd562d499d16ddca4a91b8d721549
REVIEW_BUILD_SIZE=39206998
REVIEW_RUNTIME_APP_SHA=c0171d4fa5a988272afa76cabd42b4b6ddbaea8d
REVIEW_RUNTIME_WORKBENCH_SHA=92892d66d059211113379b7e49d7f034b7ec921c
REVIEW_RUNTIME_PLUGIN=mobile_capture_bridge_v1.0.0
REVIEW_RUNTIME_PROTOCOL=/api/mobile-capture/v1
REVIEW_RUNTIME_DSH=TokenHub_DeepSeek-V4.1-Flash
REVIEW_RUNTIME_ASR=mlx-whisper/small
REVIEW_RUNTIME_ORGANIZER=instant-note-organizer-v4_schema-v4.0
REVIEW_RUNTIME_EXTERNAL_SEND=disabled
REVIEW_RUNTIME_DEVICE=OpenHarmony_emulator_127.0.0.1:5555
REAL_DEVICE_NOT_REVIEWED=YES
NOT_REAL_DEVICE_VALIDATED=YES

EVIDENCE_COMMIT=b44d11b8ffe594666721510a3b9cd9e97015415f
EVIDENCE_TREE=fd9c19a9cb44058f7a5eb94335dbb6817e4eafd6
EVIDENCE_ROOT=reports/integration/goal-kk-04/r3-gap-closure/
REVIEW_RUNTIME_RUNBOOK_REF=b44d11b8ffe594666721510a3b9cd9e97015415f:reports/integration/goal-kk-04/r3-gap-closure/RUNTIME_RUNBOOK.md
REVIEW_ENVIRONMENT_REF=b44d11b8ffe594666721510a3b9cd9e97015415f:reports/integration/goal-kk-04/r3-gap-closure/ENVIRONMENT_RECEIPT.md
CANONICAL_ARTIFACT_REF=b44d11b8ffe594666721510a3b9cd9e97015415f:reports/integration/goal-kk-04/r3-gap-closure/CANONICAL_ARTIFACT_RECEIPT.md
SCREENSHOT_INDEX_REF=b44d11b8ffe594666721510a3b9cd9e97015415f:reports/integration/goal-kk-04/r3-gap-closure/SCREENSHOT_INDEX.md
RUNTIME_PRIVACY_REF=b44d11b8ffe594666721510a3b9cd9e97015415f:reports/integration/goal-kk-04/r3-gap-closure/RUNTIME_PRIVACY_RECEIPT.md
J06_BACKGROUND_REF=b44d11b8ffe594666721510a3b9cd9e97015415f:reports/integration/goal-kk-04/r3-gap-closure/J06_IDEMPOTENCY_RECEIPT.md
J11_BACKGROUND_REF=b44d11b8ffe594666721510a3b9cd9e97015415f:reports/integration/goal-kk-04/r3-gap-closure/J11_WORKBENCH_UI_RECEIPT.md
PROVENANCE_BACKGROUND_REF=b44d11b8ffe594666721510a3b9cd9e97015415f:reports/integration/goal-kk-04/r3-gap-closure/PROVENANCE_REGRESSION_RECEIPT.md
PX_REGRESSION_BACKGROUND_REF=b44d11b8ffe594666721510a3b9cd9e97015415f:reports/integration/goal-kk-04/r3-gap-closure/PX_REGRESSION_RECEIPT.md

REVIEW_REQUIRED_EVIDENCE=COMPLETE
EXACT_DUAL_CANDIDATE_FROZEN_FOR_REVIEW=YES
EXACT_CANONICAL_ARTIFACT_IDENTITY=COMPLETE
RUNNABLE_REVIEW_INSTRUCTIONS=COMPLETE
DECLARED_ISOLATED_REVIEW_ENVIRONMENT_REPRODUCIBLE=YES
CLEAN_STATE_JOURNEYS_DEFINED=YES
REVIEWER_OWNED_EVIDENCE_REQUIRED=YES
ENGINEERING_SCREENSHOTS_AS_REVIEWER_PROOF=FORBIDDEN

PRIOR_PRODUCT_EXPERIENCE_REVIEW_PR=33
PRIOR_PRODUCT_EXPERIENCE_REVIEW_COMMIT=bb2c33595e6100750ec35110c5cd13b2d556f4ac
PRIOR_REVIEW_TARGET=d02014f185595ab9f73c423017842d2d2d268252
PRIOR_REVIEW_VERDICT=NOT_READY
PRIOR_FINDINGS=PX-KK03-01;PX-KK03-02;PX-KK03-03
PRIOR_FINDINGS_ROLE=REGRESSION_PROTECTIONS_ONLY_NO_PASS_INHERITANCE

INDEPENDENT_REVIEWER_ROLE=INDEPENDENT_PRODUCT_EXPERIENCE_REVIEWER
INDEPENDENT_REVIEWER_CONTEXT_ID=PX-KK04-FULL-EXPERIENCE-C0171D4-20260924-1121-R1
REVIEWER_AUTHORITY_REPOSITORY=zhouzengrui369-commits/product-experience-reviewer-skill
REVIEWER_AUTHORITY_COMMIT=4253deb55a04de20fca6ac50a47b42a6d4489c04
REVIEWER_AUTHORITY_TREE=eaa62967737b17cc8ad07e46e297e0a52b2c3092
DID_NOT_AUTHOR_CANDIDATE=YES
DID_NOT_TECHNICALLY_GATE_CANDIDATE=YES
DID_NOT_DEPLOY_WITH_REPAIR_AUTHORITY=YES
DID_NOT_ADMIT_CANDIDATE=YES
CODE_BLIND_FOR_VERDICT=YES
PREVIOUS_ENGINEERING_CONTEXT_REUSE=FORBIDDEN
PREVIOUS_PRODUCT_GOVERNANCE_CONTEXT_REUSE=FORBIDDEN

PRODUCT_REVIEW_REFERRAL=ISSUED
PRODUCT_REVIEW_ELIGIBILITY=PRODUCT_REVIEW_ELIGIBLE
PRODUCT_EXPERIENCE=NOT_STARTED
HUMAN_OWNER_ACCEPTANCE=NOT_REQUIRED_FOR_THIS_PRE_1_0_GOAL
MERGE_AUTHORIZED=NO
RELEASE_AUTHORIZED=NO
GOAL_MILESTONE_CLOSED=NO

NEXT_AUTHORIZED_TRANSITION=INDEPENDENT_PRODUCT_EXPERIENCE_FULL_REVIEW
FORBIDDEN_CLAIMS_ACKNOWLEDGED=YES
ISSUED_AT=2026-09-24T11:21:00+08:00
STOPPED=YES
```

### Eligibility decision

Product Review eligibility is established for the exact admitted integrated candidate. Product Governance fresh-checked both live PR Heads after Candidate Admission; App remains `c0171d4...` and Workbench remains `92892d66...`, both OPEN/DRAFT/UNMERGED. The evidence branch remains frozen at `b44d11b8...`, and the one canonical review artifact remains HAP `a7302224...1549` (39,206,998 B).

The frozen Contract's `review_required` bucket is complete: exact dual-candidate and runtime/config identity are pinned, a clean isolated runtime is reproducible from the exact Runbook, clean-state J01–J12 journeys are defined, reviewer-owned evidence is required, and the referral below binds a fresh independent reviewer context and the pinned reviewer authority.

The review mode is `FULL_EXPERIENCE_REVIEW`, not a focused retest. GOAL-KK-04 is a new full mobile-capture product increment whose frozen closure condition requires an independent full Product Experience PASS over J01–J12. PR #33 / KK03 findings remain regression protections only and cannot reduce the KK04 review to three historical issues.

### Exact independent Product Experience Review referral

The independent reviewer must start in fresh context `PX-KK04-FULL-EXPERIENCE-C0171D4-20260924-1121-R1` and use product-experience-reviewer-skill exactly at `4253deb55a04de20fca6ac50a47b42a6d4489c04` / tree `eaa62967737b17cc8ad07e46e297e0a52b2c3092`.

#### Stage A — isolated first-use review

Before reading the Product Baseline, engineering receipts, prior PX report, or historical screenshots, the reviewer must personally enter the exact runtime cold with only: target-user identity (single Owner using Lingxi mobile capture), candidate entry point, one real representative capture task, and the safety boundary (synthetic/test content only; isolated workbench; no production/private data). Freeze Stage A output before Stage B. If true isolation cannot be maintained, explicitly label the result `PRIMED_COGNITIVE_WALKTHROUGH` rather than claiming blind review.

Stage A must answer from product experience only: what the product appears to be, what primary action is obvious, whether local-save/submission state is understandable, whether the mobile/workbench relationship makes sense, and where uncertainty or trust friction appears.

#### Stage B — full frozen-contract review

After Stage A is frozen, read the frozen Product Baseline, GOAL-KK-04 Product Contract, this referral, the prior PR #33 review only as historical regression context, and the R3 evidence package only as reproduction/background material.

The reviewer must personally operate the real candidate and create new reviewer-owned screenshots/evidence for all J01–J12:

1. J01 — fresh install/connect/capabilities/revoke/rejected access/reconnect.
2. J02 — online text: local save → explicit submit → durable receive → actual workbench organize → open actual result/source on both sides.
3. J03 — real synthetic spoken audio: 30s+ actual ASR/organizer path; separately exercise the 5-minute recording/processing path and judge feedback/recovery, without treating upload as completion.
4. J04 — offline capture → kill/cold reopen → queue persists → service/network restored → authorized sync resumes; unsent draft must not be submitted.
5. J05 — interruption/recovery: workbench/service or plugin disable/enable and recovery; user should understand the state and not lose or duplicate the capture.
6. J06 — repeated same capture >=3 submits yields one formal result; same-name/same-minute different capture IDs remain independent; no Settings jump, recording misfire, or duplicate external send.
7. J07 — late/cross-day/cross-timezone sample: captured/received/processed times and original-date relationship are understandable and not misleading.
8. J08 — provenance: original '九点' → correction '十点' → supplement/result '十一点'; original source remains visible, layered, and understandable from the product in at most two navigation steps.
9. J09 — current vs historical state: failure→success, disconnect→reconnect, and cold restart do not leave stale actionable-looking receipts.
10. J10 — permission/isolation/trust: invalid/revoked auth fails safely; command-like content is treated as content; no silent provider switch or unintended external send.
11. J11 — personally use actual Workbench UI to add/search/preview/converse and judge whether the mobile plugin preserves the existing desktop product rather than degrading it. API-only evidence is not Product Experience proof.
12. J12 — no-instructions first use: understand capture, local save, unsynced vs unorganized, and where results live without engineering documentation.

#### Required historical regressions

Within the full review, explicitly sample and adjudicate the three prior findings as regressions on the exact KK04 candidate:

- PX-KK03-01: initial capture/transcript must remain distinguishable from user correction and final organized/edited result.
- PX-KK03-02: repeated save/submit must not cause unrelated system navigation or other unintended side effects.
- PX-KK03-03: historical receipts must not masquerade as the current actionable state after recovery/restart.

Do not inherit the Engineering/LE regression verdicts. Re-test them independently.

#### Evidence discipline

The reviewer must personally operate the product and create a new review evidence set. Engineering/LE screenshots and receipts may be consulted only after Stage A and used only as reproduction guidance/background; they may not be copied or cited as the reviewer's own proof.

For every material Product Experience claim record reproducible action, expected behavior, actual behavior, candidate identity, time/sequence, reviewer-owned screenshot/log/artifact, and user-comprehension or task-completion impact.

Do not inspect product source/tests to form the Product Experience verdict. Do not repair the product. If a candidate/runtime identity mismatch is found, stop with `PRODUCT_EXPERIENCE_BLOCKED` rather than silently rebuilding or changing configuration.

#### Required verdicts and claim ceiling

The reviewer must issue the four independent reviewer verdicts required by the reviewer skill:

- Product Experience Verdict;
- Release Evidence Verdict;
- Prototype Concept Verdict;
- Prototype-to-Runtime Parity.

For DELIVERY-LIFECYCLE reconciliation, the reviewer must also state one of:

`PRODUCT_EXPERIENCE_PASS | PRODUCT_EXPERIENCE_FAIL | PRODUCT_EXPERIENCE_BLOCKED`

bound only to this exact App SHA + Workbench SHA + canonical HAP + behavior configuration.

The reviewer must not claim Human Owner Acceptance, merge/release authorization, real Mate60 validation, production validation, or Goal/Milestone closure.

### Referral invalidation

Any change to App SHA/tree, Workbench SHA/tree, canonical HAP bytes, runtime model/provider/protocol, or behavior-affecting configuration invalidates this Eligibility and Referral. The lifecycle must return to Engineering / Candidate Admission rather than reviewing a changed candidate under this referral.

Product Governance stops here. The next authorized role is the fresh Independent Product Experience Reviewer bound above.

STOPPED=YES