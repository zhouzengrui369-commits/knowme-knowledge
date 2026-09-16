# Candidate Manifest — GOAL-KK-01 (R2, final exact candidate)

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
artifact: CANDIDATE_MANIFEST
actor_role: ENGINEERING_DELIVERY
actor_context_id: ED-KK-GOAL01-EXACT-CANDIDATE-EVIDENCE-REBIND-20260916-1155-R2

evidence_channel_role: NON_CANDIDATE_EVIDENCE
evidence_branch: evidence/goal-kk-01-non-candidate-r2
evidence_commit_is_candidate: NO
move_pr9_head: NO

goal_id: GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
relationship: ONE_GOAL_EQUALS_ONE_MILESTONE

product_contract:
  commit: 563997a0eca61800c8c72d23a83888821a6e0841
  tree: 2b3c70f106b0b96f724af315955f2a859a1994c0
  blob: 02b75109f12cac49a3a996a57993d4d0b5ddb091
  path: governance/milestones/GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE/CONTRACT.md
engineering_delivery_contract_ref: >-
  knowme-knowledge Issue #3 comment 5691006427 + ENGINEERING_HANDOFF.md@266115d0270146949c68c9513a3cefaeb179d93f
governance_blocker_ref: >-
  knowme-knowledge Issue #3 comment 5691624112
  (FINAL_EXACT_CANDIDATE_OPERATION_EVIDENCE_IDENTITY_MISMATCH on R1)

repository: zhouzengrui369-commits/knowme-knowledge
branch: engineering/goal-kk-01-agent-native-mate60-prototype-r1
pr: 9 (Draft, base governance/goal-kk-01-agent-native-mate60-prototype-r1)

candidate_sha: 9f3071e22def4f99cbf3a4589349e628e9e15a97
candidate_tree: b165a075f4e6a3784c6fc7794fc8c5581dc539c0
candidate_parent: d8290e7a216b647ec2853f9f4522d97f77129281
operated_candidate_sha: 9f3071e22def4f99cbf3a4589349e628e9e15a97
operated_candidate_tree: b165a075f4e6a3784c6fc7794fc8c5581dc539c0
prototype_subtree_tree: e0c147e48aa6407dcf7b6da323ef01e00492659b

evidence_binding: >-
  ALL R2 operation evidence (Local Executor + ED personal, assertions and
  screenshots) was produced against the FINAL EXACT candidate
  9f3071e22def4f99cbf3a4589349e628e9e15a97 itself — the same commit that is
  the engineering branch head and PR #9 head. There is no parent-commit
  evidence transfer. The candidate commit contains code + tests only
  (reports/ removed); every evidence byte lives on this
  NON_CANDIDATE_EVIDENCE branch.

candidate_composition: >-
  code + tests only (prototypes/knowme-knowledge-01-agent-native-mate60/**,
  10 files vs preimage). The reports/ tree present in R1 candidate d8290e7
  was deleted (git rm, 30 files) so that no run evidence is stored inside
  candidate bytes.

branch_head_match: YES (verified 2026-09-16 before receipt issue)
pr_head_match: YES (gh pr view 9 headRefOid = 9f3071e22def4f99cbf3a4589349e628e9e15a97)
worktree_clean: YES

implemented_scope:
  - Runnable interactive mobile-oriented browser prototype (React 18 + Vite 5, portrait-first 360-520px shell)
  - Journey A first encounter: Agent identity, knowledge context summary, known/unknown chips, capture + ask-Agent + capability entries
  - Journey B ask-Agent: deterministic mock answers referencing the live knowledge context, next-action opening contextual work, conversation preserved
  - Journey C capture: text capture -> candidate knowledge -> confirm / correct / reject, confirmed items visibly grow the context, Agent explains each change
  - Journey D work from knowledge: item -> detail (source/state) -> contextual work surface -> return with full context preservation
  - Journey E capability attachment: Calendar + Todo open concrete mock work surfaces; Skills PLANNED; all states honestly disclosed
  - R2 Owner-directed product iteration (Owner personally reviewed R1 and directed, in conversation, 2026-09-16):
      - Continuous background sensing: persistent sensing strip on the Agent surface, simulated sensing stream ticking in the background, microphone key pauses/resumes continuous sensing, strip survives across sheet open/close; honestly labeled 「模拟感知 · 无真实 ASR」
      - Knowledge calendar view: knowledge sheet second tab 「按日历查看」 groups knowledge by day; items confirmed during the session land under today (2026-09-16)
      - Knowledge navigation view: knowledge sheet first tab 「知识导航」 groups entries as MOC / WIKI / NOTE (Map-of-Content lineage)
      - Visual calendar for schedule/todo: 5-day week strip, per-day schedule rows plus that day's linked todos, and a todo deep link (todo-calendar-link-t-3) that jumps the calendar sheet to the linked day
  - Interaction state machine exposed on [data-journey-state] for verification
  - 57-assertion Playwright browser suite at 360x780 (MATE60_CLASS_SIMULATION)
  - KnowMe Demo lineage: 1:1 design tokens + component treatments (see KNOWME_UI_TRACEABILITY_MATRIX.md)

owner_directed_changes_disclosure: >-
  The four R2 changes above were directed by the Human Owner in conversation
  after personally operating the R1 prototype. They are deterministic-mock
  UI realizations inside the frozen contract's allowed limitations
  (NO_REAL_VOICE, NO_REAL_CALENDAR_TODO_BACKEND, DETERMINISTIC_MOCK_RUNTIME);
  they do not change Journeys A-E, acceptance outcomes, the state machine's
  honesty requirements, or any NOT_IMPLEMENTED_BY_CONTRACT boundary.
  Engineering Delivery reports them factually as OWNER_DIRECTED; whether
  they require a formal Change Request is a Product Governance adjudication,
  not an Engineering claim.

not_implemented:
  - id: NOT_IMPLEMENTED_BY_CONTRACT
    items:
      - formal HarmonyOS application
      - real Codex Harness / MiniMax / any model provider
      - real Agent runtime, long-term memory, RAG, embeddings, vector DB, Wiki index
      - real ASR / speaker verification (sensing strip and voice key are SIMULATED/PROTOTYPE_ONLY)
      - real Office/PDF/media/website parsing (Files/Website channels PROTOTYPE_ONLY)
      - real Calendar/Todo backends (both NOT_CONNECTED, mock surfaces; week strip and links are local state)
      - Skills capability (PLANNED, future Goal)
      - real persistence, real Owner data, production deployment
  - id: UNRESOLVED_WITHIN_CONTRACT
    items: []

diff_inventory:
  - "prototypes/knowme-knowledge-01-agent-native-mate60/** (source, fixtures, styles, tests, manifests, lockfile)"
  - "no other path touched in the candidate (see ALLOWED_PATH_DIFF_RECEIPT.md)"
  - "reports/** lives ONLY on evidence branch (NON_CANDIDATE_EVIDENCE)"

known_defects: []
defects_found_and_fixed_in_loop:
  - "R1: D-01 overlay stacking collision (fixed in R1, re-verified)"
  - "R1: D-02 voice-key blocking alert() disclosure (fixed in R1, re-verified)"
  - "R2: none — 57/57 passed on first full loop; ED visual review of all 10 ED screenshots found no defect"
  - "R2 observation (not a defect): R2-LE-P06 and R2-LE-P09 are byte-identical (same周四 calendar surface state); R2-ED-P06/R2-ED-P09 likewise. Recorded, not hidden."

known_limitations:
  - BROWSER_PROTOTYPE_ONLY
  - DETERMINISTIC_MOCK_RUNTIME
  - NO_REAL_MODEL / NO_REAL_HARNESS / NO_REAL_PROVIDER
  - NO_REAL_PERSISTENCE_REQUIRED (reload resets state)
  - NO_REAL_VOICE / NO_REAL_SPEAKER_VERIFICATION / NO_REAL_IMPORT_PIPELINE / NO_REAL_RAG
  - NO_REAL_CALENDAR_TODO_BACKEND
  - NO_REAL_OWNER_DATA
  - Viewport evidence is MATE60_CLASS_SIMULATION (360x780), not on-device measurement

known_deviations: []
unapproved_deviations: []
approved_change_requests: []

evidence_ownership:
  engineering_required:
    status: COMPLETE
    refs:
      - exact_candidate_sha_tree_parent: this manifest + Issue #3 R2 terminal receipt
      - candidate_manifest: CANDIDATE_MANIFEST.md
      - technical_receipt: TECHNICAL_RECEIPT.md
      - allowed_path_diff_receipt: ALLOWED_PATH_DIFF_RECEIPT.md
      - runtime_runbook: RUNTIME_RUNBOOK.md
      - browser_technical_assertions: BROWSER_ASSERTION_RECEIPT.md
      - console_and_page_error_receipt: BROWSER_ASSERTION_RECEIPT.md + ed-browser-assertions.json + le-assertions.json
      - knowme_ui_traceability_matrix: KNOWME_UI_TRACEABILITY_MATRIX.md
      - interaction_state_map: INTERACTION_STATE_MAP.md
      - screenshot_index_with_actual_viewport: SCREENSHOT_INDEX.md
      - mock_data_disclosure: MOCK_DATA_DISCLOSURE.md
      - local_execution: LOCAL_EXECUTION_REQUEST.md + LOCAL_EXECUTION_RECEIPT.md
      - ed_personal_operation: ED_PERSONAL_PRODUCT_OPERATION_RECEIPT.md
  admission_required:
    status: OPEN
  review_required:
    status: OPEN
  product_experience:
    status: NOT_RUN
  human_owner:
    status: NOT_RUN

open_non_engineering_gates:
  - CANDIDATE_ADMISSION
  - PRODUCT_REVIEW_ELIGIBILITY
  - PRODUCT_EXPERIENCE
  - HUMAN_OWNER_ACCEPTANCE

engineering_ready: YES
recommended_next_gate: PRODUCT_GOVERNANCE_CANDIDATE_ADMISSION

forbidden_claims_acknowledged: true
forbidden_claims:
  - CANDIDATE_ADMITTED
  - PRODUCT_REVIEW_ELIGIBLE
  - PRODUCT_EXPERIENCE_PASS
  - HUMAN_OWNER_ACCEPTED
  - MERGE_AUTHORIZED
  - RELEASE_AUTHORIZED
  - GOAL_MILESTONE_CLOSED

issued_at: "2026-09-16T12:30:00Z"
```
