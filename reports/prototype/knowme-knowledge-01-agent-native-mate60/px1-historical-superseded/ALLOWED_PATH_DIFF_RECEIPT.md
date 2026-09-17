# Allowed-Path Diff Receipt — GOAL-KK-01 PX Findings Correction R1

```text
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
CANDIDATE_SHA=0e859d93960e630965a5b71a3ff4c07e631d8570
CANDIDATE_PARENT=40063afd16a36674e8660f6b4a05315d51f4e546 (exact preimage)
DIFF_RANGE=40063afd16a36674e8660f6b4a05315d51f4e546..0e859d93960e630965a5b71a3ff4c07e631d8570
```

## Files changed (candidate diff, complete list)

```text
prototypes/knowme-knowledge-01-agent-native-mate60/src/App.jsx      (modified)
prototypes/knowme-knowledge-01-agent-native-mate60/src/fixtures.js  (modified)
prototypes/knowme-knowledge-01-agent-native-mate60/src/styles.css   (modified)
prototypes/knowme-knowledge-01-agent-native-mate60/tests/browser_assertions.py (modified)
```

4 files changed, 382 insertions(+), 55 deletions(-) — all inside the
contract-allowed prototype source and its technical test suite.

## Forbidden-path check

```text
governance/**                 NO CHANGES
PRODUCT_BASELINE / CONTRACT   NO CHANGES
reports/**                    NOT IN CANDIDATE (evidence lives on evidence branch only)
.github/**                    NO CHANGES
PR #9 branch                  UNMOVED (still 40063af)
```

```text
FORBIDDEN_PATH_MUTATION=NONE
UNAPPROVED_DEVIATIONS=NONE
```
