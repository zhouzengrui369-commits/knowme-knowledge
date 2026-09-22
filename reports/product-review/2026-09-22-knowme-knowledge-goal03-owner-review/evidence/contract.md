# GOAL-KK-03 — Voice-to-Note First-Use Prototype — Product Contract

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
goal_id: GOAL-KK-03-VOICE-TO-NOTE-FIRST-USE-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-03-VOICE-TO-NOTE-FIRST-USE-PROTOTYPE
relationship: ONE_GOAL_EQUALS_ONE_MILESTONE
status: FROZEN
contract_revision: R1
task_class: FIRST_USE_VOICE_TO_NOTE_PRODUCT_FLOW
product_version_horizon: 0.1_PROTOTYPE
owner_gate_horizon: PRE_1_0
formal_product_implementation: FORBIDDEN

owner_acceptance_policy:
  mode: DELEGATED_TO_PRODUCT_EXPERIENCE
  policy_ref: governance/policies/HUMAN_OWNER_FINAL_ACCEPTANCE_AT_1_0.md
  human_owner_acceptance_required: false

product_baseline:
  id: PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2
  commit: 978ed0608bda8e278c348ad2987f6a25fa3c3c2f
  path: governance/PRODUCT_BASELINE.md

predecessor:
  goal: GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
  milestone: MILESTONE-GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
  status: GOAL_MILESTONE_CLOSED
  exact_candidate_sha: 3317469085d8dc10a88818369ffcc2922904079c
  exact_candidate_tree: c688e8d6da0fe5fdaa12f2412158eb0c6d86ee15
  product_experience_pass_ref: Issue #13 comment 5756269343
  closure_ref: Issue #13 comment 5759364134

development_validation:
  simulator_first_policy: governance/policies/SIMULATOR_FIRST_UNTIL_1_0.md
  real_mate60_required: false
  independent_product_experience_required: true
  human_owner_routine_testing_required: false

target_user: SINGLE_HUMAN_OWNER

user_problem: >-
  A first-time user must not need engineering knowledge to understand what KnowME Knowledge does.
  The product must make the core voice workflow obvious: enroll/understand voice identity state,
  start a recording, stop it, obtain an honest transcript candidate, turn that captured content into
  an editable canonical note, explicitly save it, and later inspect the note together with its original
  transcript/source provenance.

customer_value: >-
  The user can capture a spoken thought or conversation record and reliably turn it into a usable,
  editable note without navigating a developer/test console or understanding TEST_FIXTURE terminology.
  The user keeps control over what becomes knowledge and can trace saved notes back to the captured source.

product_question: >-
  Can a code-blind first-time user, on a clean simulator install and without external instructions,
  discover and complete the voice-to-note workflow as a product rather than as an engineering test panel?

in_scope:
  - first-view product purpose and primary-action clarity
  - visible voiceprint enrollment/setup entry and enrolled/not-enrolled state
  - visible primary recording entry
  - recording start state, recording-in-progress state, stop/cancel state and clear feedback
  - honest transcript candidate after capture when transcript capability is available
  - disclosed simulator test-transcript route when natural simulator STT is unavailable
  - test-transcript tooling placed in a secondary/collapsed simulator-test surface, not the primary first-use flow
  - transcript candidate correction / reject / explicit continue-to-note
  - explicit "整理成笔记" transition from transcript candidate to note draft
  - canonical editable note draft containing at minimum a title and editable note body
  - original transcript/source provenance remains inspectable from the note
  - explicit note save / cancel
  - saved note appears in knowledge list and can be reopened
  - saved note + source survive force-stop / cold reopen using bounded prototype persistence
  - unconfirmed transcript or note draft must not silently become saved knowledge
  - Agent explains what changed after save and preserves context
  - technical diagnostics, simulator disclosures and test tooling remain available but secondary
  - regression protection of GOAL-KK-02 permission/trust/candidate-control behavior
  - final exact-candidate Local Executor real simulator operation with screenshots
  - final exact-candidate ED personal operation with independent screenshots

out_of_scope:
  - Mate60 real-device installation or compatibility proof
  - real-device ASR accuracy
  - real-device speaker-verification accuracy / biometric assurance
  - multi-speaker diarization or speaker-by-speaker conversation labeling
  - real LLM / Codex Harness / MiniMax / RAG integration
  - production-grade semantic summarization quality
  - audio-file import pipeline
  - Word/PDF/PPT/image/video/web import
  - full Daily Note/wiki/backlink/vector implementation
  - Calendar/Todo backend implementation
  - production backup/sync/multi-device
  - release/app-store/production deployment

required_user_journeys:
  - id: JOURNEY-A-FIRST-ENCOUNTER
    outcome: >-
      On a clean install, the first product view clearly communicates that the user can record voice/conversation
      content and turn it into notes. The primary product actions are visible without scrolling or reading external
      instructions. Engineering/test history does not dominate the first screen.
  - id: JOURNEY-B-VOICE-IDENTITY-SETUP
    outcome: >-
      The user can see whether a voice profile is enrolled and can enter the enrollment flow from an obvious product
      action. Enrollment remains clearly separate from the current capture/verification result.
  - id: JOURNEY-C-RECORD
    outcome: >-
      The user can start recording, see unmistakable recording feedback, and stop/cancel. If permission is unavailable,
      the product tells the truth and offers the appropriate permission/manual path without presenting false readiness.
  - id: JOURNEY-D-TRANSCRIPT-CANDIDATE
    outcome: >-
      A transcript candidate is shown without being silently saved. Real/fixture/manual source is explicit. The user can
      correct, reject, or continue. Simulator fixture tooling is secondary and explicitly non-real.
  - id: JOURNEY-E-ORGANIZE-INTO-NOTE
    outcome: >-
      The user can choose "整理成笔记" and receive an editable canonical note draft with a title and organized editable body.
      The original transcript/source remains inspectable and is not overwritten by the organized note.
  - id: JOURNEY-F-SAVE-AND-INSPECT
    outcome: >-
      The user explicitly saves or cancels the note. Save creates exactly one knowledge item; cancel creates zero.
      The saved note can be reopened with title/body/source/original transcript provenance visible.
  - id: JOURNEY-G-RECOVERY
    outcome: >-
      After force-stop/cold reopen, explicitly saved notes and their provenance remain inspectable; unconfirmed transcript
      and note drafts do not become saved knowledge.
  - id: JOURNEY-H-AGENT-CONTEXT-RETURN
    outcome: >-
      After save/cancel/recovery, the user returns to the Agent context, and the Agent explains the knowledge change
      without turning the default surface into a test log or diagnostics console.

acceptance_outcomes:
  - id: AO-KK03-01-FIRST-VIEW-COMPREHENSION
    outcome: >-
      A clean-install first view exposes the product purpose plus visible actions for voice identity setup and starting a
      recording. No TEST_FIXTURE log/history or diagnostic wall dominates the primary screen.
  - id: AO-KK03-02-RECORDING-FEEDBACK
    outcome: >-
      Start/recording/stop/cancel states are visually distinct and action labels match what the next tap will do.
  - id: AO-KK03-03-TRANSCRIPT-CONTROL
    outcome: >-
      Transcript candidate is never silently saved. Correct/reject/continue are independently operable and source class
      remains honest.
  - id: AO-KK03-04-NOTE-DRAFT
    outcome: >-
      "整理成笔记" creates one editable note draft with title + editable body, separate from the original transcript.
  - id: AO-KK03-05-PROVENANCE
    outcome: >-
      Saved note exposes original transcript/source provenance within two product interactions; organized content does not
      replace or erase the source.
  - id: AO-KK03-06-EXPLICIT-SAVE
    outcome: >-
      Save creates exactly +1 note, cancel/reject creates +0, and duplicate taps/recovery do not create duplicate notes.
  - id: AO-KK03-07-RECOVERY
    outcome: >-
      Saved note survives Home/background/force-stop/cold reopen; unconfirmed transcript/note draft is not promoted to saved knowledge.
  - id: AO-KK03-08-AGENT-FIRST
    outcome: >-
      Agent/task context remains the product center. Recording and note work are attached capabilities; diagnostics and
      simulator tooling are secondary/collapsed.
  - id: AO-KK03-09-TRUST-REGRESSION
    outcome: >-
      GOAL-KK-02 permission truthfulness, enrolled-profile/current-result separation, explicit confirmation and no silent
      cloud audio behavior do not regress.
  - id: AO-KK03-10-CLAIM-CEILING
    outcome: >-
      UI/evidence never claim real-device validation, real ASR accuracy, production biometric identity, real LLM/RAG, or production persistence.

allowed_known_limitations:
  - SIMULATOR_ONLY
  - REAL_MATE60_NOT_REVIEWED
  - REAL_ASR_MAY_BE_NOT_AVAILABLE_IN_SIMULATOR
  - DISCLOSED_SIMULATOR_TEST_TRANSCRIPT_ALLOWED_AS_SECONDARY_TEST_PATH
  - DETERMINISTIC_NOTE_ORGANIZER_ALLOWED
  - NO_REAL_LLM_RAG_REQUIRED
  - BOUNDED_PROTOTYPE_LOCAL_PERSISTENCE
  - NO_PRODUCTION_BACKUP_SYNC
  - NO_MULTI_SPEAKER_DIARIZATION
  - NO_PRODUCTION_RELEASE

not_allowed_as_known_limitation:
  - FIRST_VIEW_REQUIRES_ENGINEERING_BRIEFING
  - PRIMARY_VIEW_DOMINATED_BY_TEST_FIXTURE_OR_DIAGNOSTIC_LOGS
  - VOICE_RECORDING_ENTRY_NOT_DISCOVERABLE
  - RECORDING_STATE_NOT_DISTINGUISHABLE
  - NO_VISIBLE_TRANSCRIPT_TO_NOTE_ACTION
  - ORGANIZED_NOTE_ERASES_ORIGINAL_TRANSCRIPT
  - SAVED_NOTE_CANNOT_BE_REOPENED
  - SAVE_CANCEL_SEMANTICS_AMBIGUOUS
  - UNSAVED_DRAFT_SILENTLY_BECOMES_KNOWLEDGE

privacy_and_security:
  users: SINGLE_USER
  exposure: LOCAL_SIMULATOR
  synthetic_non_sensitive_test_data: REQUIRED
  raw_owner_audio_in_git: FORBIDDEN
  private_owner_transcript_in_git: FORBIDDEN
  speaker_embedding_or_voiceprint_in_git: FORBIDDEN
  secrets_in_repo: FORBIDDEN
  cloud_audio_upload: FORBIDDEN
  silent_cloud_fallback: FORBIDDEN

ui_lineage:
  authority_commit: 15a50071202536af05c51e45e04b738dcc81cbdf
  authority_tree: a63446138525020ab269c630c6507b6e7be74870
  authority_path: reports/prototype/knowme-knowledge-01-agent-native-mate60/r3-ui-authority/KnowMe-NJX-Demo.html
  authority_blob: 097e2c978877f5480a63e9da55acf5fb27e60a43
  required_grammar:
    - CENTER=AGENT_CONVERSATION_AND_CALLABLE_WORK
    - CAPTURE=VOICE_FILE_WEB_TEXT_CAPTURE
    - ACTIVE_WORK=CONTEXTUAL_WORK_SURFACE_WITH_AGENT_CONTEXT_PRESERVED
    - DASHBOARD_FIRST=FORBIDDEN
    - GENERIC_CHAT_WIDGET_ONLY=FORBIDDEN

evidence_ownership:
  engineering_required:
    - exact_candidate_sha_tree_parent
    - candidate_manifest
    - technical_receipt
    - allowed_path_diff_receipt
    - exact_simulator_build_identity
    - tests_and_regression
    - first_view_receipt
    - voice_identity_entry_receipt
    - recording_state_receipt
    - transcript_candidate_receipt
    - transcript_to_note_receipt
    - note_provenance_receipt
    - save_cancel_dedup_receipt
    - recovery_receipt
    - agent_first_surface_receipt
    - Local Executor final exact-candidate deployment_and_operation
    - ED personal final exact-candidate operation
    - privacy_safe_screenshot_index_for_both_operators
    - runtime_error_receipt
    - privacy_network_boundary_receipt
    - known_in_scope_blocking_defects_none
  admission_required:
    - candidate_branch_pr_head_exact_match
    - forward_derivation_from_exact_handoff_preimage
    - contract_coverage_complete
    - engineering_required_evidence_complete
    - forbidden_path_mutation_absent
    - unapproved_product_deviation_absent
  review_required:
    - exact_candidate_frozen_for_review
    - exact_simulator_build_identity
    - clean_first_use_review_instructions
    - declared_simulator_review_environment_available
    - journeys_A_through_H_identifiable
    - no_candidate_mutation_after_admission
  product_experience:
    - cold_first_use_comprehension
    - voice_identity_entry_comprehension
    - recording_comprehension
    - transcript_control_comprehension
    - organize_into_note_comprehension
    - save_cancel_comprehension
    - provenance_comprehension
    - recovery_comprehension
    - agent_first_comprehension
    - no_blocking_regression
  human_owner: []

engineering_allowed_paths:
  - prototypes/knowme-knowledge-02-voice-speaker-verification/**
  - reports/prototype/knowme-knowledge-03-voice-to-note-first-use/**

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
  human_owner_acceptance: false
  release_authorization: false

product_experience_mode: FULL_EXPERIENCE_REVIEW

closure_conditions:
  - one exact candidate has fresh ENGINEERING_READY against this contract
  - Product Governance admits that exact candidate
  - Product Governance declares that exact candidate PRODUCT_REVIEW_ELIGIBLE
  - independent FULL_EXPERIENCE_REVIEW returns PRODUCT_EXPERIENCE_PASS
  - no unresolved contract-required blocker remains
  - no candidate identity drift exists

claim_ceiling:
  real_device_validated: false
  mate60_compatibility_pass: false
  real_device_asr_pass: false
  real_device_speaker_verification_pass: false
  production_biometric_identity: false
  real_llm_rag_complete: false
  production_persistence_claim: false
  release_authorized: false

frozen_at: 2026-09-21T19:20:00+08:00
contract_path: governance/milestones/GOAL-KK-03-VOICE-TO-NOTE-FIRST-USE-PROTOTYPE/CONTRACT.md
```

Any change to product meaning, required journeys, acceptance outcomes, evidence ownership, security, allowed limitations, Owner gate policy or closure conditions requires Product Governance Change Request.
