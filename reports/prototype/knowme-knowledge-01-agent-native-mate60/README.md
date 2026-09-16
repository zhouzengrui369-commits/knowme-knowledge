# GOAL-KK-01 Evidence Package (NON_CANDIDATE_EVIDENCE)

```text
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_BRANCH=evidence/goal-kk-01-non-candidate-r2
CANDIDATE_SHA=9f3071e22def4f99cbf3a4589349e628e9e15a97
CANDIDATE_TREE=b165a075f4e6a3784c6fc7794fc8c5581dc539c0
CANDIDATE_PARENT=d8290e7a216b647ec2853f9f4522d97f77129281
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
```

This branch carries **operation evidence only**. It is not the engineering
candidate, does not modify the candidate, and must never become PR #9 head.
The engineering candidate lives on
`engineering/goal-kk-01-agent-native-mate60-prototype-r1` at the SHA above
(code + tests only; by governance requirement the candidate contains **no**
reports/ tree — all evidence lives here, outside the candidate bytes).

## Layout

- `*.md` at this level: R2 evidence receipts binding to candidate
  `9f3071e…` (fresh, produced 2026-09-16 after Owner-directed iteration).
- `screenshots/local-executor/`: R2 Local Executor screenshots (R2-LE-P01..P10)
  + `le-run-metadata.json`.
- `screenshots/ed-personal/`: R2 ED personal operation screenshots
  (R2-ED-P01..P10).
- `le-assertions.json` / `ed-browser-assertions.json`: machine-readable
  57/57 assertion receipts of the two independent runs.
- `r1-historical-superseded/`: byte-identical restore of the R1 evidence
  package as committed in `d8290e7…` (bound to R1 operated candidate
  `fb43216…`). **Superseded for engineering evidence binding** by the R2
  package; kept as unmodified history (HISTORICAL_RECEIPT_REWRITE=NO). See
  `r1-historical-superseded/SUPERSEDED_NOTICE.md`.
