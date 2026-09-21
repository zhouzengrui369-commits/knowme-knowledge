# CANDIDATE MANIFEST — GOAL-KK-02 Contract R3 / PX-KK02-R3-06 P2 Correction

- 生成时间：2026-09-21（Asia/Shanghai）
- 生成者：ED-KK-GOAL02-R3-PX02-P2-CORRECTION-20260920-1645-A19D（INDEPENDENT_ENGINEERING_DELIVERY）

## Exact Candidate Identity

```text
GOAL_ID=GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
MILESTONE_ID=MILESTONE-GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
CONTRACT_REVISION=R3
CONTRACT_COMMIT=168af57a2e7bd74385cecd97da1717982ac12ab1
CONTRACT_TREE=ae8c768218a7f517bd951a1b1a3f5b9354bcc932
CONTRACT_BLOB=b0ae8dbc980bc64f16bb77b30eaf5dbe9da64541

CANDIDATE_SHA=3317469085d8dc10a88818369ffcc2922904079c
CANDIDATE_TREE=c688e8d6da0fe5fdaa12f2412158eb0c6d86ee15
CANDIDATE_PARENT=6d3a4c1ec4bbaf38aa1b11183fe6adaf1807da94
CANDIDATE_BRANCH=engineering/goal-kk-02-r3-px02-p2-correction-r1
PREIMAGE_BRANCH=governance/goal-kk-02-r3-px02-p2-correction-r1 (PR #26, OPEN DRAFT)
PREIMAGE_SHA=6d3a4c1ec4bbaf38aa1b11183fe6adaf1807da94
PRIOR_CANDIDATE=06b013cf776d308737cf6726afcff7ee4831f5f4 (PR #24, admitted baseline of this correction)

BRANCH_HEAD_MATCH=YES (branch head == CANDIDATE_SHA at commit time; verified before push)
WORKTREE_CLEAN=YES (git status --porcelain empty except untracked provisioned .onnx runtime assets, gitignored)
```

## Build Artifacts (built from CANDIDATE_SHA in clean worktree kk02-px02-le)

```text
MAIN_HAP=entry-default-unsigned.hap
MAIN_HAP_SHA256=05111cd04294f937839345e09b1af08aadefdc8b6cac1147f7eb4202622ca7f8
OHOSTEST_HAP=entry-ohosTest-unsigned.hap
OHOSTEST_HAP_SHA256=8a3e260725b76081a01d50938f7ac31a70945fecda8d7c1a03281106536b9c63
MODEL_SHA256=e2d2048292e055f7b61cdec3db010503f35369b245bf0b3bbad021c9a91e4053 (provision-models.sh OK)
UNIT_TESTS=48 run / 48 pass / 0 failure / 0 error (on-device Hypium)
```

## Deploy / Operation Environment

```text
DEVICE=OpenHarmony API 24 phone emulator (emulator 6.1.0.126), hdc target 127.0.0.1:5555
BUNDLE=com.knowme.knowledge.voiceprototype (version 0.1.0)
REAL_DEVICE=NO — Mate60 / any physical hardware NOT used, NOT reviewed, NOT validated
```

## Governance References

```text
PX_FINDING_AUTHORITY=PR #25 REVIEW.md (FOCUSED_RETEST, verdict READY_WITH_MANDATORY_FIXES, open_p2=[PX-KK02-R3-06])
PX_RECONCILIATION_REF=Issue #13 comment 5748720506
ENGINEERING_ACTIVATION_REF=Issue #13 comment 5748723571
HANDOFF_CONTRACT=governance/milestones/GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE/ENGINEERING_HANDOFF_R3_PX02_P2_CORRECTION.md
```

## Change Summary (candidate vs preimage)

```text
prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/voice/VoiceSessionController.ets  +22/-2
prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/test/FixtureDemo.test.ets     +49/-0
2 files changed, 71 insertions(+), 2 deletions(-)
```

## Claim Ceiling (unchanged, inherited from Contract R3)

```text
REAL_DEVICE_NOT_REVIEWED=YES
NOT_REAL_DEVICE_VALIDATED=YES
MATE60_COMPATIBILITY_CLAIMED=NO
REAL_DEVICE_ASR_CLAIMED=NO
REAL_DEVICE_SPEAKER_VERIFICATION_CLAIMED=NO
PRODUCTION_PERSISTENCE_CLAIMED=NO
CANDIDATE_ADMITTED=NOT_CLAIMED
PRODUCT_REVIEW_ELIGIBLE=NOT_CLAIMED
PRODUCT_EXPERIENCE_PASS=NOT_CLAIMED
HUMAN_OWNER_ACCEPTED=NOT_CLAIMED
MERGE/RELEASE/GOAL_CLOSED=NOT_CLAIMED
```
