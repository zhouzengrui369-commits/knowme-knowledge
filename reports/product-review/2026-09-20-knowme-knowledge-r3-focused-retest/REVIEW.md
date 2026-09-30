# KnowME Knowledge GOAL-KK-02 R3 — 独立产品体验定向复验

## 1. Owner Decision Brief

**结论：READY_WITH_MANDATORY_FIXES。原有四个 P1 阻塞在本轮模拟器操作范围内关闭；仍须修正一项 P2 权限提示回退。建议修复后定向复验，不据此关闭 Goal/Milestone。**

```yaml
review_mode: FOCUSED_RETEST
reviewer_context: PX-KK02-R3-OWNER-DIRECT-20260920
independence: did_not_author_candidate; code_blind; no_product_source_or_test_review
isolation_status: PRIMED_COGNITIVE_WALKTHROUGH
candidate: PR24 / engineering/goal-kk-02-px01-correction-r3
commit: 06b013cf776d308737cf6726afcff7ee4831f5f4
tree: 7cb5983766875d982df4ff8795a1aa3a3bac96fc
artifact_sha256_or_deployment_id: bc5f06a65ff9adce4073d84a79355817d11955abc5a897b351d4f0ee83ae0473
product_experience_verdict: READY_WITH_MANDATORY_FIXES
release_evidence_verdict: BLOCKED_INCOMPLETE_EVIDENCE
prototype_concept_verdict: PROTOTYPE_PROMISING
prototype_to_runtime_parity: PARTIAL
prior_p0: none
new_p0: none_established
open_p1: []
open_p2: [PX-KK02-R3-06]
dev_thread_must_finish: [PX-KK02-R3-06]
owner_recommendation: 修复后定向复验
REAL_DEVICE_NOT_REVIEWED: YES
NOT_REAL_DEVICE_VALIDATED: YES
```

实际价值已成立的部分：不授权麦克风也能明确保存手动文本；可从可见入口生成披露充分的演示候选，修改、丢弃、确认；确认后可展开全文及来源；权限往返和冷启动后内容仍在。录音/声纹诊断已移到次要区域。

仍需处理：在系统麦克风关闭时，生成 TEST_FIXTURE 候选会消去当前拒绝提示，显示“空闲·未录音”；丢弃后按钮写“点开始说话”，点击却跳系统权限设置。没有观察到越权录音或静默入库，因此定为 P2，而非安全绕过或 P1 核心价值失败。

## 2. Candidate Identity 与范围变化

- 权威仓库：[knowme-knowledge](https://github.com/zhouzengrui369-commits/knowme-knowledge)，private；候选 [PR24](https://github.com/zhouzengrui369-commits/knowme-knowledge/pull/24)，父提交 `2d4e14e501caba65be3856a89ccd480aed550c36`。PR head、分支 head、本地部署工作树均为上述 exact SHA；操作前后工作树干净。[独立身份复核](evidence/reviewer-identity.json)。
- 基线仍为 v2：`PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2` @ `978ed0608bda8e278c348ad2987f6a25fa3c3c2f`。先读仓库 AGENTS、治理锁、基线、状态、CR/R3 合同和当前 GitHub 转介，不用本地未提交文件或 PM 自评替代产品基准。
- 新冻结合同：[Contract R3](evidence/contract-r3.md) @ `168af57a2e7bd74385cecd97da1717982ac12ab1`，tree `ae8c768218a7f517bd951a1b1a3f5b9354bcc932`，blob `b0ae8dbc980bc64f16bb77b30eaf5dbe9da64541`；CR `CR-KK-02-PX01-R3`。R3 接受上轮五项问题并明确 bounded persistence、直接手动输入、UI 演示候选、Agent 上下文及披露。
- 新准入：[Issue13 / 5747829096](https://github.com/zhouzengrui369-commits/knowme-knowledge/issues/13#issuecomment-5747829096)；定向复验转介：[5747856343](https://github.com/zhouzengrui369-commits/knowme-knowledge/issues/13#issuecomment-5747856343)。工程 `ENGINEERING_READY` 和 LE/ED 截图只作为背景，本报告不继承其通过结论。
- evidence-only commit `35b530d1ab9d701e0ce79d17dac1e3eca3bbb8ad` 用于定位 [manifest](evidence/candidate-manifest.md)，不是产品候选 SHA。
- 本轮重新核对并安装 exact manifest 的主 HAP 和配套 test HAP（同一次 `hdc install -r`，两个安装均成功）；主包 hash 如上，配套包 `96ec99345aaa3be748665e8b1784d58c3d1048189653fb0bf9380df1f8d7b757`。没有构建、执行技术测试、读取产品源码/测试实现或修复产品。
- 运行环境：macOS 主机；hdc `127.0.0.1:5555`；bundle `com.knowme.knowledge.voiceprototype` / EntryAbility / 0.1.0；1256×2760；API24；`const.ohos.fullname=OpenHarmony-6.1.1.125`，software.version=`emulator 6.1.0.126(SP1DEVC00E120R4P11)`。两字段名称不同，保留原始值，不相互替换。
- 初始状态：已有两条 ED 合成知识、麦克风拒绝、未注册声纹。没有清数据/卸载。既有两条只作计数基数，不作本轮成功证据。原有 ED 候选的重复片段不归因为本轮产品输入缺陷。
- 用户定位、安全级别、真实 LLM/RAG/真机/生产发布不在本轮范围等，沿用 R3；不因为没有真实大模型、真机准确率或生产备份而扣分。

## 3. 方法与初始观察

执行用户指定 [product-experience-reviewer-skill](https://github.com/zhouzengrui369-commits/product-experience-reviewer-skill) @ `4253deb55a04de20fca6ac50a47b42a6d4489c04`，tree `eaa62967737b17cc8ad07e46e297e0a52b2c3092`；`core_sha256=041a475d8cbc3404ed1e6df66c52377aecfcd631721d18a0ec9de59783f2b676`。

这是同一 reviewer 对未参与编写的新候选做定向复验；已经看过前轮失败、基线和 R3，所以不是新用户盲测，也不声称独立人类情绪样本。初始 02–07 的原始操作记录是首次观察依据：首屏常态披露模拟器/非真机；直接手动入口存在；上下文和已保存列表在语音附加区前；技术诊断默认折叠。未在后续操作前另行生成独立 Stage A 冻结文档，此为方法记录限制；不把现在整理的文字倒签为盲测冻结结果。

2026-09-20 约 15:47–16:09 +08:00，通过用户已授权的 hdc `uitest uiInput` 点击、系统键盘输入、滑动、系统设置往返、截图和布局采集。主机日志 ISO 时间为准；状态栏约慢 12 小时。90 次采集并不等于 90 个独立测试。

截图与布局是相邻采样，非原子快照。01/32/76/86 等存在启动/转场帧；尤其 32 的布局已到产品、PNG 仍是桌面，不能用其 PNG 声称已恢复。恢复结论使用稳态 33/65/88/89/90；不覆盖原始文件。发布的精选截图逐张目视检查。[Evidence Manifest](EVIDENCE.md) 包含原始 hash、无损发布副本和完整布局索引。

## 4. Retest Steps / Inheritance Matrix

上轮：[PR22 报告](https://github.com/zhouzengrui369-commits/knowme-knowledge/blob/56d005c1c76df26cdaf36675de2ba7d60d0006d4/reports/product-review/2026-09-19-knowme-knowledge-goal02-owner-review/REVIEW.md)，候选 `b02bca6e5e84e98e5b4c99bc43d3599946089e83`，NOT_READY。本轮只更新新候选结果，不改历史回执。

| Issue / R3 outcome | 实际重放与结果 | 当前状态 / 证据 |
|---|---|---|
| PX-KK02-01 / AO-R3-01 持久化 | 新手动 A：2→3；新演示 B：三点改四点、保存修正仍3、确认3→4。Home 返回、权限 off/on、force-stop 冷启动后，同一 A/B 正文及来源可展开；无重复或消失。后续另存两条，最终6=原2+本轮4。丢弃 REJECT、未确认 PENDING、已清除 CANCEL 均不在最终列表。 | **CLOSED**，06/17/18、29–33、55–65、85–90；[修正后详情](evidence/published/88-final-detail-corrected.png)；89 布局为手动来源详情 |
| PX-KK02-02 / AO-R3-02 拒绝麦克风后的手动路径 | 初始拒绝状态直接输入 A 并点记录，未开启麦克风也成功；再次撤销权限后输入 CANCEL，系统键盘全选删除并退出，计数维持5。无需先录音。没有独立“取消”按钮，本轮验证的取消方式是清空未提交输入，未把退出键盘当作已删除草稿。 | **CLOSED**（手动操作能力），03–06、58–61；[拒绝时已保存](evidence/published/06-keyboard-dismiss.png)。权限提示回退另列 R3-06 |
| PX-KK02-03 / AO-R3-03 候选控制可达 | 可见“生成 TEST_FIXTURE 演示候选”反复可用，未改阈值/状态。B 使用标准 Ctrl+A 更正文案，点保存修正后再点确认；另一 REJECT 点丢弃+0；PENDING 在 Home 后仍待确认，冷启动后不入库。 | **CLOSED**，08–21、28–33；[改文](evidence/published/17-save-correction.png)、[明确确认后4条](evidence/published/18-confirm-corrected.png)、[丢弃后仍4条](evidence/published/21-reject.png) |
| PX-KK02-04 / AO-R3-04 Agent 上下文与结果 | 默认先看到有界对话、手动工作入口、已保存知识；语音标为附加能力，诊断折叠。记录后可点条目展开完整正文和来源，较长标题的省略号不等于正文丢失。失败/返回后能继续同一记录工作。R3 明确无真实 LLM要求，所以按 bounded capture/inspect 而非一般智能助理评价。 | **CLOSED（限 R3 语义）**，06/50/65/88/89/90；[展开全文](evidence/published/50-inspect-long-saved-item.png)、[最终主界面](evidence/published/90-final-agent-entry.png) |
| PX-KK02-05 / AO-R3-05 披露与状态文案 | 常态首屏明确模拟器/非Mate60/真机未验证；fixture 候选及保存详情不冒充真实语音/机主身份；注册档案和当前验证分列；“点开始/点停止”符合动作。仍有拒绝权限被 fixture 生成错误清除的问题。录音时披露条在同一长页上方，不是固定常驻横幅。 | **PARTIALLY_FIXED**；原三项文案问题修正，R3-06 仍为 P2 待修正/明确治理处置。06/41/44/50/65，对照19–22 |

## 5. Regression Sampling

| 操作 | 预期 / 实际 | 边界与证据 |
|---|---|---|
| 未注册录音→停止 | NOT_ENROLLED、不入库；实际140ms结果，数量4未变 | 25–27，未通过合成状态注入触发 |
| 注册→取消→重新三段采样 | 取消回未注册；0/3→1/3→2/3→注册完成3/3；已保存4条未动 | 34–41，[完成](evidence/published/41-enroll-complete.png)。主机调用中文合成语音作为刺激，但声学耦合未校准，不证明采到的是预期音频 |
| 已注册正常捕获 | 本次 VERIFIED 0.686，但本地转写 NOT_AVAILABLE，因此仍不入库；重复0.710相同拦截 | 42–44、68–70，[组合状态](evidence/published/44-verified-unavailable-state.png)。VERIFIED 为 UI runtime 结果，不是 reviewer 对真实身份的背书 |
| VERIFIED 后 UI“注入测试转写”→确认→展开 | 来源继续 TEST_FIXTURE，显式确认4→5；全文明确非真实语音、非机主身份 | 45–50。是产品可见测试路径，不是脚本篡改识别状态 |
| 重置弹窗→取消 | 明确告知不可恢复且不影响知识；取消后档案已注册、知识5 | 66–67，[弹窗](evidence/published/66-reset-dialog.png)。最终“确认重置”未执行，不声明删除成功 |
| WLAN关闭→重试语音→手动记录 | 0.637 VERIFIED + NOT_AVAILABLE仍不入库；明确手动记录5→6 | 71–79，[WLAN关闭](evidence/published/73-wlan-off.png)、[保存](evidence/published/79-offline-manual-save.png)。只证明 WLAN 开关关闭时该操作，不是全网络隔离或无上传的流量证明 |
| 恢复环境→冷启动→展开 | WLAN回开启、麦克风回初始拒绝；6条和来源仍可查；注册档案仍在 | 80–90，[麦克风关闭](evidence/published/85-mic-restored-denied.png)、88/89/90 |

本轮未自然触发 UNCERTAIN / NOT_VERIFIED，未确认不可恢复声纹重置，未完整重跑 D1–D17，未抓包证明网络层绝无上传，未做真实 ASR准确率/声纹准确率/真机测试。它们是覆盖边界，不虚写本轮 PASS，也不把前轮或工程 PASS 自动继承。本轮没有证据表明这些未覆盖分支失败。

## 6. Remaining Issue Contract — PX-KK02-R3-06

- **Severity:** P2；非本轮核心捕获闭环阻塞，但必须修正的状态可信度问题；关联 PX-KK02-05、AO-R3-05，兼及 AO-R3-02。
- **Journey:** C/E，麦克风拒绝→演示候选→丢弃→尝试说话。
- **User Promise Violated:** 用户应始终分清“测试候选可操作”与“麦克风已可用”。
- **Observed Behavior:** 19 时明确“需要麦克风权限”；20 生成 fixture 后拒绝横幅消失、麦克风变“空闲·未录音”，21 丢弃后按钮“点开始说话”。22 点击进入系统设置，开关仍关闭；此前09也出现同类状态。期间没有打开权限。
- **Expected Behavior:** fixture 创建/修正/丢弃不改变真实麦克风状态；仍显示“需要权限/可选授权”，手动及演示路径继续可用。
- **Evidence:** [20](evidence/published/20-generated-reject.png)、[21](evidence/published/21-reject.png)、[22](evidence/published/22-recheck-denied-click.png)，19 布局、operation-log；18 是上一轮已恢复拒绝提示的对照。
- **Likely User Impact:** 以为可以直接录音，点击后才被送去系统设置，需重新理解状态；未观察越权、数据丢失或静默入库。
- **Current Scope:** IN_CURRENT_RELEASE_SCOPE，属于已冻结权限/恢复/状态语义，不引入新产品功能。
- **Required Behavior:** 在所有 fixture 出入口维持权限事实，并让按钮文案与即将发生的动作一致。由独立 Engineering 修正，reviewer不改代码。
- **Acceptance Criteria:** 系统麦克风关闭时，生成→修正→丢弃与生成→确认两条链后，状态仍拒绝、按钮说明授权；手动路径仍能保存，演示+0/+1规则不变；开权限再返回正确更新。
- **Focused Retest Steps:** 新冻结候选重放18–24与上述确认分支，随后冷启动展开已保存两条对照。
- **Required Retest Evidence:** 新SHA/tree/HAP hash；系统开关、每一步前后截图/布局、计数/来源、操作者命令及时间。
- **Regression Risk:** 不得为保留拒绝提示而封锁手动/fixture，或误清候选/已保存知识。

## 7. Runtime Scoring / Parity

只对本次实际可达的 R3 模拟器行为评分，无总分掩盖未完成项。

| Dimension | Score | Evidence / 限制 |
|---|---:|---|
| 捕获入口与首次价值 | 4/5 | 06/18/90；历史回执较密，主要记录入口仍可见 |
| 候选控制权 | 4/5 | 17/18/21；修正、拒绝、明确确认可操作 |
| 恢复与结果可检查 | 4/5 | 33/65/88/89；有界合成记录保留，可展开 |
| 信任与状态可理解性 | 3/5 | 44/50清晰；20–22权限提示回退 |
| Agent附属语音与诊断层级 | 4/5 | 50/90；只评价R3记录工作流，不声称通用Agent能力 |
| 真实ASR/生物识别/完整LLM | N/A | OUT_OF_CURRENT_RELEASE_SCOPE |

Prototype概念为PROTOTYPE_PROMISING；Runtime已完成有界捕获/确认/检查。未重新操作原型HTML做完整像素或行为对照，因此Parity仍PARTIAL；没有将语义改善写成全产品UI等价。

## 8. Verdict Diff / Human Owner Gate

| Verdict | Prior R2 | Current R3 | 原因 |
|---|---|---|---|
| Product Experience Verdict | NOT_READY | READY_WITH_MANDATORY_FIXES | 四个P1关闭；仍有P2状态提示修正 |
| Release Evidence Verdict | BLOCKED_INCOMPLETE_EVIDENCE | BLOCKED_INCOMPLETE_EVIDENCE | exact candidate/hash已绑定；本轮是focused sample，存在上述未覆盖项，也非发布复现/真机签名审计 |
| Prototype Concept Verdict | PROTOTYPE_PARTIAL | PROTOTYPE_PROMISING | 从失败回退到保存和检查的有界闭环已可操作 |
| Prototype-to-Runtime Parity | PARTIAL | PARTIAL | 没有新的完整UI authority parity实操 |

`HUMAN_OWNER_GATE_REQUIRED`：仅标记最终决定仍属于Human Owner，不表示已经Accepted，也不表示无条件准入关闭。建议先修正R3-06并复验；若拟接受为非阻塞限制，Parent必须明确记录处置并提交Owner决定，不能把本报告改写成EXPERIENCE_READY或完整AO-R3-06/07 PASS。

Technical PASS ≠ Product Experience PASS ≠ Human Owner Accepted ≠ Release Authorized。未合并PR、未发布、未关闭Goal/Milestone、未改变基线/合同。当前设备保留原2条及本轮4条合成知识、本轮注册档案；未删除声纹。麦克风和WLAN恢复到初始开关状态。

## 9. Evidence Manifest / Parent Handoff

[Evidence Manifest](EVIDENCE.md)；[可直接交给 Parent 的提示词](PARENT_HANDOFF.md)。本报告的工具校验只校验Skill/report结构及Core hash，不是产品技术测试或体验通过的替代品。
