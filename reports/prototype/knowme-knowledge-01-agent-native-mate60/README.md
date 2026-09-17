# GOAL-KK-01 Evidence Package (NON_CANDIDATE_EVIDENCE) — KK-PX-R5-02 Disclosure Correction R1 current

```text
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_BRANCH=evidence/goal-kk-01-non-candidate-r2
CANDIDATE_SHA=f89fe6695ebdbfa69e6b569447247120fab0c360
CANDIDATE_TREE=3b1d2a678d945d886df9185459fca6a76f332bf6
CANDIDATE_PARENT=0e859d93960e630965a5b71a3ff4c07e631d8570
ENGINEERING_BRANCH=engineering/goal-kk-01-px02-disclosure-correction-r1
ENGINEERING_PR=#15 (Draft, OPEN, UNMERGED)
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR15_HEAD=NO
```

This branch carries **operation evidence only**. It is not the engineering
candidate, does not modify the candidate, and must never become a PR head.
The engineering candidate lives on
`engineering/goal-kk-01-px02-disclosure-correction-r1` at the SHA above
(code + tests only; evidence lives here, outside candidate bytes).

## Layout

- `*.md` at this level: **PX02 Disclosure Correction R1 (current)** evidence
  receipts binding to candidate `f89fe66…`, produced 2026-09-17 under Product
  Governance authorization (Issue #3 comment 5706266611) to correct the single
  blocking residual from the formal PX retest (Issue #3 comment 5700717563 /
  PR #14): at 360x780 the ON-state in-sheet sensing line visually clipped the
  `模拟 · 无真实 ASR` capability-boundary disclosure (KK-PX-R5-02
  PARTIALLY_FIXED_BLOCKING). The disclosure is now a dedicated non-truncating
  chip in both ON and PAUSED states across all five surfaces. KK-PX-R5-01/03/04
  were CLOSED on the failed candidate and are regression-protected only.
- `screenshots/local-executor/`: Local Executor screenshots (PX2-LE-P01..P12
  + PX2-LE-PX02-<SURFACE>-<ON|PAUSED> ×10).
- `screenshots/ed-personal/`: ED personal operation screenshots (same 22).
- `le-assertions.json` / `ed-browser-assertions.json`: machine-readable
  125/125 assertion receipts of the two independent runs on the final exact SHA.
- `deliverable/`: durable self-contained single-file HTML review artifact
  (sha256 `fff5fe15…eaf539`) + its `file://` 125/125 assertion receipt.
- `px1-historical-superseded/`: PX1 evidence (bound to `0e859d9…`, PR #12),
  superseded, preserved unmodified (HISTORICAL_RECEIPT_REWRITE=NO). Its
  lifecycle results do NOT transfer.
- `r5-historical-superseded/` … `r1-historical-superseded/`: earlier rounds,
  preserved unmodified; `r3-historical-superseded/r3-ui-authority/` holds the
  Owner-provided UI authority copy (sha256 `3ef8605a…fc7d9f`).
