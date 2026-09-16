# Candidate Manifest — GOAL-KK-01

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
actor_role: ENGINEERING_DELIVERY
actor_context_id: ED-KK-GOAL01-AGENT-NATIVE-MATE60-PROTOTYPE-R1-20260916-1013-4A7D

goal_id: GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
relationship: ONE_GOAL_EQUALS_ONE_MILESTONE

product_contract:
  commit: 563997a0eca61800c8c72d23a83888821a6e0841
  tree: 2b3c70f106b0b96f724af315955f2a859a1994c0
  blob: 02b75109f12cac49a3a996a57993d4d0b5ddb091
  path: governance/milestones/GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE/CONTRACT.md
engineering_delivery_contract_ref: >-
  knowme-knowledge Issue #3 comment 5691006427 +
  governance/milestones/GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE/ENGINEERING_HANDOFF.md@266115d0270146949c68c9513a3cefaeb179d93f

repository: zhouzengrui369-commits/knowme-knowledge
branch: engineering/goal-kk-01-agent-native-mate60-prototype-r1
pr: BOUND_AT_PR_CREATION

# Self-referential hash cycle note (same rule as the frozen contract):
# this file is committed INSIDE the candidate, so the final candidate SHA is
# bound externally by the Issue #3 Engineering terminal receipt and PR head.
candidate_sha: BOUND_EXTERNALLY_BY_ISSUE_3_TERMINAL_RECEIPT
candidate_tree: BOUND_EXTERNALLY_BY_ISSUE_3_TERMINAL_RECEIPT
candidate_parent: fb432162e7dd099a32fec7b52ff00659982942f3
operated_candidate_sha: fb432162e7dd099a32fec7b52ff00659982942f3
operated_candidate_tree: aed8058e5139948fbf8c4a3152a8fbf122ce8b5a
prototype_subtree_tree: 9e60f229be9f8737b4db66cb1f7ea83d1b804201
evidence_binding: >-
  All Local Executor and ED personal operation evidence was produced against
  operated_candidate_sha fb432162e7dd099a32fec7b52ff00659982942f3. The final
  candidate commit adds only reports/prototype/** files; its
  prototypes/knowme-knowledge-01-agent-native-mate60 subtree tree is byte
  identical (9e60f229be9f8737b4db66cb1f7ea83d1b804201) to the operated
  candidate's, so the operation evidence applies to the final candidate
  without transfer of trust across code changes.

branch_head_match: BOUND_AT_FINAL_PUSH
pr_head_match: BOUND_AT_FINAL_PUSH
worktree_clean: BOUND_AT_FINAL_PUSH

implemented_scope:
  - Runnable interactive mobile-oriented browser prototype (React 18 + Vite 5, portrait-first 360-520px shell)
  - Journey A first encounter: Agent identity, knowledge context summary, known/unknown chips, capture + ask-Agent + capability entries
  - Journey B ask-Agent: deterministic mock answers referencing the live knowledge context, next-action opening contextual work, conversation preserved
  - Journey C capture: text capture -> candidate knowledge -> confirm / correct / reject, confirmed items visibly grow the context, Agent explains each change
  - Journey D work from knowledge: item -> detail (source/state) -> contextual work surface -> return with full context preservation
  - Journey E capability attachment: Calendar + Todo open concrete mock work surfaces; Skills PLANNED; all states honestly disclosed
  - Interaction state machine (9 states) exposed for verification
  - 41-assertion Playwright browser suite at 360x780 (MATE60_CLASS_SIMULATION)
  - KnowMe Demo lineage: 1:1 design tokens + component treatments (see KNOWME_UI_TRACEABILITY_MATRIX.md)

not_implemented:
  - id: NOT_IMPLEMENTED_BY_CONTRACT
    items:
      - formal HarmonyOS application
      - real Codex Harness / MiniMax / any model provider
      - real Agent runtime, long-term memory, RAG, embeddings, vector DB, Wiki index
      - real ASR / speaker verification (voice key and voice channel are PROTOTYPE_ONLY)
      - real Office/PDF/media/website parsing (Files/Website channels PROTOTYPE_ONLY)
      - real Calendar/Todo backends (both NOT_CONNECTED, mock surfaces)
      - Skills capability (PLANNED, future Goal)
      - real persistence, real Owner data, production deployment
  - id: UNRESOLVED_WITHIN_CONTRACT
    items: []

diff_inventory:
  - "prototypes/knowme-knowledge-01-agent-native-mate60/** (new: source, fixtures, styles, tests, manifests, lockfile)"
  - "reports/prototype/knowme-knowledge-01-agent-native-mate60/** (new: this evidence package)"
  - "no other path touched (see ALLOWED_PATH_DIFF_RECEIPT.md)"

known_defects: []
defects_found_and_fixed_in_loop:
  - D-01 overlay stacking collision (knowledge sheet id vs capability render condition) — fixed, re-verified
  - D-02 voice-key blocking alert() disclosure — replaced with in-conversation honest disclosure, re-verified

known_limitations:
  - BROWSER_PROTOTYPE_ONLY
  - DETERMINISTIC_MOCK_RUNTIME
  - NO_REAL_MODEL / NO_REAL_HARNESS / NO_REAL_PROVIDER
  - NO_REAL_PERSISTENCE_REQUIRED (reload resets state)
  - NO_REAL_VOICE / NO_REAL_SPEAKER_VERIFICATION / NO_REAL_IMPORT_PIPELINE / NO_REAL_RAG
  - NO_REAL_CALENDAR_TODO_BACKEND
  - NO_REAL_OWNER_DATA
  - Viewport evidence is MATE60_CLASS_SIMULATION (360x780), not on-device measurement

known_deviations:
  - Local Executor runtime port 5174 instead of 5173 (5173 occupied by ED's earlier dev server); actual URL recorded in all evidence
unapproved_deviations: []
approved_change_requests: []

evidence_ownership:
  engineering_required:
    status: COMPLETE
    refs:
      - exact_candidate_sha_tree_parent: this manifest + Issue #3 terminal receipt
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
  admission_required:
    status: OPEN
    refs: []
  review_required:
    status: OPEN
    refs: []
  product_experience:
    status: NOT_RUN
  human_owner:
    status: NOT_RUN

technical_receipt_ref: TECHNICAL_RECEIPT.md
local_execution_receipts:
  - LOCAL_EXECUTION_REQUEST.md
  - LOCAL_EXECUTION_RECEIPT.md
  - ED_PERSONAL_PRODUCT_OPERATION_RECEIPT.md
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

issued_at: "2026-09-16T11:14:00Z"
```
