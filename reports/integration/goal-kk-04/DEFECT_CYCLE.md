# GOAL-KK-04 — 缺陷循环记录（DEFECT_CYCLE）

> GOAL-KK-04 · DEFECT_CYCLE · ED context ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E
> Final pair：App `10d829195ebb7f6c4c576b0d116e45087ec2b35a` / Workbench `e548883b1d696b8245631bad129dd3737afcc5b7`
> 日期：2026-09-22

## 1. 结论

全程发现并闭环 5 个合同内缺陷（D-KK04-01/02/03 于 R1 冻结前，D-KK04-04/05 于 LE R1 后）+ 1 个语义偏差修复（E2）；1 个环境性风险（E1）如实披露不改码。D-KK04-04/05/E2 的修复导致候选 SHA 变化，按合同旧 pair（fef1b07/6e27ada8）证据失效，LE R2 与 ED same-pair 复核在新 pair（10d8291/e548883b）上重验，全部 PASS。当前无已知未修复的合同内缺陷。

## 2. R1 冻结前缺陷（ED 自发现自修复）

| ID | 现象 | 根因 | 修复与回归 |
|---|---|---|---|
| D-KK04-01 | 文本落盘缺父目录失败 | 接收落盘未建父目录 | 已修并有单测覆盖（tests/mobile_capture_bridge） |
| D-KK04-02 | note_id 含 CJK 句号/下划线导致异常 | 标题字符集未清洗 | 已修并有单测覆盖 |
| D-KK04-03 | SyncController.pullEvents/refreshPending 更新数据后未 notify()，UI 状态停在「待整理」 | 缺少变更通知 | 加 changed 标志 + notify；重装后本地会话恢复 + 轮询补拉实链验证通过（截图 s12） |

## 3. R2 缺陷循环（LE R1 发现 → ED 修复 → LE R2 复验）

| ID | 发现方 | 现象 | 根因 | 修复 | 复验 |
|---|---|---|---|---|---|
| D-KK04-04（D1，App） | LE R1 | 撤销→重连同会话内导入按钮禁用卡死（enabled=false），冷重启才恢复 | `bridge.configured` 普通属性不参与状态驱动 | @State bridgeConfigured 镜像，四处 .enabled 绑定替换（App commit 10d8291） | LE R2 PASS：同会话重连后按钮 enabled/clickable=true，点「导入演示音频」立即入箱（le2_s02）；ED 实链验证撤销→重连→导入成功（s53–s56） |
| D-KK04-05（D2，双端） | LE R1 | 整理 FAILED 条目文案说「可在采集箱重试」但无重试入口 | 缺重试通道 | workbench 新增 `POST /tasks/{id}/retry`（仅 FAILED/NEEDS_INPUT 可调用，幂等由产物核对保证；COMPLETED→409、跨设备→404、无凭证→401，边界有测试）；App 加「重试整理」按钮（Workbench commit e548883b / App commit 10d8291） | LE R2 PASS：点击后 FAILED→PROCESSING→COMPLETED（task_2b83122ad4cb430c），端点边界全对；ED 目验按钮可见（s57/s58） |
| E2（语义） | LE R1 观察 | capabilities 宣称 auto_organize_supported 但 processing_policy.auto_organize=false 被忽略仍自动整理 | 策略未生效 | auto_organize=false → 落盘 RECEIVED + 任务停 NEEDS_INPUT 不自动整理，POST /tasks/{id}/retry 显式触发（commit e548883b）；INTERFACE_CONTRACT.md §2 已补语义 | ED 实链：cap_defer_live_01 NEEDS_INPUT→retry→COMPLETED（note 202609222057…E2延迟整理验证-_live_01）；LE R2 PASS：cap_le2_e2_noauto_0001 / task_5ca2ffd813764312 同路径 |

## 4. E1 环境性超时（披露，不改码）

**现象**：DSH/TokenHub（harness 链路）时段性 600s 看门狗超时，整理任务 FAILED，重试可成。

**两轮统计（如实）**：

- LE R1 窗口：9 次整理 3 次超时，集中 19:48 后；同一样本重试可成功。
- LE R2 窗口（21:05 后）：11 任务 17 次尝试——成功 4 次（21:10–21:29，单次 317–400s，贴近 600s 看门狗）；超时失败 13 次（全部 21:38 后，横跨文本/音频、curl/App 两路，重试恢复率 0/6）。
- ED same-pair 复核（23:07–23:09）：约 2 分钟 COMPLETED，后端已恢复。

**结论与处置理由**：21:30 后整理后端持续性退化，非并发挤出、非 KK-04 代码问题（两轮观察一致）；正常时段余量仅约 200s。不改看门狗/超时参数（属工作台生产配置，越本 Goal 授权）；D2 重试入口即用户侧恢复路径；建议责任方查 harness 链路可用性并考虑放宽看门狗或重试退避。全部受影响旅程（J02/J03b/J05/J07/J08 的 R2 整理段）以「链路层 PASS + 整理 FAILED(E1)」如实记录，未改写为通过。

## 5. 已知非阻断观察（LE R1 记录，未列为必修）

- 导入按钮文字截断（UI 文案长度）。
- 模拟器状态栏时钟异常、captured_timezone=America/Chicago（region 怪癖，Date 时间戳 +08:00 正确）。
- /api/note 中文路径需 URL 编码（客户端行为）。

## 6. 缺陷导致的 pair 失效处理

D-KK04-04/05/E2 修复改变候选 SHA → 旧 pair fef1b07/6e27ada8 的 final 实操证据按合同 §8 失效（2026-09-22 21:05 起），仅作历史；LE R2 在新 pair 全旅程复验、ED 本人 same-pair 复核，证据链以新 pair 为准。历史回执（LE_RECEIPT_R1.md）只追加失效说明，未改写。
