# SAVE / CANCEL / DEDUP — 保存、取消与防重复入库

## 头部标识

- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1
- PR = #32（draft, OPEN）
- DATE = 2026-09-22
- ENVIRONMENT = OpenHarmony emulator（kk02phone）, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555

## 主张

保存恰好 +1（连点/双击不重复入库）；取消恰好 +0 且候选一并丢弃；Agent 对两种结果都有解释，无静默状态变化。

## ED 本人操作证据

- **ED-14（PASS，保存）**：点「保存笔记」，「已保存笔记…,知识 +1(现在共 1 条)」，Agent 解释入库与溯源。截图：[ed-16-note-saved-plus1.jpeg](./screenshots/ed-personal/ed-16-note-saved-plus1.jpeg)
- **ED-16（PASS，取消）**：新录音 VERIFIED 0.686 → 整理 → 取消：「已取消,这条笔记没有保存。知识没有变化(+0);原始转写候选也已丢弃。」知识仍 1 条。截图：[ed-18-cancel-journey-draft.jpeg](./screenshots/ed-personal/ed-18-cancel-journey-draft.jpeg)、[ed-19-cancel-note-plus0.jpeg](./screenshots/ed-personal/ed-19-cancel-note-plus0.jpeg)
- **ED-17（PASS，防重复）**：新录音 VERIFIED 0.741 → 整理 → 快速双击「保存笔记」，「知识 +1(现在共 2 条)」，列表恰好多 1 条，无重复入库。截图：[ed-20-save-doubleclick-dedup.jpeg](./screenshots/ed-personal/ed-20-save-doubleclick-dedup.jpeg)

## Local Execution 交叉佐证

- **LE-14（PASS）**：保存笔记并连点，恰好 +1、无重复入库。截图：[20](./screenshots/local-execution-run3/20-LE-14-save-note-exactly+1.jpeg) [21](./screenshots/local-execution-run3/21-LE-14-pre-save-draft.jpeg) [22](./screenshots/local-execution-run3/22-LE-14-saved-exactly+1-no-dup.jpeg)
- **LE-13（PASS）**：草稿取消，知识 +0。截图：[19-LE-13-draft-cancel-knowledge+0.jpeg](./screenshots/local-execution-run3/19-LE-13-draft-cancel-knowledge+0.jpeg)
- **LE-08（PASS）**：候选丢弃，知识 +0，Agent 解释不入库原因。截图：[12-LE-08-discard-knowledge+0-after.jpeg](./screenshots/local-execution-run3/12-LE-08-discard-knowledge+0-after.jpeg)

## 结论

保存/取消/防重复三条路径计数精确（+1/+0/双击仍 +1），且每步均有 Agent 解释，双轨 PASS。
