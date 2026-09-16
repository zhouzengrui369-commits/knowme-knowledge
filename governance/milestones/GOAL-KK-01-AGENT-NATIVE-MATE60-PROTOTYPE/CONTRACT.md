# GOAL-KK-01 — Agent-native Mate60 Prototype

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
goal_id: GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
relationship: ONE_GOAL_EQUALS_ONE_MILESTONE
status: FROZEN
version_horizon: 0.1_PROTOTYPE
task_class: INTERACTIVE_PRODUCT_PROTOTYPE
formal_product_implementation: FORBIDDEN

product_baseline:
  version: PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v1
  ref: governance/PRODUCT_BASELINE.md@8fc17246067d5ddfcda63be8c99235193143c5b8

product_governance:
  role: PRODUCT_GOVERNANCE
  context_id: PG-KK-GOAL01-20260916-1010-7F2C

target_user: SINGLE_HUMAN_OWNER
user_problem: >-
  The Owner must not encounter a conventional notes app with an AI entry point. On first use,
  the product must make it understandable that the Owner is collaborating with a personal
  knowledge Agent that has a current knowledge context, explicit gaps, capture paths and
  callable work capabilities.
customer_value: >-
  In a Mate60-class portrait experience, the Owner can recognize and operate KnowME Knowledge
  as a continuously growing personal knowledge Agent rather than a dashboard, file manager or
  generic chatbot, while preserving the exact KnowMe visual/interaction lineage.

in_scope:
  - runnable interactive mobile-oriented browser prototype
  - Mate60-class portrait-first spatial layout
  - exact KnowMe Demo visual and interaction lineage
  - central Agent conversation and callable-work context
  - visible or summonable capture capability for Text Voice Files Website
  - evolving personal knowledge context represented by knowledge items or nodes
  - visible or summonable Knowledge Calendar Todo Skills capabilities
  - contextual work surface or overlay that preserves Agent context
  - deterministic mock responses and prototype-only local state
  - explicit capability availability and connection-state disclosure

out_of_scope:
  - formal HarmonyOS application implementation
  - real Codex Harness integration
  - real MiniMax or other model-provider integration
  - real Agent runtime or long-term memory
  - real RAG embedding vector database or Wiki index
  - real Office PDF image audio video or website parsing pipeline
  - real ASR or speaker verification
  - real Calendar or Todo backend
  - real device integration
  - real Owner private data
  - production deployment or release

required_user_journeys:
  - id: JOURNEY-A-FIRST-ENCOUNTER
    outcome: >-
      First view communicates a personal knowledge Agent identity, current knowledge context,
      known/unknown state, capture entry, ask-Agent entry and callable capabilities without
      reading as a dashboard, file list or empty chatbot.
  - id: JOURNEY-B-ASK-AGENT
    outcome: >-
      Owner asks a knowledge question in the central Agent context; deterministic mock response
      references current knowledge context and exposes a next action that opens related work
      without replacing the Agent context with conventional page navigation.
  - id: JOURNEY-C-INFORMATION-ENTERS-KNOWLEDGE
    outcome: >-
      Text capture creates candidate knowledge; Owner can confirm, correct or reject; confirmed
      information visibly changes the knowledge context and the Agent explains the change.
  - id: JOURNEY-D-WORK-FROM-KNOWLEDGE
    outcome: >-
      Owner activates a knowledge item/node, inspects context and source/state, opens a contextual
      work surface and returns with central Agent conversation/context preserved.
  - id: JOURNEY-E-CAPABILITY-ATTACHMENT
    outcome: >-
      Owner opens Calendar, Todo or another right-side capability into concrete contextual work;
      unavailable capabilities remain explicitly PROTOTYPE_ONLY, NOT_CONNECTED, AVAILABLE or PLANNED.

acceptance_outcomes:
  - id: AO-01-AGENT-IDENTITY
    outcome: >-
      Independent product review and the Human Owner can recognize the first view as a personal
      knowledge Agent experience rather than a dashboard, conventional notes app or generic chatbot.
  - id: AO-02-KNOWME-LINEAGE
    outcome: >-
      Visual/interaction structure is traceable to the frozen KnowMe Demo dark contextual workbench:
      central Agent, knowledge/context field, capture side, capability side and contextual floating work.
  - id: AO-03-CONTEXT-PRESERVATION
    outcome: >-
      Agent conversation/context is preserved across Agent -> knowledge -> work surface -> capability -> back.
  - id: AO-04-KNOWLEDGE-GROWTH-SEMANTICS
    outcome: >-
      Journey C visibly communicates input -> Owner confirmation/correction/rejection -> knowledge-context
      change -> Agent explanation.
  - id: AO-05-HONEST-CAPABILITY-STATE
    outcome: >-
      NOT_CONNECTED is never presented as CONNECTED; PROTOTYPE_ONLY is never presented as REAL;
      deterministic mock content is never presented as Owner data.
  - id: AO-06-MOBILE-USABILITY
    outcome: >-
      At the declared portrait mobile review viewport, core actions are clickable, key elements are
      not obscured, core journeys do not depend on hover, core text is readable and primary journeys
      do not require horizontal scrolling.

allowed_known_limitations:
  - BROWSER_PROTOTYPE_ONLY
  - DETERMINISTIC_MOCK_RUNTIME
  - NO_REAL_MODEL
  - NO_REAL_HARNESS
  - NO_REAL_PROVIDER
  - NO_REAL_PERSISTENCE_REQUIRED
  - NO_REAL_VOICE
  - NO_REAL_SPEAKER_VERIFICATION
  - NO_REAL_IMPORT_PIPELINE
  - NO_REAL_RAG
  - NO_REAL_CALENDAR_TODO_BACKEND
  - NO_REAL_OWNER_DATA

evidence_ownership:
  engineering_required:
    - exact_candidate_sha_tree_parent
    - candidate_manifest
    - technical_receipt
    - allowed_path_diff_receipt
    - runtime_runbook
    - browser_technical_assertions
    - console_and_page_error_receipt
    - knowme_ui_traceability_matrix
    - interaction_state_map
    - screenshot_index_with_actual_viewport
    - mock_data_disclosure
  admission_required:
    - pr_head_branch_head_candidate_identity_match
    - candidate_derives_from_frozen_handoff_preimage
    - frozen_contract_coverage_complete
    - engineering_required_evidence_complete
    - forbidden_path_mutation_absent
    - unapproved_product_deviation_absent
    - known_limitations_within_contract
  review_required:
    - exact_candidate_frozen_for_review
    - runnable_review_instructions
    - journeys_A_through_E_identifiable
    - review_environment_available
    - no_candidate_mutation_after_admission
  product_experience:
    - agent_first_first_impression
    - portrait_mobile_usability
    - knowme_visual_interaction_lineage
    - journeys_A_through_E_task_completion
    - agent_context_preservation
    - knowledge_growth_comprehensibility
    - honest_capability_state_disclosure
    - absence_of_dashboard_or_generic_chatbot_regression
  human_owner:
    - owner_accepts_mobile_personal_knowledge_agent_product_form
    - owner_accepts_knowme_to_mobile_inheritance_direction
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
  - KNOWME_DEMO_IS_VISUAL_INTERACTION_LINEAGE
  - CENTER_IS_AGENT_CONVERSATION_AND_CALLABLE_WORK
  - BACKGROUND_IS_EVOLVING_PERSONAL_KNOWLEDGE_CONTEXT
  - CAPTURE_AND_CAPABILITIES_PRESERVE_AGENT_CONTEXT
  - DASHBOARD_FIRST_FORBIDDEN
  - GENERIC_CHAT_WIDGET_ONLY_FORBIDDEN
  - PROTOTYPE_MUST_DISCLOSE_MOCK_AND_CONNECTION_STATE_HONESTLY
  - REAL_HARNESS_PROVIDER_RAG_VOICE_AND_BACKENDS_ARE_FUTURE_GOALS

ui_authority:
  repository: zhouzengrui369-commits/knowme
  commit: baa61e693c4681445b8ef0f34c2113292f68e8c7
  tree: 3bad5f228b47c8e76ccd4203744e5e40b2f30fe4
  root: tasks/pm/20260721-knowme-cognitive-surface-demo-r5/
  app_blob: 4523e61d60017d63e99b2a58cff763f1a82d6b49
  styles_blob: 9667f012df8e03496395ee176a93ea2db976a697
  offline_html_blob: 2b00d2e158619f5c20380cbf06b90236c33eb55b

engineering_allowed_paths:
  - prototypes/knowme-knowledge-01-agent-native-mate60/**
  - reports/prototype/knowme-knowledge-01-agent-native-mate60/**
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
  - one exact candidate has ENGINEERING_READY from independent Engineering Delivery
  - Product Governance admits that exact candidate
  - Product Governance declares that exact candidate PRODUCT_REVIEW_ELIGIBLE
  - Independent Product Experience Review returns PASS on that exact candidate
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
  - KnowMe_visual_interaction_lineage

frozen_at: "2026-09-16T10:10:00+08:00"
frozen_commit: BOUND_EXTERNALLY_BY_GOAL_ACTIVATION_RECEIPT
frozen_tree: BOUND_EXTERNALLY_BY_GOAL_ACTIVATION_RECEIPT
contract_path: governance/milestones/GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE/CONTRACT.md
```

## Prototype disclosure and screenshot contract

Voice, Files and Website must be visible as capture affordances but may be `PROTOTYPE_ONLY`; the prototype must not imply real ASR, speaker verification or file parsing. At least one right-side capability must open a concrete contextual work surface. Screenshots must cover First Encounter, Ask Agent, Candidate Knowledge Confirmation, Knowledge Context Changed, Knowledge Work Surface, Capability Work Surface and Return With Agent Context Preserved. Every screenshot record must state its actual viewport and must not claim that viewport as a measured Mate60 CSS viewport unless measured on-device.

## Contract identity rule

The immutable bytes of this file are frozen by the first commit that introduces it. Because a Git commit cannot truthfully contain its own hash/tree without a self-referential hash cycle, the exact `CONTRACT_COMMIT`, `CONTRACT_TREE` and `CONTRACT_BLOB` are bound externally by the Goal Issue activation receipt and Engineering Handoff. Any later byte change to this file creates a successor contract and invalidates the previous handoff/downstream states.
