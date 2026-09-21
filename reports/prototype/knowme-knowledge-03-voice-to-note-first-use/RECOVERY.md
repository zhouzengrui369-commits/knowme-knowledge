# RECOVERY — 持久化与冷启恢复

## 头部标识

- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1
- PR = #32（draft, OPEN）
- DATE = 2026-09-22
- ENVIRONMENT = OpenHarmony emulator（kk02phone）, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555

## 主张

已保存知识与声纹档案在 force-stop 冷启后持久恢复；未保存草稿不复活、不入库。持久化为本地 snapshot v4（有界本地存储，非生产备份）。

## ED 本人操作证据

- **ED-18（PASS）**：aa force-stop → 冷启，知识 2 条、声纹档案已录入均恢复，消息「已从本地恢复 2 条已保存知识与对话上下文(0.1 原型有界本地存储,非生产备份)。」截图：[ed-21-cold-restart-recovery.jpeg](./screenshots/ed-personal/ed-21-cold-restart-recovery.jpeg)
- **ED-19（PASS）**：新录音 VERIFIED 0.815 → 整理成草稿（不保存）→ force-stop → 冷启：无草稿卡、知识仍 2 条、无草稿内容入库。截图：[ed-22-unsaved-draft-before-kill.jpeg](./screenshots/ed-personal/ed-22-unsaved-draft-before-kill.jpeg)、[ed-23-draft-not-revived.jpeg](./screenshots/ed-personal/ed-23-draft-not-revived.jpeg)

## Local Execution 交叉佐证

- **LE-16（PASS）**：有已存知识时 force-stop 后冷启，知识持久恢复。截图：[25-LE-16-coldstart-persistence.jpeg](./screenshots/local-execution-run3/25-LE-16-coldstart-persistence.jpeg)
- **LE-17（PASS）**：有未保存草稿时 force-stop 后冷启，未保存草稿不复活。截图：[26](./screenshots/local-execution-run3/26-LE-17a-unsaved-draft-before-kill.jpeg) [27](./screenshots/local-execution-run3/27-LE-17b-coldstart-no-draft-revive.jpeg)

## 结论

恢复边界精确——已存内容（知识+声纹档案）恢复，未保存草稿不复活——双轨 PASS；恢复消息如实声明本地有界存储性质。
