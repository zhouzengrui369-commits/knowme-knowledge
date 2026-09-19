# GOAL-KK-02 Contract R3 — Engineering Delivery Execution Contract

```text
PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
ROLE=INDEPENDENT_ENGINEERING_DELIVERY
GOAL_ID=GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
MILESTONE_ID=MILESTONE-GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
ONE_GOAL_EQUALS_ONE_MILESTONE=true
CONTRACT_REVISION=R3
TASK_CLASS=PX_FINDINGS_SUCCESSOR_ENGINEERING_CORRECTION
```

## 1. Only target

The only product target is frozen Contract R3. The prior PX report is finding/retest authority, not the whole scope. Engineering must close the accepted findings and any other implementation defect found within the same frozen contract.

Accepted PX findings:

```text
PX-KK02-01
PX-KK02-02
PX-KK02-03
PX-KK02-04
PX-KK02-05
```

Engineering difficulty is not authority to weaken acceptance, trust gating, persistence, Agent-first semantics or claim ceilings.

## 2. Fresh authority read

Before mutation read exact:

1. `AGENTS.md`;
2. `.github/skills/chatgpt-parent-pm/GOVERNANCE_LOCK.json`;
3. locked Engineering Delivery Skill;
4. Product Baseline v2;
5. `CR-KK-02-PX01-R3.md`;
6. frozen `CONTRACT-R3.md`;
7. this execution contract;
8. exact Engineering Handoff R3;
9. PX report @ `56d005c1c76df26cdaf36675de2ba7d60d0006d4`;
10. exact authorized preimage / live branch / Draft PR.

Moving refs, chat memory, dirty local state and prior PASS are not authority.

## 3. Engineering mission

```text
authorized preimage
→ implement full Contract R3 successor
→ technical tests
→ build/install
→ actual product operation
→ active defect discovery
→ repair
→ regression
→ provisional final SHA
→ fresh Local Executor exact-SHA run
→ Local Executor screenshots/receipt
→ ED personal same-SHA run
→ ED independent screenshots/receipt
→ any defect reopens Engineering
→ repeat until no blocking in-scope defects
→ exact candidate package
→ ENGINEERING_READY
```

`CODE_COMPLETE`, `BUILD_SUCCESS`, `TEST_PASS`, `CI_PASS` or `PR_CREATED` are not Engineering Ready.

## 4. R3 mandatory product corrections

### PX-KK02-01

Implement bounded simulator persistence/recovery so explicitly confirmed/manual synthetic knowledge plus bounded Agent conversation context remain inspectable after Home return, microphone permission settings round-trip, force-stop and cold reopen. Rejected/discarded/unconfirmed candidates must stay absent.

### PX-KK02-02

Mic-denied / voice-unavailable states must expose a direct manual-text path from the current surface, with cancel/save and honest source labeling, without reauthorizing microphone.

### PX-KK02-03

Make the disclosed TEST_FIXTURE candidate journey repeatably reachable through visible UI when natural simulator speech cannot yield a usable candidate. No threshold hacking, direct internal-state mutation or out-of-band injection. The user must actually operate correction, reject and explicit confirm; reject increments zero, confirm exactly one.

### PX-KK02-04

Restore Agent-first grammar on the default surface: visible task/context, voice as attached capability, result inspection and return to same context. Technical diagnostics may exist but cannot dominate the default product surface. Do not add real LLM/RAG.

### PX-KK02-05

Normal/recording/result surfaces must disclose simulator/not-real-device limits, keep enrollment state separate from current capture verdict, and use wording matching tap-to-start / tap-to-stop behavior.

## 5. Active defect discovery

ED must actively inspect at minimum:

- cold start and restored start;
- permission grant/deny/revoke/restore;
- manual entry submit/cancel while mic denied;
- enrollment start/cancel/complete/reset;
- natural VERIFIED/UNCERTAIN/NOT_VERIFIED/NOT_AVAILABLE when reachable;
- TEST_FIXTURE path;
- candidate correct/reject/confirm;
- count/source consistency;
- persistence after Home/settings/force-stop/cold reopen;
- rejected/unconfirmed data not resurrected;
- Agent context before/after capture/fallback/restart;
- error recovery and repeated capture;
- state contradiction/stale result;
- layout/scroll/keyboard/button reachability;
- diagnostic dominance versus Agent-first default;
- simulator/real-device disclosure;
- no silent cloud audio;
- D1-D17 regressions.

Any newly observed defect that violates R3 must be fixed even if PX did not explicitly name it.

## 6. Defect loop

```text
IMPLEMENT
→ TEST
→ BUILD
→ DEPLOY
→ OPERATE
→ OBSERVE
→ DEFECT
→ ROOT CAUSE
→ FIX
→ REGRESSION
→ REDEPLOY
→ OPERATE AGAIN
```

Continue until `KNOWN_IN_SCOPE_BLOCKING_DEFECTS=NONE`.

## 7. Local Executor child agent — mandatory

ED must dispatch a fresh child context:

```text
ROLE=LOCAL_EXECUTOR
CONTEXT_ID=LE-KK-GOAL02-R3-FINAL-<NEW_UNIQUE_ID>
PREVIOUS_CONTEXT_REUSE=FORBIDDEN
```

Local Executor must:

- fresh-materialize the exact provisional final SHA;
- prove exact SHA/tree and clean worktree;
- provision only authorized local runtime/model assets;
- build exact candidate;
- install/deploy on the declared simulator;
- operate R3 journeys A-F plus accepted PX retest paths;
- capture privacy-safe screenshots;
- return sanitized observations and receipts.

Local Executor must not edit source/tests/config to repair behavior, commit/push, weaken acceptance, declare Engineering Ready, Candidate Admission or Product Experience.

## 8. Local Executor operation evidence

At minimum capture before/after evidence for:

1. Agent-first cold entry;
2. simulator/not-real-device disclosure;
3. microphone denied + manual text entry + save while still denied;
4. permission restore with prior saved knowledge/context retained;
5. two saved synthetic items before and after force-stop/cold reopen;
6. enrollment state separately visible from current capture verdict;
7. natural trust-blocking state(s);
8. disclosed TEST_FIXTURE entry;
9. fixture candidate before correction;
10. corrected candidate;
11. reject with zero increment;
12. new fixture candidate;
13. confirm with exactly +1;
14. result inspection and Agent-context return;
15. restart/return showing confirmed item preserved;
16. reset confirmation regression;
17. error recovery / repeated action.

Every critical path must record `ENTRY_STATE / ACTION / EXPECTED / ACTUAL / RESULT / SCREENSHOT_REFS`.

## 9. Local Executor defect handling

If Local Executor finds an in-scope defect:

```text
LOCAL_EXECUTOR_SELF_REPAIR=FORBIDDEN
RETURN_DEFECT_TO_ED=YES
```

ED fixes it. Candidate SHA changes. Previous final Local Executor evidence is superseded and the required final run must be repeated.

## 10. ED personal operation — mandatory

After Local Executor final PASS, ED personally operates the same exact SHA/build/environment. ED must not merely read LE screenshots or rerun automation.

ED must personally click/type/scroll/revoke/restore/force-stop/reopen/correct/reject/confirm and validate the core R3 flows. ED creates independent screenshots under `screenshots/ed-personal/**` and `ED_PERSONAL_OPERATION_RECEIPT.md`.

If ED observes any in-scope defect, Engineering Ready is forbidden; fix → new SHA → technical regression → fresh LE final run → fresh ED personal run.

## 11. PX findings regression matrix

Create `PX_FINDINGS_REGRESSION_MATRIX.md` with:

```text
finding
prior observed failure
successor implementation
technical regression test
Local Executor operation
ED personal operation
screenshot refs
final engineering status
```

No finding closes merely because code changed or a unit test passed.

## 12. Mandatory R3 evidence package

At minimum:

- `CANDIDATE_MANIFEST.md`;
- `TECHNICAL_RECEIPT.md`;
- `ALLOWED_PATH_DIFF_RECEIPT.md`;
- `SIMULATOR_ENVIRONMENT_RECEIPT.md`;
- `PX_FINDINGS_REGRESSION_MATRIX.md`;
- `PERSISTENCE_RECOVERY_RECEIPT.md`;
- `DENIED_MANUAL_FALLBACK_RECEIPT.md`;
- `CANDIDATE_FIXTURE_FLOW_RECEIPT.md`;
- `AGENT_FIRST_SURFACE_RECEIPT.md`;
- `DISCLOSURE_STATE_RECEIPT.md`;
- `LOCAL_EXECUTION_RECEIPT.md`;
- `ED_PERSONAL_OPERATION_RECEIPT.md`;
- `REGRESSION_RECEIPT.md`;
- `RUNTIME_ERROR_RECEIPT.md`;
- `NETWORK_BOUNDARY_RECEIPT.md`;
- `PRIVACY_EVIDENCE_RECEIPT.md`;
- `SCREENSHOT_INDEX.md`;
- `screenshots/local-executor/**`;
- `screenshots/ed-personal/**`.

Use synthetic non-sensitive content. Raw Owner audio, voiceprints/embeddings, private transcripts, credentials and secrets remain forbidden in Git.

## 13. Candidate identity

Final candidate must have exact:

```text
CANDIDATE_SHA=<40-char SHA>
CANDIDATE_TREE=<exact>
CANDIDATE_PARENT=<exact>
CANDIDATE_SHA=BRANCH_HEAD=PR_HEAD
WORKTREE_CLEAN=YES
```

Do not append evidence commits onto the candidate branch after freezing the candidate. Prefer an independent evidence transport ref/branch. Any candidate SHA/tree change invalidates previous final LE/ED evidence.

## 14. Claim ceiling

All product/evidence must retain:

```text
REAL_DEVICE_NOT_REVIEWED=YES
NOT_REAL_DEVICE_VALIDATED=YES
MATE60_COMPATIBILITY_CLAIMED=NO
REAL_DEVICE_ASR_CLAIMED=NO
REAL_DEVICE_SPEAKER_VERIFICATION_CLAIMED=NO
PRODUCTION_PERSISTENCE_CLAIMED=NO
```

R3 bounded local persistence is prototype semantics only, not production backup/sync.

## 15. Engineering Ready hard gate

Only declare `ENGINEERING_READY` when all are true:

```text
CONTRACT_R3_IMPLEMENTED=YES
PX_KK02_01_ENGINEERING_REGRESSION=PASS
PX_KK02_02_ENGINEERING_REGRESSION=PASS
PX_KK02_03_ENGINEERING_REGRESSION=PASS
PX_KK02_04_ENGINEERING_REGRESSION=PASS
PX_KK02_05_ENGINEERING_REGRESSION=PASS
TRUST_GATE_REGRESSION=PASS
D1_D17_REGRESSION=PASS
TECHNICAL_TESTS=PASS
FINAL_BUILD=PASS
LOCAL_EXECUTOR_FINAL_EXACT_SHA_OPERATION=PASS
LOCAL_EXECUTOR_SCREENSHOTS=COMPLETE
ED_PERSONAL_SAME_SHA_OPERATION=PASS
ED_PERSONAL_SCREENSHOTS=COMPLETE
KNOWN_IN_SCOPE_BLOCKING_DEFECTS=NONE
RUNTIME_BLOCKERS=NONE
PRIVACY_NETWORK_BOUNDARY=PASS
CLAIM_CEILING_HONORED=YES
BRANCH_HEAD_MATCH=YES
PR_HEAD_MATCH=YES
WORKTREE_CLEAN=YES
ENGINEERING_REQUIRED_EVIDENCE=COMPLETE
UNAPPROVED_DEVIATIONS=NONE
```

Without actual LE and ED product operation, Engineering Ready is forbidden.

## 16. GitHub delivery

Engineering must commit/push the successor, maintain a Draft OPEN UNMERGED engineering PR, publish exact evidence refs, and write the Engineering terminal to Issue #13. Chat-only completion is invalid.

## 17. Engineering terminal

Ready terminal must bind:

```text
PROTOCOL_VERSION
GOAL_ID
MILESTONE_ID
ACTOR_ROLE=INDEPENDENT_ENGINEERING_DELIVERY
ACTOR_CONTEXT_ID
INPUT_STATE=ENGINEERING_DELIVERY_ACTIVE
OUTPUT_STATE=ENGINEERING_READY
PRODUCT_CONTRACT_COMMIT
PRODUCT_CONTRACT_TREE
PRODUCT_CONTRACT_PATH
PX_FINDINGS_AUTHORITY
CANDIDATE_SHA
CANDIDATE_TREE
CANDIDATE_PARENT
CANDIDATE_BRANCH
CANDIDATE_PR
BRANCH_HEAD_MATCH=YES
PR_HEAD_MATCH=YES
WORKTREE_CLEAN=YES
CANDIDATE_MANIFEST_REF
TECHNICAL_RECEIPT_REF
PX_FINDINGS_REGRESSION_MATRIX_REF
LOCAL_EXECUTOR_REF
ED_PERSONAL_OPERATION_REF
SCREENSHOT_INDEX_REF
ENGINEERING_REQUIRED_EVIDENCE=COMPLETE
KNOWN_IN_SCOPE_BLOCKING_DEFECTS=NONE
UNAPPROVED_DEVIATIONS=NONE
RECOMMENDED_NEXT_GATE=PRODUCT_GOVERNANCE_CANDIDATE_ADMISSION
FORBIDDEN_CLAIMS_ACKNOWLEDGED=YES
STOPPED=YES
```

ED must not declare Candidate Admission, Review Eligibility, PX PASS/FAIL, Human Owner Acceptance, real-device validation, merge/release or Goal/Milestone closure.

## 18. Mandatory Parent PM handover

At completion ED must output a reusable `PARENT_PM_HANDOVER_PROMPT` containing:

### A. Completed
- exact accepted PX findings repaired;
- additional in-scope defects found/repaired;
- journeys implemented and regressions.

### B. Exact candidate
- SHA/tree/parent/branch/PR/head matches/worktree clean.

### C. Evidence refs
- Candidate Manifest;
- Technical Receipt;
- PX regression matrix;
- LE receipt/screenshots;
- ED personal receipt/screenshots;
- persistence/manual fallback/fixture/Agent-first/disclosure receipts;
- Issue terminal / Draft PR.

### D. Local Executor
- context ID, exact SHA/build, journeys, screenshot count, defects found, result.

### E. ED personal
- exact SHA/build, journeys, screenshot count, defects found/repaired, result.

### F. Blockers
- `ENGINEERING_BLOCKERS=NONE` if ready, otherwise exact first blocker;
- list later non-engineering gates separately.

### G. Not completed
- `CONTRACT_REQUIRED_NOT_COMPLETE`;
- `OUT_OF_SCOPE_FUTURE_WORK`.

### H. Known limitations / claim ceiling
- simulator-only, no real-device validation, no production persistence claim.

### I. Next gate
```text
NEXT_AUTHORIZED_GATE=PRODUCT_GOVERNANCE_CANDIDATE_ADMISSION
CANDIDATE_ADMISSION_CLAIMED=NO
PRODUCT_REVIEW_ELIGIBILITY_CLAIMED=NO
PRODUCT_EXPERIENCE_CLAIMED=NO
HUMAN_OWNER_ACCEPTANCE_CLAIMED=NO
MERGE_RELEASE_CLAIMED=NO
GOAL_MILESTONE_CLOSED=NO
STOPPED=YES
```

## Definition of Done

Tests prove code behavior; Local Executor and ED personal operation prove the delivered product behavior. Both are mandatory. A successor that has not actually been operated against Contract R3 is not deliverable and must not be handed to Product Governance for acceptance.