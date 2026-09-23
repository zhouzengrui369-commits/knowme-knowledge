# IMPLEMENTATION_PLAN — r3-gap-closure

2026-09-23 ｜ context ED-KK04-ADMISSION-GAP-CLOSURE-20260923-B2C4 ｜ 本计划为 R3 实际执行记录，非事前设想；每一步均已完成并可追溯。

## 1. 执行序列（实际发生）

| 步 | 内容 | 证据 |
|---|---|---|
| 1 | 治理权威 fresh 核验（执行合同 Issue #35 comment 5791881544、BLOCK 5791626362、preimage、参与授权逐字核对落盘） | kk04-ed2/governance/ 落盘件 |
| 2 | canonical HAP 冻结：13:09 唯一真实构建（scripts/build-hap.sh，hvigorw --mode module -p product=default -p buildMode=debug assembleHap --no-daemon）→ sha256 a7302224…1549 / 39,206,998B；18:45 no-op 复验复构建确认；只读冻结，ALL_EQUAL=YES | CANONICAL_ARTIFACT_RECEIPT |
| 3 | ED 环境 fresh 重置（18241 全新 KB_ROOT）+ canonical HAP 全新安装 | ENVIRONMENT_RECEIPT |
| 4 | fresh LE child（agent-3，实例 18243）：J01–J12 全旅程实操，13/13 任务 COMPLETED（19:00–20:35） | LOCAL_EXECUTION_REQUEST / LOCAL_EXECUTION_RECEIPT |
| 5 | ED 本人套件（实例 18241，canonical HAP）：J02–J09 + J06a/J06b 同名同分钟双 ID + J11 Playwright 真实 UI + PX×3，14 captures / 14 tasks 全 COMPLETED（20:46–21:55） | ED_PERSONAL_OPERATION_RECEIPT / J06_IDEMPOTENCY_RECEIPT / J11_WORKBENCH_UI_RECEIPT / PX_REGRESSION_RECEIPT |
| 6 | 双套截图目验（ED 16 张关键图 + LE 6 张关键图全 PASS） | VISUAL_INSPECTION_RECEIPT / SCREENSHOT_INDEX |
| 7 | 证据包组装（本目录 25 份 + 136 张截图）+ Issue #35 corrected terminal + njx-knowledge#6 引用同步 + 本交接提示词 | 本包 / Issue 评论 |

## 2. R3 关闭方式（对应上轮 BLOCK 事由）

- **GAP-A（J06 双侧）**：LE 与 ED 双侧均完成同名同分钟双 ID 场景，各自独立 COMPLETED，零 LOCKED_SKIP。ED 侧正确配对 cap_f1c40d62（21:16:05）+ cap_c40b9f58（21:16:16）；21:10 的 r2 修正副产物对（失误产生）已如实记录于 J06_IDEMPOTENCY_RECEIPT。
- **GAP-B（J11 双侧）**：双侧均以 Playwright 驱动真实浏览器 UI 完成 add/search/preview/conversation（非纯 API 等价）。
- **GAP-C（canonical HAP）**：唯一真实构建 + no-op 复验 + 只读冻结，MAIN_HAP_SHA256=CANONICAL_HAP_SHA256 单一值。

## 3. 缺陷循环治理

- 本轮 fresh 实操**未发现合同内产品缺陷**（CONTRACT_REQUIRED_NOT_COMPLETE=NONE），候选 SHA 未变，不制造无意义源码 commit（合同 §18 明示允许）。
- 新观察项（非合同内缺陷）：OBS-ED3-01（J04 离线改用停服法等效断连，hdc rport rm 本机实测失败「ruler is not exist」）、OBS-ED-03（前端 MOC 摘要渲染怪相）等，全部如实列入 DEFECT_CYCLE 与披露清单。

## 4. 范围与不做的事

- 合同范围内：模拟器、隔离实例、合成/测试数据、文本+音频两种模态。
- 不做：真机、生产/公网部署、真实私人数据、多模态扩展、完整索引规模验证、看门狗参数调优（全部列入 OUT_OF_SCOPE_FUTURE_WORK）。
- 禁区：governance/AGENTS/kbctl/skills/vendor/public_gateway/生产环境零触碰（ALLOWED_PATH_DIFF_RECEIPT）。

## 5. 回滚与洁净

- 双 worktree detached @ candidate，`git status --porcelain` 为空。
- 隔离实例 18241（ED）/18243（LE）随收尾停止；生产 8787 健康检查只读验证 200。
