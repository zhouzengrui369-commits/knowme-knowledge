# GOAL-KK-04 R2-final — IMPLEMENTATION_PLAN

> 2026-09-23 · ED context ED-KK04-FINAL-EVIDENCE-COMPLETION-20260923-A1F7
> 本计划为重入轮（Issue #35 comment 5788458660）的实际执行记录，非事前设想；每一步均已完成并可追溯。

## 1. 执行序列（实际发生）

| 步 | 内容 | 证据 |
|---|---|---|
| 1 | 治理权威 fresh 核验（合同/preimage/参与授权/skill 身份逐字核对） | kk04-ed2/governance/ 落盘件 |
| 2 | Fresh materialize preimage pair → 工程分支 → R1 候选（10d8291/e548883b） | 旧包（SUPERSEDED） |
| 3 | 搭隔离环境（KB_ROOT 独立、插件 enabled、外发 disabled、rport 转发、模拟器） | ENVIRONMENT_RECEIPT / RUNTIME_RUNBOOK |
| 4 | LE R1（observation-only child agent-2）全旅程实操 | LOCAL_EXECUTION_RECEIPT（R1 部分，旧包） |
| 5 | 缺陷循环 R1：5 缺陷 + E1 修复 → 新 pair c0171d4/92892d66 | DEFECT_CYCLE / ALLOWED_PATH_DIFF_RECEIPT |
| 6 | 环境修复：D-LE2-02 前端部署 | DEFECT_CYCLE |
| 7 | LE R2 新 pair 全旅程复测：J01–J12 全 PASS，9/9 COMPLETED | LOCAL_EXECUTION_RECEIPT |
| 8 | ED 本人 same-pair 独立实操套件（含 J06 同名同分钟补做）11/11 COMPLETED | ED_PERSONAL_OPERATION_RECEIPT |
| 9 | 双套截图目验 | VISUAL_INSPECTION_RECEIPT |
| 10 | 证据包组装（本目录）+ Issue #35 corrected terminal + #6 引用 + PARENT_PM_HANDOVER_PROMPT | 本包 / Issue 评论 |

## 2. 缺陷循环治理（合同 §8 遵守）

- 候选 SHA 改变即重冻结：旧 pair（10d8291/e548883b）证据标记 SUPERSEDED 不删不改；新 pair 上重做全部 final-pair 实操（LE R2 + ED 套件）。
- LE 为独立 child（agent-2），observation-only；ED 套件由 ED 本人操作，不派子代理。
- E1 处理：不标 PASS、不作「环境原因算过」；走产品内重试路径直至 COMPLETED，attempts 如实记录。

## 3. 范围与不做的事

- 合同范围内：模拟器、隔离实例、合成/测试数据、文本+音频两种模态。
- 不做：真机、生产/公网部署、真实私人数据、多模态扩展、索引规模验证、看门狗参数调优（全部列入 OUT_OF_SCOPE_FUTURE_WORK）。
- 禁区：governance/AGENTS/kbctl/skills/vendor/public_gateway/生产环境零触碰（ALLOWED_PATH_DIFF_RECEIPT §3）。

## 4. 回滚与洁净

- 双 worktree detached @ candidate，`git status --porcelain` 为空。
- 隔离实例 18241（ED）/18242（LE）随收尾停止；生产 8787 健康检查只读验证 200。
