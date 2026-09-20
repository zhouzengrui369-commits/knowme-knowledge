# Parent PM / Product Governance 接管提示词

请以独立 Parent PM / Product Governance 角色接管 KnowME Knowledge GOAL-KK-02 R3。本轮已由 Owner 直接授权的独立产品体验审核官实际操作模拟器，报告不是工程自评；请先读同目录 REVIEW.md 和 EVIDENCE.md，并以 GitHub 产品基线为准。

## 冻结身份

- Candidate PR24：https://github.com/zhouzengrui369-commits/knowme-knowledge/pull/24
- branch：`engineering/goal-kk-02-px01-correction-r3`
- exact SHA：`06b013cf776d308737cf6726afcff7ee4831f5f4`
- tree：`7cb5983766875d982df4ff8795a1aa3a3bac96fc`
- parent：`2d4e14e501caba65be3856a89ccd480aed550c36`
- main HAP SHA256：`bc5f06a65ff9adce4073d84a79355817d11955abc5a897b351d4f0ee83ae0473`
- paired HAP SHA256：`96ec99345aaa3be748665e8b1784d58c3d1048189653fb0bf9380df1f8d7b757`
- baseline v2：`978ed0608bda8e278c348ad2987f6a25fa3c3c2f`
- frozen Contract R3 / CR-KK-02-PX01-R3：`168af57a2e7bd74385cecd97da1717982ac12ab1`
- 准入/复验转介：Issue13 comments `5747829096` / `5747856343`。
- evidence-only commit `35b530d1ab9d701e0ce79d17dac1e3eca3bbb8ad` 不是候选。

## 接收独立结论

Product Experience=`READY_WITH_MANDATORY_FIXES`；Release Evidence=`BLOCKED_INCOMPLETE_EVIDENCE`；Prototype Concept=`PROTOTYPE_PROMISING`；Parity=`PARTIAL`。

本轮针对上述 exact candidate 关闭原有 P1：PX-KK02-01、02、03、04，关闭仅限 R3 的有界模拟器工作流。麦克风拒绝时能手动记录；演示候选可修正/丢弃/明确确认；Home、权限off/on、冷启动后内容/来源/计数仍在；结果可展开全文；诊断处于次要区域。

PX-KK02-05 为 `PARTIALLY_FIXED`：模拟器/非真机、注册与当前结果、点击动作三方面已改善，但新增关联 P2 `PX-KK02-R3-06` 尚未解决。系统麦克风关闭时生成 TEST_FIXTURE 后，拒绝提示被清除、状态变“空闲·未录音”；丢弃后“点开始说话”实际跳转设置。没有观察到越权或静默入库。完整行为合同与验收步骤在 REVIEW.md §6。

## 下一步

1. 先复核 GitHub 当前 head 与上述 SHA 是否仍一致，新增本轮独立回执，不覆盖 Sept19 NOT_READY 历史回执，不把报告提交 SHA 当产品 SHA。
2. 建议派独立 Engineering 修正 R3-06，再提交新 exact candidate、manifest、技术及真实操作证据，重新准入并定向复验。Parent 不写产品源码、测试、构建或依赖；当前 reviewer 也没有改代码。
3. 若主张将该 P2 接受为非阻塞限制，明确记录依据及 Owner 决定；不得静默改写此报告为 EXPERIENCE_READY。若改变范围/阈值/关闭条件，走 CR。
4. 新复验重放：麦克风拒绝→生成演示→修改→丢弃，以及生成→确认；全程状态正确；手动入口和+0/+1仍成立；开权限返回、冷启动、展开两条保存内容。保持声音信任门，不能为了可达性伪造 VERIFIED。
5. 本轮 NOT_ENROLLED、VERIFIED+NOT_AVAILABLE 拦截已实际观察；UNCERTAIN、NOT_VERIFIED未自然触发；最终不可恢复声纹重置未执行（仅弹窗/取消）；未完整重跑D1–D17、无网络流量审计。按覆盖边界处理，不继承工程/前轮PASS，不把“未覆盖”写成失败。
6. `HUMAN_OWNER_GATE_REQUIRED` 仅保留最终 Human Owner 决定权；本轮不是 Accepted、Merge Authorized、Release Authorized 或 Goal/Milestone Closed。建议修正并复验后再请求同一新候选的Owner接受。

## 实机操作边界与当前设备

本轮真实操作的是 `127.0.0.1:5555` 的 OpenHarmony 模拟器，bundle `com.knowme.knowledge.voiceprototype`，非 Mate60。90 次采集、17 张精选原始画面无损副本；截图和布局非原子快照，32是转场桌面PNG，报告明确不用其证明恢复。

初始已有2条ED合成知识；本轮新增4条，最终6条。A手动、B经“三点→四点”修正后确认、VERIFIED路径的fixture、WLAN关闭时手动记录均有新证据。REJECT/PENDING/CANCEL未入库。没有上传原始音频、声纹、embedding或真实Owner私密转写。保留本轮注册档案，未确认永久重置；麦克风恢复拒绝、WLAN恢复开启。

不得要求本 Goal 证明真实 ASR/声纹准确率、通用 LLM/RAG、生产备份或真机兼容；这些不在 R3 范围。不得把本轮模拟器结果外推成真实身份保证、真机通过或发布许可。
