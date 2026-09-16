# Engineering Delivery Handoff — GOAL-KK-01 — Successor Contract R2

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
actor_role: PRODUCT_GOVERNANCE
actor_context_id: PG-KK-GOAL01-CR-R2R3-20260916-1430-A91F

product_baseline_ref: PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2@978ed0608bda8e278c348ad2987f6a25fa3c3c2f
goal_id: GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
relationship: ONE_GOAL_EQUALS_ONE_MILESTONE
change_request: CR-KK-01-OWNER-DIRECTED-R2-R3

product_contract:
  revision: R2
  commit: 978ed0608bda8e278c348ad2987f6a25fa3c3c2f
  tree: db0be0e4ac22b9780cf5cf3c80998d3cfd15731d
  blob: 05bc2ca7cce5e8645301994b348f702f2286d3f3
  path: governance/milestones/GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE/CONTRACT-R2.md

engineering_delivery_authority:
  repository: zhouzengrui369-commits/chatgpt-engineering-delivery
  commit: 8bcf9da58d6147fcd2345a4b465f17f7a27850fd
  tree: 593bacfee4910a55b9b6c7bd2f2ca56b8761d134
  skill_path: core/ENGINEERING_DELIVERY_SKILL.md

engineering_delivery_context_id: ED-KK-GOAL01-CONTRACT-R2-REVALIDATION-20260916-1435-6C4E
engineering_delivery_contract_ref: >-
  knowme-knowledge Issue #3 successor governance activation receipt + this exact handoff file

preimage:
  repository: zhouzengrui369-commits/knowme-knowledge
  branch: engineering/goal-kk-01-agent-native-mate60-prototype-r1
  sha: e6e9c3d87a1c87fa0614aa1a4ec44e354117adde
  tree: beeb0d6e136419036fb71fe5bd31aa8863f9227f
  parent: 9f3071e22def4f99cbf3a4589349e628e9e15a97

intended_revalidation:
  exact_candidate_reuse_permitted: true
  candidate_may_equal_preimage: true
  source_mutation_required: false
  reason: >-
    e6e9c3d is the already-implemented Owner-directed R3 successor. Prior Engineering Ready is
    invalid only because the frozen Product Contract changed. Fresh Engineering must verify the exact
    bytes against Contract R2 and may re-declare the same SHA ENGINEERING_READY if no in-scope defect
    requires mutation.

allowed_paths:
  - prototypes/knowme-knowledge-01-agent-native-mate60/**
  - reports/prototype/knowme-knowledge-01-agent-native-mate60/**
  - evidence/goal-kk-01-non-candidate-r2 (evidence transport only, never candidate identity)
forbidden_paths:
  - AGENTS.md
  - README.md
  - PROJECT_STATUS.md
  - .github/**
  - governance/**
  - formal_product_source/**
  - any_other_project_or_repository/**
approved_change_requests:
  - governance/change-requests/CR-KK-01-OWNER-DIRECTED-R2-R3.md@978ed0608bda8e278c348ad2987f6a25fa3c3c2f

ui_authority:
  repository: zhouzengrui369-commits/knowme-knowledge
  evidence_commit: 15a50071202536af05c51e45e04b738dcc81cbdf
  evidence_tree: a63446138525020ab269c630c6507b6e7be74870
  path: reports/prototype/knowme-knowledge-01-agent-native-mate60/r3-ui-authority/KnowMe-NJX-Demo.html
  blob: 097e2c978877f5480a63e9da55acf5fb27e60a43
  source: HUMAN_OWNER_PROVIDED

evidence_ownership:
  engineering_required:
    - exact_candidate_sha_tree_parent
    - successor_contract_technical_receipt
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

required_return:
  - engineering_terminal
  - successor_contract_technical_receipt
  - exact_candidate_identity
  - local_executor_final_sha_receipt
  - ed_personal_final_sha_receipt
  - self_contained_html_review_artifact_ref

forbidden_engineering_claims:
  - CANDIDATE_ADMITTED
  - PRODUCT_REVIEW_ELIGIBLE
  - PRODUCT_EXPERIENCE_PASS
  - HUMAN_OWNER_ACCEPTED
  - MERGE_AUTHORIZED
  - RELEASE_AUTHORIZED
  - GOAL_MILESTONE_CLOSED
```

## Fresh Engineering re-entry requirements

1. Fresh-read Contract R2 and CR before any execution.
2. Materialize exact `e6e9c3d87a1c87fa0614aa1a4ec44e354117adde` and verify tree.
3. Evaluate all R2/R3 Owner-directed behavior against Contract R2; do not assume prior R3 PASS transfers.
4. Run the complete current assertion suite on the exact final SHA.
5. Dispatch a fresh observation-only Local Executor against that same exact final SHA.
6. ED personally operates that same exact final SHA from the Human Owner/user perspective.
7. If any Contract R2 defect is found, repair it inside allowed product paths, producing a new successor candidate; then all exact-candidate operation evidence must be repeated.
8. If no product bytes need change, the exact candidate may remain `e6e9c3d...`; emit a fresh ENGINEERING_READY bound to Contract R2.
9. Produce/export a self-contained HTML review artifact from the exact candidate source and store it in the NON_CANDIDATE_EVIDENCE channel with candidate SHA/tree, build command and sha256. Do not commit that review artifact into the candidate merely to carry evidence.
10. Stop after fresh Engineering terminal; do not perform Candidate Admission.