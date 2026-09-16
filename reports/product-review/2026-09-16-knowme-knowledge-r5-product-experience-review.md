# Owner Decision Brief

Review Mode: EXPLORATORY_PRODUCT_REVIEW（Owner 直接授权的完整原型观察）
Candidate: KnowME Knowledge GOAL-KK-01 R5，PR #9
Commit: 40063afd16a36674e8660f6b4a05315d51f4e546
Artifact SHA-256 / Deployment ID: 60feb609628659a0a5fcecc9d0fd2ed7d64dc6b765753a0d25dae5190d09afdf

Product Experience Verdict: BLOCKED_RUNTIME_ACCESS（真实产品 Runtime 未提供；不阻止本次原型体验）
Release Evidence Verdict: BLOCKED_INCOMPLETE_EVIDENCE（原型，不是 release candidate；未确认正式准入/独立审核资格）
Prototype Concept Verdict: PROTOTYPE_PARTIAL
Prototype-to-Runtime Parity: PARITY_NOT_APPLICABLE（本 Goal 明确只交付原型）

本轮核心承诺：在手机竖屏中，用同一 Agent 上下文完成知识捕获、理解、调用及日历/待办工作。
核心承诺是否成立：部分成立。捕获入口、导航、日历联动可操作；新增知识引用与工作面内容不一致，持续感知状态在工作面被遮挡，确认语义不清。
上一轮 P0 状态：未提供独立体验报告，不继承 Engineering 的“无缺陷”或 80/80 为体验结果。
本轮新 P0：未在所操作的合成 Mock 旅程中确认 P0；不推断全产品 P0=0。

最重要的正面信号：
1. 360×780 下，首屏具有个人知识 Agent 身份、知识计数、已知/未知和明确 Mock 标识。
2. 修正后的笔记进入知识导航与知识日历；对话在普通浮层切换后保留。
3. 日程顺延至次日、完成、引用到对话，以及 Todo→对应日历可真实操作；日历与知识日历均可切换日/周/月。

必须处理：P1-01 来源与回答/工作面错配；P1-02 持续感知可见性；P2-01 修正/确认状态；P2-02 返回路径文案。具体行为与复验标准见下文。
Owner 当前建议：[x] 修复后定向复验；当前不作正式 Owner Acceptance、发布或 Milestone 关闭。

## 1. 身份与独立性披露

本任务此前 author 过 bootstrap 治理文档，是原 Parent PM 上下文，未 author 产品候选，也未修改本轮产品代码。用户随后直接授权体验审核并提交 GitHub。本轮实操与意见有效作为 Owner-requested exploratory observations，但不能把同一上下文自称为正式独立 reviewer，不能代签 Human Owner Acceptance。未由 PM 预设 verdict。

Stage A 为 PRIMED_COGNITIVE_WALKTHROUGH：此前已知产品基线，本轮还读取过 PR 描述；不是 BLIND_TEST。初印象单独冻结，见证据目录 stage-a.md。未创建独立盲测子上下文，本报告不声称隔离盲测完成。

不查、不改产品源码/测试，不运行产品断言测试，不重建候选。仅下载并运行已发布的 HTML transport artifact，使用真实浏览器 AX 点击、键盘输入和截图；技术回执只用于定位 exact artifact。

## 2. Candidate identity

- Repository: zhouzengrui369-commits/knowme-knowledge
- Branch: engineering/goal-kk-01-agent-native-mate60-prototype-r1
- Commit SHA: 40063afd16a36674e8660f6b4a05315d51f4e546
- Tree: 72464ee6727af4837cb24b77238f7ddadeca02ed（Engineering 回执；发布前 GitHub 再核验）
- Parent: 3c2088888a0896f9bb0149560dcfbf5412adb2f4
- Working Tree Status: 未 checkout/修改产品候选；下载产物字节以 Git blob 与 SHA-256 核验。
- Candidate App / URL: loopback HTTP 静态服务中的 self-contained HTML；仅桌面浏览器模拟 360×780，不是 Mate60 真机。
- Artifact evidence commit: c51f7b3d4a0c5d7afdce9e9849b734321c86674f
- Artifact path: reports/prototype/knowme-knowledge-01-agent-native-mate60/deliverable/KnowME-Knowledge-01-Prototype.html
- Artifact Git blob: 910bb08194c1a42bd8f1ad945709119d99495786
- Artifact bytes: 199404
- SHA-256: 60feb609628659a0a5fcecc9d0fd2ed7d64dc6b765753a0d25dae5190d09afdf
- Build Command: 交付 README 记载 npm run build 后内联 JS/CSS；本轮未执行、未独立重建。
- Build Timestamp: 本轮未独立核验；不用于 release 声明。
- OS / Architecture: macOS 26.2 / arm64。
- Browser / Runtime: Codex in-app browser；具体内核版本未采集。
- Backend / Database / Model / Provider: UI 明确 deterministic Mock、非真实数据、无真实后端/ASR；未接真实 Provider。
- Dataset: 初始 6 条 fixture + 本轮一条合成读书笔记；未导入 Owner 私密数据。
- Network: loopback 提供完整 HTML；本轮未实施网络断开实验。
- Configuration Snapshot: 新建独立端口页面、360×780 viewport、无账号/凭据注入；结束恢复 viewport。
- Previous Review: 未发现可继承的独立体验报告；Engineering 自测不代替此项。

下载说明：最初按 terminal receipt 中较早 evidence commit 请求 HTML 返回 404；随后 fresh 固定到包含 artifact 的 c51f7b3...。gh raw 输出产生的字节与 declared hash 不符，因此改用 Git blob API base64 解码，双重验证 blob/hash 后刷新页面，之后全部正式记录操作基于一致字节。没有修改 artifact 来凑 hash，也未把错误下载当产品缺陷。

## 3. 阶段 A 冻结结果

仅根据实际使用，我认为这是一个以对话为中心、可把文本变成知识并联动日程的手机原型。捕获入口清楚，Mock 标识有助识别边界；但保存修正即入库、待确认与已确认并存，以及新笔记被套用航材结论，让我难以确定系统是否理解并正确保存了内容。日程顺延、完成和引用到对话可操作，产品价值还需靠知识内容一致性补足。

## 4. Stage B 基线对照 / 当前范围与 N/A

基准为 Product Baseline v2（governance/PRODUCT_BASELINE.md @62d1a377f7a9824630a3abbf5fd5bbf6d87e7254）及 Contract R2（@978ed0608bda8e278c348ad2987f6a25fa3c3c2f，tree db0be0e4ac22b9780cf5cf3c80998d3cfd15731d，blob 05bc2ca7cce5e8645301994b348f702f2286d3f3）。未用 bootstrap v1 取代 successor。

IN_CURRENT_RELEASE_SCOPE（此处指当前原型合同）：JOURNEY A–E、个人知识 Agent 身份、文本候选/修正/拒绝、上下文工作面、五维/九维导航、知识日期视图、日历三视图/Todo 联动、持续模拟感知状态及诚实能力披露。

OUT_OF_CURRENT_RELEASE_SCOPE：真实 HarmonyOS、模型/Harness、ASR/声纹、RAG、长期记忆、真实导入、真实日历后端、跨刷新持久化、真实 Owner 数据与 production release。不因未实现这些给原型扣分。

AMBIGUOUS_SCOPE / 未完成证明：R5 相对已批准 R2/R3 CR 的范围裁决与正式 admission 未由本轮重新 adjudicate；精确 Owner Demo 视觉并排对照和真机体验未执行，不声明 UI lineage PASS。项目独立 Product Experience Profile 未取得，使用冻结合同 A–E 作为本次观察映射，不自写验收基线。

产品理念已经有可操作原型表达，但知识“成长后能重新调用”的价值尚被内容错配削弱，不能由页面数量或测试通过数替代。

## 5. Runtime 用户旅程

真实产品 Runtime：未提供。所有下列操作属于 Prototype，不能提升 Runtime 分数。

## 6. Prototype 用户旅程记录

所有步骤发生于本轮浏览器交互，顺序号与截图文件名对应；截图为 360×780，顺序用作时间/序列证据。

| 旅程 | 操作与实际结果 | 用户影响 / 结论 | Evidence |
| --- | --- | --- | --- |
| A 首次认识 | 首屏显示灵犀、6 条知识、未知提示、Mock 标志；底部捕获/知识/日历/待办/技能 | 下一步可辨识；模拟边界明确 | 14（刷新回初始） |
| C 输入 | 捕获合成文本“审核样例：明天下午三点整理读书笔记，先核对原文再更新知识。”→生成候选 | CANDIDATE、来源、确认/修正/拒绝清楚 | 01 |
| C 修正 | 修正标题为“审核样例：读书笔记复核”→保存修正 | 立即入库为第 7 条，无再次确认；详情待确认与 CONFIRMED 并存 | 02、03 |
| D 工作面 | 由新增笔记打开工作面 | 标题正确，正文却为 30 分钟/4 小时 AOG 结论，显示来源可追溯/冲突1项 | 04 |
| B 相关提问 | 问“我的读书笔记复核要做什么？” | 回答没有覆盖，引用 AOG；与“之后相关问题会引用”承诺不符 | 05 |
| B 精确标题 | 输入“审核样例：读书笔记复核” | 引用新笔记标题，但回答 ABC 关键件延迟两天 | 13 |
| E 日程操作 | 比较备用供应方案→顺延一天→明天→完成→引用对话 | 次日可见并可完成；quote 携日期回对话并关联供应商知识 | 06、07 |
| E Todo 深链 | 待办“补齐备用供应商成本证据”→在可视化日历查看 | 到今天日历且显示相关待办 | 浏览器 AX 操作记录；08/09 为后续视图 |
| E 三视图 | 日历日→周→月 | 可切换；顺延日程周视图仍可见，但 11:00 排在 10:00 前 | 06、08、09 |
| D 知识导航 | 展开工作记录 | 计数4且新增条目可见；完整五维/九维入口可见 | 10 |
| D 知识日历 | 按日历查看→日/周/月 | 新笔记在今天5条中可见；周/月切换可操作 | 11、12 |
| A/D 感知 | 主面板暂停成功，打开知识/日历浮层 | 暂停状态返回后保留，但浮层遮住整个感知条 | 08、10；AX 暂停记录 |
| 连续性 | 浮层返回保留对话；刷新 | 刷新回6条及初始对话，暂停也复位 | 14；合同允许无真实持久化，不定为数据丢失P0 |
| 边界 | 技能入口 | PLANNED，并说明后续 Goal；未伪装连接 | 浏览器 AX 记录 |

未覆盖：拒绝候选、第二种输入修正、九维每一维的展开、真实断网、file://本轮复验、真实设备及完整 UI authority parity。不能由已有80/80替代这些缺口。

## 7. Prototype-to-Runtime Parity

| Lane | 本轮事实 |
| --- | --- |
| in-runtime | 无真实产品 Runtime 被操作 |
| only-in-prototype | 对话、知识捕获/导航/工作面、日历/Todo联动、模拟感知 |
| divergent | 不对未提供 Runtime 作推断 |
| not-yet-productized | Harness/Provider、持久化、真实ASR/RAG/日历等，合同外 |

## 8. 历史问题继承矩阵

| 原问题 | 当前状态 | 新证据 | 是否关闭 | 是否回归 |
| --- | --- | --- | --- | --- |
| Engineering 所述历史 D-01/D-02 | BLOCKED | 未取得独立旧问题验收合同 | 不宣布 | 未判定 |

## 9. 评分

Runtime 评分全部 N/A，不归一化。以下仅为本轮观察的 Prototype 分数，不汇总为产品通过：

| Dimension | Score | Applicable | Evidence | Reason |
| --- | --- | --- | --- | --- |
| Agent 身份与入口 | 4/5 | IN_CURRENT_RELEASE_SCOPE | 14 | 入口和上下文清楚 |
| 知识内容与来源一致性 | 1/5 | IN_CURRENT_RELEASE_SCOPE | 04、13 | 新标题配错正文 |
| Owner 状态/控制理解 | 2/5 | IN_CURRENT_RELEASE_SCOPE | 01–03 | 修正与确认混合，状态相互矛盾 |
| 导航及日期组织 | 4/5 | IN_CURRENT_RELEASE_SCOPE | 10–12 | 新知识可找回，尚未穷尽九维展开 |
| 日历/Todo 协作 | 4/5 | IN_CURRENT_RELEASE_SCOPE | 06–09 | 核心快速操作联动成立，顺序有瑕疵 |
| 持续感知语义 | 2/5 | IN_CURRENT_RELEASE_SCOPE | 08、10 | 主页面可暂停，浮层遮挡状态 |
| Owner Demo 精确视觉继承 | N/A | IN_CURRENT_RELEASE_SCOPE / NOT_EVALUATED | — | 未执行并排对照，不能当PASS |
| 真实模型/ASR/持久化 | N/A | OUT_OF_CURRENT_RELEASE_SCOPE | Contract R2 | 不以未来能力扣分 |

## 10. Issue contracts / P0–P3 问题与复验合同

### KK-PX-R5-01 / 新知识来源与正文错配

Severity: P1（当前明确是 Mock 原型；不冒充真实 Owner 数据事故 P0）
Journey: B / D
User Promise Violated: 当前知识引用、所选条目上下文工作、AO-03/AO-04 的可理解性。
Observed Behavior: 完整标题“审核样例：读书笔记复核”命中新条目后，正文为 ABC 延迟两天；其工作面显示30分钟/4小时与“来源可追溯”。相关自然问法则说没有覆盖。
Expected Behavior: 即使 deterministic Mock，也应使用被引用条目的内容，或明确无法模拟该条目；不得把无关航材内容挂到新笔记名下。
Evidence: 03、04、05、13。
Likely User Impact: 用户无法相信“知识增长”真的进入 Agent 上下文，引用装饰掩盖内容脱节。
Current Scope: IN_CURRENT_RELEASE_SCOPE；不要求真实模型/RAG。
Required Behavior: 新笔记、引用正文、工作面与来源保持语义一致；无可用结论时诚实为空。
Acceptance Criteria: 用两条不同主题合成知识，分别确认后按标题询问/打开工作面，正确返回各自内容或明确模拟边界，无跨主题模板；不虚构冲突/证据。
Focused Retest Steps: 冷开→捕获两条→确认→自然问法/全标题→来源→工作面→返回。
Required Retest Evidence: exact candidate/hash、输入/确认/回答/工作面截图与连续交互记录。
Regression Risk: 已有 AOG fixture 路由、unknown 分支和来源跳转。

### KK-PX-R5-02 / 工作浮层遮挡持续感知状态

Severity: P1
Journey: A / D / E
User Promise Violated: Contract AO-09 明确要求 ordinary sheet/work-surface interaction 中 persistent sensing status remains visible。
Observed Behavior: 360×780 下，知识、日历周视图及工作面覆盖底部感知条，用户无法看见正在感知还是暂停。
Expected Behavior: 常规工作中保留可见的模拟感知状态与明确暂停/恢复入口。
Evidence: 03、04、08、10。
Likely User Impact: 在主工作期间失去感知状态与控制的可见性；持续感知产品语义退化为首屏装饰。
Current Scope: IN_CURRENT_RELEASE_SCOPE。
Required Behavior: 可见且可操作的感知状态贯穿工作面，仍标识无真实ASR。
Acceptance Criteria: 感知运行/暂停两种状态分别打开知识、工作面、日历、待办，均可见状态且可控制，无内容遮挡。
Focused Retest Steps: 360×780 冷开→运行与暂停各一轮→四种面板→返回。
Required Retest Evidence: 各状态截图和真实点击序列。
Regression Risk: 面板高度、底部操作可达性、对话上下文。

### KK-PX-R5-03 / 保存修正即确认且状态矛盾

Severity: P2
Journey: C
User Promise Violated: AO-04 要求 Owner confirmation/correction/rejection 的清楚语义。
Observed Behavior: 点击“保存修正”直接入库，随后详情同时有“待确认”和CONFIRMED。
Expected Behavior: 如果按钮包含最终入库应明确说明；或保存后回候选等待确认。已确认状态不再带待确认标签。
Evidence: 01、02、03。
Likely User Impact: 用户难以判断保存草稿还是批准入库。
Current Scope: IN_CURRENT_RELEASE_SCOPE。合同未强制独立二次确认，因此不将缺少额外点击夸大为越权P0。
Required Behavior: 操作名称与状态迁移一致；单一可信状态。
Acceptance Criteria: 修正后用户可在点击前理解是否入库，计数与最终状态同步，无待确认/已确认并存。
Focused Retest Steps: 新文本→候选→修正→保存→观察计数/详情→另测拒绝分支。
Required Retest Evidence: 保存前后和详情截图。
Regression Risk: 直接确认、拒绝、计数及日期导航。

### KK-PX-R5-04 / “返回 Agent 对话”没有直接返回对话

Severity: P2
Journey: D
User Promise Violated: 返回目标与操作名称一致，AO-03 的可理解性。
Observed Behavior: 从新增笔记详情进入工作面后，点“返回 Agent 对话”先退回详情，关闭详情后又回知识导航，需再关闭才回对话。
Expected Behavior: 该按钮直接返回对话，或准确命名为返回上层。
Evidence: 04 与本轮 AX 顺序记录；截图只证明按钮文案，路径需定向复验。
Likely User Impact: 额外关闭步骤，用户误以为返回无效。
Current Scope: IN_CURRENT_RELEASE_SCOPE。
Required Behavior: 目标明确且路径一致。
Acceptance Criteria: 从知识导航/对话两种来源打开工作面，按钮抵达其标明目标，既有对话保留。
Focused Retest Steps: 导航→条目→工作面→返回；对话动作→详情→工作面→返回。
Required Retest Evidence: 连续录屏或逐步截图/AX。
Regression Risk: 多层浮层导航状态。

P3 观察：顺延后日视图/周视图11:00排在10:00前（06、08）；引用回答重复日期（07）。不作为本轮核心阻断，但应记录一致性改进。

## 11. 四类裁决 / Human Owner Gate

Product Experience Verdict: BLOCKED_RUNTIME_ACCESS
Release Evidence Verdict: BLOCKED_INCOMPLETE_EVIDENCE
Prototype Concept Verdict: PROTOTYPE_PARTIAL
Prototype-to-Runtime Parity: PARITY_NOT_APPLICABLE

HUMAN_OWNER_GATE_NOT_ELIGIBLE_FOR_FORMAL_ACCEPTANCE：本轮非正式独立Gate，存在P1且覆盖未穷尽；不发放全范围 P0=0，也不生成可被误用为通过的 Owner签字。用户可自行继续看原型，但本报告不代表其真实情感/长期意愿判断。

## 12. Evidence manifest / 证据索引

Evidence directory: 2026-09-16-knowme-knowledge-r5/evidence/

01候选；02修正即入库；03状态冲突；04错误工作面；05相关问法未召回；06顺延；07日程引用；08周历；09月历；10知识导航；11知识日视图；12知识月视图；13完整标题错配；14刷新初态。共14张真实浏览器截图。

stage-a.md为冻结初印象；SHA256SUMS.txt列证据hash；authority-verification.json记录发布前exact身份复核；skill-validation.txt记录精确reviewer skill校验。

Skill authority: zhouzengrui369-commits/product-experience-reviewer-skill @4253deb55a04de20fca6ac50a47b42a6d4489c04；core_sha256=041a475d8cbc3404ed1e6df66c52377aecfcd631721d18a0ec9de59783f2b676。最初误用本地validator默认root导致结构FAIL，未据此发布；改用下载的exact技能仓库与显式--root验证PASS。没有修改Skill或Core来绕过验证。

## 13. Parent handoff

请按本报告 exact candidate/hash 接收 Owner-requested exploratory review，勿将其转换为正式独立审核PASS、Owner Acceptance或发布批准。先对 P1-01/02 与 P2-03/04 安排独立 Engineering 修正或逐项提供可复现反证；修正须新exact candidate，不改写本报告。保留当前R5证据，重新完成候选绑定与正式独立reviewer资格后定向复验。未来真实AI/ASR/RAG不属于这次整改要求。R5范围CR/准入由治理单独处理，不可借手续替代本报告实际体验问题。

### Screenshot links

- [01-candidate.png](2026-09-16-knowme-knowledge-r5/evidence/01-candidate.png)
- [02-save-edit-auto-ingest.png](2026-09-16-knowme-knowledge-r5/evidence/02-save-edit-auto-ingest.png)
- [03-conflicting-status.png](2026-09-16-knowme-knowledge-r5/evidence/03-conflicting-status.png)
- [04-unrelated-work-surface.png](2026-09-16-knowme-knowledge-r5/evidence/04-unrelated-work-surface.png)
- [05-new-knowledge-not-recalled.png](2026-09-16-knowme-knowledge-r5/evidence/05-new-knowledge-not-recalled.png)
- [06-deferred-event.png](2026-09-16-knowme-knowledge-r5/evidence/06-deferred-event.png)
- [07-event-quote.png](2026-09-16-knowme-knowledge-r5/evidence/07-event-quote.png)
- [08-calendar-week.png](2026-09-16-knowme-knowledge-r5/evidence/08-calendar-week.png)
- [09-calendar-month.png](2026-09-16-knowme-knowledge-r5/evidence/09-calendar-month.png)
- [10-knowledge-navigation.png](2026-09-16-knowme-knowledge-r5/evidence/10-knowledge-navigation.png)
- [11-knowledge-day.png](2026-09-16-knowme-knowledge-r5/evidence/11-knowledge-day.png)
- [12-knowledge-month.png](2026-09-16-knowme-knowledge-r5/evidence/12-knowledge-month.png)
- [13-exact-title-query.png](2026-09-16-knowme-knowledge-r5/evidence/13-exact-title-query.png)
- [14-refresh-reset.png](2026-09-16-knowme-knowledge-r5/evidence/14-refresh-reset.png)
