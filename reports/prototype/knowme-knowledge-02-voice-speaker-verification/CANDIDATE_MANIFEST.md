# CANDIDATE_MANIFEST — GOAL-KK-02 Contract R2 (SIMULATOR-FIRST)

```text
GOAL=GOAL-KK-02 Voice Capture + Enrolled-Speaker Verification Prototype
CONTRACT=CONTRACT-R2 commit 335e4b9e6c64c9e6a9b69fcc2d2e49b5a0c0d69c(FROZEN)
BRANCH=engineering/goal-kk-02-simulator-first-r2
LINEAGE=R1 HEAD 549fad6 是 PREIMAGE 4b23b82 的祖先(已核对);R2 分支自 governance/goal-kk-02-simulator-first-r2 拉出

CANDIDATE_SHA=b02bca6(fix(goal-kk-02-r2): R2-D16 + R2-D17 …)
CANDIDATE_TREE=b40553f25b6a6c8eaa6ef37629ea176c2b09d047
CANDIDATE_PARENT=20945974a26fd68c5691629d71ffaff83332acd3
说明:CANDIDATE_SHA 之后的 55371ae / 1c2f257 / 395a6b1 仅为 reports/ 证据归档提交,不改任何代码;
     最终 PR HEAD 为证据完备后的分支头,与 CANDIDATE_SHA 代码树一致。

BUILD_ARTIFACTS(两 hap 同命令安装于模拟器):
  entry-default-unsigned.hap   sha256=c2971591bc835759924f1e0d6bfa50dbd040861fee805578e20e1d2ca73d03ab
  entry-ohosTest-unsigned.hap  sha256=5d500af654ff45ef95b8f3a285695486a5af4ce33322f3e4987bae900e955792
  模型资产(不进 git,provision-models.sh 校验):3dspeaker_speech_eres2net_base_200k_sv_zh-cn_16k-common.onnx
    sha256=e2d2048292e055f7b61cdec3db010503f35369b245bf0b3bbad021c9a91e4053

SIGNING=未签名 debug 构建(模拟器允许安装未签名 hap;真机签名属 post-1.0)
BUNDLE=com.knowme.knowledge.voiceprototype(apiCompatibleVersion=40100011)

VALIDATION_RUNS:
  Local Executor RUN 1 @2094597:发现 D16/D17 → 按缺陷循环作废(归档于 defect-loop-run1/)
  Local Executor RUN 2 @b02bca6:PASS(LOCAL_EXECUTION_RECEIPT.md)
  ED Personal @b02bca6 同构建同模拟器:PASS(ED_PERSONAL_OPERATION_RECEIPT.md)
  单元测试:24/24 PASS(见 REGRESSION_RECEIPT.md)

ACTOR_CONTEXT_ID=ED-KK-GOAL02-SIMULATOR-FIRST-R2-20260919-0925-B4E7
LOCAL_EXECUTOR_CONTEXT_ID=LE-KK-GOAL02-SIMULATOR-R2-FINAL-20260919-1130-C9F2
```

## 诚实声明

```text
REAL_DEVICE_NOT_REVIEWED=YES
NOT_REAL_DEVICE_VALIDATED=YES
SIMULATOR_PROXY_DISCLOSURE=HONEST
TEST_FIXTURE_NEVER_PRESENTED_AS_REAL=YES
NO_SILENT_CLOUD_AUDIO=YES(应用未声明 INTERNET 权限,无任何网络调用代码)
```
