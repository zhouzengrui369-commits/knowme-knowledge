# GOAL-KK-02 — Voice Capture + Enrolled-Speaker Verification Prototype — Successor Contract R3

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
goal_id: GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
relationship: ONE_GOAL_EQUALS_ONE_MILESTONE
status: FROZEN
contract_revision: R3
task_class: PX_FINDINGS_SUCCESSOR_ENGINEERING_CORRECTION
version_horizon: 0.1_PROTOTYPE
formal_product_implementation: FORBIDDEN

supersedes:
  contract_r2_commit: 335e4b9e6c64c9e6a9b69fcc2d2e49b5a0c0d69c
  predecessor_candidate_sha: b02bca6e5e84e98e5b4c99bc43d3599946089e83
  predecessor_candidate_tree: b40553f25b6a6c8eaa6ef37629ea176c2b09d047
  predecessor_candidate_pr: 21
  predecessor_product_experience_ref: Issue #13 comment 5742173191
  predecessor_product_experience_result: NOT_READY

change_request:
  id: CR-KK-02-PX01-R3
  path: governance/change-requests/CR-KK-02-PX01-R3.md

product_baseline:
  version: PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2
  ref: governance/PRODUCT_BASELINE.md@978ed0608bda8e278c348ad2987f6a25fa3c3c2f

development_validation_policy:
  id: POLICY-KK-SIMULATOR-FIRST-UNTIL-1.0
  path: governance/policies/SIMULATOR_FIRST_UNTIL_1_0.md

px_authority:
  report_commit: 56d005c1c76df26cdaf36675de2ba7d60d0006d4
  report_path: reports/product-review/2026-09-19-knowme-knowledge-goal02-owner-review/REVIEW.md
  handoff_path: reports/product-review/2026-09-19-knowme-knowledge-goal02-owner-review/PARENT_HANDOFF.md
  accepted_findings:
    - PX-KK02-01
    - PX-KK02-02
    - PX-KK02-03
    - PX-KK02-04
    - PX-KK02-05

target_user: SINGLE_HUMAN_OWNER
user_problem: >-
  The Owner needs an Agent-first voice capture flow that remains trustworthy through permission/recovery states,
  preserves explicitly saved prototype knowledge/context, provides a non-voice continuation path, and exposes
  the candidate control journey repeatably in the declared simulator environment without overstating device identity.
customer_value: >-
  The Owner can start from an Agent context, use voice or manual fallback, understand enrollment versus current
  verification state, correct/reject/confirm a disclosed candidate, recover from permission/process interruptions,
  and inspect the resulting saved prototype knowledge without losing context.

product_question: >-
  Can the simulator-first voice prototype become a coherent Agent workflow whose saved result remains inspectable,
  whose fallback and candidate controls are always reachable, and whose simulation/device boundaries are clear
  enough for an independent focused Product Experience retest?

in_scope:
  - all Contract R2 simulator-first voice/trust behavior unless explicitly superseded below
  - bounded local persistence of explicitly confirmed/manual synthetic knowledge and bounded Agent conversation context
  - persistence/recovery across Home return, permission settings round-trip, force-stop and cold reopen in declared simulator
  - no recovery of rejected/discarded/unconfirmed voice candidate as confirmed knowledge
  - direct manual-text continuation while microphone permission is denied or voice capability unavailable
  - repeatable UI-reachable disclosed TEST_FIXTURE candidate path when natural simulator speech path cannot reach usable candidate
  - correction, reject and explicit confirm as separate user operations
  - reject causes zero knowledge increment; confirm causes exactly one increment
  - Agent-first default product surface and contextual return
  - normal-state simulator / real-device claim boundary
  - explicit separation of enrolled profile state from current capture verification result
  - action wording consistent with actual tap/start/stop interaction
  - active Engineering defect discovery and regression of prior D1-D17 plus PX-KK02-01..05
  - final exact candidate Local Executor simulator deployment/operation with screenshots
  - final exact candidate ED personal simulator operation with independent screenshots

out_of_scope:
  - real Mate60 installation, signing or compatibility proof
  - real-device ASR availability/accuracy
  - real-device speaker verification accuracy or biometric assurance
  - production backup, cloud sync or multi-device persistence
  - real LLM / Codex Harness / MiniMax / RAG integration
  - full five-dimension / nine-dimension / calendar implementation changes outside regression needed to preserve inherited context
  - production release or app-store distribution

required_user_journeys:
  - id: JOURNEY-A-AGENT-FIRST-ENTRY
    outcome: >-
      The first/main surface presents an Agent/task context with voice as an attached capability; simulator and
      prototype identity boundaries are understandable without opening diagnostics.
  - id: JOURNEY-B-ENROLLMENT-AND-STATE
    outcome: >-
      Owner can enroll/cancel/reset; enrolled-profile state remains distinct from each capture verdict, and
      prototype speaker verification is not represented as production identity assurance.
  - id: JOURNEY-C-CANDIDATE-CONTROL
    outcome: >-
      From the declared simulator environment, the user can repeatably reach a real transcript or clearly disclosed
      TEST_FIXTURE candidate via visible UI, then correct, reject and explicitly confirm in separate flows.
  - id: JOURNEY-D-TRUST-BOUNDARY
    outcome: >-
      NOT_ENROLLED / UNCERTAIN / NOT_VERIFIED / NOT_AVAILABLE never silently ingest knowledge; fixture/manual text
      never masquerades as verified Owner speech.
  - id: JOURNEY-E-RECOVERY-AND-MANUAL-CONTINUATION
    outcome: >-
      Permission denial and voice unavailability expose direct manual text continuation without microphone reauthorization;
      Home return, permission round-trip, force-stop and cold reopen preserve explicitly saved prototype knowledge/context.
  - id: JOURNEY-F-RETURN-AND-INSPECTION
    outcome: >-
      After manual save, reject, confirm, error recovery and restart, the user returns to the Agent context and can
      inspect the resulting item/source/state without recorder-console dominance.

acceptance_outcomes:
  - id: AO-R3-01-PERSISTENCE-TRUTH
    finding: PX-KK02-01
    outcome: >-
      Record two synthetic items through explicit user actions. After Home return, microphone permission off/on round-trip,
      force-stop and cold reopen, the same confirmed/manual items, source labels, count and bounded Agent context remain
      inspectable with no duplicate or disappearance. Rejected/discarded/unconfirmed candidates remain absent.
  - id: AO-R3-02-DENIED-MANUAL-FALLBACK
    finding: PX-KK02-02
    outcome: >-
      With microphone permission denied, the current product surface exposes manual text entry, cancel and explicit save
      without requiring microphone enablement; saved source is text/manual, never verified voice.
  - id: AO-R3-03-REPEATABLE-CANDIDATE-PATH
    finding: PX-KK02-03
    outcome: >-
      From a clean declared simulator start, a visible product path reaches a clearly labeled TEST_FIXTURE candidate when
      natural simulator recognition cannot yield one. No threshold/state hacking or out-of-band injection is required.
      Correction, reject and confirm are each actually operated; reject changes count by 0 and confirm by exactly +1.
  - id: AO-R3-04-AGENT-FIRST-SURFACE
    finding: PX-KK02-04
    outcome: >-
      Default surface and journey read as Agent/task workflow. Voice/verification diagnostics are secondary; after capture,
      fallback, reject or confirm, user returns to the same contextual work and can inspect the result. No real LLM/RAG required.
  - id: AO-R3-05-DISCLOSURE-AND-STATE-COPY
    finding: PX-KK02-05
    outcome: >-
      Normal, recording and result states clearly state simulator/not-real-device validation, prototype verification boundary,
      enrolled-profile status separately from current verdict, and action verbs matching tap-to-start/tap-to-stop behavior.
  - id: AO-R3-06-PRESERVE-TRUST-GATE
    outcome: >-
      Existing NOT_ENROLLED / UNCERTAIN / NOT_VERIFIED / NOT_AVAILABLE blocking remains intact and cannot be weakened merely
      to make the candidate flow easier to reach.
  - id: AO-R3-07-REGRESSION
    outcome: >-
      Enrollment, reset confirmation, D1-D17, permission recovery, no-silent-cloud boundary, candidate explicit-confirm semantics
      and Agent-context return show no blocking regression.
  - id: AO-R3-08-CLAIM-CEILING
    outcome: >-
      All evidence and UI maintain REAL_DEVICE_NOT_REVIEWED / NOT_REAL_DEVICE_VALIDATED semantics.

allowed_known_limitations:
  - SIMULATOR_ONLY_VALIDATION
  - REAL_MATE60_NOT_INSTALLED
  - REAL_DEVICE_ASR_NOT_VALIDATED
  - REAL_DEVICE_SPEAKER_VERIFICATION_NOT_VALIDATED
  - REAL_DEVICE_OFFLINE_NOT_VALIDATED
  - SIMULATOR_PROXY_OR_TEST_FIXTURE_ALLOWED_IF_EXPLICITLY_DISCLOSED
  - PROTOTYPE_NOT_PRODUCTION_AUTHENTICATION
  - NO_REAL_LLM_RAG_REQUIRED
  - NO_PRODUCTION_BACKUP_OR_SYNC
  - NO_PRODUCTION_RELEASE

not_allowed_as_known_limitation:
  - CONFIRMED_KNOWLEDGE_DISAPPEARS_AFTER_DECLARED_RECOVERY
  - AGENT_CONTEXT_DISAPPEARS_AFTER_DECLARED_RECOVERY
  - MIC_DENIED_REQUIRES_REAUTH_BEFORE_MANUAL_TEXT
  - CANDIDATE_FLOW_UNREACHABLE_IN_DECLARED_REVIEW_ENVIRONMENT
  - RECORDER_DIAGNOSTIC_FIRST_DEFAULT_SURFACE
  - SIMULATOR_REAL_DEVICE_BOUNDARY_ONLY_VISIBLE_IN_ERROR_OR_FIXTURE_STATE

privacy_and_security:
  users: SINGLE_USER
  exposure: LOCAL_SIMULATOR
  raw_owner_audio_in_git: FORBIDDEN
  speaker_embedding_or_voiceprint_in_git: FORBIDDEN
  owner_private_transcript_in_git: FORBIDDEN
  cloud_audio_upload: FORBIDDEN_IN_THIS_GOAL
  secrets_in_repo: FORBIDDEN
  synthetic_test_data_preferred: true

evidence_ownership:
  engineering_required:
    - exact_candidate_sha_tree_parent
    - candidate_manifest
    - technical_receipt
    - allowed_path_diff_receipt
    - exact_simulator_build_identity
    - simulator_environment_identity
    - technical_tests_and_regression
    - px_findings_regression_matrix
    - persistence_recovery_receipt
    - denied_manual_fallback_receipt
    - candidate_fixture_flow_receipt
    - agent_first_surface_receipt
    - disclosure_state_receipt
    - Local Executor final exact-candidate simulator deployment_and_operation
    - ED personal final exact-candidate simulator operation
    - privacy_safe_screenshot_index_for_both_operators
    - runtime_error_receipt
    - privacy_and_network_boundary_receipts
    - known_in_scope_blocking_defects_none
  admission_required:
    - pr_head_branch_head_candidate_identity_match
    - candidate_derives_forward_from_exact_R3_handoff_preimage
    - contract_R3_coverage_complete
    - engineering_required_evidence_complete
    - forbidden_path_mutation_absent
    - unapproved_product_deviation_absent
    - known_limitations_within_contract_R3
  review_required:
    - exact_successor_candidate_frozen_for_review
    - exact_simulator_build_identity
    - runnable_review_instructions
    - declared_simulator_review_environment_available
    - R3_journeys_A_through_F_identifiable
    - focused_retest_entry_state_defined
    - no_candidate_mutation_after_admission
  product_experience:
    - PX-KK02-01_closed
    - PX-KK02-02_closed
    - PX-KK02-03_closed
    - PX-KK02-04_closed
    - PX-KK02-05_closed_or_nonblocking_with_governance_acceptance
    - no_blocking_regression
    - simulator_real_device_claim_boundary
  human_owner:
    - owner_accepts_corrected_agent_first_voice_flow
    - owner_accepts_bounded_simulator_persistence_semantics
    - owner_accepts_deferral_of_real_device_validation_until_after_1_0

engineering_allowed_paths:
  - prototypes/knowme-knowledge-02-voice-speaker-verification/**
  - reports/prototype/knowme-knowledge-02-voice-speaker-verification/**
engineering_forbidden_paths:
  - AGENTS.md
  - README.md
  - PROJECT_STATUS.md
  - .github/**
  - governance/**
  - prototypes/knowme-knowledge-01-agent-native-mate60/**
  - reports/prototype/knowme-knowledge-01-agent-native-mate60/**
  - formal_product_source/**
  - any_other_project_or_repository/**

required_gates:
  candidate_admission: true
  product_review_eligibility: true
  product_experience: true
  human_owner_acceptance: true
  release_authorization: false

next_product_experience_mode: FOCUSED_RETEST

closure_conditions:
  - one exact successor candidate has fresh ENGINEERING_READY against Contract R3
  - Product Governance admits that exact successor candidate
  - Product Governance declares that exact successor candidate PRODUCT_REVIEW_ELIGIBLE
  - independent FOCUSED_RETEST closes all blocking accepted PX findings with no blocking regression
  - Human Owner explicitly accepts that same exact successor candidate
  - no unresolved Contract R3 blocker remains
  - no candidate identity drift exists

claim_ceiling:
  real_device_validated: false
  mate60_compatibility_pass: false
  real_device_asr_pass: false
  real_device_speaker_verification_pass: false
  production_persistence_claim: false
  release_authorized: false

post_1_0_required_successor_goal: REAL_DEVICE_INSTALLATION_AND_COMPATIBILITY_VALIDATION

frozen_at: 2026-09-20T07:35:00+08:00
contract_path: governance/milestones/GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE/CONTRACT-R3.md
```

Any later product-scope, acceptance, evidence-class, privacy/security or closure-condition change requires a new approved Change Request and successor contract.