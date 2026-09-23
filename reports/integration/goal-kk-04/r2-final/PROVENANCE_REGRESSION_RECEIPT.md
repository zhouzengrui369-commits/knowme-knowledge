# GOAL-KK-04 R2-final — PROVENANCE_REGRESSION_RECEIPT

> 2026-09-23 · J08 来源链/版本链回归（本轮核心修复区），ED/LE 双实例三层实证。

## 1. 场景

同一 capture_id 连续三层：r1 原始采集「班组会议时间九点」→ r2 现场修正「十点」→ r3 补充「值班经理十一点到场确认」。

## 2. LE 实例（capture cap_bcf2af5b41d4a26c38674f905a1c61af）

- r1 13:26 COMPLETED（13:31:30）；r2 13:34 COMPLETED（13:51:35）；r3 13:40 COMPLETED（13:53:12）——三层任务各自独立 COMPLETED。
- **r2 PROCESSING 中即可完成 r3 提交**（D-LE2-04 修复确认，le3_j08_01/05）。
- captures 表同 capture_id 三行 revision 1/2/3；三层 raw asset 文件分别存在、内容各自独立、r1 原文未覆盖。
- 三层 note_id（-5a1c61af 后缀）各自 MD+HTML 实际存在；r2/r3 context_ref 指向 r1 note。
- App「原始来源」一击展示完整版本链：r1 原始采集+结果链接 / r2、r3 修正补充+各自状态与哈希（le3_j08_06 中间态 r2/r3 PROCESSING、le3_j08_07 终态全 COMPLETED）。
- 修正横幅带目标条目名（D-LE2-05，le3_j08_02）。

## 3. ED 实例（capture cap_6db22cb0d93f64a8ec0c215c4cfa3606）

- r1 14:13（九点）→ r2 14:17（十点，现场修正）→ r3 14:18（十一点补充）；r2 整理中即提交 r3 正常排队（D-LE2-04 本人回归，ed_s09）。
- 终态三任务全 COMPLETED、attempts=1；三条独立笔记（202609231413九点/202609231417十点/202609231418十一点，-4cfa3606 后缀）。
- r3 溯源面板：capture_id rev3、捕获/接收/整理三时间、内容哈希 sha256:3e7811b7…、版本链 r1/r2/r3 各 COMPLETED 各带结果（ed_s19）。

## 4. 服务端六要素核验（LE 执行，ED 复核）

raw asset ✓ 最初内容 ✓ 用户修正 ✓ 用户补充 ✓ 正式结果（各层 note）✓ revision 关系（payload_revision + correction_of）✓。

## 5. 协议支撑

get_capture 返回全部 revisions + text_body（本轮 D-LE2-04 修复的协议增量），App 版本链视图据此一次渲染——回归证据即 ed_s19/le3_j08_07。

## 6. 结论

J08 全部验收点双实例 PASS；修正不覆盖原文、补充不断链、每层独立可溯。
