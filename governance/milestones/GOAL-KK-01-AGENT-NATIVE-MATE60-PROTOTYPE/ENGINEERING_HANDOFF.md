# Engineering Delivery Handoff — GOAL-KK-01

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
actor_role: PRODUCT_GOVERNANCE
actor_context_id: PG-KK-GOAL01-20260916-1010-7F2C

product_baseline_ref: PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v1@8fc17246067d5ddfcda63be8c99235193143c5b8
goal_id: GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
relationship: ONE_GOAL_EQUALS_ONE_MILESTONE

product_contract:
  commit: 563997a0eca61800c8c72d23a83888821a6e0841
  tree: 2b3c70f106b0b96f724af315955f2a859a1994c0
  blob: 02b75109f12cac49a3a996a57993d4d0b5ddb091
  path: governance/milestones/GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE/CONTRACT.md

engineering_delivery_authority:
  repository: zhouzengrui369-commits/chatgpt-engineering-delivery
  commit: 8bcf9da58d6147fcd2345a4b465f17f7a27850fd
  tree: 593bacfee4910a55b9b6c7bd2f2ca56b8761d134
  skill_path: core/ENGINEERING_DELIVERY_SKILL.md

engineering_delivery_context_id: ED-KK-GOAL01-AGENT-NATIVE-MATE60-PROTOTYPE-R1-20260916-1013-4A7D
engineering_delivery_contract_ref: knowme-knowledge Issue #3 plus this exact handoff file

preimage:
  repository: zhouzengrui369-commits/knowme-knowledge
  branch: governance/goal-kk-01-agent-native-mate60-prototype-r1
  sha: 563997a0eca61800c8c72d23a83888821a6e0841
  tree: 2b3c70f106b0b96f724af315955f2a859a1994c0
  parent: 8fc17246067d5ddfcda63be8c99235193143c5b8

allowed_paths:
  - prototypes/knowme-knowledge-01-agent-native-mate60/**
  - reports/prototype/knowme-knowledge-01-agent-native-mate60/**
forbidden_paths:
  - AGENTS.md
  - README.md
  - PROJECT_STATUS.md
  - .github/**
  - governance/**
  - formal_product_source/**
  - any_other_project_or_repository/**
approved_change_requests: []

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

required_return:
  - engineering_terminal
  - candidate_manifest
  - technical_receipt

forbidden_engineering_claims:
  - CANDIDATE_ADMITTED
  - PRODUCT_REVIEW_ELIGIBLE
  - PRODUCT_EXPERIENCE_PASS
  - HUMAN_OWNER_ACCEPTED
  - MERGE_AUTHORIZED
  - RELEASE_AUTHORIZED
  - GOAL_MILESTONE_CLOSED
```

## Engineering activation boundary

Engineering must begin in the exact fresh context ID above and recover authority from GitHub, not this chat. The Engineering branch/candidate must derive from the exact preimage SHA/tree above. Product Governance has not started Engineering Delivery, has not created a candidate and does not own `ENGINEERING_READY`.

This handoff authorizes implementation only for the frozen interactive prototype contract. Real HarmonyOS formal implementation, Codex Harness, MiniMax/provider integration, RAG/vector storage, ASR/speaker verification, real import pipelines, real Calendar/Todo backends and real Owner data remain forbidden in this Goal.
