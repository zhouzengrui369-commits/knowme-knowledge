# GOAL-KK-01 Evidence Package (NON_CANDIDATE_EVIDENCE) — R5 current

```text
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_BRANCH=evidence/goal-kk-01-non-candidate-r2
CANDIDATE_SHA=40063afd16a36674e8660f6b4a05315d51f4e546
CANDIDATE_TREE=72464ee6727af4837cb24b77238f7ddadeca02ed
CANDIDATE_PARENT=3c2088888a0896f9bb0149560dcfbf5412adb2f4
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
```

This branch carries **operation evidence only**. It is not the engineering
candidate, does not modify the candidate, and must never become PR #9 head.
The engineering candidate lives on
`engineering/goal-kk-01-agent-native-mate60-prototype-r1` at the SHA above
(code + tests only; evidence lives here, outside candidate bytes).

## Layout

- `*.md` at this level: **R5 (current)** evidence receipts binding to
  candidate `40063af…`, produced 2026-09-16 after the Owner directed three
  product changes: knowledge navigation simplified to 五维知识地图 +
  九维认知图谱 only (extra MOC/WIKI/NOTE groups removed); knowledge
  「按日历查看」 now has 月/周/日 three views matching the schedule calendar;
  schedule/todo entries gained quick actions (完成 / 顺延一天) and
  引用对话 (quote card into the conversation). R4's brand rename (灵犀) and
  R3's Owner-directed surfaces are unchanged and re-verified.
- `screenshots/local-executor/`: R5 Local Executor screenshots (R5-LE-P01..P12).
- `screenshots/ed-personal/`: R5 ED personal operation screenshots (R5-ED-P01..P12).
- `le-assertions.json` / `ed-browser-assertions.json`: machine-readable
  80/80 assertion receipts of the two independent runs on the final exact SHA.
- `deliverable/`: durable self-contained single-file HTML review artifact
  (`KnowME-Knowledge-01-Prototype.html`, built from candidate `40063af…`,
  JS/CSS inlined, opens via `file://`) plus its `file://` 80/80 assertion
  receipt. GitHub-durable since evidence commit `8298491…`:

```text
HTML_GITHUB_REF=evidence/goal-kk-01-non-candidate-r2@82984911ff11cf6ae80e255126fd1f59145da254:reports/prototype/knowme-knowledge-01-agent-native-mate60/deliverable/KnowME-Knowledge-01-Prototype.html
HTML_GITHUB_BLOB=910bb08194c1a42bd8f1ad945709119d99495786
HTML_SHA256=60feb609628659a0a5fcecc9d0fd2ed7d64dc6b765753a0d25dae5190d09afdf
HTML_SHA256_VERIFIED_FROM_GITHUB_BYTES=YES (fresh download 2026-09-16)
```

- `r4-historical-superseded/`: R4 evidence (bound to `3c20888…`), superseded
  by R5, preserved unmodified (HISTORICAL_RECEIPT_REWRITE=NO).
- `r3-historical-superseded/`: R3 evidence (bound to `e6e9c3d…`), superseded,
  preserved unmodified; also holds
  `r3-ui-authority/KnowMe-NJX-Demo.html`, the byte-identical copy of the
  Owner-provided UI authority (sha256
  3ef8605a6b74c6514ee7097d24100d5f06e258b2e6bbdb03e591a02a51fc7d9f).
- `r2-historical-superseded/`: R2 evidence (bound to `9f3071e…`), superseded,
  preserved unmodified.
- `r1-historical-superseded/`: R1 evidence (bound to `fb43216…`), superseded,
  preserved unmodified.
