# KnowME Knowledge — R3 权限状态独立体验复验

## 1. Owner Decision Brief

**结论：EXPERIENCE_READY，限本次 R3 定向复验范围。PX-KK02-R3-06 关闭；四项核心体验回归抽样未发现退化。建议将这个 exact candidate 提交 Human Owner 决策。**

```yaml
review_mode: FOCUSED_RETEST
scope: MICRO / PX-KK02-R3-06 plus PX-KK02-01..04 regression sampling
reviewer_context: PX-KK02-R3-P2-OWNER-DIRECT-20260921
independence: did_not_author_candidate; code_blind; reviewer_owned_UI_evidence
isolation_status: PRIMED_COGNITIVE_WALKTHROUGH
candidate: PR27 / engineering/goal-kk-02-r3-px02-p2-correction-r1
commit: 3317469085d8dc10a88818369ffcc2922904079c
tree: c688e8d6da0fe5fdaa12f2412158eb0c6d86ee15
artifact_sha256_or_deployment_id: 05111cd04294f937839345e09b1af08aadefdc8b6cac1147f7eb4202622ca7f8
core_sha256: 041a475d8cbc3404ed1e6df66c52377aecfcd631721d18a0ec9de59783f2b676
product_experience_verdict: EXPERIENCE_READY
release_evidence_verdict: BLOCKED_INCOMPLETE_EVIDENCE
prototype_concept_verdict: NO_PROTOTYPE_REVIEWED
prototype_to_runtime_parity: PARITY_PARTIAL
core_promise: 拒绝麦克风时仍能控制演示候选和手动记录，状态真实，明确保存后可以恢复并检查
core_promise_holds: YES_WITHIN_FOCUSED_SCOPE
prior_p0: none
new_p0: none_observed
open_p1_in_sample: []
open_mandatory_p2_in_sample: []
dev_thread_must_finish: []
next_round_focused_retest_only: 当前问题无待修复项；候选或范围变化后重新确定复验范围
owner_recommendation: 放行到 Human Owner 决策；不代表合并、发布或关闭里程碑
REAL_DEVICE_NOT_REVIEWED: YES
NOT_REAL_DEVICE_VALIDATED: YES
```

三项直接证据：拒权期间生成、修正、丢弃、确认和手动保存均保留权限提示；丢弃 +0、确认 +1、手动保存 +1；恢复授权及冷启动后，同一两条新知识的正文和来源可检查。未确认候选没有变为已保存知识。

本轮只发布审核报告和证据，没有查看产品源码/测试实现，没有构建、运行技术测试或修复产品。工程/PM 的通过文字不作为体验证据。最终 Owner 接受、merge、release、Goal/Milestone 关闭未建立。

## 2. Candidate Identity / 权威基准

| 项目 | 本轮绑定 |
|---|---|
| 仓库与候选 | [knowme-knowledge / PR27](https://github.com/zhouzengrui369-commits/knowme-knowledge/pull/27)，OPEN / DRAFT / UNMERGED；SHA/tree 如上；parent `6d3a4c1ec4bbaf38aa1b11183fe6adaf1807da94` |
| GitHub 准入/转介 | [5755322906](https://github.com/zhouzengrui369-commits/knowme-knowledge/issues/13#issuecomment-5755322906) / [5755454617](https://github.com/zhouzengrui369-commits/knowme-knowledge/issues/13#issuecomment-5755454617)；转介称 FOCUSED_RETEST_MICRO，本报告使用 Skill 的 FOCUSED_RETEST 模式 |
| 产品基线 | `PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2`，[978ed060 的基线](https://github.com/zhouzengrui369-commits/knowme-knowledge/blob/978ed0608bda8e278c348ad2987f6a25fa3c3c2f/governance/PRODUCT_BASELINE.md) |
| 冻结合同 | [Contract R3](evidence/contract-r3.md) @ `168af57a2e7bd74385cecd97da1717982ac12ab1`；tree `ae8c768218a7f517bd951a1b1a3f5b9354bcc932`；blob `b0ae8dbc980bc64f16bb77b30eaf5dbe9da64541`；本次纠正不新增 CR 或 R4 |
| 历史报告 | [PR25](https://github.com/zhouzengrui369-commits/knowme-knowledge/pull/25)，report commit `c40eed63860d0e94d041b0de5bb4ff329b826c8e`；旧候选 `06b013cf776d308737cf6726afcff7ee4831f5f4`，不转移 PASS |
| evidence transport | `861ea8c06e1785114ddc7f67401e7f044e3be0a5`，只定位工程 manifest/运行说明，不是本轮产品 SHA |
| 主 HAP | `entry-default-unsigned.hap`，SHA256 `05111cd04294f937839345e09b1af08aadefdc8b6cac1147f7eb4202622ca7f8` |
| 配套 test HAP | `entry-ohosTest-unsigned.hap`，SHA256 `8a3e260725b76081a01d50938f7ac31a70945fecda8d7c1a03281106536b9c63`；安装配套包不等于执行其测试 |
| 部署关联 | 两个包均由 reviewer 核 hash，13:10 同次 `hdc install -r` 成功后 force-stop/start；操作前后 exact 工作树干净；[独立复核](evidence/reviewer-identity.json)、[安装日志](evidence/environment-commands.jsonl) |
| 构建说明 | exact candidate 的 prototype README 声明 `scripts/build-hap.sh`；reviewer 未执行、未读取该脚本。该 README 的旧合同/真机文字不覆盖新 R3 的模拟器范围 |
| 设备/系统 | macOS 主机；OpenHarmony emulator `127.0.0.1:5555`；1256×2760，arm64-v8a，API24；fullname `OpenHarmony-6.1.1.125`；software.version `emulator 6.1.0.126(SP1DEVC00E120R4P11)`，分别保留实际字段 |
| App / 模型 | `com.knowme.knowledge.voiceprototype` / `EntryAbility` / 0.1.0；界面明确确定性演示、无真实 LLM。工程 manifest 声明模型 hash `e2d2048292e055f7b61cdec3db010503f35369b245bf0b3bbad021c9a91e4053`；仅作配置背景，本轮不裁决模型准确率或实际路由 |
| 初始/最终配置 | 麦克风均为已授权；过程中通过系统设置关/开。WLAN 初始开启且未改变。声纹档案始终未注册。初始2条 ED合成知识，最终4条=初始2+本轮明确保存2。未清数据/卸载/重置声纹 |

先核对 GitHub AGENTS、治理锁、中央规则、基线、状态、当前合同、准入及 exact PR；这些内容决定角色与范围。PROJECT_STATUS 的 activation snapshot 不替代较新的准入/转介回执。PM 的纠正建议只是复现线索，产品基线及实际体验才是裁决依据。

用户指定的 [product-experience-reviewer-skill](https://github.com/zhouzengrui369-commits/product-experience-reviewer-skill) 固定在 `4253deb55a04de20fca6ac50a47b42a6d4489c04`，tree `eaa62967737b17cc8ad07e46e297e0a52b2c3092`，Core SHA256 `041a475d8cbc3404ed1e6df66c52377aecfcd631721d18a0ec9de59783f2b676`。

## 3. Stage A / Stage B / 方法边界

[Stage A 原文](evidence/stage-a.md) 于 13:11:33 +08:00 冻结，SHA256 `31e33be10fd957b9c8a8f4b6e6cdcbe25a5c3d675177ca68f89c5583fcb31748`，先于本轮后续定位对照。由于同一上下文已有历史问题和转介信息，明确为 **PRIMED_COGNITIVE_WALKTHROUGH**，不是盲测或真实人类情绪样本。

首次稳态 [02](evidence/published/02-initial-stable.png)：原型/模拟器身份可见，直接文本记录、上下文和已保存知识位于语音附加区前，技术诊断不占首位。Stage B 与 R3 对照后，按有界 capture/inspect 工作流评价，不把真实 LLM、真机声学能力或完整知识工作台当作本轮新增要求。

| 范围 | 标签 | 本轮处理 |
|---|---|---|
| 拒权状态真实性、可选授权动作、fixture修正/丢弃/确认、手动保存 | IN_CURRENT_RELEASE_SCOPE | 本轮目标，逐项实操 |
| 恢复、来源检查、Agent上下文层级 | IN_CURRENT_RELEASE_SCOPE | 新候选回归抽样 |
| 注册/重置、完整 D1–D17、UNCERTAIN/NOT_VERIFIED/NOT_AVAILABLE 等信任分支 | IN_CURRENT_RELEASE_SCOPE | 未在本次 micro 全量重跑；不移用旧 PASS，不据缺测宣称失败 |
| 真机识别/生物识别准确率、生产备份、真实LLM/RAG、生产发布 | OUT_OF_CURRENT_RELEASE_SCOPE | N/A；不扣本轮体验分，不作为本次额外整改门槛 |

13:10–13:23 +08:00，以 hdc 系统点击、键盘输入、滑动、系统权限往返和进程生命周期操作完成；共50次截图/布局采集，非50个独立测试。主机日志带时区；模拟器状态栏约慢12小时，不用其分钟显示作为绝对时间。截图/布局是相邻采样，不是原子快照。01、45 为启动转场，结论使用稳态02、38/39、46–50。21–23 的输入未命中文本框，是操作者坐标失误；24重新定位后才实际编辑成功，未将无效动作记为产品缺陷。

## 4. Issue Contract — PX-KK02-R3-06 重放与关闭

所有行绑定上述 exact candidate；序号与完整时间见 [Evidence Manifest](EVIDENCE.md)。用户感受列是认知走查判断。

| 步骤 / 证据序号 | 预期 | 实际结果 | 用户感受 / 结论 |
|---|---|---|---|
| 05–08 系统关闭麦克风并回产品 | 显示拒权；手动可继续 | [06系统开关OFF](evidence/published/06-mic-off.png)；产品横幅、麦克风状态及授权动作一致；知识2条 | 能区分“可记录文字”和“麦克风不可用”；PASS |
| 09–10 生成 `PX21-R：周二下午三点审阅目录。` | 演示候选不改变权限事实 | [10](evidence/published/10-reject-generated.png) 保留拒权横幅/需要权限；count2 | 不再误以为麦克风已可用；PASS |
| 11–15 改“三点”为“四点”，保存修正 | 只改待确认内容，不保存知识或清拒权 | [15](evidence/published/15-reject-correction-saved.png) 显示四点、待确认、count2、需要权限 | 修正与入库分离；PASS |
| 16 丢弃R，17点授权动作，18不授权返回 | +0；动作文字符合跳转 | [16](evidence/published/16-rejected-plus-zero.png) 仍2条，按钮“授权麦克风并开始说话”；[17](evidence/published/17-permission-action-after-reject.png) 到系统App权限页、开关仍OFF | 下一步可预测；PASS |
| 19–29 另建B，实际修改并保存修正，再确认 | 确认前+0，确认后恰好+1；保持拒权 | `PX21-B：周五下午三点整理项目资料。` 改为四点；28仍2， [29](evidence/published/29-confirm-plus-one-denied.png) 为3且来源TEST_FIXTURE，拒权横幅仍在 | 有明确控制权；PASS |
| 30–32 拒权时手动输入A并点记录 | 无需开启麦克风；手动来源 | [32](evidence/published/32-manual-keyboard-hide.png) 为4，A=`PX21-A：明天下午三点整理读书笔记。`，拒权状态保持 | 替代路径确实能完成工作；PASS |
| 33–39 生成PENDING但不确认，Home返回、force-stop冷启动 | 不自动入库，保存的A/B仍在 | [36](evidence/published/36-return-pending.png) 返回后仍待确认/count4；[39](evidence/published/39-cold-list-pending-absent.png) 冷启动仅4条，R及PENDING不在已保存列表，当前候选为空 | 不把“生成过”当作“已保存”；PASS |
| 40–44 可见授权动作→系统开权限→返回→开始→取消 | 权限刷新；真正可进入录音状态；取消不入库 | [41](evidence/published/41-mic-granted-system.png) ON；[42](evidence/published/42-return-granted.png) 已授予/待开始；[43](evidence/published/43-granted-start.png) 录音中及停止/取消；[44](evidence/published/44-granted-cancel.png) 空闲/count4 | 状态与动作一致；PASS，仅证明UI录音会话，不证明音频识别效果 |
| 45–50 再冷启动并分别点A/B | 同文、同来源、无重复、上下文可回看 | [48手动详情](evidence/published/48-manual-detail-scroll.png)、[49演示详情](evidence/published/49-fixture-detail.png)、[50上下文](evidence/published/50-final-context.png)；count4 | 保存结果可以检查；PASS |

**关闭合同：** PX-KK02-R3-06，原P2，关联 PX-KK02-05 / AO-R3-05。旧问题为 fixture 操作清掉拒权状态，随后“开始说话”却进入权限设置。本轮系统开关OFF期间，生成、保存修正、丢弃、确认、手动保存均保留真实状态；授权文案与系统跳转一致；真正授权后状态刷新，冷启动未退化。原验收条件在本轮重放范围内全部满足，状态 **CLOSED**，没有剩余必须修复项。未观察到越权录音、静默入库或数据丢失。

## 5. Inheritance Matrix / 回归抽样

| 事项 | PR25历史状态 | 本候选新证据 | 本轮状态 |
|---|---|---|---|
| PX-KK02-R3-06 权限状态 | OPEN / mandatory P2 | 06–44完整目标链 | **CLOSED** |
| PX-KK02-01 持久化 | CLOSED（旧候选） | 新A/B经Home、权限往返和两次冷启动，48/49仍同文同来源；未确认/拒绝未入库 | 抽样未回归；不继承旧候选PASS |
| PX-KK02-02 拒权手动继续 | CLOSED（旧候选） | 30–32在拒权时保存A | 保存路径未回归；本轮未另测清空草稿取消 |
| PX-KK02-03 候选可达与控制 | CLOSED（旧候选） | R修改后丢弃+0；B修正后确认+1；PENDING不确认不入库 | 抽样未回归 |
| PX-KK02-04 Agent上下文/检查 | CLOSED（R3语义） | 02/48–50上下文、手动、列表在语音前；可展开正文来源 | 抽样未回归；非通用智能Agent背书 |
| PX-KK02-05 文案/披露 | PARTIALLY_FIXED，剩R3-06 | 02/15/16/42/48/49/50；剩余权限问题关闭 | 遗留mandatory项已清；没有全量重做每个录音/验证分支 |

保留的体验观察：授权恢复后，上方对话上下文仍有此前“权限未授予”的历史消息（43/50）。当前权限区、动作和录音行为已正确；本轮未观察该历史记录阻止操作，不将其判作R3-06仍未修复。长页需要滚动，仍有阅读成本。该观察保留原截图，供以后信息层级优化参考，不新增本轮mandatory修复。

## 6. Runtime Scoring / Prototype / Parity

仅为本轮实际操作的局部评分，不计算总平均分，不虚构长期使用意愿。

| Dimension | Score | Applicable | Evidence | Reason |
|---|---:|---|---|---|
| 权限事实和动作可理解性 | 4/5 | YES / IN_CURRENT_RELEASE_SCOPE | 06/15/16/17/41–44 | 当前状态已一致，历史对话仍增加阅读成本 |
| 候选控制权 | 4/5 | YES / IN_CURRENT_RELEASE_SCOPE | 15/16/28/29/36/39 | 修正/拒绝/确认分离，候选不默认为保存 |
| 拒权时继续完成任务 | 4/5 | YES / IN_CURRENT_RELEASE_SCOPE | 30–32/48 | 手动可保存并检查来源，无需授权 |
| 恢复与可检查结果 | 4/5 | YES / IN_CURRENT_RELEASE_SCOPE | 38/39/48/49 | 两次冷启动后的新A/B正文来源及数量正确 |
| Agent上下文与层级 | 4/5 | YES / IN_CURRENT_RELEASE_SCOPE | 02/50 | 记录/结果在语音附加能力前；页面仍较长 |
| 真机ASR/生物识别/真实LLM | N/A | N/A — OUT_OF_CURRENT_SCOPE | R3合同 | 不在本轮范围，不参与归一化 |

| Parity层次 | 证据边界 |
|---|---|
| In Runtime | 本次确实操作的模拟器App：拒权/恢复、手动记录、公开fixture候选控制、保存与检查 |
| Only in Prototype | 未重新操作独立HTML/设计原型；无本轮新增概念通过声明 |
| Divergent | 未执行完整原型对照，不能断言无差异 |
| Not yet productized | 真机语音和声纹保证、真实LLM/RAG、生产备份/发布不在本轮目标 |

TEST_FIXTURE 的**操作流程**在真实App中被操作过，其**识别内容**仍是模拟文本，不能据此证明真实ASR或机主身份。录音UI出现只证明进入会话状态；本轮未进行语音准确率、声纹校准或网络抓包。

## 7. Four Verdicts / Human Owner Gate

| Verdict | PR25历史 | 本轮 | 理由 |
|---|---|---|---|
| Product Experience Verdict | READY_WITH_MANDATORY_FIXES | **EXPERIENCE_READY** | 剩余mandatory P2满足重放条件，核心回归抽样无退化；仅限micro范围 |
| Release Evidence Verdict | BLOCKED_INCOMPLETE_EVIDENCE | **BLOCKED_INCOMPLETE_EVIDENCE** | exact包/运行已绑定；本次不是完整发布复现，未覆盖全部R3信任/注册重置分支；这不是要求追加范围外真机工程 |
| Prototype Concept Verdict | PROTOTYPE_PROMISING | **NO_PROTOTYPE_REVIEWED** | 本轮只操作新candidate runtime，不沿用旧原型概念评分 |
| Prototype-to-Runtime Parity | PARTIAL（旧报告原文） | **PARITY_PARTIAL** | 使用Core规范枚举；有runtime证据，无完整原型等价复验 |

**HUMAN_OWNER_GATE_REQUIRED。** 无本轮观察到的P0/P1或剩余mandatory P2；建议Parent据此完成当前候选的独立体验状态对账，并交Human Owner做最终产品决定。本报告不代表Owner Accepted、Release Authorized或Goal/Milestone Closed。候选变更后本结论不自动转移。

Owner可用不超过8分钟亲自复看：①在当前App点开A/B，检查内容和来源（1分钟）；②关闭麦克风，生成一条自己的合成演示候选，修改后丢弃，确认不入库且仍显示需授权（2分钟）；③拒权时手动记录一条非隐私示例（1分钟）；④按可见动作授权，返回后开始/取消录音（1分钟）；⑤重新打开App检查刚保存的内容（1分钟）；⑥判断是否理解模拟器/演示边界，是否愿意继续用这个记录流程（1分钟）。该脚本尚未由Human Owner执行，新增合成条目会保留；结束将权限恢复到个人偏好。

## 8. Evidence Manifest / Parent Handoff

[Evidence Manifest](EVIDENCE.md) 提供17张本轮精选原生截图的无损副本、全部50份布局原文、时间日志、安装/身份和hash；[Parent交接提示词](PARENT_HANDOFF.md) 可直接复制。所有截图为reviewer新采集，未复用LE/ED截图。Skill/report校验只验证报告结构与Core，不作为产品技术PASS或体验结论的替代。
