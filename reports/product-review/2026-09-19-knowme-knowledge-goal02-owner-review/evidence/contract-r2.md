# GOAL-KK-02 — Voice Capture + Enrolled-Speaker Verification Prototype — Successor Contract R2

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
goal_id: GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
relationship: ONE_GOAL_EQUALS_ONE_MILESTONE
status: FROZEN
contract_revision: R2
supersedes_contract_commit: 73701b2f3069a0384568977909b601504c9fc591
change_request: CR-KK-02-SIMULATOR-FIRST-UNTIL-1.0
version_horizon: 0.1_PROTOTYPE
task_class: SIMULATOR_FIRST_HARMONYOS_VOICE_TRUST_PROTOTYPE
formal_product_implementation: FORBIDDEN

product_baseline:
  version: PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2
  ref: governance/PRODUCT_BASELINE.md@978ed0608bda8e278c348ad2987f6a25fa3c3c2f

development_validation_policy:
  id: POLICY-KK-SIMULATOR-FIRST-UNTIL-1.0
  path: governance/policies/SIMULATOR_FIRST_UNTIL_1_0.md

target_user: SINGLE_HUMAN_OWNER
user_problem: >-
  The Owner needs a coherent Agent-attached voice interaction whose permission, capture, transcription,
  speaker-state and trust-gate semantics can be product-tested before real-device installation, without
  falsely presenting simulator behavior as proven Mate60 capability.
customer_value: >-
  In the declared HarmonyOS simulator/development environment, the Owner can experience and evaluate the
  complete voice-to-candidate product flow, including honest uncertainty and recovery, while preserving
  the Agent-first mental model. Real Mate60 installation and device-specific capability validation are deferred.

product_question: >-
  Can the accepted Agent-first product be extended with a complete, understandable and trustworthy voice-capture
  and enrolled-speaker interaction flow in the simulator environment, ready to become part of the 1.0 product
  without claiming untested real-device behavior?

in_scope:
  - HarmonyOS simulator/development-environment runnable prototype
  - explicit permission / idle / recording / stopped / denied / unavailable states
  - voice-capture interaction and transcript-result interaction
  - local/runtime STT where simulator supports it; otherwise honest NOT_AVAILABLE and disclosed simulator test transcript/proxy where required to exercise product flow
  - Owner enrollment interaction and prototype verification states VERIFIED / NOT_VERIFIED / UNCERTAIN / NOT_AVAILABLE
  - simulator/runtime speaker verification where available; disclosed SIMULATOR_PROXY / TEST_FIXTURE semantics where actual speaker discrimination cannot be established
  - trust gate preventing NOT_VERIFIED / UNCERTAIN / NOT_AVAILABLE from silent ingestion
  - correction / reject / explicit confirm before candidate knowledge ingestion
  - Agent context preservation
  - simulator offline/degraded-state behavior and no silent cloud audio fallback
  - active simulator defect discovery and repair
  - exact final candidate Local Executor simulator operation
  - exact final candidate ED personal simulator operation

out_of_scope:
  - real Mate60 installation
  - real Mate60 microphone/device permission proof
  - real-device ASR availability or quality claims
  - real-device speaker-verification accuracy claims
  - real-device offline performance claims
  - production biometric authentication
  - production release / app-store distribution
  - real Harness / MiniMax / RAG unless separately frozen by another Goal

required_user_journeys:
  - id: JOURNEY-A-VOICE-ENTRY
    outcome: Owner sees an Agent-attached voice entry and honest permission/capability state before capture.
  - id: JOURNEY-B-ENROLLMENT
    outcome: Owner can start/cancel/complete/reset enrollment and understands prototype/simulator verification limits.
  - id: JOURNEY-C-VOICE-TO-CANDIDATE
    outcome: Capture produces a visible transcript result or honest NOT_AVAILABLE; the complete candidate correction/reject/confirm flow remains operable using only clearly disclosed simulator evidence.
  - id: JOURNEY-D-TRUST-BOUNDARY
    outcome: VERIFIED / NOT_VERIFIED / UNCERTAIN / NOT_AVAILABLE are understandable; untrusted states never silently ingest knowledge.
  - id: JOURNEY-E-RECOVERY-AND-RETURN
    outcome: Permission denial, unavailable runtime, retry/discard/manual fallback and return to Agent are understandable and preserve context.

acceptance_outcomes:
  - id: AO-01-SIMULATOR-RUNNABLE
    outcome: The exact candidate installs/runs in the declared simulator environment from a reproducible build.
  - id: AO-02-VOICE-STATE-HONESTY
    outcome: Permission, idle, recording, stopped, denied and unavailable states are visible and non-contradictory.
  - id: AO-03-TRANSCRIPT-HONESTY
    outcome: Actual simulator STT is identified as actual when available; test/proxy transcript data is explicitly disclosed and never presented as Mate60 real-device proof.
  - id: AO-04-SPEAKER-STATE-HONESTY
    outcome: Verification states and any simulator proxy/fixture are explicitly distinguished from real-device biometric performance.
  - id: AO-05-TRUST-GATE
    outcome: NOT_VERIFIED / UNCERTAIN / NOT_AVAILABLE never auto-confirm or silently ingest knowledge.
  - id: AO-06-CANDIDATE-FLOW
    outcome: Transcript candidate supports correction, reject and explicit confirm; confirm is required before visible knowledge growth.
  - id: AO-07-AGENT-FIRST-CONTEXT
    outcome: Voice remains an Agent capability, not a standalone recorder/developer console, and return preserves Agent context.
  - id: AO-08-RECOVERY
    outcome: Permission denial, unavailable speech runtime, retry, discard and manual fallback remain usable and coherent.
  - id: AO-09-NO-SILENT-CLOUD-AUDIO
    outcome: Simulator testing reveals no intentional cloud audio upload or silent cloud speech fallback in this Goal.
  - id: AO-10-CLAIM-CEILING
    outcome: Product and evidence clearly state REAL_DEVICE_NOT_REVIEWED / NOT_REAL_DEVICE_VALIDATED.

allowed_known_limitations:
  - SIMULATOR_ONLY_VALIDATION
  - REAL_MATE60_NOT_INSTALLED
  - REAL_DEVICE_ASR_NOT_VALIDATED
  - REAL_DEVICE_SPEAKER_VERIFICATION_NOT_VALIDATED
  - REAL_DEVICE_OFFLINE_NOT_VALIDATED
  - SIMULATOR_PROXY_OR_TEST_FIXTURE_ALLOWED_IF_EXPLICITLY_DISCLOSED
  - PROTOTYPE_NOT_PRODUCTION_AUTHENTICATION
  - NO_PRODUCTION_RELEASE

privacy_and_security:
  raw_owner_audio_in_git: FORBIDDEN
  speaker_embedding_or_voiceprint_in_git: FORBIDDEN
  owner_private_transcript_in_git: FORBIDDEN
  cloud_audio_upload: FORBIDDEN_IN_THIS_GOAL
  secrets_in_repo: FORBIDDEN

evidence_ownership:
  engineering_required:
    - exact_candidate_sha_tree_parent
    - candidate_manifest
    - technical_receipt
    - allowed_path_diff_receipt
    - exact_simulator_build_identity
    - simulator_environment_identity
    - technical_tests_and_regression
    - no_silent_cloud_audio_static_or_runtime_observation
    - Local Executor final exact-candidate simulator installation_and_operation
    - ED personal final exact-candidate simulator operation
    - privacy_safe_screenshot_index_for_both_operators
    - known_in_scope_blocking_defects_none
    - regression_receipt_for_agent_context_and_candidate_semantics
  admission_required:
    - pr_head_branch_head_candidate_identity_match
    - candidate_derives_from_successor_handoff_preimage
    - contract_coverage_complete
    - engineering_required_evidence_complete
    - forbidden_path_mutation_absent
    - unapproved_product_deviation_absent
  review_required:
    - exact_candidate_frozen_for_review
    - exact_simulator_build_or_review_runtime_identity
    - runnable_review_instructions
    - declared_simulator_review_environment_available
    - journeys_A_through_E_identifiable
    - no_candidate_mutation_after_admission
  product_experience:
    - voice_entry_comprehension
    - enrollment_comprehension
    - transcript_result_comprehension
    - verification_state_comprehension
    - trust_gate_comprehension
    - candidate_confirmation_flow
    - recovery_and_error_states
    - agent_context_preservation
    - absence_of_recorder_console_regression
    - explicit_simulator_and_real_device_claim_boundary
  human_owner:
    - owner_accepts_simulator_voice_interaction_direction
    - owner_accepts_trust_gate_semantics
    - owner_accepts_candidate_flow
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

closure_conditions:
  - one exact candidate has fresh ENGINEERING_READY against Contract R2 using simulator-required evidence
  - Product Governance admits that exact candidate
  - Product Governance declares that exact candidate PRODUCT_REVIEW_ELIGIBLE
  - Independent Product Experience Review returns PASS in the declared simulator/review environment
  - Human Owner explicitly accepts that same exact candidate
  - no unresolved Contract R2 blocker remains
  - no candidate identity drift exists

claim_ceiling:
  real_device_validated: false
  mate60_compatibility_pass: false
  real_device_asr_pass: false
  real_device_speaker_verification_pass: false
  real_device_offline_pass: false

post_1_0_required_successor_goal: REAL_DEVICE_INSTALLATION_AND_COMPATIBILITY_VALIDATION

change_request_required_for:
  - target_user
  - customer_value
  - product_boundary
  - required_user_journey
  - acceptance_outcome_or_threshold
  - evidence_bucket_or_class
  - privacy_or_security_boundary
  - allowed_limitation
  - closure_condition
  - simulator_first_until_1_0_policy

frozen_at: 2026-09-19T09:20:00+08:00
contract_path: governance/milestones/GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE/CONTRACT-R2.md
```

Any later byte change requires a successor contract and invalidates this handoff/downstream candidate state.