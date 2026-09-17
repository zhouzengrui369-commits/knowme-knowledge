# GOAL-KK-02 — Voice Capture + Enrolled-Speaker Verification Prototype

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
goal_id: GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
relationship: ONE_GOAL_EQUALS_ONE_MILESTONE
status: FROZEN
version_horizon: 0.1_PROTOTYPE
task_class: REAL_DEVICE_VOICE_AND_SPEAKER_VERIFICATION_PROTOTYPE
formal_product_implementation: FORBIDDEN

product_baseline:
  version: PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2
  ref: governance/PRODUCT_BASELINE.md@978ed0608bda8e278c348ad2987f6a25fa3c3c2f

predecessor:
  goal: GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
  milestone: MILESTONE-GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
  closure_ref: Issue #3 comment 5715161903
  owner_acceptance_ref: Issue #3 comment 5715155474
  accepted_candidate_sha: f89fe6695ebdbfa69e6b569447247120fab0c360
  accepted_candidate_tree: 3b1d2a678d945d886df9185459fca6a76f332bf6

product_governance:
  role: PRODUCT_GOVERNANCE
  context_id: PG-KK-GOAL02-FREEZE-20260917-2135-PG

target_user: SINGLE_HUMAN_OWNER
user_problem: >-
  The Owner needs to speak naturally to KnowME Knowledge on the target Mate60 path without losing trust
  over who spoke, what was transcribed, or whether uncertain speech silently became personal knowledge.
customer_value: >-
  On a real Mate60, the Owner can explicitly start voice capture, receive a local-first transcript and an
  honest enrolled-speaker verification state, and decide whether the transcript enters the existing
  candidate-knowledge confirmation flow. Non-owner or uncertain speech never silently becomes trusted knowledge.

product_question: >-
  Can the accepted Agent-first prototype be extended with a real-device, local-first voice path that captures
  speech, transcribes Mandarin, distinguishes an enrolled Owner from non-owner/uncertain input at prototype level,
  and hands only explicitly accepted content into the knowledge-candidate flow while preserving clear privacy and
  capability boundaries?

in_scope:
  - smallest runnable real-device prototype on the Owner's Mate60-class HarmonyOS path
  - explicit microphone permission, start, stop, cancel and retry interaction
  - local-first speech-to-text using an Engineering-selected on-device approach
  - enrolled Owner speaker setup, reset and prototype speaker-verification path
  - explicit result states: VERIFIED, NOT_VERIFIED, UNCERTAIN, NOT_AVAILABLE
  - visible distinction between transcript confidence/availability and speaker-verification state
  - verified Owner speech can create a candidate transcript only after the user sees the result
  - NOT_VERIFIED / UNCERTAIN / NOT_AVAILABLE speech cannot silently create trusted knowledge
  - transcript correction / reject / explicit confirm before knowledge ingestion
  - at least one fully offline real-device voice run after required local assets are provisioned
  - bounded device benchmark: capture-to-result latency, local model/runtime identity, memory observation where available, and acoustic-condition notes
  - bounded verification sample matrix with aggregate results only
  - preserve the accepted Agent-first interaction grammar and current KnowME visual/product lineage
  - Engineering may benchmark sherpa-onnx, HarmonyOS-native speech capabilities, or other local candidates; no engine is frozen by Product Governance

out_of_scope:
  - production-grade biometric authentication or identity assurance
  - payment, account-login, security-token or legal identity authority
  - silent always-on microphone capture
  - background continuous real microphone ingestion
  - cloud audio upload or silent cloud speech fallback in this Goal
  - production privacy/data-retention policy
  - long-term storage of raw Owner voice, speaker embeddings or voiceprints as product data
  - real Codex Harness / MiniMax provider integration
  - real long-term memory / RAG / vector database / Wiki synthesis
  - production release or app-store distribution
  - diagnosis of biometric FAR/FRR as production quality from this small prototype sample

required_user_journeys:
  - id: JOURNEY-A-PERMISSION-AND-IDLE
    outcome: >-
      On first voice use the Owner sees the real microphone permission/capability state before capture begins;
      microphone activity is never implied while idle, denied or unavailable.
  - id: JOURNEY-B-OWNER-ENROLLMENT
    outcome: >-
      The Owner can explicitly create an enrolled-speaker prototype profile from local samples, see completion or
      failure, cancel/reset it, and is told that this is prototype verification rather than production authentication.
  - id: JOURNEY-C-VERIFIED-OWNER-CAPTURE
    outcome: >-
      The Owner starts capture, speaks Mandarin, stops capture, receives a visible transcript plus VERIFIED state,
      then corrects/rejects/confirms the transcript before it enters the existing knowledge-candidate flow.
  - id: JOURNEY-D-NONOWNER-OR-UNCERTAIN
    outcome: >-
      A consenting non-owner or disclosed replay/negative sample produces NOT_VERIFIED or UNCERTAIN rather than
      silent trust; the content does not auto-enter knowledge and the UI offers discard/retry or manual text entry.
  - id: JOURNEY-E-OFFLINE-DEGRADED
    outcome: >-
      With network unavailable, the provisioned local path either completes capture/transcription/verification or
      honestly reports NOT_AVAILABLE; there is no silent cloud fallback and no false success.

acceptance_outcomes:
  - id: AO-01-REAL-MATE60-EVIDENCE
    outcome: >-
      Closure evidence includes a real Owner-authorized Mate60 run with exact device/OS/build identity; desktop or
      simulator-only evidence cannot substitute for the real-device requirement.
  - id: AO-02-PERMISSION-AND-MIC-HONESTY
    outcome: >-
      Permission, idle, recording, stopped, denied and unavailable states are understandable and never imply active
      microphone capture when capture is not occurring.
  - id: AO-03-LOCAL-FIRST-STT
    outcome: >-
      At least five short scripted Mandarin Owner utterances are exercised in a quiet real-device session; at least
      four preserve the intended core meaning in the visible transcript before manual correction. A moderate-noise
      sample may degrade, but uncertainty/retry must be explicit and cannot silently become trusted knowledge.
  - id: AO-04-BOUNDED-SPEAKER-VERIFICATION
    outcome: >-
      In a bounded prototype matrix, at least four of five enrolled-Owner attempts return VERIFIED, while five
      disclosed negative attempts produce zero false VERIFIED results. Negative samples may be consenting non-owner
      speech or clearly disclosed replay/synthetic negatives. These counts are prototype evidence only, not FAR/FRR claims.
  - id: AO-05-TRUST-GATE
    outcome: >-
      NOT_VERIFIED, UNCERTAIN and NOT_AVAILABLE can never auto-confirm or silently ingest a knowledge item.
  - id: AO-06-CANDIDATE-HANDOFF
    outcome: >-
      A VERIFIED transcript enters the existing candidate flow with correction/reject/explicit-confirm semantics;
      confirm is required before knowledge-context growth and Agent context remains preserved.
  - id: AO-07-OFFLINE-NO-SILENT-FALLBACK
    outcome: >-
      At least one provisioned real-device run is executed with network unavailable and no cloud request is required
      for the accepted local voice path. If the local engine cannot operate, the product shows NOT_AVAILABLE instead of fallback success.
  - id: AO-08-PERFORMANCE-OBSERVABILITY
    outcome: >-
      Engineering records capture-stop-to-visible-result latency for the bounded sample set and documents the local
      runtime/model identity and observed device constraints; no paper-spec estimate substitutes for measurement.
  - id: AO-09-PRIVACY-AND-EVIDENCE-HYGIENE
    outcome: >-
      Raw Owner audio, speaker embeddings/voiceprints, secrets and private transcripts are not committed to GitHub.
      Durable evidence contains synthetic/redacted screenshots, aggregate counts, hashes/config identities and sanitized logs only.
  - id: AO-10-AGENT-FIRST-CONTEXT
    outcome: >-
      Voice remains an attached Agent capture capability, not a separate recorder app or standalone speech console;
      after confirm/reject the user returns to the same Agent/knowledge mental model.

prototype_sample_policy:
  owner_positive_attempts_minimum: 5
  negative_attempts_minimum: 5
  owner_verified_minimum: 4
  negative_false_verified_maximum: 0
  quiet_stt_attempts_minimum: 5
  quiet_stt_core_meaning_preserved_minimum: 4
  production_biometric_claim_allowed: false

privacy_and_security:
  users: SINGLE_USER
  exposure: LOCAL_DEVICE
  data: PERSONAL_AUDIO_AND_BIOMETRIC_LIKE_SIGNAL
  reversibility: REVERSIBLE_PROTOTYPE
  automation_authority: CAPTURE_CANDIDATE_ONLY
  raw_owner_audio_in_git: FORBIDDEN
  speaker_embedding_or_voiceprint_in_git: FORBIDDEN
  owner_private_transcript_in_git: FORBIDDEN
  non_owner_sample: CONSENTED_OR_SYNTHETIC_REPLAY_ONLY
  cloud_audio_upload: FORBIDDEN_IN_THIS_GOAL
  secrets_in_repo: FORBIDDEN

allowed_known_limitations:
  - PROTOTYPE_NOT_PRODUCTION_AUTHENTICATION
  - SMALL_SAMPLE_PROXY_NOT_FAR_FRR_VALIDATION
  - NO_ALWAYS_ON_REAL_MICROPHONE
  - NO_BACKGROUND_REAL_AUDIO_INGESTION
  - NO_CLOUD_AUDIO_FALLBACK
  - NO_REAL_HARNESS_OR_LLM_PROVIDER
  - NO_LONG_TERM_MEMORY_OR_RAG
  - NO_PRODUCTION_AUDIO_RETENTION
  - NO_APP_STORE_RELEASE

evidence_ownership:
  engineering_required:
    - exact_candidate_sha_tree_parent
    - candidate_manifest
    - technical_receipt
    - allowed_path_diff_receipt
    - exact_real_device_build_or_package_identity
    - real_mate60_device_and_os_receipt
    - microphone_permission_state_receipt
    - local_stt_runtime_model_identity
    - speaker_verification_runtime_identity
    - bounded_sample_matrix_sanitized_aggregate
    - capture_to_result_latency_measurements
    - offline_no_silent_cloud_fallback_receipt
    - sanitized_network_boundary_observation
    - privacy_no_raw_audio_or_voiceprint_in_git_receipt
    - final_exact_candidate_local_executor_real_device_operation
    - engineering_regression_tests
    - console_runtime_error_receipt
    - screenshot_or_screen_recording_index_without_private_audio
    - regression_receipt_for_goal_kk_01_agent_context_and_candidate_semantics
  admission_required:
    - pr_head_branch_head_candidate_identity_match
    - candidate_derives_forward_from_exact_engineering_handoff_preimage
    - contract_coverage_complete
    - engineering_required_evidence_complete
    - forbidden_path_mutation_absent
    - unapproved_product_deviation_absent
    - privacy_and_security_constraints_satisfied
    - known_limitations_within_contract
  review_required:
    - exact_candidate_frozen_for_review
    - exact_real_device_build_or_package_identity
    - runnable_install_and_device_session_instructions
    - owner_authorized_real_device_review_environment_available
    - journeys_A_through_E_identifiable
    - no_candidate_mutation_after_admission
    - reviewer_can_operate_real_product_without_source_test_inspection
  product_experience:
    - permission_and_mic_state_comprehension
    - enrollment_comprehension_and_reset
    - transcript_usability
    - speaker_state_comprehension
    - nonowner_uncertain_trust_boundary
    - candidate_confirmation_flow
    - offline_degraded_honesty
    - perceived_latency_and_recovery
    - agent_context_preservation
    - absence_of_recorder_app_or_developer_console_regression
  human_owner:
    - owner_accepts_real_device_voice_capture_interaction
    - owner_accepts_enrollment_and_verification_semantics
    - owner_accepts_nonowner_uncertain_blocking_behavior
    - owner_accepts_local_first_offline_behavior
    - owner_accepts_privacy_and_data_retention_boundary
    - owner_accepts_voice_to_candidate_knowledge_flow

ui_authority:
  exact_visual_authority_repository: zhouzengrui369-commits/knowme-knowledge
  exact_visual_authority_commit: 15a50071202536af05c51e45e04b738dcc81cbdf
  exact_visual_authority_path: reports/prototype/knowme-knowledge-01-agent-native-mate60/r3-ui-authority/KnowMe-NJX-Demo.html
  exact_visual_authority_blob: 097e2c978877f5480a63e9da55acf5fb27e60a43
  accepted_product_predecessor_sha: f89fe6695ebdbfa69e6b569447247120fab0c360
  preserve_agent_first_grammar: true

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
  - one exact candidate has fresh ENGINEERING_READY against this contract
  - Product Governance admits that exact candidate
  - Product Governance declares that exact candidate PRODUCT_REVIEW_ELIGIBLE
  - Independent Product Experience Review returns PASS on that exact candidate in the authorized real-device review environment
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
  - privacy_or_security_boundary
  - allowed_limitation
  - closure_condition
  - real_mate60_requirement
  - cloud_audio_boundary
  - speaker_verification_trust_semantics

frozen_at: "2026-09-17T21:35:00+08:00"
contract_path: governance/milestones/GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE/CONTRACT.md
```

## Contract identity rule

The immutable bytes of this file are frozen by the first governance commit that introduces it. The exact commit/tree/blob are bound externally by the Product Governance activation receipt. Any later byte change is a successor contract and invalidates the Engineering handoff and downstream states.
