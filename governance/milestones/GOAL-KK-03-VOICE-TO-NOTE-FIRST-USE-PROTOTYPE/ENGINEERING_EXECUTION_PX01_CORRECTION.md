# GOAL-KK-03 — PX01 Successor Engineering Correction Execution Addendum

```text
PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
ROLE=INDEPENDENT_ENGINEERING_DELIVERY
GOAL_ID=GOAL-KK-03-VOICE-TO-NOTE-FIRST-USE-PROTOTYPE
MILESTONE_ID=MILESTONE-GOAL-KK-03-VOICE-TO-NOTE-FIRST-USE-PROTOTYPE
ONE_GOAL_EQUALS_ONE_MILESTONE=true

TASK_CLASS=PX_FINDINGS_SUCCESSOR_CORRECTION
PRODUCT_CONTRACT=R1_FROZEN_UNCHANGED
ACCEPTED_FINDINGS=PX-KK03-01;PX-KK03-02;PX-KK03-03

PREVIOUS_ENGINEERING_CONTEXT_REUSE=FORBIDDEN
```

This addendum does not replace the frozen Product Contract or the existing Engineering Execution Contract. It narrows the successor correction priorities while preserving the full frozen contract as the sole product target.

## 1. Sole target and completeness

Engineering must not treat the three findings as the entire product contract.

The frozen GOAL-KK-03 R1 contract remains the only product target. Engineering must:

- close PX-KK03-01..03;
- preserve every already-working R1 journey;
- actively discover and repair any additional in-scope implementation defect encountered;
- refuse Engineering Ready until the successor is actually operated and proven on the final exact candidate.

```text
CODE_CHANGED != ENGINEERING_READY
TEST_PASS != ENGINEERING_READY
BUILD_PASS != ENGINEERING_READY
PX_FINDINGS_PATCHED != ENGINEERING_READY
```

## 2. PX-KK03-01 implementation outcome

The data model and UI must preserve provenance layers without fabricating history:

```text
CAPTURED_ORIGINAL_TRANSCRIPT
→ USER_CORRECTED_TRANSCRIPT
→ ORGANIZED_EDITABLE_NOTE
```

At minimum:

- initial capture remains immutable evidence for this bounded prototype;
- correction produces a separate corrected value;
- note organization consumes the corrected value;
- editing the note does not overwrite either transcript layer;
- saved note exposes source + captured original + corrected transcript when a correction occurred;
- legacy entries without the extra layer display an honest “not recorded in this prototype version” state rather than fabricated content;
- no unlimited edit-version history is required.

## 3. PX-KK03-02 implementation outcome

The save action must be terminal/idempotent with respect to rapid repeated input.

At minimum:

- first legal save commits exactly +1;
- subsequent same-draft save taps are swallowed as no-op/product feedback;
- no click-through to controls that appear underneath after the save surface disappears;
- no Settings/AppInfo launch unless the user explicitly activates a permission/settings control;
- no automatic recording start after save;
- single tap and rapid double tap both end in a stable product state;
- current permission state remains truthful.

Engineering must inspect gesture/event propagation and page-transition timing rather than only asserting note-count dedup.

## 4. PX-KK03-03 implementation outcome

Agent history must not masquerade as current actionable state.

At minimum:

- current-state/action surface is distinct from historical receipts/messages;
- stale permission-denied guidance becomes historical after permission is granted;
- stale “draft created; save/cancel” guidance is not presented as current after the draft is gone;
- cold restore explicitly explains saved state and that unsaved draft/candidate was not restored when applicable;
- preserved history can still be inspected;
- test/diagnostic receipts remain secondary/collapsed;
- cleaning current context must not delete saved knowledge.

Engineering may use message metadata/state generation/ephemeral action guidance, but product semantics above are the authority.

## 5. Required regression protections

At minimum preserve:

- clean first-use comprehension;
- voice identity setup;
- recording feedback;
- permission honesty;
- transcript candidate control;
- TEST_FIXTURE disclosure;
- note title/body editing;
- save +1;
- cancel/reject +0;
- note provenance;
- Home return behavior;
- saved-note cold-restart recovery;
- unsaved candidate/draft not ingested;
- Agent-first product grammar;
- no silent cloud audio;
- simulator/not-real-device claim ceiling.

## 6. Active defect discovery

ED must operate at least:

- provenance correction chain;
- save single-tap and double-tap in denied/granted permission states;
- state/history transitions around deny→grant;
- draft Home return;
- draft force-stop/cold reopen;
- note save/cancel/reopen;
- repeated action / stale UI / click-through / keyboard obstruction;
- historical/current message separation;
- predecessor trust/permission regressions.

Any additional defect violating R1 must be fixed before final candidate freeze.

## 7. Mandatory Local Executor child agent

Before Engineering Ready, ED must dispatch a fresh observation-only child context:

```text
ROLE=LOCAL_EXECUTOR
CONTEXT_ID=LE-KK-GOAL03-PX01-FINAL-<NEW_REAL_UNIQUE_ID>
PREVIOUS_CONTEXT_REUSE=FORBIDDEN
MODE=OBSERVATION_ONLY
```

Local Executor must fresh-materialize the provisional final exact SHA, build/deploy it locally to the declared OpenHarmony simulator, operate the product personally, and capture privacy-safe screenshots.

Local Executor may not:

- edit source/tests/config;
- self-repair;
- change thresholds/internal state out-of-band;
- commit/push;
- declare lifecycle states.

Any Local Executor defect returns to ED.

## 8. Mandatory Local Executor focused journeys

### LE-PX01-01 provenance three-layer chain

Use synthetic content:

```text
captured original = “会议原定九点”
user correction = “会议改到十点”
note body edit = “会议改到十一点”
```

Operate:

- generate/capture initial transcript;
- correct and save correction;
- organize into note;
- edit note;
- save;
- reopen;
- cold restart;
- reopen again.

Prove product UI distinguishes original 9 / corrected 10 / note 11 layers and source; original is visible within two interactions.

### LE-PX01-02 save click-through

In mic denied state:

- create/edit draft;
- expand provenance;
- single save → exactly +1, no Settings;
- new draft;
- rapid double-click/two-tap save → exactly +1, no Settings;
- verify no automatic recording;
- verify explicit permission action still opens Settings when intentionally tapped.

Repeat double-save sample with mic granted. Cold reopen proves no duplicate.

### LE-PX01-03 current-vs-history

- deny mic and capture current denial guidance;
- grant mic and return;
- verify current state is granted and old denial is visibly historical/non-actionable;
- create draft → Home → return, verify draft remains actionable;
- create another draft → force-stop → cold reopen;
- verify +0 knowledge, no draft surface, explicit explanation that unsaved work was not restored;
- verify stale save/cancel instruction is not current;
- reopen saved note and provenance;
- verify test/diagnostic history remains secondary.

### LE-PX01-04 preserved core regression

Sample:

- clean first view;
- recording state/timer;
- voice identity state;
- transcript candidate reject +0;
- note cancel +0;
- note save +1;
- saved recovery;
- unsaved not ingested.

Every critical step must record:

```text
ENTRY_STATE
ACTION
EXPECTED
ACTUAL
EXIT_STATE
RESULT
SCREENSHOT_REFS
```

## 9. Candidate mutation invalidates final operation evidence

If ED changes candidate SHA/tree after a final Local Executor run:

```text
OLD_LE_FINAL_EVIDENCE=INVALID
```

ED must rerun tests/build as needed and dispatch a fresh complete Local Executor final run.

## 10. ED personal final operation — mandatory

After Local Executor final PASS, ED personally operates the same exact SHA and same build.

ED must independently repeat:

- 9→10→11 provenance chain;
- single save and double save with no system jump;
- explicit permission action still works;
- deny→grant current/history separation;
- Home-return draft;
- force-stop draft loss explanation;
- saved-note reopen/provenance;
- key save/cancel/recovery regressions.

ED must create a separate screenshot set; reusing LE screenshots is forbidden.

Any ED-observed in-scope defect reopens Engineering and forces a new SHA + fresh LE + fresh ED final run.

## 11. Evidence package

At minimum add/update:

- CANDIDATE_MANIFEST.md
- TECHNICAL_RECEIPT.md
- ALLOWED_PATH_DIFF_RECEIPT.md
- PX01_FINDINGS_REGRESSION_MATRIX.md
- PX_KK03_01_PROVENANCE_LAYERS_RECEIPT.md
- PX_KK03_02_SAVE_IDEMPOTENCE_RECEIPT.md
- PX_KK03_03_CURRENT_HISTORY_RECEIPT.md
- LOCAL_EXECUTION_RECEIPT.md
- ED_PERSONAL_OPERATION_RECEIPT.md
- REGRESSION_RECEIPT.md
- RUNTIME_ERROR_RECEIPT.md
- PRIVACY_NETWORK_BOUNDARY_RECEIPT.md
- SCREENSHOT_INDEX.md
- screenshots/local-executor/**
- screenshots/ed-personal/**

Use an independent evidence transport ref so evidence commits do not move the candidate PR Head.

## 12. Engineering Ready hard gate

Only return ENGINEERING_READY when all are true:

```text
PX_KK03_01_ENGINEERING_REGRESSION=PASS
PX_KK03_02_ENGINEERING_REGRESSION=PASS
PX_KK03_03_ENGINEERING_REGRESSION=PASS

CAPTURED_ORIGINAL_PRESERVED=YES
CORRECTED_TRANSCRIPT_SEPARATE=YES
NOTE_BODY_SEPARATE=YES
PROVENANCE_REOPEN_AFTER_COLD_RESTART=PASS

SINGLE_SAVE_PLUS_ONE=PASS
DOUBLE_SAVE_PLUS_ONE=PASS
DOUBLE_SAVE_SYSTEM_JUMP=NONE
DOUBLE_SAVE_AUTO_RECORDING=NONE
EXPLICIT_PERMISSION_ACTION_STILL_WORKS=YES

DENY_TO_GRANT_CURRENT_STATE=PASS
OLD_DENIAL_IS_HISTORICAL_NOT_ACTIONABLE=YES
HOME_DRAFT_CONTINUES=PASS
COLD_RESTART_UNSAVED_DRAFT_NOT_INGESTED=PASS
COLD_RESTART_EXPLAINS_UNSAVED_NOT_RESTORED=YES
STALE_DRAFT_SAVE_CANCEL_GUIDANCE_CURRENT=NO

PRESERVED_CORE_REGRESSION=PASS
TECHNICAL_TESTS=PASS
FINAL_BUILD=PASS

LOCAL_EXECUTOR_FINAL_EXACT_SHA_OPERATION=PASS
LOCAL_EXECUTOR_SCREENSHOTS=COMPLETE
ED_PERSONAL_SAME_SHA_OPERATION=PASS
ED_PERSONAL_SCREENSHOTS=COMPLETE

KNOWN_IN_SCOPE_BLOCKING_DEFECTS=NONE
RUNTIME_BLOCKERS=NONE
CLAIM_CEILING_HONORED=YES

CANDIDATE_SHA=BRANCH_HEAD=PR_HEAD
WORKTREE_CLEAN=YES
ENGINEERING_REQUIRED_EVIDENCE=COMPLETE
UNAPPROVED_DEVIATIONS=NONE
```

Without real product operation evidence, Engineering Ready is forbidden.

## 13. GitHub delivery and handback

On completion ED must:

- commit and push the successor;
- keep an OPEN DRAFT UNMERGED Engineering PR;
- publish exact Engineering terminal to Issue #30;
- output PARENT_PM_HANDOVER_PROMPT.

The handover must clearly state:

A. completed work and root causes;
B. exact candidate SHA/tree/parent/branch/PR;
C. evidence refs;
D. Local Executor context/actions/screenshots/defects/result;
E. ED personal actions/screenshots/defects/result;
F. Engineering blockers or NONE;
G. contract-required not complete;
H. out-of-scope future work;
I. known limitations/claim ceiling;
J. next authorized gate = Product Governance Candidate Admission.

ED may not claim Candidate Admission, Review Eligibility, Product Experience PASS/FAIL, Human Owner Acceptance, merge/release or Goal closure.
