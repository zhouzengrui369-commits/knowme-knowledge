# GOAL-KK-02 — Engineering Handoff

```text
PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
ACTOR_ROLE=PRODUCT_GOVERNANCE
GOAL_ID=GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
MILESTONE_ID=MILESTONE-GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
ONE_GOAL_EQUALS_ONE_MILESTONE=true
VERSION_HORIZON=0.1_PROTOTYPE

PRODUCT_BASELINE_ID=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2
PRODUCT_BASELINE_REF=governance/PRODUCT_BASELINE.md@978ed0608bda8e278c348ad2987f6a25fa3c3c2f

CONTRACT_PATH=governance/milestones/GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE/CONTRACT.md
CONTRACT_COMMIT=73701b2f3069a0384568977909b601504c9fc591
CONTRACT_TREE=19c5d01d3189eccbfe3dcf54b4913d4c738392c8
CONTRACT_BLOB=789c96efc9be3cd2281999097f3cbab798989bf6
CONTRACT_STATUS=FROZEN

PREDECESSOR_GOAL=GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
PREDECESSOR_CLOSURE_REF=Issue #3 comment 5715161903
PREDECESSOR_OWNER_ACCEPTANCE_REF=Issue #3 comment 5715155474
ACCEPTED_PRODUCT_PREDECESSOR_SHA=f89fe6695ebdbfa69e6b569447247120fab0c360
ACCEPTED_PRODUCT_PREDECESSOR_TREE=3b1d2a678d945d886df9185459fca6a76f332bf6

ENGINEERING_DELIVERY_AUTHORITY_REPOSITORY=zhouzengrui369-commits/chatgpt-engineering-delivery
ENGINEERING_DELIVERY_AUTHORITY_COMMIT=8bcf9da58d6147fcd2345a4b465f17f7a27850fd
ENGINEERING_DELIVERY_AUTHORITY_TREE=593bacfee4910a55b9b6c7bd2f2ca56b8761d134
ENGINEERING_DELIVERY_SKILL_PATH=core/ENGINEERING_DELIVERY_SKILL.md

ENGINEERING_CONTEXT_ID=ED-KK-GOAL02-VOICE-SPEAKER-PROTOTYPE-R1-20260917-A7C4
PREVIOUS_ENGINEERING_CONTEXT_REUSE=FORBIDDEN
ENGINEERING_PREIMAGE_REPOSITORY=zhouzengrui369-commits/knowme-knowledge
ENGINEERING_PREIMAGE_BRANCH=governance/goal-kk-02-voice-speaker-prototype-r1
ENGINEERING_PREIMAGE_SHA=BOUND_BY_ACTIVATION_RECEIPT
ENGINEERING_PREIMAGE_TREE=BOUND_BY_ACTIVATION_RECEIPT

NEW_ENGINEERING_BRANCH=engineering/goal-kk-02-voice-speaker-prototype-r1
NEW_DRAFT_PR=REQUIRED

ALLOWED_PATHS=
- prototypes/knowme-knowledge-02-voice-speaker-verification/**
- reports/prototype/knowme-knowledge-02-voice-speaker-verification/**

FORBIDDEN_PATHS=
- AGENTS.md
- README.md
- PROJECT_STATUS.md
- .github/**
- governance/**
- prototypes/knowme-knowledge-01-agent-native-mate60/**
- reports/prototype/knowme-knowledge-01-agent-native-mate60/**
- formal_product_source/**
- any_other_project_or_repository/**

PRODUCT_GOVERNANCE_ROLE=FORBIDDEN
PRODUCT_EXPERIENCE_REVIEWER_ROLE=FORBIDDEN
HUMAN_OWNER_ACCEPTANCE_AUTHORITY=NONE
MERGE_RELEASE_AUTHORITY=NONE
```

## 1. Engineering mission

Deliver the smallest complete real-device prototype that proves the frozen Contract question:

```text
Owner on real Mate60
→ explicit microphone permission/start/stop
→ local-first Mandarin transcript
→ enrolled-speaker verification state
→ trust gate
→ candidate knowledge
→ correct / reject / explicit confirm
→ Agent context preserved
```

Do not broaden this into a general voice platform, full HarmonyOS product rewrite, production biometric system, Harness/LLM integration, RAG or background always-on microphone system.

## 2. Mandatory fresh-read order

Before any source/test mutation, fresh-read:

1. repository `AGENTS.md`;
2. `.github/skills/chatgpt-parent-pm/GOVERNANCE_LOCK.json`;
3. exact central Engineering Delivery Skill at the authority above;
4. Product Baseline v2;
5. exact frozen GOAL-KK-02 Contract;
6. this Engineering Handoff;
7. GOAL-KK-01 closure / Owner acceptance refs;
8. accepted predecessor candidate `f89fe669...` and its current Agent-first behavior;
9. live GOAL-KK-02 Issue / governance activation receipt / preimage SHA-tree;
10. live Engineering branch / PR state after creation.

Moving refs, chat memory, stale Draft issue text, old Goal receipts, local dirty state, and other projects are not authority.

## 3. Technical-choice boundary

Product Governance does not choose the speech engine. Engineering must make a measured choice.

At minimum evaluate feasible local paths such as:

- `sherpa-onnx` where compatible;
- current HarmonyOS-native speech / inference capabilities where accessible;
- another local engine only if it better satisfies the same frozen contract.

Do not select from paper specifications alone. Record exact runtime/model/library versions and real Mate60 observations. If the device/runtime cannot support the required local path, return an honest Engineering terminal (`ENGINEERING_NOT_READY` or `BLOCKED_EXTERNAL_AUTHORITY` as applicable) instead of silently substituting cloud audio.

## 4. Real-device and privacy gates

Real Mate60 evidence is mandatory for `ENGINEERING_READY`.

Owner-authorized raw audio / speaker enrollment material is **local ephemeral test data**, not repository evidence. Engineering and Local Executor must never commit:

- raw Owner audio;
- raw private transcript content;
- speaker embeddings / voiceprints;
- identity credentials / tokens / secrets.

Durable evidence must use sanitized aggregate counts, redacted/synthetic screenshots, model/runtime hashes or identities, and sanitized logs.

Negative speaker samples must be either a consenting non-owner or clearly disclosed synthetic/replay negatives. Do not collect another person's voice without consent.

## 5. Frozen prototype acceptance sample

The Contract owns the thresholds. Engineering must not weaken them:

```text
Owner positive attempts >= 5
Owner VERIFIED >= 4/5
Negative attempts >= 5
False VERIFIED among negatives = 0/5
Quiet scripted Mandarin STT attempts >= 5
Core meaning preserved before manual correction >= 4/5
At least one provisioned offline real-device run
```

These are bounded prototype checks only. Do not represent them as production biometric FAR/FRR, production ASR benchmark, or security certification.

## 6. Required Engineering evidence

Return one atomic package with at minimum:

- exact candidate SHA / tree / parent;
- Draft PR head = branch head = candidate;
- Candidate Manifest;
- Technical Receipt;
- allowed-path diff receipt;
- exact build/package identity;
- real Mate60 device/OS/build receipt;
- microphone permission/state receipt;
- local STT runtime/model identity;
- speaker-verification runtime identity;
- sanitized 5-positive / 5-negative sample matrix;
- transcript semantic-preservation results;
- capture-stop-to-visible-result latency observations;
- offline/no-silent-cloud-fallback receipt;
- sanitized network-boundary observation;
- privacy/no-raw-audio-or-voiceprint-in-Git receipt;
- final exact candidate Local Executor real-device operation receipt;
- Engineering technical tests and regression tests;
- runtime error receipt;
- screenshot/screen-recording index without private audio/transcripts;
- regression evidence that accepted GOAL-KK-01 Agent context and candidate-confirmation semantics remain intact.

## 7. Local Executor

The Local Executor is observation-only. It may install/materialize the authorized exact candidate on the Owner's Mate60, request the user-authorized microphone permission, execute the frozen sample matrix, run offline/degraded checks and return sanitized observations.

It must not:

- modify source/tests;
- self-repair;
- commit/push;
- weaken sample thresholds;
- upload raw Owner audio or voiceprints;
- declare Engineering Ready or Product Experience.

If device access, microphone permission or required local runtime assets cannot be obtained, record the blocker. Do not replace the real-device gate with desktop/simulator evidence.

## 8. Product behavior that must remain inherited

The new prototype may live under the new GOAL-KK-02 prototype path, but it must preserve the accepted predecessor's product meaning:

- 灵犀 / KnowME Agent-first identity;
- central Agent context;
- knowledge candidate correction/reject/explicit-confirm semantics;
- knowledge/calendar/todo context not regressed by the voice attachment;
- no dashboard-first or standalone recorder-console product form;
- honest capability/state disclosure.

Voice is an Agent capture capability, not a separate product.

## 9. Engineering terminal

Only declare:

```text
OUTPUT_STATE=ENGINEERING_READY
```

when all frozen Contract acceptance and Engineering evidence are complete on one exact candidate, including the real Mate60 observation.

If not complete, use the truthful Engineering terminal allowed by the locked state machine.

Never declare:

```text
CANDIDATE_ADMITTED
PRODUCT_REVIEW_ELIGIBLE
PRODUCT_EXPERIENCE_PASS
HUMAN_OWNER_ACCEPTED
MERGE_AUTHORIZED
RELEASE_AUTHORIZED
GOAL_MILESTONE_CLOSED
```

Hand the atomic package back to Product Governance and stop.
