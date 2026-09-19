# KnowME Knowledge — Simulator-First Through 1.0 Validation Policy

```text
POLICY_ID=POLICY-KK-SIMULATOR-FIRST-UNTIL-1.0
PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
ACTOR_ROLE=PRODUCT_GOVERNANCE
OWNER_DIRECTION_DATE=2026-09-19
STATUS=FROZEN
APPLIES_TO_VERSION_HORIZON=NOW_THROUGH_1.0_MVP
```

## Owner-frozen rule

Human Owner direction:

> 先用模拟器做产品测试；1.0 版本开发完成并通过产品体验审核后，再进入真机安装。

This is a development and validation ordering rule. It does not change the product target platform: KnowME Knowledge remains a Mate60 / HarmonyOS product.

## Required lifecycle ordering through 1.0

For bounded Goals that contribute to the 0.1 → 1.0 product horizon:

```text
Frozen Goal/Milestone Contract
→ Engineering implementation
→ simulator / controlled-development-environment technical operation
→ Local Executor simulator operation when engineering_required
→ ED personal simulator operation
→ ENGINEERING_READY
→ Candidate Admission
→ Product Review Eligibility
→ Independent Product Experience Review in the frozen simulator/review environment
→ Human Owner Acceptance
→ Goal/Milestone closure
→ next bounded Goal
```

Real Mate60 installation is not a default Engineering Ready prerequisite for these pre-device-validation Goals.

## 1.0 device gate

After the exact 1.0 MVP candidate has PRODUCT_EXPERIENCE_PASS and HUMAN_OWNER_ACCEPTED, Product Governance must create a separate bounded Goal/Milestone for 1.0 real-device installation, Mate60 compatibility validation, and device-specific capability/performance validation.

That later Goal owns real-device evidence such as installation, microphone permission, on-device ASR availability, speaker-verification behavior, offline behavior, performance, thermal/battery observations where required, and device-specific remediation.

One Goal = One Milestone remains mandatory.

## Claim ceiling before real-device validation

Before the post-1.0 real-device Goal passes, no pre-device Goal may claim:

```text
MATE60_REAL_DEVICE_VALIDATED
REAL_DEVICE_COMPATIBILITY_PASS
REAL_DEVICE_ASR_AVAILABLE
REAL_DEVICE_SPEAKER_VERIFICATION_PASS
REAL_DEVICE_OFFLINE_PASS
PRODUCTION_DEVICE_READY
```

Simulator evidence may establish interaction completeness, state-machine correctness, trust-gate behavior, candidate-confirmation semantics, Agent-context preservation, simulator/runtime technical behavior, and UI/UX quality in the declared review environment. It does not prove actual Mate60 runtime capability.

## Product Experience rule

Formal Product Experience Review is allowed before real-device installation when the frozen Goal explicitly defines the simulator or controlled development environment as the Product Experience review environment.

The reviewer must disclose:

```text
REVIEW_ENVIRONMENT=SIMULATOR_OR_CONTROLLED_DEV_ENV
REAL_DEVICE_NOT_REVIEWED=YES
```

A PASS is valid only for that Goal's frozen scope and cannot be re-labeled as a real-device PASS.

## Contract discipline

This policy does not silently rewrite an already frozen Goal. Any active Goal whose frozen contract currently requires real-device evidence before Engineering Ready must receive an approved Change Request, successor frozen Contract, and new exact Engineering Handoff before Engineering may use the simulator-first ordering.

## Technical strategy

Engineering should continue to implement device-targeted code where feasible, including compatibility declarations and platform APIs, but device-only uncertainty remains explicitly deferred. Engineering must preserve honest states such as NOT_AVAILABLE, NOT_VERIFIED, UNCERTAIN, SIMULATOR_ONLY, and NOT_REAL_DEVICE_VALIDATED where applicable.

## Security / privacy

Deferring real-device installation does not relax privacy boundaries. Raw Owner audio, voiceprints, speaker embeddings, secrets and private transcripts remain forbidden from GitHub unless an exact future contract explicitly changes the evidence boundary through Product Governance.

## Authority boundary

This policy changes validation ordering only. It does not authorize merge, release, production deployment, bypassing Candidate Admission, bypassing formal Product Experience, bypassing Human Owner Acceptance, or claiming real-device capability from simulator evidence.