# Allowed-Path Diff Receipt — GOAL-KK-01 PX02 Disclosure Correction R1

```text
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
CANDIDATE_SHA=f89fe6695ebdbfa69e6b569447247120fab0c360
CANDIDATE_PARENT=0e859d93960e630965a5b71a3ff4c07e631d8570 (exact preimage)
DIFF_RANGE=0e859d93960e630965a5b71a3ff4c07e631d8570..f89fe6695ebdbfa69e6b569447247120fab0c360
```

## Files changed (candidate diff, complete list)

```text
prototypes/knowme-knowledge-01-agent-native-mate60/src/App.jsx      (modified)
prototypes/knowme-knowledge-01-agent-native-mate60/src/styles.css   (modified)
prototypes/knowme-knowledge-01-agent-native-mate60/tests/browser_assertions.py (modified)
```

3 files changed, 52 insertions(+), 22 deletions(-) — all inside the
contract-allowed prototype source and its technical test suite. The diff is the
single authorized KK-PX-R5-02 residual correction (in-sheet disclosure chip)
plus its regression assertions; no other product behavior changed.

## Forbidden-path check

```text
governance/**                 NO CHANGES
PRODUCT_BASELINE / CONTRACT   NO CHANGES
reports/**                    NOT IN CANDIDATE (evidence lives on evidence branch only)
.github/**                    NO CHANGES
PR #9 branch                  UNMOVED (still 40063af)
PR #12 branch                 UNMOVED (still 0e859d9, failed-PX history)
PR #14                      UNMOVED (failed-PX adjudication record)
```

```text
FORBIDDEN_PATH_MUTATION=NONE
UNAPPROVED_DEVIATIONS=NONE
```
