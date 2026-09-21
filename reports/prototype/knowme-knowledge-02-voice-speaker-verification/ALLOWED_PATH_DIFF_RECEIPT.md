# ALLOWED PATH DIFF RECEIPT — PX-KK02-R3-06 Correction

- ED_CONTEXT_ID=ED-KK-GOAL02-R3-PX02-P2-CORRECTION-20260920-1645-A19D
- CANDIDATE_SHA=3317469085d8dc10a88818369ffcc2922904079c
- PREIMAGE_SHA=6d3a4c1ec4bbaf38aa1b11183fe6adaf1807da94

## Allowed write paths (per activation / GOVERNANCE_LOCK)

```text
prototypes/knowme-knowledge-02-voice-speaker-verification/**
reports/prototype/knowme-knowledge-02-voice-speaker-verification/**
```

## Candidate diff (preimage → candidate)

```text
git diff 6d3a4c1ec4bbaf38aa1b11183fe6adaf1807da94..3317469085d8dc10a88818369ffcc2922904079c --stat

 .../entry/src/main/ets/voice/VoiceSessionController.ets  | 24 ++++++++++-
 .../entry/src/ohosTest/ets/test/FixtureDemo.test.ets     | 49 ++++++++++++++++++++++
 2 files changed, 71 insertions(+), 2 deletions(-)
```

两个文件均位于 `prototypes/knowme-knowledge-02-voice-speaker-verification/**` 内。

## Compliance check

```text
GOVERNANCE_FILES_TOUCHED=NO
CONTRACT_FILES_TOUCHED=NO (CONTRACT-R3.md blob 逐字核验 = b0ae8dbc980bc64f16bb77b30eaf5dbe9da64541，未变)
OUT_OF_SCOPE_PATHS_TOUCHED=NONE
INTERNAL_STATE_OR_THRESHOLD_MANIPULATION=NONE（无内部状态/阈值修改伪造候选路径）
TRUST_GATE_WEAKENING=NONE（未触碰声纹 trust gate 逻辑）
EVIDENCE_IN_CANDIDATE_BRANCH=NO（证据走独立分支 evidence/goal-kk-02-r3-px02-p2-correction-r1）
```

## Evidence branch diff (candidate → evidence)

本证据包仅落在 `reports/prototype/knowme-knowledge-02-voice-speaker-verification/**`（receipts + screenshots），不改动任何原型源码/测试/治理文件；候选 PR head 不因证据提交而移动。
