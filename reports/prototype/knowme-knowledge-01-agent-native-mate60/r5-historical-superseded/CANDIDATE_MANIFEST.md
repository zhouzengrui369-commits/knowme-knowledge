# Candidate Manifest — GOAL-KK-01 (R5, final exact candidate)

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
artifact: CANDIDATE_MANIFEST
actor_role: ENGINEERING_DELIVERY
actor_context_id: ED-KK-GOAL01-R5-NAVCAL-QUICKACTION-20260916-1610-R5

evidence_channel_role: NON_CANDIDATE_EVIDENCE
evidence_branch: evidence/goal-kk-01-non-candidate-r2
evidence_commit_is_candidate: NO
move_pr9_head: NO

goal_id: GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
relationship: ONE_GOAL_EQUALS_ONE_MILESTONE

product_baseline: PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2

product_contract:
  revision: R2
  commit: 978ed0608bda8e278c348ad2987f6a25fa3c3c2f
  tree: db0be0e4ac22b9780cf5cf3c80998d3cfd15731d
  blob: 05bc2ca7cce5e8645301994b348f702f2286d3f3
  path: governance/milestones/GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE/CONTRACT-R2.md

ui_authority:
  source: Owner-provided KnowMe-NJX-Demo.html (supplied in conversation 2026-09-16, "这个才是knowme的原型")
  sha256: 3ef8605a6b74c6514ee7097d24100d5f06e258b2e6bbdb03e591a02a51fc7d9f
  evidence_copy: r3-historical-superseded/r3-ui-authority/KnowMe-NJX-Demo.html (byte-identical)
  prior_authority: zhouzengrui369-commits/knowme demo (baa61e6…), superseded by the Owner-provided file

repository: zhouzengrui369-commits/knowme-knowledge
branch: engineering/goal-kk-01-agent-native-mate60-prototype-r1
pr: 9 (Draft, base governance/goal-kk-01-agent-native-mate60-prototype-r1)

candidate_sha: 40063afd16a36674e8660f6b4a05315d51f4e546
candidate_tree: 72464ee6727af4837cb24b77238f7ddadeca02ed
candidate_parent: 3c2088888a0896f9bb0149560dcfbf5412adb2f4
operated_candidate_sha: 40063afd16a36674e8660f6b4a05315d51f4e546
operated_candidate_tree: 72464ee6727af4837cb24b77238f7ddadeca02ed
prototype_subtree_tree: 02557fa953c9ce8ae5643acc28efba86f5d4fdac

evidence_binding: >-
  ALL R5 operation evidence (Local Executor + ED personal, assertions and
  screenshots) was produced against the FINAL EXACT candidate 40063af…
  itself — the same commit that is the engineering branch head and PR #9
  head. No parent-commit evidence transfer. Candidate = code + tests only;
  every evidence byte lives on this NON_CANDIDATE_EVIDENCE branch.

branch_head_match: YES (verified via git ls-remote 2026-09-16)
pr_head_match: YES (gh pr view 9 headRefOid = 40063afd16a36674e8660f6b4a05315d51f4e546)
worktree_clean: YES

implemented_scope:
  - Everything in R2 (Journeys A–E, continuous background sensing strip, knowledge calendar view, knowledge navigation, visual calendar/todo linking, 9-state machine)
  - R3 Owner-directed product iteration (still present):
      - 知识导航 includes 五维知识地图: 工作记录·我做了什么 / 生活感悟·我如何感受 / 人生规划·我想走向哪里 / 系统思考·我如何理解 / 行业洞察·我看见什么变化, live-computed counts, each dimension expands to its real items which open the same knowledge detail
      - 知识导航 includes 九维认知图谱: 01 身份角色 … 09 动态与情景, same expansion semantics
      - 日历 has 月/周/日 three views: September 2026 month grid (astronomically correct Monday-first weekdays, today highlighted, event dots, cell deep-opens day view), full Mon–Sun week view with per-day schedule and linked-todo counts, and the day view (schedule + 当日关联待办)
      - Weekday labels corrected to real weekdays (2026-09-16 = Wednesday); 装机窗口 narrative aligned to 周四 2026-09-17 (schedule + todo t-3 moved accordingly)
  - R4 Owner-directed product iteration (still present; classified NON_MATERIAL_UI_AUTHORITY_ALIGNMENT by Product Governance, no new CR required):
      - Brand rename 懂我 → 灵犀 across the whole UI surface, consistent with the authoritative Demo's "灵犀 · Digital Brain"; source grep "懂" = 0
  - R5 Owner-directed product iteration (Owner directed, 2026-09-16):
      - 知识导航 IS exactly the 五维知识地图 + 九维认知图谱 — the legacy 主题入口·MOC / 知识文档·WIKI / 笔记与捕获·NOTE groupings below the maps are removed; every item remains reachable via dimension expansion
      - 按日历查看 gains 日/周/月 three views mirroring the schedule calendar: day view (week strip + day group, defaults to 今天), week view (Mon–Sun rows with knowledge items + counts, row deep-opens day view), month view (September 2026 grid, dots only on days holding knowledge, today highlighted, cell deep-opens day view; out-of-month knowledge honestly reachable via 本月之外 list)
      - 日程/待办 quick actions: schedule items get 完成/重做 + 顺延一天 (prototype-local state, day view/week/month all reflect moves); todos get 顺延一天 (complete toggle preexisting)
      - 引用对话: every schedule/todo item has 引用到对话 — the sheet closes, a quote card lands in the conversation, and 灵犀 answers referencing the item's linked knowledge with a contextual next action (deterministic mock)
  - 80-assertion Playwright browser suite at 360x780 (MATE60_CLASS_SIMULATION); +12 vs R4

owner_directed_changes_disclosure: >-
  The R5 changes above were directed by the Human Owner in conversation
  (2026-09-16). They are deterministic-mock UI realizations inside the frozen
  Contract R2's allowed limitations (DETERMINISTIC_MOCK_RUNTIME,
  NO_REAL_CALENDAR_TODO_BACKEND); they do not change Journeys A–E, acceptance
  outcomes, or NOT_IMPLEMENTED_BY_CONTRACT boundaries. R2/R3 changes are
  covered by APPROVED CR-KK-01-OWNER-DIRECTED-R2-R3; R4 was classified by
  Product Governance as NON_MATERIAL_UI_AUTHORITY_ALIGNMENT (no new CR). R5
  is disclosed factually as OWNER_DIRECTED; whether it requires a formal
  Change Request is a Product Governance adjudication, not an Engineering
  claim.

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
  - "R3: none (67/67 first loop)"
  - "R4: none (68/68 first loop ×2 operators)"
  - "R5: two layout defects found by ED visual review of smoke screenshots and fixed before the evidence runs: (1) 日/周/月 switcher wrapped to two rows (.sheet-tabs was 2-column; added .three variant); (2) quick-action buttons squeezed vertical by the schedule-item grid (qa-row now spans full width). Then 80/80 first full loop ×2 operators, zero console/page errors"
  - "R5 observation (not a defect): deterministic rendering makes several ED/LE frames byte-identical across operators; R5-P06 ≠ R5-P09 (P06 carries quick-action buttons, P09 follows the postpone quick action); recorded, not hidden"

known_limitations:
  - BROWSER_PROTOTYPE_ONLY / DETERMINISTIC_MOCK_RUNTIME / NO_REAL_MODEL
  - NO_REAL_HARNESS / NO_REAL_PROVIDER / NO_REAL_PERSISTENCE_REQUIRED
  - NO_REAL_VOICE / NO_REAL_SPEAKER_VERIFICATION / NO_REAL_IMPORT_PIPELINE / NO_REAL_RAG
  - NO_REAL_CALENDAR_TODO_BACKEND / NO_REAL_OWNER_DATA
  - Viewport evidence is MATE60_CLASS_SIMULATION (360x780), not on-device measurement

known_deviations: []
unapproved_deviations: []
approved_change_requests:
  - CR-KK-01-OWNER-DIRECTED-R2-R3 (APPROVED by Product Governance 2026-09-16; R4 rename classified NON_MATERIAL_UI_AUTHORITY_ALIGNMENT, no new CR)

evidence_ownership:
  engineering_required:
    status: COMPLETE
    refs:
      - exact_candidate_sha_tree_parent: this manifest + Issue #3 R5 terminal receipt
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

issued_at: "2026-09-16T16:20:00Z"
```

## Durable self-contained HTML artifact (GitHub-verified)

```text
HTML_GITHUB_REF=evidence/goal-kk-01-non-candidate-r2@82984911ff11cf6ae80e255126fd1f59145da254:reports/prototype/knowme-knowledge-01-agent-native-mate60/deliverable/KnowME-Knowledge-01-Prototype.html
HTML_GITHUB_BLOB=910bb08194c1a42bd8f1ad945709119d99495786
HTML_SHA256=60feb609628659a0a5fcecc9d0fd2ed7d64dc6b765753a0d25dae5190d09afdf
HTML_SHA256_VERIFIED_FROM_GITHUB_BYTES=YES (fresh download from GitHub 2026-09-16)
SOURCE_CANDIDATE_SHA=40063afd16a36674e8660f6b4a05315d51f4e546
SOURCE_CANDIDATE_TREE=72464ee6727af4837cb24b77238f7ddadeca02ed
```
