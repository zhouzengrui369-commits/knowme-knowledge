# CANDIDATE MANIFEST — GOAL-KK-02 Contract R3 PX01 Successor Correction

- GOAL: GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
- Contract: R3（冻结 commit `168af57a2e7bd74385cecd97da1717982ac12ab1`，tree `ae8c768218a7f517bd951a1b1a3f5b9354bcc932`，blob `b0ae8dbc980bc64f16bb77b30eaf5dbe9da64541`，均已逐字核验）
- Actor: ED-KK-GOAL02-PX01-CORRECTION-R3-20260920-0750-C61A（INDEPENDENT_ENGINEERING_DELIVERY）
- 日期: 2026-09-20

## Exact candidate identity

```text
CANDIDATE_SHA=06b013cf776d308737cf6726afcff7ee4831f5f4
CANDIDATE_TREE=7cb5983766875d982df4ff8795a1aa3a3bac96fc
CANDIDATE_PARENT=2d4e14e501caba65be3856a89ccd480aed550c36
CANDIDATE_BRANCH=engineering/goal-kk-02-px01-correction-r3
BRANCH_HEAD_MATCH=YES（分支头即 CANDIDATE_SHA，证据不追加于候选分支）
PR_HEAD_MATCH=见 Issue #13 ENGINEERING_READY 终态包（Draft PR 建立后填 YES）
WORKTREE_CLEAN=YES（git status --porcelain 为空）
```

- Preimage: `5de5bea5373d8390187f117ac35cd8a4c6608211`（tree `cdd179742f1e8cecc8aa72e60701966de7144167`，核验一致）
- 候选提交序列：preimage → `2d4e14e`（R3 实现 + D18/D19/D20）→ `06b013c`（R3-D21 修复，defect loop 第二圈）

## 构建产物指纹（Local Executor 于 exact SHA 构建）

- main hap `entry-default-unsigned.hap` sha256: `bc5f06a65ff9adce4073d84a79355817d11955abc5a897b351d4f0ee83ae0473`
- ohosTest hap `entry-ohosTest-unsigned.hap` sha256: `96ec99345aaa3be748665e8b1784d58c3d1048189653fb0bf9380df1f8d7b757`
- 声纹模型（运行时资产，不入 Git）: `3dspeaker_speech_eres2net_base_200k_sv_zh-cn_16k-common.onnx` sha256 `e2d2048292e055f7b61cdec3db010503f35369b245bf0b3bbad021c9a91e4053`（provision-models.sh 校验 OK）
- ED 本人 final run 使用与 LE 完全相同的 main hap 二进制（sha256 上列）安装运行。

## 变更范围（vs preimage）

8 个文件，+1216/-320，全部位于合同允许路径 `prototypes/knowme-knowledge-02-voice-speaker-verification/**`（详见 ALLOWED_PATH_DIFF_RECEIPT）。

## 证据包位置

本证据包（17 receipts + screenshots/**）按合同 §13 存放于独立 evidence transport 分支 `evidence/goal-kk-02-px01-correction-r3`，未追加到候选分支。

## Claim ceiling

最高仅声明 ENGINEERING_READY。不声明 CANDIDATE_ADMITTED / PRODUCT_REVIEW_ELIGIBLE / PRODUCT_EXPERIENCE_PASS / HUMAN_OWNER_ACCEPTED / REAL_DEVICE_VALIDATED / MERGE / RELEASE / GOAL_CLOSED。
