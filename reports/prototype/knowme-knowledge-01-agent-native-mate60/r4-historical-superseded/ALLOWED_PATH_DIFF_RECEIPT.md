# Allowed-Path Diff Receipt — GOAL-KK-01 (R4, final exact candidate)

```text
ARTIFACT=ALLOWED_PATH_DIFF_RECEIPT
ACTOR_ROLE=ENGINEERING_DELIVERY
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
PREIMAGE_SHA=563997a0eca61800c8c72d23a83888821a6e0841
OPERATED_CANDIDATE_SHA=3c2088888a0896f9bb0149560dcfbf5412adb2f4
```

Full diff of the operated final exact candidate against the exact frozen
preimage:

```text
$ git diff --name-only 563997a0eca61800c8c72d23a83888821a6e0841 3c2088888a0896f9bb0149560dcfbf5412adb2f4
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

The candidate contains **code + tests only**; every evidence byte lives on
this NON_CANDIDATE_EVIDENCE branch.

Verifiable:

```bash
git rev-parse origin/engineering/goal-kk-01-agent-native-mate60-prototype-r1
# must equal 3c2088888a0896f9bb0149560dcfbf5412adb2f4
git rev-parse origin/engineering/goal-kk-01-agent-native-mate60-prototype-r1^{tree}
# must equal 625a7f471b0c723debb4a0295da3b4cd6c72a178
git rev-parse origin/engineering/goal-kk-01-agent-native-mate60-prototype-r1:prototypes/knowme-knowledge-01-agent-native-mate60
# must equal 5f9045aba9a53650f7e59201fe171a3e80c6a0ba
```

Forbidden paths untouched: AGENTS.md, README.md, PROJECT_STATUS.md,
.github/**, governance/**, formal_product_source/**, any other
project/repository. The UI authority (Owner-provided KnowMe-NJX-Demo.html)
was read-only for ED; a byte-identical copy is stored on this evidence branch
at `r3-historical-superseded/r3-ui-authority/` (allowed evidence path), not in the candidate. A working
copy also exists untracked at `references/` in the ED workspace (excluded via
.git/info/exclude, never committed).
