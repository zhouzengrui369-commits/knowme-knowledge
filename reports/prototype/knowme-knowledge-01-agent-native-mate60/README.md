# GOAL-KK-01 Evidence Package (NON_CANDIDATE_EVIDENCE) — R3 current

```text
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_BRANCH=evidence/goal-kk-01-non-candidate-r2
CANDIDATE_SHA=e6e9c3d87a1c87fa0614aa1a4ec44e354117adde
CANDIDATE_TREE=beeb0d6e136419036fb71fe5bd31aa8863f9227f
CANDIDATE_PARENT=9f3071e22def4f99cbf3a4589349e628e9e15a97
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
```

This branch carries **operation evidence only**. It is not the engineering
candidate, does not modify the candidate, and must never become PR #9 head.
The engineering candidate lives on
`engineering/goal-kk-01-agent-native-mate60-prototype-r1` at the SHA above
(code + tests only; evidence lives here, outside candidate bytes).

## Layout

- `*.md` at this level: **R3 (current)** evidence receipts binding to
  candidate `e6e9c3d…`, produced 2026-09-16 after the Owner supplied the
  authoritative KnowMe-NJX-Demo and directed: knowledge navigation with
  五维知识地图 + 九维认知图谱; calendar with 月/周/日 three views.
- `screenshots/local-executor/`: R3 Local Executor screenshots (R3-LE-P01..P12).
- `screenshots/ed-personal/`: R3 ED personal operation screenshots (R3-ED-P01..P12).
- `le-assertions.json` / `ed-browser-assertions.json`: machine-readable
  67/67 assertion receipts of the two independent runs on the final exact SHA.
- `r3-ui-authority/KnowMe-NJX-Demo.html`: byte-identical copy of the
  Owner-provided UI authority (sha256
  3ef8605a6b74c6514ee7097d24100d5f06e258b2e6bbdb03e591a02a51fc7d9f).
- `r2-historical-superseded/`: R2 evidence (bound to `9f3071e…`), superseded
  by R3, preserved unmodified (HISTORICAL_RECEIPT_REWRITE=NO).
- `r1-historical-superseded/`: R1 evidence (bound to `fb43216…`), superseded,
  preserved unmodified.
