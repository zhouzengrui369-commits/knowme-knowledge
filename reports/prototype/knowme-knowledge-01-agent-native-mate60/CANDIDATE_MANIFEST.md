# Candidate Manifest — GOAL-KK-01 (PX Findings Correction R1, final exact successor candidate)

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
artifact: CANDIDATE_MANIFEST
actor_role: ENGINEERING_DELIVERY
actor_context_id: ED-KK-GOAL01-PX-FINDINGS-CORRECTION-R1-20260916-2100-4F8C

evidence_channel_role: NON_CANDIDATE_EVIDENCE
evidence_branch: evidence/goal-kk-01-non-candidate-r2
evidence_commit_is_candidate: NO
move_pr12_head: NO

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
new_change_request_required: NO   # PG adjudicated, Issue #3 comment 5698309228
correction_authority: Issue #3 comment 5698309228 (ENGINEERING_CORRECTION_AUTHORIZED)
exploratory_findings_source: PR #11 @ e095af1fa6bfc988360c252bd16e6dbdef2262ee (evidence only)

candidate_sha: 0e859d93960e630965a5b71a3ff4c07e631d8570
candidate_tree: f93f4cfa9c539c22873e228df2738a21cb2bd1b9
candidate_parent: 40063afd16a36674e8660f6b4a05315d51f4e546   # exact preimage, forward-only
engineering_branch: engineering/goal-kk-01-px-findings-correction-r1
engineering_pr: "#12 (Draft, OPEN, UNMERGED)"
branch_head_match: YES
pr_head_match: YES
candidate_composition: CODE_AND_TESTS_ONLY
previous_candidate: 40063afd16a36674e8660f6b4a05315d51f4e546  # PR #9, historical, unmoved
lifecycle_inheritance: NONE (prior ENGINEERING_READY / CANDIDATE_ADMITTED / PRODUCT_REVIEW_ELIGIBLE do not transfer)

implemented_scope:
  - KK-PX-R5-01 (P1) knowledge semantic consistency:
      Agent replies render only matched items' own title/summary/conclusion;
      honest note when no deterministic conclusion exists; unknown topics get an
      honest gap with zero unrelated references; work surfaces render the
      item's own content; conflict counts no longer fabricated.
  - KK-PX-R5-02 (P1) continuous sensing visible under overlays:
      in-sheet sensing bar (status + 模拟·无真实 ASR disclosure + 暂停/恢复,
      synced with global strip) in Knowledge / Knowledge Detail / Work Surface /
      Calendar / Todo; verified SENSING=ON and PAUSED at 360x780.
  - KK-PX-R5-03 (P2) correction/confirmation semantics — model A:
      保存修正 updates the candidate draft and returns to the candidate card
      (predictability hint shown); ingestion only via explicit 确认入库;
      confirmed items drop the 待确认 tag — one trustworthy state.
  - KK-PX-R5-04 (P2) return-target consistency — option A:
      「返回 Agent 对话」 returns DIRECTLY to the Agent conversation from both
      entry paths (knowledge navigation; Agent next action); conversation and
      knowledge context preserved.
  - P3 (local, low-risk, within authorization):
      postponed schedule stays time-ordered (day + week views);
      reference reply no longer duplicates the date label.

regression_protected:
  - 灵犀 Agent-first identity; capture confirm/correct/reject journey
  - 五维知识地图 + 九维认知图谱 navigation (no extra groupings)
  - knowledge calendar 日/周/月; Calendar 日/周/月; Todo → Calendar day deep link
  - schedule/todo quick actions (完成/顺延) + 引用对话
  - honest NOT_CONNECTED / PROTOTYPE_ONLY / PLANNED states
  - 360x780 portrait usability; no real AI/RAG/ASR/backend claims

verification:
  browser_assertion_suite: 115 assertions (80 -> 115, +35 PX acceptance/regression)
  local_executor_run: 115/115 — fresh clone at exact SHA, port 5174, console/page errors empty, post-run git status clean
  ed_personal_run: 115/115 — post-commit HEAD re-verified, port 5173, console/page errors empty, screenshots visually reviewed
  file_protocol_run: 115/115 — self-contained HTML via file:// URL
  no_parent_commit_evidence_transfer: YES

self_contained_html:
  path: deliverable/KnowME-Knowledge-01-Prototype.html
  sha256: 9db96a26a6821c134d2ca543ebd5016f0654ac60bc6eb48976ceb4e3cd6a2a02
  source_candidate_sha: 0e859d93960e630965a5b71a3ff4c07e631d8570
  file_protocol_assertions: deliverable/file-protocol-assertions.json (115/115)

defects:
  round_defects_fixed:
    - KK-PX-R5-01, KK-PX-R5-02, KK-PX-R5-03, KK-PX-R5-04 (acceptance PASS)
    - P3 postponed-schedule ordering; P3 reference-reply date duplication
  new_defects_found_this_round: none (115/115 first full loop on final SHA ×2 operators; smoke screenshot review clean)

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

issued_at: "2026-09-16T22:45:00Z"
```
