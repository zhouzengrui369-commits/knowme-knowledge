# Candidate Manifest — GOAL-KK-01 (R3, final exact candidate)

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
artifact: CANDIDATE_MANIFEST
actor_role: ENGINEERING_DELIVERY
actor_context_id: ED-KK-GOAL01-R3-DEMO-AUTHORITY-20260916-1320-R3

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

ui_authority:
  source: Owner-provided KnowMe-NJX-Demo.html (supplied in conversation 2026-09-16, "这个才是knowme的原型")
  sha256: 3ef8605a6b74c6514ee7097d24100d5f06e258b2e6bbdb03e591a02a51fc7d9f
  evidence_copy: r3-ui-authority/KnowMe-NJX-Demo.html (byte-identical)
  prior_authority: zhouzengrui369-commits/knowme demo (baa61e6…), superseded by the Owner-provided file

repository: zhouzengrui369-commits/knowme-knowledge
branch: engineering/goal-kk-01-agent-native-mate60-prototype-r1
pr: 9 (Draft, base governance/goal-kk-01-agent-native-mate60-prototype-r1)

candidate_sha: e6e9c3d87a1c87fa0614aa1a4ec44e354117adde
candidate_tree: beeb0d6e136419036fb71fe5bd31aa8863f9227f
candidate_parent: 9f3071e22def4f99cbf3a4589349e628e9e15a97
operated_candidate_sha: e6e9c3d87a1c87fa0614aa1a4ec44e354117adde
operated_candidate_tree: beeb0d6e136419036fb71fe5bd31aa8863f9227f
prototype_subtree_tree: 0641d2e4ee000aac79f9ef2f4f36d1d8c61a53f9

evidence_binding: >-
  ALL R3 operation evidence (Local Executor + ED personal, assertions and
  screenshots) was produced against the FINAL EXACT candidate e6e9c3d…
  itself — the same commit that is the engineering branch head and PR #9
  head. No parent-commit evidence transfer. Candidate = code + tests only;
  every evidence byte lives on this NON_CANDIDATE_EVIDENCE branch.

branch_head_match: YES (verified via git ls-remote 2026-09-16)
pr_head_match: YES (gh pr view 9 headRefOid = e6e9c3d87a1c87fa0614aa1a4ec44e354117adde)
worktree_clean: YES

implemented_scope:
  - Everything in R2 (Journeys A–E, continuous background sensing strip, knowledge calendar view, knowledge navigation, visual calendar/todo linking, 9-state machine)
  - R3 Owner-directed product iteration (Owner supplied the authoritative KnowMe-NJX-Demo and directed, 2026-09-16):
      - 知识导航 includes 五维知识地图: 工作记录·我做了什么 / 生活感悟·我如何感受 / 人生规划·我想走向哪里 / 系统思考·我如何理解 / 行业洞察·我看见什么变化, live-computed counts, each dimension expands to its real items which open the same knowledge detail
      - 知识导航 includes 九维认知图谱: 01 身份角色 … 09 动态与情景, same expansion semantics
      - 日历 has 月/周/日 three views: September 2026 month grid (astronomically correct Monday-first weekdays, today highlighted, event dots, cell deep-opens day view), full Mon–Sun week view with per-day schedule and linked-todo counts, and the day view (schedule + 当日关联待办)
      - Weekday labels corrected to real weekdays (2026-09-16 = Wednesday); 装机窗口 narrative aligned to 周四 2026-09-17 (schedule + todo t-3 moved accordingly)
  - 67-assertion Playwright browser suite at 360x780 (MATE60_CLASS_SIMULATION)

owner_directed_changes_disclosure: >-
  The R3 changes above were directed by the Human Owner in conversation with
  the authoritative Demo attached. They are deterministic-mock UI
  realizations inside the frozen contract's allowed limitations
  (DETERMINISTIC_MOCK_RUNTIME, NO_REAL_CALENDAR_TODO_BACKEND); they do not
  change Journeys A–E, acceptance outcomes, or NOT_IMPLEMENTED_BY_CONTRACT
  boundaries. Engineering Delivery reports them factually as OWNER_DIRECTED;
  whether they require a formal Change Request is a Product Governance
  adjudication, not an Engineering claim.

not_implemented:
  - id: NOT_IMPLEMENTED_BY_CONTRACT
    items:
      - formal HarmonyOS application
      - real Codex Harness / MiniMax / any model provider
      - real Agent runtime, long-term memory, RAG, embeddings, vector DB, Wiki index
      - real ASR / speaker verification (sensing strip and voice key are SIMULATED/PROTOTYPE_ONLY)
      - real Office/PDF/media/website parsing (Files/Website channels PROTOTYPE_ONLY)
      - real Calendar/Todo backends (NOT_CONNECTED; month/week/day views are local mock state)
      - 2D/3D knowledge graph rendering (Demo has 2D 关系 / 3D 星海 toggles; not ported — desktop-parlor visuals, not required by the frozen contract)
      - Skills capability (PLANNED, future Goal)
      - real persistence, real Owner data, production deployment
  - id: UNRESOLVED_WITHIN_CONTRACT
    items: []

diff_inventory:
  - "prototypes/knowme-knowledge-01-agent-native-mate60/** (source, fixtures, styles, tests)"
  - "no other path touched in the candidate (see ALLOWED_PATH_DIFF_RECEIPT.md)"
  - "reports/** lives ONLY on evidence branch (NON_CANDIDATE_EVIDENCE)"

known_defects: []
defects_found_and_fixed_in_loop:
  - "R1: D-01 overlay stacking collision; D-02 alert() voice disclosure (both fixed, still fixed)"
  - "R2: none (57/57 first loop)"
  - "R3: none (67/67 first loop; ED visual review of new-surface screenshots clean)"
  - "R3 observation (not a defect): deterministic rendering makes several ED/LE frames byte-identical across operators, and R3-P06 == R3-P09 (same 周四 day surface via two paths); recorded, not hidden"

known_limitations:
  - BROWSER_PROTOTYPE_ONLY / DETERMINISTIC_MOCK_RUNTIME / NO_REAL_MODEL
  - NO_REAL_HARNESS / NO_REAL_PROVIDER / NO_REAL_PERSISTENCE_REQUIRED
  - NO_REAL_VOICE / NO_REAL_SPEAKER_VERIFICATION / NO_REAL_IMPORT_PIPELINE / NO_REAL_RAG
  - NO_REAL_CALENDAR_TODO_BACKEND / NO_REAL_OWNER_DATA
  - Viewport evidence is MATE60_CLASS_SIMULATION (360x780), not on-device measurement

known_deviations: []
unapproved_deviations: []
approved_change_requests: []

evidence_ownership:
  engineering_required:
    status: COMPLETE
    refs:
      - exact_candidate_sha_tree_parent: this manifest + Issue #3 R3 terminal receipt
      - candidate_manifest: CANDIDATE_MANIFEST.md
      - technical_receipt: TECHNICAL_RECEIPT.md
      - allowed_path_diff_receipt: ALLOWED_PATH_DIFF_RECEIPT.md
      - runtime_runbook: RUNTIME_RUNBOOK.md
      - browser_technical_assertions: BROWSER_ASSERTION_RECEIPT.md (+ le-assertions.json, ed-browser-assertions.json)
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

issued_at: "2026-09-16T13:45:00Z"
```
