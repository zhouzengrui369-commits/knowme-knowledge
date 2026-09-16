# GOAL-KK-01 — Agent-native Mate60 Prototype — Successor Contract R2

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
goal_id: GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
relationship: ONE_GOAL_EQUALS_ONE_MILESTONE
status: FROZEN
contract_revision: R2
supersedes_contract_commit: 563997a0eca61800c8c72d23a83888821a6e0841
change_request: CR-KK-01-OWNER-DIRECTED-R2-R3
version_horizon: 0.1_PROTOTYPE
task_class: INTERACTIVE_PRODUCT_PROTOTYPE
formal_product_implementation: FORBIDDEN

product_baseline:
  version: PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2
  ref: governance/PRODUCT_BASELINE.md@SUCCESSOR_GOVERNANCE_COMMIT_A

product_governance:
  role: PRODUCT_GOVERNANCE
  context_id: PG-KK-GOAL01-CR-R2R3-20260916-1430-A91F

target_user: SINGLE_HUMAN_OWNER
user_problem: >-
  The Owner must encounter a coherent personal knowledge Agent rather than a conventional notes app,
  dashboard or generic chatbot. The prototype must communicate continuous information sensing,
  navigable personal knowledge/cognition structures, and a usable time/task context while preserving
  Agent context.
customer_value: >-
  In a Mate60-class portrait experience, the Owner can understand and operate KnowME Knowledge as a
  continuously growing personal knowledge Agent: capture and sensing feed knowledge, knowledge can be
  navigated through the Owner-defined five-dimensional and nine-dimensional structures or by date,
  and calendar/todo context is visible and operable without leaving the Agent mental model.

in_scope:
  - runnable interactive mobile-oriented browser prototype
  - Mate60-class portrait-first spatial layout
  - exact Human Owner-provided KnowMe-NJX-Demo visual/product lineage
  - central Agent conversation and callable-work context
  - persistent background sensing interaction strip with pause/resume semantics
  - sensing explicitly disclosed as deterministic mock with no real ASR or speaker verification
  - visible or summonable capture capability for Text Voice Files Website
  - evolving personal knowledge context represented by items/nodes
  - knowledge calendar view
  - knowledge navigation view
  - five-dimensional knowledge map with live counts, expandable items and honest zero states
  - nine-dimensional cognitive graph with live counts, expandable items and honest zero states
  - visible or summonable Knowledge Calendar Todo Skills capabilities
  - Calendar month/week/day views
  - visual linkage between Calendar dates and associated Todos
  - Todo deep link into corresponding Calendar day context
  - contextual work surface/overlay that preserves Agent context
  - deterministic mock responses and prototype-only local state
  - explicit capability availability/connection-state disclosure
  - self-contained HTML review artifact bound to the exact candidate source for code-blind/manual inspection

out_of_scope:
  - formal HarmonyOS application implementation
  - real Codex Harness integration
  - real MiniMax or other model-provider integration
  - real Agent runtime or long-term memory
  - real RAG embedding vector database or Wiki index
  - real Office PDF image audio video or website parsing pipeline
  - real ASR or speaker verification
  - real background microphone capture
  - real Calendar or Todo backend
  - real device integration
  - real Owner private data
  - production deployment or release

required_user_journeys:
  - id: JOURNEY-A-FIRST-ENCOUNTER
    outcome: >-
      First view communicates a personal knowledge Agent identity, current knowledge context,
      known/unknown state, capture entry, ask-Agent entry, callable capabilities and persistent
      background-sensing state. The sensing affordance is clearly marked as simulated/prototype-only.
  - id: JOURNEY-B-ASK-AGENT
    outcome: >-
      Owner asks a knowledge question in the central Agent context; deterministic mock response
      references current knowledge context and exposes a next action opening related work without
      replacing the Agent context with conventional page navigation.
  - id: JOURNEY-C-INFORMATION-ENTERS-KNOWLEDGE
    outcome: >-
      Text capture creates candidate knowledge; Owner can confirm, correct or reject; confirmed
      information visibly changes the knowledge context and the Agent explains the change. Newly
      confirmed knowledge becomes visible in date-based knowledge view and the appropriate cognitive
      navigation structures without pretending to be persisted beyond prototype-local state.
  - id: JOURNEY-D-WORK-FROM-KNOWLEDGE
    outcome: >-
      Owner can navigate knowledge by date, by five-dimensional knowledge map, by nine-dimensional
      cognitive graph and by knowledge item. A selected item exposes context/source/state, opens a
      contextual work surface and returns with central Agent conversation/context preserved.
  - id: JOURNEY-E-CAPABILITY-ATTACHMENT
    outcome: >-
      Owner opens Calendar or Todo into concrete contextual work. Calendar supports month/week/day
      views; dates show linked schedule/Todo context; Todo can deep-link to the corresponding Calendar
      day. Unavailable real connections remain explicitly NOT_CONNECTED/PROTOTYPE_ONLY/PLANNED.

acceptance_outcomes:
  - id: AO-01-AGENT-IDENTITY
    outcome: >-
      First view reads as a personal knowledge Agent experience, not a dashboard, conventional notes
      app or generic chatbot.
  - id: AO-02-OWNER-UI-LINEAGE
    outcome: >-
      Visual/interaction structure is traceable to the exact Owner-provided KnowMe-NJX-Demo authority
      while preserving central Agent context and contextual work surfaces.
  - id: AO-03-CONTEXT-PRESERVATION
    outcome: >-
      Agent conversation/context is preserved across Agent -> knowledge navigation -> item/work surface
      -> Calendar/Todo capability -> back.
  - id: AO-04-KNOWLEDGE-GROWTH-SEMANTICS
    outcome: >-
      Journey C visibly communicates input -> Owner confirmation/correction/rejection -> knowledge-context
      change -> Agent explanation, and the confirmed information is reflected in date/cognitive navigation.
  - id: AO-05-HONEST-CAPABILITY-STATE
    outcome: >-
      NOT_CONNECTED is never presented as CONNECTED; PROTOTYPE_ONLY is never presented as REAL;
      deterministic mock content is never presented as Owner data; simulated background sensing is
      never presented as real ASR, speaker verification or microphone capture.
  - id: AO-06-MOBILE-USABILITY
    outcome: >-
      At the declared portrait mobile review viewport, core actions are clickable, key elements are not
      obscured, critical journeys do not depend on hover, core text is readable and primary journeys do
      not require blocking horizontal scrolling.
  - id: AO-07-KNOWLEDGE-NAVIGATION
    outcome: >-
      Knowledge navigation visibly exposes the five Owner-defined knowledge dimensions and nine
      Owner-defined cognitive dimensions, with live counts, expandable actual prototype items and honest
      zero-count states; a date-based knowledge view is also available.
  - id: AO-08-CALENDAR-TIME-CONTEXT
    outcome: >-
      Calendar month/week/day views are all operable and consistent, schedule/Todo information is
      associated with dates, and Todo-to-calendar deep linking reaches the intended day context.
  - id: AO-09-CONTINUOUS-SENSING-SEMANTICS
    outcome: >-
      Persistent sensing status remains visible through ordinary sheet/work-surface interaction,
      supports pause/resume behavior, and continuously discloses that it is a simulation without real ASR.

allowed_known_limitations:
  - BROWSER_PROTOTYPE_ONLY
  - DETERMINISTIC_MOCK_RUNTIME
  - NO_REAL_MODEL
  - NO_REAL_HARNESS
  - NO_REAL_PROVIDER
  - NO_REAL_PERSISTENCE_REQUIRED
  - NO_REAL_VOICE
  - NO_REAL_SPEAKER_VERIFICATION
  - NO_REAL_BACKGROUND_MICROPHONE_CAPTURE
  - NO_REAL_IMPORT_PIPELINE
  - NO_REAL_RAG
  - NO_REAL_CALENDAR_TODO_BACKEND
  - NO_REAL_OWNER_DATA
  - MATE60_CLASS_SIMULATION_NOT_ON_DEVICE_MEASUREMENT

evidence_ownership:
  engineering_required:
    - exact_candidate_sha_tree_parent
    - candidate_manifest_or_successor_engineering_terminal
    - technical_receipt_or_successor_revalidation_receipt
    - allowed_path_diff_receipt
    - runtime_runbook
    - browser_technical_assertions_covering_successor_contract
    - console_and_page_error_receipt
    - owner_ui_authority_traceability_matrix
    - interaction_state_map
    - final_exact_candidate_local_executor_operation
    - final_exact_candidate_ed_personal_operation
    - screenshot_index_with_actual_viewport
    - mock_data_disclosure
    - continuous_sensing_state_assertions
    - five_dimension_navigation_assertions
    - nine_dimension_navigation_assertions
    - calendar_month_week_day_assertions
    - calendar_todo_linkage_assertions
  admission_required:
    - pr_head_branch_head_candidate_identity_match
    - candidate_equals_or_derives_from_fresh_successor_handoff_preimage
    - successor_contract_coverage_complete
    - engineering_required_evidence_complete
    - forbidden_path_mutation_absent
    - unapproved_product_deviation_absent
    - known_limitations_within_successor_contract
    - owner_directed_change_request_approved
  review_required:
    - exact_candidate_frozen_for_review
    - runnable_review_instructions
    - journeys_A_through_E_identifiable
    - review_environment_or_artifact_available
    - self_contained_html_review_artifact_bound_to_exact_candidate_source
    - no_candidate_mutation_after_admission
  product_experience:
    - agent_first_first_impression
    - portrait_mobile_usability
    - owner_ui_lineage
    - journeys_A_through_E_task_completion
    - agent_context_preservation
    - knowledge_growth_comprehensibility
    - five_dimension_knowledge_map_comprehensibility
    - nine_dimension_cognitive_graph_comprehensibility
    - calendar_month_week_day_comprehensibility
    - calendar_todo_linkage_comprehensibility
    - continuous_sensing_semantics_comprehensibility
    - honest_capability_state_disclosure
    - absence_of_dashboard_or_generic_chatbot_regression
  human_owner:
    - owner_accepts_mobile_personal_knowledge_agent_product_form
    - owner_accepts_owner_provided_knowme_demo_inheritance_direction
    - owner_accepts_five_dimension_and_nine_dimension_navigation
    - owner_accepts_month_week_day_calendar_and_todo_linkage
    - owner_accepts_continuous_sensing_interaction_direction
    - owner_accepts_interaction_structure_as_0_1_successor_foundation

security_tier:
  users: SINGLE_USER
  exposure: LOCAL
  data: PERSONAL
  reversibility: REVERSIBLE
  automation_authority: OBSERVE

owner_locked_decisions:
  - PRODUCT_IS_AGENT_FIRST_NOT_NOTES_APP_PLUS_CHAT
  - PRIMARY_DEVICE_CLASS_IS_MATE60_PORTRAIT
  - OWNER_PROVIDED_KNOWME_NJX_DEMO_IS_EXACT_CURRENT_UI_AUTHORITY
  - CENTER_IS_AGENT_CONVERSATION_AND_CALLABLE_WORK
  - BACKGROUND_IS_EVOLVING_PERSONAL_KNOWLEDGE_CONTEXT
  - CAPTURE_AND_CAPABILITIES_PRESERVE_AGENT_CONTEXT
  - CONTINUOUS_BACKGROUND_SENSING_INTERACTION_REQUIRED_IN_PROTOTYPE
  - CONTINUOUS_SENSING_MUST_BE_HONESTLY_SIMULATED_NO_REAL_ASR
  - KNOWLEDGE_CALENDAR_VIEW_REQUIRED
  - FIVE_DIMENSION_KNOWLEDGE_MAP_REQUIRED
  - FIVE_DIMENSIONS_WORK_LIFE_PLAN_SYSTEM_INDUSTRY_FIXED_BY_OWNER
  - NINE_DIMENSION_COGNITIVE_GRAPH_REQUIRED
  - NINE_DIMENSIONS_IDENTITY_VALUE_CAPABILITY_RELATION_KNOWLEDGE_BEHAVIOR_GOAL_DECISION_DYNAMIC_FIXED_BY_OWNER
  - CALENDAR_MONTH_WEEK_DAY_REQUIRED
  - CALENDAR_TODO_VISUAL_LINKAGE_REQUIRED
  - SELF_CONTAINED_HTML_REVIEW_ARTIFACT_REQUIRED
  - DASHBOARD_FIRST_FORBIDDEN
  - GENERIC_CHAT_WIDGET_ONLY_FORBIDDEN
  - REAL_HARNESS_PROVIDER_RAG_ASR_AND_BACKENDS_ARE_FUTURE_GOALS

ui_authority:
  repository: zhouzengrui369-commits/knowme-knowledge
  evidence_commit: 15a50071202536af05c51e45e04b738dcc81cbdf
  evidence_tree: a63446138525020ab269c630c6507b6e7be74870
  path: reports/prototype/knowme-knowledge-01-agent-native-mate60/r3-ui-authority/KnowMe-NJX-Demo.html
  blob: 097e2c978877f5480a63e9da55acf5fb27e60a43
  source: HUMAN_OWNER_PROVIDED

engineering_allowed_paths:
  - prototypes/knowme-knowledge-01-agent-native-mate60/**
  - reports/prototype/knowme-knowledge-01-agent-native-mate60/**
  - NON_CANDIDATE_EVIDENCE_CHANNEL_FOR_REVIEW_ARTIFACTS
engineering_forbidden_paths:
  - AGENTS.md
  - README.md
  - PROJECT_STATUS.md
  - .github/**
  - governance/**
  - formal_product_source/**
  - any_other_project_or_repository/**

required_gates:
  candidate_admission: true
  product_review_eligibility: true
  product_experience: true
  human_owner_acceptance: true
  release_authorization: false

closure_conditions:
  - one exact candidate has fresh ENGINEERING_READY against this successor contract
  - Product Governance admits that exact candidate against this successor contract
  - Product Governance declares that exact candidate PRODUCT_REVIEW_ELIGIBLE
  - Independent Product Experience Review returns PASS on that exact candidate/review artifact
  - Human Owner explicitly accepts that same exact candidate
  - no unresolved contract blocker remains
  - no candidate identity drift exists

change_request_required_for:
  - target_user
  - customer_value
  - product_boundary
  - required_user_journey
  - acceptance_outcome_or_threshold
  - evidence_bucket_or_class
  - security_tier
  - allowed_limitation
  - closure_condition
  - Agent_first_interaction_architecture
  - exact_UI_authority
  - five_dimension_knowledge_navigation_semantics
  - nine_dimension_cognitive_navigation_semantics
  - calendar_month_week_day_semantics
  - continuous_sensing_semantics

frozen_at: "2026-09-16T14:30:00+08:00"
frozen_commit: BOUND_EXTERNALLY_BY_SUCCESSOR_ACTIVATION_RECEIPT
frozen_tree: BOUND_EXTERNALLY_BY_SUCCESSOR_ACTIVATION_RECEIPT
contract_path: governance/milestones/GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE/CONTRACT-R2.md
```

## Successor contract identity rule

The immutable bytes of this file are frozen by the first governance commit that introduces it. Exact commit/tree/blob are bound externally by the successor activation receipt and fresh Engineering Handoff. Any later byte change creates another successor contract and invalidates its handoff/downstream states.