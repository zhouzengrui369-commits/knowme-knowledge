# 给 Parent 的接管提示词

你是 KnowME Knowledge 的 Product Governance / Parent PM。请继续治理对账，不编写或修改产品代码、测试、构建/部署脚本、依赖文件，不兼任Engineering。本轮Owner已授权独立体验审核和GitHub报告提交；产品基线是判断基准，PM/ED通过声明不能覆盖实操证据。

先从GitHub读取本目录 `REVIEW.md`、`EVIDENCE.md`、`evidence/reviewer-identity.json` 与 `evidence/skill-validation.txt`，再按仓库AGENTS顺序核对治理锁、当前基线/合同、最新回执和PR。不要用聊天或本地未提交文件替代权威。

## 必须保持的精确身份

```text
REPO=zhouzengrui369-commits/knowme-knowledge
GOAL_ID=GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
MILESTONE_ID=MILESTONE-GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
CONTRACT_REVISION=R3
CONTRACT_COMMIT=168af57a2e7bd74385cecd97da1717982ac12ab1
CONTRACT_TREE=ae8c768218a7f517bd951a1b1a3f5b9354bcc932
CONTRACT_BLOB=b0ae8dbc980bc64f16bb77b30eaf5dbe9da64541
BASELINE=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2
BASELINE_COMMIT=978ed0608bda8e278c348ad2987f6a25fa3c3c2f
CANDIDATE_PR=27
CANDIDATE_BRANCH=engineering/goal-kk-02-r3-px02-p2-correction-r1
CANDIDATE_SHA=3317469085d8dc10a88818369ffcc2922904079c
CANDIDATE_TREE=c688e8d6da0fe5fdaa12f2412158eb0c6d86ee15
CANDIDATE_PARENT=6d3a4c1ec4bbaf38aa1b11183fe6adaf1807da94
MAIN_HAP_SHA256=05111cd04294f937839345e09b1af08aadefdc8b6cac1147f7eb4202622ca7f8
TEST_HAP_SHA256=8a3e260725b76081a01d50938f7ac31a70945fecda8d7c1a03281106536b9c63
ENGINEERING_EVIDENCE_TRANSPORT_COMMIT=861ea8c06e1785114ddc7f67401e7f044e3be0a5
ADMISSION=Issue13/comment5755322906
REFERRAL=Issue13/comment5755454617
REVIEWER_AUTHORITY_COMMIT=4253deb55a04de20fca6ac50a47b42a6d4489c04
REVIEWER_AUTHORITY_TREE=eaa62967737b17cc8ad07e46e297e0a52b2c3092
REVIEWER_CORE_SHA256=041a475d8cbc3404ed1e6df66c52377aecfcd631721d18a0ec9de59783f2b676
REVIEWER_CONTEXT=PX-KK02-R3-P2-OWNER-DIRECT-20260921
REVIEW_MODE=FOCUSED_RETEST
REVIEW_SCOPE=MICRO_R3_06_WITH_PX01_TO_04_REGRESSION_SAMPLES
PRODUCT_EXPERIENCE_VERDICT=EXPERIENCE_READY
RELEASE_EVIDENCE_VERDICT=BLOCKED_INCOMPLETE_EVIDENCE
PROTOTYPE_CONCEPT_VERDICT=NO_PROTOTYPE_REVIEWED
PROTOTYPE_TO_RUNTIME_PARITY=PARITY_PARTIAL
PX_KK02_R3_06=CLOSED
HUMAN_OWNER_GATE=HUMAN_OWNER_GATE_REQUIRED
HUMAN_OWNER_ACCEPTANCE=NOT_ESTABLISHED
MERGE_AUTHORIZED=NO
RELEASE_AUTHORIZED=NO
GOAL_MILESTONE_CLOSED=NO
REAL_DEVICE_NOT_REVIEWED=YES
NOT_REAL_DEVICE_VALIDATED=YES
```

本轮结论由reviewer在13:10–13:23 +08:00实际操作获得，未读产品源码/测试实现，未构建或运行技术测试。核hash并安装配套HAP后，实际完成系统麦克风OFF、fixture生成/修正/丢弃(+0)、另一fixture修正/确认(+1)、拒权时手动保存(+1)、未确认候选跨Home/冷启动不入库、授权动作到系统页、授权后开始/取消录音，以及再次冷启动展开正文与来源。

原有2条ED合成知识未删除。本轮仅新增已确认B和手动A两条，最终4条。R被丢弃、PENDING未确认，均不在保存列表。麦克风恢复初始已授权，WLAN未改，声纹档案未注册且未重置。上方历史权限消息仍保留，但当前权限区和动作正确；该阅读成本未作为新的mandatory缺陷。

## 现在应该做什么

1. 鲜读PR27 head、分支head、tree及本报告commit，确认仍为上述exact candidate；若改变则停止转移本报告通过结论，重新定义准入/复验。
2. 为本候选追加不可篡改的Product Governance reconciliation，记录 R3-06 在本轮微型定向体验复验中CLOSED、Product Experience为EXPERIENCE_READY。按中央状态机做范围准确的映射，不改写PR25历史失败或旧回执。
3. PX-KK02-01..04仅有本轮明确样本的无回归结果；PX-KK02-05剩余mandatory权限项已清。本报告没有全量重跑D1–D17、注册/重置、UNCERTAIN/NOT_VERIFIED/NOT_AVAILABLE，也没有做原型等价或真机测评。不要写成全量AO-R3-06/07 PASS；Parent如需其他门禁，按冻结合同逐项对账已有证据、缺口与责任，不能用缺测捏造失败或用工程绿灯替代体验。
4. 提交 `REVIEW.md` 中不超过8分钟的Owner脚本，等待Human Owner实际决定。体验已完成的目标不应无理由重新退回工程；范围外真机/真实LLM/生产备份不得新增为本次micro整改门槛。
5. 合并、发布和Goal/Milestone关闭是独立后续门禁，未经相应授权不要执行。若调整产品范围、验收阈值或关闭条件，走Change Request；保持一个Goal对应一个Milestone并同步关闭的规则。

直接前序：PR25报告commit `c40eed63860d0e94d041b0de5bb4ff329b826c8e`，Issue13/comment5748639444；治理曾将 READY_WITH_MANDATORY_FIXES 对账为未通过，因为R3-06仍mandatory。本报告给的是新候选、新操作、新结论，不能倒改历史。

最终给Owner的回复请说明：本轮目标问题已关闭、可进入Owner产品决定；不要写“Owner已接受”“已发布”“里程碑已关闭”。附上本报告及实际截图链接，并明确还有哪些后续门禁未建立。
