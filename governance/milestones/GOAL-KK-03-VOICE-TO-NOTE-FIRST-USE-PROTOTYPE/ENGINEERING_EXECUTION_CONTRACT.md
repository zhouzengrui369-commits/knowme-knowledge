# GOAL-KK-03 — Engineering Delivery Execution Contract

```text
PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
ROLE=INDEPENDENT_ENGINEERING_DELIVERY
GOAL_ID=GOAL-KK-03-VOICE-TO-NOTE-FIRST-USE-PROTOTYPE
MILESTONE_ID=MILESTONE-GOAL-KK-03-VOICE-TO-NOTE-FIRST-USE-PROTOTYPE
ONE_GOAL_EQUALS_ONE_MILESTONE=true
TASK_CLASS=FIRST_USE_VOICE_TO_NOTE_PRODUCT_FLOW
PREVIOUS_ENGINEERING_CONTEXT_REUSE=FORBIDDEN
```

## 1. Sole target

The frozen Product Contract is the only product target.

Engineering must implement the complete bounded successor required by the contract, not merely add UI labels or make tests pass.

If ED discovers another implementation defect that violates the same frozen contract, ED must fix it before delivery even if Product Governance or a prior reviewer did not explicitly name it.

## 2. Product-value objective

The delivered prototype must read as a product for a first-time user:

```text
understand purpose
→ see voice identity setup / recording entry
→ start recording
→ stop/cancel with clear feedback
→ get honest transcript candidate
→ correct/reject/continue
→ "整理成笔记"
→ edit canonical note draft
→ explicit save/cancel
→ reopen note
→ inspect original transcript/source
```

Do not solve this Goal by creating a larger engineering/test console.

## 3. First-use hard rule

On a clean install:

- product purpose is immediately visible;
- primary voice actions are visible without scrolling;
- no wall of TEST_FIXTURE history/logs dominates the first screen;
- simulator/test tools are secondary/collapsed;
- technical diagnostics are secondary/collapsed;
- empty knowledge state is honest.

## 4. Simulator reality

Real Mate60/real ASR is not required.

If natural simulator STT is unavailable, use a clearly disclosed simulator test-transcript path to prove transcript→note behavior, but keep it out of the primary first-use path.

A fixture/test transcript can prove product flow only. It cannot claim real ASR or speaker identity.

## 5. Active defect loop

```text
IMPLEMENT
→ TEST
→ BUILD
→ DEPLOY
→ OPERATE PRODUCT
→ OBSERVE
→ DEFECT
→ ROOT CAUSE
→ FIX
→ REGRESSION
→ REDEPLOY
→ OPERATE AGAIN
```

Continue until:

```text
KNOWN_IN_SCOPE_BLOCKING_DEFECTS=NONE
```

## 6. Local Executor child agent — mandatory

Before Engineering Ready, ED must dispatch a fresh child context:

```text
ROLE=LOCAL_EXECUTOR
CONTEXT_ID=LE-KK-GOAL03-FINAL-<NEW_REAL_UNIQUE_ID>
PREVIOUS_CONTEXT_REUSE=FORBIDDEN
MODE=OBSERVATION_ONLY
```

Local Executor must materialize the provisional final exact SHA, prove the worktree/build identity, deploy it to the declared simulator, operate the product through the required journeys, and capture privacy-safe screenshots.

Local Executor may not edit source/tests/config, repair the product, commit/push, weaken acceptance, or declare lifecycle states.

Any defect found by Local Executor returns to ED. If ED changes candidate SHA/tree, all prior final Local Executor evidence is invalid and a fresh final run is required.

## 7. Mandatory Local Executor journeys

At minimum:

1. clean install / first encounter with no external briefing;
2. first view showing purpose + voice identity setup + primary recording action;
3. enter voice identity enrollment and return;
4. start recording;
5. observe recording-in-progress state;
6. stop/cancel and observe honest result;
7. reach transcript candidate using real simulator path or disclosed secondary simulator test-transcript path;
8. correct transcript candidate;
9. reject one candidate and verify +0;
10. continue another transcript to "整理成笔记";
11. inspect editable note draft title + body;
12. edit note draft;
13. inspect original transcript/source provenance;
14. cancel one note draft and verify +0;
15. save another note draft and verify exactly +1;
16. reopen saved note and inspect title/body/source/transcript;
17. force-stop/cold reopen and verify saved note persists;
18. verify unconfirmed transcript/note draft did not silently save;
19. return to Agent context and verify Agent explains the knowledge change;
20. regression sample of GOAL-KK-02 permission/trust/candidate-control behavior.

Each critical journey must record ENTRY_STATE / ACTION / EXPECTED / ACTUAL / EXIT_STATE / RESULT / SCREENSHOT_REFS.

## 8. ED personal operation — mandatory

After Local Executor final PASS, ED must personally operate the same exact candidate SHA and same build.

ED must independently click/type/scroll/start/stop/correct/reject/organize/edit/save/cancel/reopen/restart.

ED must capture a separate screenshot set. Reusing Local Executor screenshots is forbidden.

Any ED-observed in-scope defect reopens Engineering and forces:
fix → new SHA → tests → build → fresh LE final run → fresh ED personal run.

## 9. Required Engineering evidence

At minimum:

- CANDIDATE_MANIFEST.md
- TECHNICAL_RECEIPT.md
- ALLOWED_PATH_DIFF_RECEIPT.md
- FIRST_VIEW_RECEIPT.md
- VOICE_IDENTITY_ENTRY_RECEIPT.md
- RECORDING_STATE_RECEIPT.md
- TRANSCRIPT_CANDIDATE_RECEIPT.md
- TRANSCRIPT_TO_NOTE_RECEIPT.md
- NOTE_PROVENANCE_RECEIPT.md
- SAVE_CANCEL_DEDUP_RECEIPT.md
- RECOVERY_RECEIPT.md
- AGENT_FIRST_SURFACE_RECEIPT.md
- LOCAL_EXECUTION_RECEIPT.md
- ED_PERSONAL_OPERATION_RECEIPT.md
- REGRESSION_RECEIPT.md
- RUNTIME_ERROR_RECEIPT.md
- PRIVACY_NETWORK_BOUNDARY_RECEIPT.md
- SCREENSHOT_INDEX.md
- screenshots/local-executor/**
- screenshots/ed-personal/**

Use independent evidence transport so evidence commits do not move the candidate PR Head.

## 10. Engineering Ready hard gate

Only declare ENGINEERING_READY when all are true:

```text
CONTRACT_IMPLEMENTED=YES
FIRST_VIEW_PRODUCT_COMPREHENSION_ENGINEERING_CHECK=PASS
VOICE_IDENTITY_ENTRY=PASS
RECORDING_START_STOP_CANCEL=PASS
TRANSCRIPT_CONTROL=PASS
TRANSCRIPT_TO_NOTE=PASS
NOTE_EDIT=PASS
NOTE_PROVENANCE=PASS
SAVE_EXACTLY_PLUS_ONE=PASS
CANCEL_REJECT_PLUS_ZERO=PASS
RECOVERY=PASS
UNCONFIRMED_NOT_SAVED=PASS
AGENT_CONTEXT_RETURN=PASS
GOAL_KK_02_REGRESSION=PASS
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
CANDIDATE_SHA=BRANCH_HEAD=PR_HEAD
WORKTREE_CLEAN=YES
ENGINEERING_REQUIRED_EVIDENCE=COMPLETE
UNAPPROVED_DEVIATIONS=NONE
```

Tests/build/CI alone never establish Engineering Ready.

## 11. GitHub delivery

Engineering must:

- commit;
- push;
- create Draft OPEN UNMERGED Engineering PR;
- publish exact Engineering terminal to the GOAL-KK-03 Issue;
- keep candidate SHA = branch Head = PR Head;
- output a complete PARENT_PM_HANDOVER_PROMPT.

## 12. Mandatory Parent PM handover

The handover must state:

A. what was completed;
B. exact candidate SHA/tree/parent/branch/PR;
C. evidence refs;
D. Local Executor context, journeys, screenshots, defects/result;
E. ED personal journeys, screenshots, defects/result;
F. exact Engineering blockers or NONE;
G. contract-required not complete;
H. out-of-scope future work;
I. known limitations/claim ceiling;
J. next authorized gate = Product Governance Candidate Admission.

ED may not claim Candidate Admission, Product Review Eligibility, Product Experience PASS/FAIL, Human Owner Acceptance, merge/release, real-device validation, or Goal/Milestone closure.
