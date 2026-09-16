# Allowed-Path Diff Receipt — GOAL-KK-01

```text
ARTIFACT=ALLOWED_PATH_DIFF_RECEIPT
ACTOR_ROLE=ENGINEERING_DELIVERY
PREIMAGE_SHA=563997a0eca61800c8c72d23a83888821a6e0841
OPERATED_CANDIDATE_SHA=fb432162e7dd099a32fec7b52ff00659982942f3
```

Full diff of the operated candidate against the exact frozen preimage:

```text
$ git diff --name-only 563997a0eca61800c8c72d23a83888821a6e0841 fb432162e7dd099a32fec7b52ff00659982942f3
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

The final candidate commit additionally adds only
`reports/prototype/knowme-knowledge-01-agent-native-mate60/**` (this evidence
package). Verifiable:

```bash
git diff --name-only 563997a0eca61800c8c72d23a83888821a6e0841 origin/engineering/goal-kk-01-agent-native-mate60-prototype-r1
git rev-parse origin/engineering/goal-kk-01-agent-native-mate60-prototype-r1:prototypes/knowme-knowledge-01-agent-native-mate60
# must equal 9e60f229be9f8737b4db66cb1f7ea83d1b804201
```

Forbidden paths untouched: AGENTS.md, README.md, PROJECT_STATUS.md,
.github/**, governance/**, formal_product_source/**, any other
project/repository. KnowMe Demo was read-only (lineage reference only).
