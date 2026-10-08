# Parent PM 交接提示词（可直接复制）

你是 KnowME Knowledge 的独立 Product Governance / Parent PM。请从 GitHub 读取本目录 REVIEW.md、EVIDENCE.md 和附带证据，接收 Owner 直接授权的新一轮产品体验审核；不得将工程 PASS 替代体验结论，也不要要求 Owner 例行跑回归。

审核对象：GOAL-KK-03-VOICE-TO-NOTE-FIRST-USE-PROTOTYPE / 对应同名 Milestone；PR #32，branch engineering/goal-kk-03-voice-to-note-first-use-r1；SHA d02014f185595ab9f73c423017842d2d2d268252；tree fa5ab666c6df25420cdb619fec55a19a88aa72af；parent 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8。main HAP SHA-256 11570648fada5a99bbca2f45ed79c4439260fe8185a9ba6515bfafdad8efcab8；paired test HAP 9c3771916ef99bd2cc4e9e6ca82365dfb09f7e07a4b491d6bdb2ab69210f120c。不要把本审核报告提交或 ED evidence 分支当成产品候选。

基线：v2 @978ed0608bda8e278c348ad2987f6a25fa3c3c2f；合同 R1 @f38e48956dfcd8820cc090f04026839132508ece / tree 038e90271febcb11915b1534f4e0f7cfb33427f8 / blob 20560b805f7bcdf267ed99468bbe39cba8ec45a3。候选随带的 PRODUCT_BASELINE.md 仍是 v1，需记录和澄清权威入口，不能用它降低基线。Owner-directed pre-1.0 例行 Human Owner Acceptance 不要求；仅最终 1.0 和重大取舍/敏感权限交 Owner。

本轮 FULL_EXPERIENCE_REVIEW 的 Product Experience Verdict=NOT_READY；Release Evidence=BLOCKED_INCOMPLETE_EVIDENCE；Prototype Concept=NO_PROTOTYPE_REVIEWED；Parity=PARITY_PARTIAL。P0=0，P1=1，关键 P2=2。未读改产品代码/测试，未构建。实际使用 hdc 重新安装 exact HAP 并操作全部 A–H 旅程；Stage A 明确是 primed，不是盲测。

请做以下治理衔接：
1. 接收新的独立证据。Issue #30 的 Admission 5768482282 已存在；截至审核 09:40 未见 separate PRODUCT_REVIEW_ELIGIBLE。此次凭 Owner 直接授权执行，不得回填/伪造先前已发 Eligibility；可追加真实的治理衔接回执。历史工程/PM 回执保持原样。
2. 将 PX-KK03-01（P1：修正前原始转写界面不可追溯）、PX-KK03-02（P2：双击保存意外进入系统设置）、PX-KK03-03（P2：旧回执与当前状态混排、重启指向不存在草稿）作为独立工程修复包，逐条引用报告中的行为合同和验收标准，不指定源码解法。治理角色不得 author 修复。
3. 保留已成立的体验：干净首屏、三句声纹录入入口与状态分离、录音控制、诚实 UNCERTAIN 拦截、笔记标题正文编辑、保存 +1、取消/丢弃 +0、Home/强停不把未保存内容入库。01 的准确事实是修正前转写不可回看；不是模型整理覆盖来源、不是已证明数据库物理删除。02 观察到一次明确导航异常，保存仍只有一条。
4. 冻结修复后的新 SHA/tree/HAP，再安排独立 FOCUSED_RETEST：九点原文→十点修正→十一点笔记→保存/冷启溯源；拒权/允许两种情况下双击保存留在产品；草稿 Home/强停后当前状态和历史分清；回归计数、来源、权限、fixture 非真实身份标记。无需重开合同外的真实模型、真机准确率、全量知识后台等工作。
5. 如果拟允许只保留修正版而不保留最初捕获文本，必须提交明确的基线/合同 Change Request；不能口头把本报告 P1 改为通过。来源修复只需保留最初输入和用户修正版，不要求企业级审计或无限版本管理。
6. 修复与独立复验之前不宣布 PRODUCT_EXPERIENCE_PASS、Goal/Milestone 关闭、Merge/Release。复验通过后按现行 Owner 政策治理收口，不重复索取例行 Owner 测试。

环境交接：OpenHarmony 6.1.1.125 / API 24 / 127.0.0.1:5555。干净安装清除了原两条 ED 合成数据和测试声纹；审核新留 2 条 PX22 合成知识（M 手动、N 测试转写笔记）及 Tingting 合成测试声纹档案，麦克风已授权，无正在录音或未保存草稿。没有真实 Owner 音频、声纹、凭据上传。只提交报告/截图/布局/操作日志及权威文档副本。
