# 给 Parent PM / Product Governance 的交接提示词

你是 KnowME Knowledge 的 Product Governance / Parent PM，本任务只接收独立产品体验审核，不兼任工程修复。

请先从 GitHub 读取项目 AGENTS、有效治理锁、基线 v2、GOAL-KK-02 合同 R2、Issue #13、PR #21 和本报告 PR。不要用聊天摘要替代权威文件，也不要改写历史回执。

候选：`b02bca6e5e84e98e5b4c99bc43d3599946089e83`，tree `b40553f25b6a6c8eaa6ef37629ea176c2b09d047`，PR #21，branch `candidate/goal-kk-02-simulator-first-r2-b02bca6`。主 HAP SHA256 `c2971591bc835759924f1e0d6bfa50dbd040861fee805578e20e1d2ca73d03ab`。证据分支 PR20 不是此候选。

审核人得到 Owner 直接授权并使用 hdc 实际点击、输入、截图；未读/改产品源码或测试，未技术验收/准入/代行 Owner 接受。模式 FULL_EXPERIENCE_REVIEW / PRIMED_COGNITIVE_WALKTHROUGH。模拟器 kk02phone，OpenHarmony-6.1.1.125；REAL_DEVICE_NOT_REVIEWED / NOT_REAL_DEVICE_VALIDATED。

先读同目录 REVIEW.md、EVIDENCE.md 和关键截图 49、55、58、66、69。结论：R2 FAIL；Product Experience NOT_READY；Release Evidence BLOCKED_INCOMPLETE_EVIDENCE；Prototype PROTOTYPE_PARTIAL；Parity PARTIAL。

待处理问题：
1. PX-KK02-01 P1：权限往返/冷重开后，“已记下”的合成知识与会话消失，注册档案却保留。
2. PX-KK02-02 P1：麦克风拒绝页没有手动文本入口，只有重新授权。
3. PX-KK02-03 P1：本轮五次注册后的合成语音均未进入候选，纠正/拒绝/确认以及 TEST_FIXTURE 披露链尚未独立验证。不要诊断为代码不存在；这是声明环境中的实际可达性/覆盖阻塞。
4. PX-KK02-04 P1：Agent-first 表面仍是录音/声纹诊断面板，缺乏任务上下文与结果继续处理路径；不要求此 Goal 增加真实 LLM/RAG。
5. PX-KK02-05 P2：常态页的模拟器/真机未验证披露不足，注册状态和本次识别状态混杂，“按住说话”与实测动作不一致。

正面证据同样保留：三段注册可完成；取消、暖返回保留会话；未注册/UNCERTAIN/NOT_VERIFIED 不静默入库；手动点击记录才增量；WLAN 关闭时手动恢复可用。

特别修正旧交接：本轮自然得到 NOT_VERIFIED，相似度 .444，见55；不要继续把“自然不可达”作为此次证据事实。真实声纹区分能力仍未证明。最终 reset 因删除确认未返回而未执行；测试声纹仅是本轮合成材料，已保留。WLAN 和麦克风已恢复初始开/允许状态。

请按合同安排独立 Engineering 修复和 exact candidate 重新交付，再交独立审核官执行 REVIEW.md 中逐项定向复验。范围/阈值/关闭条件变化要走 CR；不要通过删弱验收来消除缺陷。未经新证据不得改写本次 FAIL。

本报告没有 Human Owner Accepted、Merge/Release Authorized 或 Goal/Milestone Closed。Skill 的 HUMAN_OWNER_GATE_REQUIRED 只是权限边界标记，不是推荐接受。当前建议仍是修复后复验，不能关闭 Goal/Milestone。本交接本身不自动派发/创建新任务。
