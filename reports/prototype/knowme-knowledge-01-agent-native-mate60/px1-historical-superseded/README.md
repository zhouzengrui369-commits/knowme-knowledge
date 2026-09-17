# GOAL-KK-01 Evidence Package (NON_CANDIDATE_EVIDENCE) — PX Findings Correction R1 current

```text
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_BRANCH=evidence/goal-kk-01-non-candidate-r2
CANDIDATE_SHA=0e859d93960e630965a5b71a3ff4c07e631d8570
CANDIDATE_TREE=f93f4cfa9c539c22873e228df2738a21cb2bd1b9
CANDIDATE_PARENT=40063afd16a36674e8660f6b4a05315d51f4e546
ENGINEERING_BRANCH=engineering/goal-kk-01-px-findings-correction-r1
ENGINEERING_PR=#12 (Draft, OPEN, UNMERGED)
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR12_HEAD=NO
```

This branch carries **operation evidence only**. It is not the engineering
candidate, does not modify the candidate, and must never become a PR head.
The engineering candidate lives on
`engineering/goal-kk-01-px-findings-correction-r1` at the SHA above
(code + tests only; evidence lives here, outside candidate bytes).

## Layout

- `*.md` at this level: **PX Findings Correction R1 (current)** evidence
  receipts binding to candidate `0e859d9…`, produced 2026-09-16 under Product
  Governance authorization (Issue #3 comment 5698309228) to correct the four
  Contract R2 defects recorded by exploratory review PR #11:
  KK-PX-R5-01 knowledge semantic mismatch, KK-PX-R5-02 sensing hidden under
  overlays, KK-PX-R5-03 correction/confirmation conflict, KK-PX-R5-04
  return-target mismatch — plus two local low-risk P3 fixes (postponed
  schedule ordering; reference-reply date duplication).
- `screenshots/local-executor/`: Local Executor screenshots (PX1-LE-P01..P12).
- `screenshots/ed-personal/`: ED personal operation screenshots (PX1-ED-P01..P12).
- `le-assertions.json` / `ed-browser-assertions.json`: machine-readable
  115/115 assertion receipts of the two independent runs on the final exact SHA.
- `deliverable/`: durable self-contained single-file HTML review artifact
  (sha256 `9db96a26…a2a02`) + its `file://` 115/115 assertion receipt.
- `r5-historical-superseded/`: R5 evidence (bound to `40063af…`, PR #9),
  superseded by this successor candidate, preserved unmodified
  (HISTORICAL_RECEIPT_REWRITE=NO). R5 lifecycle results do NOT transfer.
- `r4-historical-superseded/` … `r1-historical-superseded/`: earlier rounds,
  preserved unmodified; `r3-historical-superseded/r3-ui-authority/` holds the
  Owner-provided UI authority copy (sha256 `3ef8605a…fc7d9f`).
