# Allowed-Path Diff Receipt — GOAL-KK-01 (R2, final exact candidate)

```text
ARTIFACT=ALLOWED_PATH_DIFF_RECEIPT
ACTOR_ROLE=ENGINEERING_DELIVERY
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
PREIMAGE_SHA=563997a0eca61800c8c72d23a83888821a6e0841
OPERATED_CANDIDATE_SHA=9f3071e22def4f99cbf3a4589349e628e9e15a97
```

Full diff of the operated final exact candidate against the exact frozen
preimage:

```text
$ git diff --name-only 563997a0eca61800c8c72d23a83888821a6e0841 9f3071e22def4f99cbf3a4589349e628e9e15a97
prototypes/knowme-knowledge-01-agent-native-mate60/.gitignore
prototypes/knowme-knowledge-01-agent-native-mate60/index.html
prototypes/knowme-knowledge-01-agent-native-mate60/package-lock.json
prototypes/knowme-knowledge-01-agent-native-mate60/package.json
prototypes/knowme-knowledge-01-agent-native-mate60/src/App.jsx
prototypes/knowme-knowledge-01-agent-native-mate60/src/fixtures.js
prototypes/knowme-knowledge-01-agent-native-mate60/src/main.jsx
prototypes/knowme-knowledge-01-agent-native-mate60/src/styles.css
prototypes/knowme-knowledge-01-agent-native-mate60/tests/browser_assertions.py
prototypes/knowme-knowledge-01-agent-native-mate60/vite.config.js
```

The candidate contains **code + tests only**. Unlike R1 candidate `d8290e7`
(which carried reports/** inside the candidate), the R2 candidate carries
no reports/ tree at all — every evidence byte lives on the separate
NON_CANDIDATE_EVIDENCE branch `evidence/goal-kk-01-non-candidate-r2`
(this branch), satisfying governance blocker 5691624112.

Verifiable:

```bash
git diff --name-only 563997a0eca61800c8c72d23a83888821a6e0841 origin/engineering/goal-kk-01-agent-native-mate60-prototype-r1
git rev-parse origin/engineering/goal-kk-01-agent-native-mate60-prototype-r1
# must equal 9f3071e22def4f99cbf3a4589349e628e9e15a97
git rev-parse origin/engineering/goal-kk-01-agent-native-mate60-prototype-r1^{tree}
# must equal b165a075f4e6a3784c6fc7794fc8c5581dc539c0
git rev-parse origin/engineering/goal-kk-01-agent-native-mate60-prototype-r1:prototypes/knowme-knowledge-01-agent-native-mate60
# must equal e0c147e48aa6407dcf7b6da323ef01e00492659b
```

Forbidden paths untouched: AGENTS.md, README.md, PROJECT_STATUS.md,
.github/**, governance/**, formal_product_source/**, any other
project/repository. KnowMe Demo was read-only (lineage reference only).
