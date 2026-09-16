# Allowed-Path Diff Receipt — GOAL-KK-01 (R3, final exact candidate)

```text
ARTIFACT=ALLOWED_PATH_DIFF_RECEIPT
ACTOR_ROLE=ENGINEERING_DELIVERY
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
PREIMAGE_SHA=563997a0eca61800c8c72d23a83888821a6e0841
OPERATED_CANDIDATE_SHA=e6e9c3d87a1c87fa0614aa1a4ec44e354117adde
```

Full diff of the operated final exact candidate against the exact frozen
preimage:

```text
$ git diff --name-only 563997a0eca61800c8c72d23a83888821a6e0841 e6e9c3d87a1c87fa0614aa1a4ec44e354117adde
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
# must equal e6e9c3d87a1c87fa0614aa1a4ec44e354117adde
git rev-parse origin/engineering/goal-kk-01-agent-native-mate60-prototype-r1^{tree}
# must equal beeb0d6e136419036fb71fe5bd31aa8863f9227f
git rev-parse origin/engineering/goal-kk-01-agent-native-mate60-prototype-r1:prototypes/knowme-knowledge-01-agent-native-mate60
# must equal 0641d2e4ee000aac79f9ef2f4f36d1d8c61a53f9
```

Forbidden paths untouched: AGENTS.md, README.md, PROJECT_STATUS.md,
.github/**, governance/**, formal_product_source/**, any other
project/repository. The R3 UI authority (Owner-provided KnowMe-NJX-Demo.html)
was read-only for ED; a byte-identical copy is stored on this evidence branch
at `r3-ui-authority/` (allowed evidence path), not in the candidate. A working
copy also exists untracked at `references/` in the ED workspace (excluded via
.git/info/exclude, never committed).
