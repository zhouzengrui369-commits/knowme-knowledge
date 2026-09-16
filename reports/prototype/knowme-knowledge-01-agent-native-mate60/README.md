# GOAL-KK-01 Evidence Package (NON_CANDIDATE_EVIDENCE) — R4 current

```text
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_BRANCH=evidence/goal-kk-01-non-candidate-r2
CANDIDATE_SHA=3c2088888a0896f9bb0149560dcfbf5412adb2f4
CANDIDATE_TREE=625a7f471b0c723debb4a0295da3b4cd6c72a178
CANDIDATE_PARENT=e6e9c3d87a1c87fa0614aa1a4ec44e354117adde
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
```

This branch carries **operation evidence only**. It is not the engineering
candidate, does not modify the candidate, and must never become PR #9 head.
The engineering candidate lives on
`engineering/goal-kk-01-agent-native-mate60-prototype-r1` at the SHA above
(code + tests only; evidence lives here, outside candidate bytes).

## Layout

- `*.md` at this level: **R4 (current)** evidence receipts binding to
  candidate `3c20888…`, produced 2026-09-16 after the Owner directed the
  brand rename 懂我 → 灵犀 (consistent with the authoritative Demo's
  「灵犀 · Digital Brain」). R3's Owner-directed surfaces (五维知识地图 +
  九维认知图谱 in knowledge navigation; calendar 月/周/日 three views) are
  unchanged and re-verified.
- `screenshots/local-executor/`: R4 Local Executor screenshots (R4-LE-P01..P12).
- `screenshots/ed-personal/`: R4 ED personal operation screenshots (R4-ED-P01..P12).
- `le-assertions.json` / `ed-browser-assertions.json`: machine-readable
  68/68 assertion receipts of the two independent runs on the final exact SHA.
- `r3-historical-superseded/`: R3 evidence (bound to `e6e9c3d…`), superseded
  by R4, preserved unmodified (HISTORICAL_RECEIPT_REWRITE=NO); also holds
  `r3-ui-authority/KnowMe-NJX-Demo.html`, the byte-identical copy of the
  Owner-provided UI authority (sha256
  3ef8605a6b74c6514ee7097d24100d5f06e258b2e6bbdb03e591a02a51fc7d9f).
- `r2-historical-superseded/`: R2 evidence (bound to `9f3071e…`), superseded,
  preserved unmodified.
- `r1-historical-superseded/`: R1 evidence (bound to `fb43216…`), superseded,
  preserved unmodified.
