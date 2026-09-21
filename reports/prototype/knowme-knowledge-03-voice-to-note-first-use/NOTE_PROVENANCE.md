# NOTE PROVENANCE — 笔记溯源

## 头部标识

- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1
- PR = #32（draft, OPEN）
- DATE = 2026-09-22
- ENVIRONMENT = OpenHarmony emulator（kk02phone）, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555

## 主张

每条笔记可溯源：来源与原始转写可见，整理不覆盖原始转写；已存条目详情四要素（标题/正文/来源/原始转写）齐全。

## ED 本人操作证据

- **ED-12（PASS）**：草稿中展开「查看原始转写与来源」，「来源:机主本人语音(验证状态 VERIFIED)」「原始转写(整理不会覆盖它):「…」」可见。截图：[ed-13-note-provenance.jpeg](./screenshots/ed-personal/ed-13-note-provenance.jpeg)、[ed-14-note-provenance-detail.jpeg](./screenshots/ed-personal/ed-14-note-provenance-detail.jpeg)
- **ED-15（PASS）**：已存条目详情四要素齐全；来源「机主本人语音(验证状态 VERIFIED),你明确保存后入库。」；原始转写保持编辑前原文。截图：[ed-17-item-detail.jpeg](./screenshots/ed-personal/ed-17-item-detail.jpeg)
- **ED-14（PASS）**：保存后列表条目带「本人语音·已验证」徽标。截图：[ed-16-note-saved-plus1.jpeg](./screenshots/ed-personal/ed-16-note-saved-plus1.jpeg)

## Local Execution 交叉佐证

- **LE-12（PASS）**：草稿中查看来源，来源+原始转写可见且不被整理覆盖。截图：[18-LE-12-source-and-raw-transcript.jpeg](./screenshots/local-execution-run3/18-LE-12-source-and-raw-transcript.jpeg)
- **LE-15（PASS）**：已存条目详情四要素（标题/正文/来源/原始转写）齐全。截图：[23](./screenshots/local-execution-run3/23-LE-15-entry-detail.jpeg) [24](./screenshots/local-execution-run3/24-LE-15-entry-detail-raw-transcript.jpeg)
- **LE-22a（PASS）**：TEST_FIXTURE 注入的笔记保存时消息带 ⚠️「来源是模拟器测试转写(TEST_FIXTURE),不是真实语音识别」，列表条目带「TEST_FIXTURE 演示」徽标。截图：[73](./screenshots/local-execution-run3/73-LE-22a-inject-done.jpeg) [75](./screenshots/local-execution-run3/75-LE-22a-saved.jpeg)
- **LE-19b（PASS）**：手动文本兜底入库并标注来源。截图：[34-LE-19b-manual-candidate-created.jpeg](./screenshots/local-execution-run3/34-LE-19b-manual-candidate-created.jpeg)

## 结论

溯源链路（草稿可查来源与原始转写 → 已存条目四要素齐全 → 徽标区分来源类型）双轨 PASS；TEST_FIXTURE 来源全程显式标注，不与真实语音混淆。
