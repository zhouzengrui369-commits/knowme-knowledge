# Candidate Manifest — GOAL-KK-01 (PX02 Disclosure Correction R1, exact successor candidate)

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
artifact: CANDIDATE_MANIFEST
actor_role: ENGINEERING_DELIVERY
actor_context_id: ED-KK-GOAL01-PX02-DISCLOSURE-CORRECTION-R1-20260917-0925-D7A2

evidence_channel_role: NON_CANDIDATE_EVIDENCE
evidence_branch: evidence/goal-kk-01-non-candidate-r2
evidence_commit_is_candidate: NO
move_pr15_head: NO

goal_id: GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
product_baseline: PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2
product_contract_revision: R2
product_contract_commit: 978ed0608bda8e278c348ad2987f6a25fa3c3c2f
product_contract_tree: db0be0e4ac22b9780cf5cf3c80998d3cfd15731d
product_contract_blob: 05bc2ca7cce5e8645301994b348f702f2286d3f3
product_contract_path: governance/milestones/GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE/CONTRACT-R2.md
approved_change_requests:
  - CR-KK-01-OWNER-DIRECTED-R2-R3
new_change_request_required: NO   # PG adjudicated, Issue #3 comment 5706266611
correction_authority: Issue #3 comment 5706266611 (ENGINEERING_CORRECTION_AUTHORIZED, scope frozen to KK-PX-R5-02 residual + regression protection)
failed_px_ref: Issue #3 comment 5700717563 / PR #14 (PX1 candidate 0e859d9 judged PRODUCT_EXPERIENCE FAIL)
exploratory_findings_source: PR #11 @ e095af1fa6bfc988360c252bd16e6dbdef2262ee (evidence only)

candidate_sha: f89fe6695ebdbfa69e6b569447247120fab0c360
candidate_tree: 3b1d2a678d945d886df9185459fca6a76f332bf6
candidate_parent: 0e859d93960e630965a5b71a3ff4c07e631d8570   # exact preimage, forward-only
engineering_branch: engineering/goal-kk-01-px02-disclosure-correction-r1
engineering_pr: "#15 (Draft, OPEN, UNMERGED)"
branch_head_match: YES
pr_head_match: YES
candidate_composition: CODE_AND_TESTS_ONLY
previous_candidate: 0e859d93960e630965a5b71a3ff4c07e631d8570  # PR #12, failed-PX history, unmoved
lifecycle_inheritance: NONE (prior ENGINEERING_READY / CANDIDATE_ADMITTED / PRODUCT_REVIEW_ELIGIBLE do not transfer)

implemented_scope:
  - KK-PX-R5-02 residual (the ONLY PX1 blocking residual per failed-PX adjudication):
      in-sheet sensing bar restructured into two rows — row 1 carries the signal,
      state text (后台持续感知中 / 感知已暂停), a dedicated non-truncated disclosure
      chip 「模拟 · 无真实 ASR」 (data-testid="sheet-sensing-disclosure",
      flex-shrink: 0), and the 暂停/恢复 toggle; row 2 carries the dynamic sensing
      line (ellipsis allowed). The disclosure is now fully readable at 360x780
      on all five sheet surfaces, in both SENSING=ON and PAUSED states.
  - Regression protection only: no other product behavior was changed;
    KK-PX-R5-01 / R5-03 / R5-04 and the two P3 fixes remain exactly as in
    candidate 0e859d9 and are covered by the unchanged assertion set.

regression_protected:
  - 灵犀 Agent-first identity; capture confirm/correct/reject journey
  - 五维知识地图 + 九维认知图谱 navigation (no extra groupings)
  - knowledge calendar 日/周/月; Calendar 日/周/月; Todo → Calendar day deep link
  - schedule/todo quick actions (完成/顺延) + 引用对话
  - honest NOT_CONNECTED / PROTOTYPE_ONLY / PLANNED states
  - KK-PX-R5-01 semantic consistency; R5-03 correction model A; R5-04 return-target option A
  - 360x780 portrait usability; no real AI/RAG/ASR/backend claims

verification:
  browser_assertion_suite: 125 assertions (115 -> 125, +10 PX02 disclosure-full assertions:
      PX02_DISCLOSURE_FULL_<ON|PAUSED>_<surface> × 5 surfaces × 2 states, each asserting
      scrollWidth <= clientWidth + 1 AND full disclosure text present)
  local_executor_run: 125/125 — exact-SHA materialization, port 5174, console/page errors empty
  ed_personal_run: 125/125 — post-commit HEAD re-verified, port 5173, console/page errors empty, screenshots visually reviewed
  file_protocol_run: 125/125 — self-contained HTML via file:// URL
  no_parent_commit_evidence_transfer: YES

self_contained_html:
  path: deliverable/KnowME-Knowledge-01-Prototype.html
  sha256: fff5fe152c204471263a97d9753a09317dea2d08e4aec585ab25dff5b5eaf539
  source_candidate_sha: f89fe6695ebdbfa69e6b569447247120fab0c360
  file_protocol_assertions: deliverable/file-protocol-assertions.json (125/125)

defects:
  round_defects_fixed:
    - KK-PX-R5-02 residual: disclosure chip truncated on ON-state sheets
      (reviewer-measured clientWidth=254 / scrollWidth=404) — now a dedicated
      non-truncated chip, verified fully visible in both sensing states.
  regression_status:
    - KK-PX-R5-01 / R5-03 / R5-04: CLOSED, regression-protected (unchanged assertions all PASS)
  new_defects_found_this_round: none (125/125 first full loop on final SHA ×2 operators; smoke screenshot review clean)

known_limitations: all within Contract R2 allowed_known_limitations
  (BROWSER_PROTOTYPE_ONLY, DETERMINISTIC_MOCK_RUNTIME, NO_REAL_MODEL/HARNESS/PROVIDER,
   NO_REAL_PERSISTENCE_REQUIRED, NO_REAL_VOICE/ASR/IMPORT_PIPELINE/RAG,
   NO_REAL_CALENDAR_TODO_BACKEND, NO_REAL_OWNER_DATA;
   viewport evidence 360x780 MATE60_CLASS_SIMULATION)

not_implemented_by_contract:
  - HarmonyOS formal implementation; real Harness/Provider/Agent runtime;
    long-term memory/RAG/vector store/Wiki index; real ASR/voiceprint;
    real import pipeline; real Calendar/Todo backend; Demo 2D-relation/3D
    star-map rendering; Skills; real persistence; real Owner data; production deployment

unresolved_within_contract: none

forbidden_claims:
  - CANDIDATE_ADMITTED
  - PRODUCT_REVIEW_ELIGIBLE
  - PRODUCT_EXPERIENCE_PASS
  - HUMAN_OWNER_ACCEPTED
  - MERGE
  - RELEASE
  - GOAL_MILESTONE_CLOSED

issued_at: "2026-09-17T10:05:00Z"
```
