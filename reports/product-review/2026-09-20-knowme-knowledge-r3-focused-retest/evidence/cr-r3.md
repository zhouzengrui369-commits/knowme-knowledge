# CR-KK-02-PX01-R3 — Product Experience FAIL Correction

```text
PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
ACTOR_ROLE=PRODUCT_GOVERNANCE
CHANGE_REQUEST_ID=CR-KK-02-PX01-R3
GOAL_ID=GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
MILESTONE_ID=MILESTONE-GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
ONE_GOAL_EQUALS_ONE_MILESTONE=true
DECISION=APPROVED
TRIGGER=FORMAL_PRODUCT_EXPERIENCE_FAIL
PX_RECEIPT_REF=Issue #13 comment 5742173191
PX_REPORT_COMMIT=56d005c1c76df26cdaf36675de2ba7d60d0006d4
PX_REPORT_PATH=reports/product-review/2026-09-19-knowme-knowledge-goal02-owner-review/REVIEW.md
PREDECESSOR_CANDIDATE=b02bca6e5e84e98e5b4c99bc43d3599946089e83
PREDECESSOR_PRODUCT_EXPERIENCE=NOT_READY
PRODUCT_DIRECTION_CHANGE=NO
REAL_DEVICE_SCOPE_CHANGE=NO
REAL_LLM_RAG_SCOPE_CHANGE=NO
```

## Governance decision

Product Governance accepts the following formal PX findings as successor-correction requirements because they map to existing Product Baseline v2 / Contract R2 promises, but their exact closure criteria are now made explicit and binding in Contract R3:

- `PX-KK02-01` P1 — confirmed knowledge / Agent context disappears across permission recovery and cold process restart.
- `PX-KK02-02` P1 — microphone-denied state lacks direct manual-text continuation.
- `PX-KK02-03` P1 — the declared simulator environment does not provide a repeatable UI-reachable path into the disclosed TEST_FIXTURE candidate correction/reject/confirm journey.
- `PX-KK02-04` P1 — primary surface is recorder/speaker-diagnostic-first instead of Agent-first contextual work.
- `PX-KK02-05` P2 — simulator/real-device boundary, enrollment-vs-current-verdict distinction, and action wording remain insufficiently clear.

## Why a Change Request is required

The product target user, core customer value, simulator-first policy, privacy boundary and deferred real-device strategy are unchanged. However, this successor explicitly tightens acceptance outcomes and closure evidence after a formal PX FAIL, including persistence/recovery behavior and focused-retest criteria. Under repository governance, acceptance-outcome / closure-condition changes require a CR.

## R3 correction semantics

### PX-KK02-01

`已记下` / explicitly confirmed synthetic knowledge and the bounded Agent conversation context must remain inspectable after:

- normal Home/background return;
- microphone permission settings round-trip;
- application force-stop / cold reopen in the declared simulator environment.

This is bounded prototype persistence needed to make the visible save/confirm promise truthful. It is not production backup, cloud sync, multi-device persistence, or long-term database architecture.

Unconfirmed, rejected or discarded voice candidates must not become confirmed knowledge during recovery.

### PX-KK02-02

When microphone permission is denied or voice capability is unavailable, the same primary product surface must offer a clear manual-text continuation path without forcing microphone reauthorization. Manual input must be labeled by source and must not be represented as verified Owner voice.

### PX-KK02-03

The declared simulator review environment must expose a repeatable, user-visible, honest path to the candidate correction / reject / explicit-confirm flow. If acoustic/STT/verification conditions do not naturally produce a usable transcript, Engineering may provide a clearly disclosed simulator TEST_FIXTURE route, but it must:

- be reachable through visible product UI without changing thresholds/state out of band;
- never claim real ASR, real speaker identity or Mate60 validation;
- preserve trust-gate semantics;
- allow correction, reject and explicit confirm as separate observable operations;
- show reject causes no knowledge increment and confirm causes exactly one increment.

### PX-KK02-04

The primary surface must remain recognizably Agent-first within this bounded prototype:

- user starts from an Agent/task context rather than a diagnostic console;
- voice is presented as one capture capability attached to that context;
- after failure, manual fallback, candidate reject/confirm, and recovery, the user returns to the same context and can inspect the resulting item;
- implementation/runtime diagnostic detail may remain available but must not dominate the default product surface.

No real LLM, RAG, knowledge graph or new backend is required by this correction.

### PX-KK02-05

Normal states, not only error/fixture states, must clearly communicate:

- simulator / real-device-not-validated boundary;
- prototype speaker verification is not production identity assurance;
- enrolled-profile state is separate from the current capture verdict;
- button/action wording matches actual tap/start/stop behavior.

## Focused successor retest

The next independent Product Experience review should use `FOCUSED_RETEST` against these five accepted findings plus regression of:

- enrollment;
- NOT_ENROLLED / UNCERTAIN / NOT_VERIFIED trust blocking;
- permission recovery;
- explicit confirmation boundary;
- no silent cloud audio claim ceiling;
- Agent-context return.

## Preserved boundaries

Still out of scope:

- real Mate60 installation or compatibility proof;
- real-device ASR / speaker discrimination;
- real Codex Harness / MiniMax / RAG;
- production persistence/backup/sync;
- production biometric authentication;
- release / app-store distribution.

## Invalidation

Contract R3 supersedes Contract R2 for this Goal/Milestone. The R2 Engineering handoff, R2 ENGINEERING_READY, Candidate Admission, Review Eligibility and R2 Product Experience state are historical and do not transfer PASS to the successor.

Product Governance must freeze Contract R3 and issue a new exact Engineering Handoff before any source/test mutation.