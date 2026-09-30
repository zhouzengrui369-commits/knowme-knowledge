# Parent PM / Product Governance 交接提示词

下面内容可直接交给独立 Parent 对话。此文件是交接文档，没有自动向其他任务发送消息。

---

你接手 KnowME Knowledge 的 **Product Governance / Parent PM**，仅负责治理，不兼任 Engineering Delivery，也不改产品源码/测试/构建。GitHub为唯一权威事实源。先读仓库AGENTS、治理锁、baseline v3、GOAL-KK-04冻结合同、Issue35最新回执，再读本目录REVIEW.md、EVIDENCE.md及截图/最终运行回执，不以工程PASS或本提示词替代证据。

本轮Owner授权独立体验审核已完成，使用 product-experience-reviewer-skill@4253deb55a04de20fca6ac50a47b42a6d4489c04，结论：**NOT_READY / PRODUCT_EXPERIENCE_FAIL；P0=0，P1=6，关键P2=1**。Release Evidence=BLOCKED_INCOMPLETE_EVIDENCE；Prototype=NO_PROTOTYPE_REVIEWED；Parity=PARITY_PARTIAL。Stage A诚实标记PRIMED_COGNITIVE_WALKTHROUGH，当前审核任务继承旧reviewer历史；未伪造referral中请求的新context，也没有author/技术gate/admit候选。

唯一集成候选：

- App PR37 / engineering/goal-kk-04-lingxi-mobile-capture-bridge-r1：SHA `c0171d4fa5a988272afa76cabd42b4b6ddbaea8d`；tree `4c88cf33614e93a1b9dc64be12929cd64dd019e7`；parent `10d829195ebb7f6c4c576b0d116e45087ec2b35a`。
- Workbench njx-knowledge PR8 / engineering/goal-kk-04-mobile-capture-bridge：SHA `92892d66d059211113379b7e49d7f034b7ec921c`；tree `b527133111112abea4831fa6b4be2c251e7927be`；parent `e548883b1d696b8245631bad129dd3737afcc5b7`。
- canonical HAP `a73022244985e93a3f227b967bd771e8070dd562d499d16ddca4a91b8d721549`，39,206,998B。工程证据commit `b44d11b8ffe594666721510a3b9cd9e97015415f`只是背景，本审核有独立的新UI证据。
- Baseline/Contract `be400447c1d68062d22ae5e9ea0d169d929514df`；contract blob `19c950767a799d4c04712820f643cb46ab9e0077`；中央锁 `fc4872d9ba33325cf43a0778bb3ea01aea050c0f`。Issue35 admission comment5797265869、referral5806928405仍是本轮准入依据；标题旧BLOCKED不能推翻最新回执。

核心正向结果应保留：手机文本→工作台真实整理→双端同note_id和实际HTML；313.34秒真实录音文件完整；已授权文本/音频队列恢复自动补传，草稿未误提交；九点/十点/十一点各层保留；同名同分钟不同ID各自完成；撤销凭证401。不要重建手机端第二套知识处理后台，也不要把这些成功当成全旅程PASS。

本轮必修清单（具体复现、截图、Acceptance Criteria和Retest Evidence逐条见REVIEW.md）：

1. **PX-KK04-01 P1**：断连冷开绿字已连接，能力停用信息和展开来源修订滞后。
2. **PX-KK04-02 P1**：文本连续三次提交后进入另一条313秒录音的修正模式，列表重排造成真实错对象操作。
3. **PX-KK04-03 P1**：工作台旧MOC标题/09.09日期/静态来源混入真实记录，manifest成NOTE，HTML标签直接显示；回源入口不满足双端两步可追。
4. **PX-KK04-04 P1**：近静音模拟器真录经ASR得到无关重复内容，卡片仍普通已整理。正文有质量提示是缓解，不是完全语义成功；需要有效≥30秒实时采集样本和清晰质量恢复，不能用导入音频替代。
5. **PX-KK04-05 P1**：隔离原桌面新增显示已发企业微信，对应manifest却SKIPPED/未调用。不得为了验证回执向他人真实发送。
6. **PX-KK04-07 P1**：同音频结果已生成而手机长时间整理中后超时失败；进程中断恢复又创建同capture/revision第二份来源，旧结果能在工作台打开却没有绑定回手机。只证明重复来源及状态/结果失联，不宣称第二份正式整理完成。
7. **PX-KK04-06 关键P2**：手机默认raw YAML/Markdown、截断演示按钮与旧声纹权限说明，影响普通使用。保留已接受的工作台视觉布局，只改合同内行为表达。

你的下一步：在GitHub新增治理回执承接PRODUCT_EXPERIENCE_FAIL，保留历史ENGINEERING_READY/ADMITTED/referral原文，明确其不等于体验通过；不要改写旧回执。把上述行为合同交独立ED对话修复，要求新exact双候选、canonical HAP、配置/Provider/协议身份、manifest/technical receipt。若发生范围/基线/安全级别/关闭条件变化，先CR。ED最高宣布ENGINEERING_READY，不得替Reviewer接受。

复验必须覆盖七项问题和受影响旅程，并满足新Goal04完整J01–J12合同：补一致跨时区、插件卸载恢复、有意义的真实录音、1秒反馈/10秒补传/5秒更新的受控证据；不把当前局部样本冒充完整性能PASS。环境时区矛盾、模拟器弱输入以及审核工具进程中断应单独披露，不夸大为真机通用故障，也不能拿它们豁免可见产品状态问题。尾项18:12手机变为FAILED并提供重试，10/11采集修订COMPLETED、1项FAILED；已有旧HTML但手机未回绑。以final-runtime-receipt.json为准，不把文件存在写成双端完成，也不把明确超时写成无尽转圈。

Goal03保持SUSPENDED，不因本轮回归样本追溯关闭：旧01原文层为PARTIALLY_FIXED；旧02错跳风险OPEN（本次变体为错对象）；旧03为PARTIALLY_FIXED。没有旧PASS继承。

本Goal pre-1.0 Owner验收已委托产品体验审核，**无例行Human Owner Gate**，不要再次要求Owner代做技术/体验复验。最终1.0 Human Owner Acceptance保留。当前不授权合并、发布、生产或Goal/Milestone关闭；只有后续独立体验PASS且无必修/漂移后，Parent才可按合同处理Goal与Milestone同时关闭。

本报告PR仅新增审核文档/证据。未改产品源码/测试/构建，未部署生产，未使用Owner私密资料。local-runtime、凭据、原始音频、HAP、DB未上传。请据报告中真实UI结果建立修复合同，不让实现方的“已知问题/工具误点”口述替代独立重放。
