# PROVENANCE_REGRESSION_RECEIPT — r3-gap-closure（J08 / PX-KK03-01）

2026-09-23 ｜ canonical HAP a7302224…

## 合同要件

九点→十点→十一点三层来源与 revision 链：最初捕获、用户修正/补充、最终整理三层可区分；修正版不覆盖最初捕获。

## ED 侧（18241，21:23–21:32）cap_818c95ef11d8fe54845a577e9e67a1f9

| revision | intent | 内容 | task | 终态 | 笔记 |
|---|---|---|---|---|---|
| r1 | note | 第一层（九点）：原始版本 | task（21:23 提交） | COMPLETED 21:25:40 | 202609232123…第一层九点…-9e67a1f9.md |
| r2 | correction | 第二层（十点）：第一次修正 | task（21:26 提交） | COMPLETED 21:29:11 | 202609232126…第二层十点…-9e67a1f9.md |
| r3 | correction | 第三层（十一点）：第二次修正 | task（21:29 提交） | COMPLETED 21:32:04 | 202609232129…第三层十一点…-9e67a1f9.md |

- 三层 assets 目录 r1/r2/r3 并存；r1 原始备份（.raw-transcript.backup.md）grep 实证仍含「第一层（九点）：这是原始版本内容」——**原文不覆盖**。
- 每层各生成独立笔记文件（capture 后缀 -9e67a1f9 同源可溯），note_revision 均=1（每层笔记自身首版——同 LE D-LE3-07：设计一致，非缺陷）。
- 会话溯源消息：「已生成『cap_818c95ef…』的修正版（revision 2/3），原文保持不变」（截图 ed3_s30）。
- 截图 ed3_s24–s28（含修正模式横幅、放弃修正按钮）。

## LE 侧（18243）cap_42487fc30d322ba594e373f9a53efcf6

- r1 19:32 / r2 20:09 / r3 20:20 各 COMPLETED，各独立笔记。
- 关键图 j08_19_provenance_chain.jpeg：App「原始来源」展开显示 capture_id + revision 3 + 捕获时间 + 内容哈希 sha256 + 原始文本 + 接收/整理时间 + 版本链三层「每层独立保存，原文不覆盖」。

## 结论

J08 / PX-KK03-01 双侧 PASS：三层链可区分、可溯源、原文不覆盖、内容哈希逐层锚定。
