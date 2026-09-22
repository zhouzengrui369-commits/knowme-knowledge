# Owner Decision Brief

Review Mode: **FULL_EXPERIENCE_REVIEW — Owner 直接授权的独立产品体验审核**  
Candidate: KnowME Knowledge / GOAL-KK-03 / [PR #32](https://github.com/zhouzengrui369-commits/knowme-knowledge/pull/32)  
Commit: `d02014f185595ab9f73c423017842d2d2d268252`  
Artifact SHA-256: `11570648fada5a99bbca2f45ed79c4439260fe8185a9ba6515bfafdad8efcab8`

| Verdict | 裁决 |
|---|---|
| Product Experience Verdict | **NOT_READY**；首次使用和笔记保存闭环已可操作，但原始转写的追溯边界仍缺失 |
| Release Evidence Verdict | **BLOCKED_INCOMPLETE_EVIDENCE**；本次是模拟器产品体验，不是完整发布审计 |
| Prototype Concept Verdict | **NO_PROTOTYPE_REVIEWED**；本轮未另开权威 HTML 概念原型 |
| Prototype-to-Runtime Parity | **PARITY_PARTIAL**；实际录音/候选/笔记工作面已存在，未验证完整权威原型同构 |

核心承诺：把捕获的内容转成用户可编辑、明确保存、可回看来源的笔记。**PARTIAL**：显式保存与恢复成立；修正前的转写无法从笔记或候选界面找回。新发现 **P0=0，P1=1，关键 P2=2**。建议：**修复后定向复验**，本轮不出具 `PRODUCT_EXPERIENCE_PASS`。

正向证据：干净安装首屏用途、录音和声纹入口清楚；编辑标题/正文、保存 +1、取消/丢弃 +0、重复点击不重复入库均实操成立；两类未保存状态未在重启后入库，已保存笔记及其整理前输入仍可回看。

必须完成：**PX-KK03-01** 区分并保留最初转写与用户修正版；**PX-KK03-02** 保存连续点击不得意外打开系统设置；**PX-KK03-03** 旧回执与当前可用状态必须分清。复验限定这三项及保存/恢复/权限回归。无需 Owner 承担本轮例行回归；1.0 最终 Owner Acceptance 仍由本人决定。

## 1. 审核依据与角色

本轮由 Owner 明确授权，实际使用 `hdc uitest uiInput` 点击、输入、滚动、Home，并用系统命令强停/重开。未阅读或修改产品源码、测试、构建脚本；没有构建、运行技术测试或修复产品。只写审核报告和证据。工程的 67/67、LE 22/22、ED 21/21 是背景，不是本审核的通过依据。

执行 [product-experience-reviewer Skill](https://github.com/zhouzengrui369-commits/product-experience-reviewer-skill/tree/4253deb55a04de20fca6ac50a47b42a6d4489c04/product-experience-reviewer)，按其四裁决、问题合同、Stage A/B 与真实操作证据要求交付。

```yaml
reviewer_authority_commit: 4253deb55a04de20fca6ac50a47b42a6d4489c04
reviewer_authority_tree: eaa62967737b17cc8ad07e46e297e0a52b2c3092
core_sha256: 041a475d8cbc3404ed1e6df66c52377aecfcd631721d18a0ec9de59783f2b676
central_parent_commit: 118594ff0b853732a2da22270d9499573ff2201e
central_parent_tree: 84b57f804076fa34bf83218496575d07cfc457df
product_baseline: PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2
product_baseline_commit: 978ed0608bda8e278c348ad2987f6a25fa3c3c2f
contract_revision: R1
contract_commit: f38e48956dfcd8820cc090f04026839132508ece
contract_tree: 038e90271febcb11915b1534f4e0f7cfb33427f8
contract_blob: 20560b805f7bcdf267ed99468bbe39cba8ec45a3
```

权威顺序：Owner 本轮授权和已落 GitHub 的 Owner 政策 → 项目基线 v2 → 冻结 Goal03 R1 规定的本轮可交付范围 → 真实体验证据。合同用于范围公平，不能取消基线的原始证据与来源承诺。PM/ED 声明不替代独立判断。

新鲜 GitHub 记录： [激活](https://github.com/zhouzengrui369-commits/knowme-knowledge/issues/30#issuecomment-5759411988)、[工程交付](https://github.com/zhouzengrui369-commits/knowme-knowledge/issues/30#issuecomment-5764422020)、[包装修正](https://github.com/zhouzengrui369-commits/knowme-knowledge/issues/30#issuecomment-5768475365)、[Candidate Admission](https://github.com/zhouzengrui369-commits/knowme-knowledge/issues/30#issuecomment-5768482282)。09:40 复读时仍无单独的 `PRODUCT_REVIEW_ELIGIBLE` 回执。本轮凭 Owner 直接授权开展审核，**不伪造 PM 已发准入后续回执，也不因这一文书缺口中止体验**；Parent 需如实衔接治理状态。

候选所带 `governance/PRODUCT_BASELINE.md` 是旧 v1 快照；本审核另从合同指定的 `978ed060...` 读取 v2。该包装差异不能降低基线。当前候选 `docs/acceptance/PRODUCT_EXPERIENCE_PROFILE.md` 返回 404；采用已有项目 profile.yaml 的定位、当前基线和 R1 的 A–H 旅程作专项映射，不挪用旧档案评分。此处是报告口径，不是修改合同。

## 2. Candidate Identity

| 字段 | 实际绑定 |
|---|---|
| Repository / branch | `zhouzengrui369-commits/knowme-knowledge` / `engineering/goal-kk-03-voice-to-note-first-use-r1` |
| SHA / tree | `d02014f185595ab9f73c423017842d2d2d268252` / `fa5ab666c6df25420cdb619fec55a19a88aa72af` |
| Parent | `15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8` |
| PR base / handoff preimage | `42eaaa76748d08e875ed843d8a5543d922219ab4` |
| Main HAP SHA-256 | `11570648fada5a99bbca2f45ed79c4439260fe8185a9ba6515bfafdad8efcab8` |
| Paired ohosTest HAP SHA-256 | `9c3771916ef99bd2cc4e9e6ca82365dfb09f7e07a4b491d6bdb2ab69210f120c`；仅随同安装，未运行测试 |
| App | `com.knowme.knowledge.voiceprototype / EntryAbility`，版本 0.1.0 |
| Device / runtime | `hdc 127.0.0.1:5555`，OpenHarmony 6.1.1.125 / API 24 / aarch64，原生 1256×2760 |
| Host | macOS 26.2 / build 25C56 / arm64；hdc 3.2.0d |
| Local candidate | `KnowME knowledge/kk03-le-final3`；审核前后 SHA/tree 匹配、工作树干净 |
| Build command | 候选 README 声明 `scripts/build-hap.sh`；reviewer 未执行 |
| Model / provider | 本地声纹原型；笔记使用明确披露的确定性整理，无真实 LLM/RAG；模型能力不因标签而判真机有效 |
| Network | 本轮未改 WLAN；系统 AppInfo 显示“移动数据和 WLAN”访问选项。`ip route` 在设备不可用，未获得有效路由/抓包证据；“无云端上传”只作为 UI 声明及既有工程边界，不冒充本轮独立网络证明 |
| Prior review | Goal02 PR #28，另一候选、另一范围，不继承 PASS |
| Evidence transport | ED `ca836b360dfb2501614a800e0d729522eb776717` 仅背景；本轮截图全部重新采集 |

详见 [identity](evidence/reviewer-identity.json)、[环境命令](evidence/environment-commands.jsonl)、[操作日志](evidence/operation-log.jsonl)。

### 状态与数据影响

初始覆盖安装后看到 ED 的两条合成测试记录和已录入测试档案（02）。为按 R1 体验首次使用，随后**卸载此测试原型并安装同一已核 hash 的 HAP 对**，清除了这两条 ED 测试记录及原测试档案；未声称保留它们。此变化在操作前告知，原始 Stage A 不回写。之后从 0 条开始，本轮保存手动 M 和笔记 N，最终 **2 条**；取消 SOURCE、丢弃候选、重启 PENDING 和默认草稿均未增加条数。

麦克风由拒绝改为允许，结束时已授权。通过系统 `say -v Tingting` 播放合成语句完成三句测试录入；最终保留此合成测试档案，不是 Owner 生物身份。未上传音频、声纹、embedding、HAP、凭据或真实私密资料。最终应用未录音、无未保存候选/草稿。

## 3. Stage A Frozen Output

[stage-a.md](evidence/stage-a.md) 于 `2026-09-22T09:15:19.573761+08:00` 冻结，SHA-256 `8f24df52a9a86d00309467363b3a14cafc5fea1fd442efb7648ae8e3dab5dea7`。

**PRIMED_COGNITIVE_WALKTHROUGH**：已有前轮上下文并看过本轮候选/激活元信息，不能称真正隔离盲测。Stage A 看到的是已有 ED 合成记录的冷启动；“干净首用”是之后的 Stage B 实操 09，二者不混称。初始判断：用途与主动作明确，旧回执可能拖慢内容导航。全文以冻结附件为准。

## 4. Stage B — 定位与基线对照

1. **用户与价值**：单 Owner 的本地优先个人知识 Agent。本轮检验语音/测试转写到可编辑笔记，不把它改成纯录音器验收。
2. **核心理念**：当前工作与 Agent 上下文相连，显式控制入库，来源可追溯。09 首屏目的清楚，43 编辑面工作明确；93/106 旧消息混作当前行动提示削弱上下文可信性。
3. **原始证据**：基线 `RAW_ASSET=保留原始证据，不得静默丢弃`，R1 要求 original transcript/source inspectable。笔记正文编辑没有覆盖整理前输入；但保存转写修正后，最初转写已无法经产品界面回看（55→57→59），两层须分别判定。
4. **允许限制**：模拟器声学失败、确定性整理、未连接真实模型都在 R1 允许范围，不因此定缺陷。录音返回 UNCERTAIN 不证明真实 ASR 成败，不能以 fixture 笔记成功冒充自然语音端到端成功。
5. **交付状态**：基本闭环已从工程面板改善为可见工作面，但来源边界与结果导航仍有明确修复项。Owner 授权并不使工程/PM 的通过声明成为体验事实。

## 5. Scope & N/A

| 旅程/维度 | 状态 | 理由 |
|---|---|---|
| A 首用、B 声纹入口/状态、C 录音/权限 | IN_CURRENT_RELEASE_SCOPE | R1 直接要求；本轮已实际操作 |
| D 修正/丢弃、E 整理和标题正文编辑、F 保存/溯源、G 恢复 | IN_CURRENT_RELEASE_SCOPE | 核心笔记闭环；fixture 仅证明披露的模拟器分支 |
| H 当前工作/Agent 上下文、旧记录与当前状态辨识 | IN_CURRENT_RELEASE_SCOPE | R1 AO-08 与产品基线 |
| 修正前原始转写和用户修正版的区分 | IN_CURRENT_RELEASE_SCOPE | 基线原始证据及 R1 原始转写要求；无需完整版本管理系统 |
| 真机 ASR、生产生物认证、真实 LLM/RAG、语义总结质量 | OUT_OF_CURRENT_RELEASE_SCOPE | R1 明确排除，不评分、不判 PASS |
| 多格式导入、完整 Wiki/Calendar/Todo、同步备份 | OUT_OF_CURRENT_RELEASE_SCOPE | 全产品方向保留，不以当前缺失否定本轮 |
| 正式发布、生产级数据保留和网络保证 | OUT_OF_CURRENT_RELEASE_SCOPE | 本审核不能证明或授权 |

## 6. Runtime User Journey Walkthrough

所有步骤同一候选 `d02014f...`；时间为 2026-09-22 Asia/Shanghai，逐动作精确时间见 [Evidence](EVIDENCE.md) 和 JSONL。下列“感受”是 reviewer 的理解成本判断，不代表真实人类偏好调查。

| Journey / 时间与证据 | 重放操作 | 预期 → 实际 | 用户感受 / 裁决 |
|---|---|---|---|
| A / 09:17 左右，09 | 卸载测试安装后重新打开 | 0 条、用途、录音/录入声纹在首屏；fixture/技术诊断折叠 → 符合 | 知道下一步；PASS |
| B / 09:33–34，68–74 | 打开声纹管理，三次开始/合成朗读/停止 | 0/3→1/3→2/3→3/3；“档案已录入”与“本次尚未捕获”分开 | 流程可理解；PASS（仅模拟器合成音） |
| C / 09:16、09:18、09:33–35，05–07、10–13、66–77 | 开始/观察计时/取消；拒绝权限；设置允许并返回；录入后真实开始/停止录音 | 取消 +0；拒权后手动可用，允许后状态刷新；实际音频返回 UNCERTAIN，不入库，提供重说/丢弃 | 状态诚实；PASS。拒绝后自动打开系统设置有额外跳转成本 |
| D / 09:20–33，20–23、33–35、53–57、63–64 | 次要工具生成测试候选，修正，保存修正；另一候选丢弃 | 来源始终 TEST_FIXTURE；未确认不入库；丢弃 +0 → 成立；修正前文本不再可回看 | 控制可用，原始追溯缺口；PARTIAL / PX-KK03-01 |
| E / 09:22–31，36–43、55–59 | 整理；改标题和正文；展开来源 | 一份草稿、标题正文可编辑、明确非 LLM；正文 5 点 vs 整理前输入 4 点同时存在 → 成立；更早 3 点/探针 9 点不保留在界面 | 可整理且可改，来源层次不足；PARTIAL / PX-KK03-01 |
| F / 09:24–33，43–49、60、64 | 双击保存、Back 返回、点列表；取消另一草稿和丢弃候选 | 保存仅 +1，总数 2；取消/丢弃 +0；列表点开可溯源 → 成立；双击保存意外打开 AppInfo | 结果存在，导航出乎意料；PARTIAL / PX-KK03-02 |
| G / 09:37–39，89–96、102–106 | 分别在候选、草稿态 Home 返回，再 force-stop/cold reopen；打开已存 N | Home 保留未保存工作；强停后无候选/草稿入库；2 条已保存内容仍在；94 点 N +95 滚动，共 2 交互看完正文/来源 | 数据边界成立；PASS（有界原型持久化） |
| H / 09:24–39，46、60、93、106 | 保存/取消后返回；冷启动读当前屏 | 即时结果说明 +1/+0；重启声明恢复 2 条 → 成立；旧“未授权”“已生成草稿，点保存”仍像当前提示且无可操作草稿 | 需要自行推断哪些话失效；PARTIAL / PX-KK03-03 |

**输入纪律**：26/28 曾因 hdc 输入重新点击消除选区而形成重复文字，属于操作者失误；30–35 清空后重新输入才是有效修正。83 点击了键盘区域，没有生成候选；88 重新定位后才实际生成。01/08/部分滚动捕获为转场；以稳定截图及邻接布局判定。未把上述动作归为产品缺陷。106 个 capture 序号不等于 106 个独立测试案例。

## 7. Prototype / Parity 独立轨

R1 的 UI authority pin 是 `15a50071202536af05c51e45e04b738dcc81cbdf` / tree `a63446138525020ab269c630c6507b6e7be74870` / HTML blob `097e2c978877f5480a63e9da55acf5fb27e60a43`。本轮阅读该引用及设计语法，**没有打开和操作该 HTML**，因此不出概念评分，不声称像素一致。

| Experience | Where |
|---|---|
| In Runtime | 首用录音入口、声纹管理、转写候选、笔记标题/正文编辑、列表来源、保存恢复 |
| Only in Prototype | 本轮未核实，不凭旧截图列举为已验证能力 |
| Divergent | 当前运行界面的旧回执占据主要上下文区域，见 PX-KK03-03；不是已完成 HTML 比对的结论 |
| Not yet productized | 真机语音质量、真实模型语义整理、全量知识工具/同步等当前合同外能力 |

## 8. Inheritance Matrix

| Issue / 历史主题 | Prior | Current | Evidence | Closed? / Regressed? |
|---|---|---|---|---|
| PR #28 的拒权状态与候选操作一致性 | Goal02 微范围通过 | 当前候选拒权标签保留、手动路线可用、允许后刷新 | 13、23、59、67 | 原结论不转移；本轮样本未见该状态丢失回归 |
| 显式入库、来源标注、未确认不入库 | Goal02 已有证据 | 本轮笔记范围重新操作 | 43–49、60、64、91–106 | 基本边界成立；新增前修正来源问题独立编号 |
| 声纹长期档案 vs 本次结果 | Goal02 已有证据 | 3/3 已录入，但自然录音 UNCERTAIN | 74、77 | 这两个当前样本未回归；非完整信任矩阵 |
| ED “本候选无阻塞缺陷” | 工程声明 | reviewer 新发现 01–03 | 本报告问题合同 | 不继承/不覆盖历史回执；新增独立结论 |

## 9. Runtime Scoring

以下按 R1 A–H 映射，不是新合同阈值。平均分不抵消 P1。

| Dimension | Score | Applicable | Evidence | Reason |
|---|---:|---|---|---|
| 首次用途与主动作 A | 4/5 | YES | 09 | 无外部说明可辨认用途与开始动作 |
| 身份状态理解 B | 4/5 | YES | 68–74、77 | 长期档案与当前结果明确分开 |
| 录音/权限 C | 4/5 | YES | 05–07、10–13、67、75–77 | 计时/停止/取消可用，拒权有手动路径 |
| 候选控制 D | 4/5 | YES | 35、53–57、64 | 可修正/丢弃，未自动保存 |
| 可编辑笔记 E | 4/5 | YES | 36、43 | 标题和正文独立可编辑，确定性整理诚实 |
| 来源与保存 F | 2/5 | YES | 43–49、55–59 | 最初转写不可回看；连续保存意外跳转 |
| 恢复 G | 4/5 | YES | 91–96、102–106 | 保存保留，未保存不入库 |
| 当前上下文 H | 2/5 | YES | 93、106 | 已失效提示与当前状态混排 |
| 真机准确率/真实模型质量/生产持久化 | — | N/A — OUT_OF_CURRENT_SCOPE | contract.md | 不纳入分数、不作推定 |

## 10. Issue PX-KK03-01 / “原始转写”只剩用户修正版，初次捕获文本不可追溯

**Severity: P1**  
Journey: D/E/F；AO-03、AO-05；基线 RAW_ASSET。  
User Promise Violated: 原始证据保留、保存笔记可追溯到原始转写；不是要求完整版本历史。

**Observed Behavior:** 53 原候选为“PX22-SOURCE：会议原定九点。”；55 同一界面同时显示原候选九点、编辑框十点。点击“保存修正”（57）后，候选显示变为十点；整理并展开“原始转写与来源”（59）时，“原始转写(整理不会覆盖它)”也是十点，界面没有入口找回九点。另一路保存 N 后可回看 4 点修正版，但最初 3 点不再出现（20/23→35→43→49→96）。

**Expected Behavior:** 用户能分别知道“最初捕获了什么”“我修正成什么”“笔记写成什么”；三者来源连续。修正版可以作为整理输入，不能借“原始转写”标签掩盖前一层已不可追溯。

**Evidence:** [55 修正前并列](evidence/published/55-source-corrected.png)、[59 整理后来源](evidence/published/59-source-provenance.png)、[43 编辑笔记](evidence/published/43-edited-draft.png)、[96 冷启动溯源](evidence/published/96-cold-note-stable.png)，以及 20/23/35/53/57 的全布局和实际输入日志；同一候选及 HAP hash 见 §2。

**Likely User Impact:** 用户后来发现一次修正有误时，不能从该笔记判断最初记录是什么，只会看到修正版被标为原始，削弱复核能力。

**Current Scope:** IN_CURRENT_RELEASE_SCOPE。  
**Required Behavior:** 在本次候选/笔记的可视路径保留一份最初转写，修正版另列为用户修正/整理输入；可不做无限版本管理。

**Acceptance Criteria / Focused Retest Steps:**
1. 输入九点候选，改成十点并保存修正，再整理成笔记；来源能区分九点原文与十点用户修正版。
2. 将笔记正文改为十一点并保存，只增加 1 条；重开后仍能回看上述两层来源，最初转写至少在两次产品交互内可见。
3. 取消/丢弃仍 +0；fixture 来源不可变成真实语音或机主认证。

**Required Retest Evidence:** 最初候选、修正版保存前后、笔记来源、最终正文、保存计数、冷启动来源截图及操作序列；冻结新 SHA/HAP。  
**Regression Risk:** 不得把取消/丢弃内容自动入库，不得把用户修正文案回退，不得降低 fixture 披露。

**分级限度：** 原始转写字段的变化发生在用户明确点“保存修正”时，未证明数据库物理删除，亦未观察到模型整理覆盖该字段。因此不写“整理导致原始数据丢失”，不升 P0。P1 判定针对基线要求的原始捕获追溯在产品界面缺失；若 Parent 要允许只留修正版，必须走基线/合同 Change Request，而不能口头改称通过。

## 11. Issue PX-KK03-02 / 连续点击“保存笔记”后意外进入系统设置

**Severity: P2 — mandatory fix**  
Journey: F/H；AO-06、AO-08。  
User Promise Violated: 保存完成后回到笔记/Agent 上下文，重复点击不产生另一无关动作。

**Observed Behavior:** 麦克风拒权、草稿来源已展开；43 的“保存笔记”位于 `[101,2278][611,2418]`。实际 `doubleClick 350 2340` 后 44 进入系统 AppInfo。46 Back 返回显示仅 +1、总数 2；没有重复笔记，权限仍未授权。

**Expected Behavior:** 双击保存仍留在产品，显示一次保存结果，不打开系统设置或启动其他动作。

**Evidence:** [43 保存前](evidence/published/43-edited-draft.png)、[44 保存后系统页](evidence/published/44-note-save-doubletap.png)、[46 返回后的计数](evidence/published/46-save-return.png)、operation-log 中对应 doubleClick 成功执行；§2 精确候选。

**Likely User Impact:** 用户确认保存后被带离笔记，以为仍需授权才能完成保存，必须返回确认结果。  
**Current Scope:** IN_CURRENT_RELEASE_SCOPE。  
**Required Behavior:** 连续点击只完成一次保存并呈现完成状态，不能触发页面变化后的其他行为。

**Acceptance Criteria / Focused Retest Steps:** 拒权+展开来源+编辑草稿下分别单击、双击保存；两种情形都 +1、无系统跳转。允许麦克风时重复同样操作，不自动开始录音。重开后无重复笔记。

**Required Retest Evidence:** 动作前后截图、真实双击/快速两击日志或录屏、总数和权限/录音状态、候选身份。  
**Regression Risk:** 保存按钮响应性、去设置动作仍可由用户主动触发、录音权限流程。

此问题本轮观察到 **1 次明确事件**，未宣称每次必现，也没有通过源码推断事件穿透机制。下一候选须按同一场景复验；“没有重复保存”不能覆盖导航异常。

## 12. Issue PX-KK03-03 / 历史回执像当前指令，重启后提示操作已经不存在的草稿

**Severity: P2 — mandatory fix**  
Journey: H，关联 G；AO-08。  
User Promise Violated: Agent 保留上下文，同时清楚解释当前已完成、可继续的工作。

**Observed Behavior:** 93 顶部已显示“权限已授予”，同屏历史区域仍直接写“麦克风权限未授予”“请在系统设置中允许”，未标为过去事件。106 强停重开后草稿已按设计丢弃、数量仍 2，历史却仍写“已整理成笔记草稿…点保存…点取消”，没有对应草稿操作面，也没有明确解释该草稿未恢复。历史中多段 TEST_FIXTURE 回执占据大块主要视区。

**Expected Behavior:** 当前状态/可行动项与历史分开；恢复后说清已恢复保存内容、未保存工作是否存在，旧回执不能充当当前待办。

**Evidence:** [93 转写恢复](evidence/published/93-transcript-cold-stable.png)、[104 草稿后台保留](evidence/published/104-draft-background.png)、[106 草稿强停后](evidence/published/106-draft-cold-stable.png)，§2 精确候选。

**Likely User Impact:** 用户会反复去授权、寻找已经不存在的草稿按钮，并需要自己推断哪些 Agent 话语过期。  
**Current Scope:** IN_CURRENT_RELEASE_SCOPE。  
**Required Behavior:** 明确历史/当前边界；取消、拒权解除及冷启动后给出可理解的现状，仍可查历史，但默认页面不要被旧测试回执主导。

**Acceptance Criteria / Focused Retest Steps:**
1. 拒权后重新授权，回到应用，不再把拒权文案当作当前行动提示。
2. 生成草稿后 Home 返回能继续；强停重开后不入库，并明确草稿未恢复，不提示点击不存在的保存/取消。
3. 已保存笔记与来源继续可访问，必要历史可回看，测试/诊断依旧次要。

**Required Retest Evidence:** 拒权/允许前后、Home 与强停前后整屏截图；用户到已有笔记的操作路径；计数/来源。  
**Regression Risk:** 不得为清理界面删除已保存知识，不得把旧草稿自动保存来“匹配”历史消息。

## 13. 非阻塞观察与未覆盖项

- **P3 / 次要测试入口反馈**：输入后软键盘仍展开，生成候选插到页面上方；需要关闭键盘并向上找。只影响披露的 fixture 辅助路径，不能代表自然语音候选必有同样问题。
- **P3 / 首屏方向词**：欢迎语说“点下方开始录音”，实际按钮位于欢迎语上方。不是阻塞。
- 未完整重测 VERIFIED/NOT_OWNER/NOT_AVAILABLE 等全部信任分支；本轮新自然样本是 UNCERTAIN。没有真机、真实模型、网络抓包或生产备份验证。
- 未重新运行工程长时采样冻结复现或技术回归，因本角色是产品体验审核；不能转述 ED 修复为独立验证通过。

## 14. Four Verdicts 与 Human Owner Gate

最终四项裁决同顶部，不因工程全部 PASS、某项体验通过、Owner 直接授权而提高。

**Product Experience: NOT_READY**。P1-01 开放，P2-02/03 必修；功能已可用的部分保留正向结论。Release Evidence 为 **BLOCKED_INCOMPLETE_EVIDENCE**，不是“候选无法复现”：当前 SHA/HAP/安装/操作链可复核，但本报告不含完整发布范围、自然信任全分支和独立网络验证，也未审完整 HTML parity。

**Human Owner Gate 政策适配：** 通用 Skill §17 的默认 `HUMAN_OWNER_GATE_REQUIRED` 不可机械转化为本轮再次请 Owner 跑例行测试。项目已落 GitHub 的 [Owner-directed 政策](evidence/owner-policy.md) 与 R1 规定 `DELEGATED_TO_PRODUCT_EXPERIENCE`、`HUMAN_OWNER_ACCEPTANCE_REQUIRED=NO`（pre-1.0）；当前用户继续授权独立审核，与之相符。故此 Goal 的例行 Human Owner Gate **NOT_REQUIRED**；本报告既不代签最终 Owner Acceptance，也不宣布 Merge/Release/Goal 关闭。修复和独立复验由交付角色承担，1.0 最终验收留给 Owner。

## 15. Evidence / 后续

[证据索引与时间线](EVIDENCE.md) · [Parent 可复制交接](PARENT_HANDOFF.md) · [Skill 校验](evidence/skill-validation.txt)。证据保留操作失误与未成功的环境查询，不把缺失项改写成通过。全部新增文件只在 `reports/product-review/`。
