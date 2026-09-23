# GOAL-KK-04 r3-gap-closure — TECHNICAL_RECEIPT

> 2026-09-23 · ED context ED-KK04-ADMISSION-GAP-CLOSURE-20260923-B2C4
> 本轮零源码改动（候选 pair 不变）；本回执记录 R3 技术复验结论，supersede r2-final 同名文件的实操数据部分。

## 1. 架构与链路

手机 App（OpenHarmony ArkTS，prototype knowme-knowledge-02）→ HTTP 协议 v1（/api/mobile-capture/v1，设备凭证鉴权）→ Workbench 插件 mobile_capture_bridge v1.0.0（routes 接收持久化 → store sqlite WAL → pipeline 串行整理）→ ASR mlx-whisper/small → organizer instant-note-organizer-v4（DSH/TokenHub DeepSeek-V4.1-Flash）→ KB daily 笔记三产物（.md / .raw-transcript.backup.md / .md.html）→ 前端知识视图（galaxy.html + 服务端注入层）。

## 2. 关键设计不变式（R3 全部复核实证）

- **草稿不入库**：未显式「交给灵犀」永不离开本机（ED 各旅程 BEFORE 图 + DB 顺序实证）。
- **离线不丢**：停服离线排队 → 冷重启保留 → 恢复自动补传（ED task_ac4b649c attempts=2；LE 同旅程）。
- **幂等**：ED 连点×3 = 1 capture/1 task/1 note；LE 同结论。
- **同名同分钟双 ID**：ED cap_f1c40d62/cap_c40b9f58（21:16）、LE cap_06f9551c/cap_d872942b（19:17），双侧双独立笔记互不覆盖。
- **串行整理**：ED 14 task 的 ORGANIZE_COMPLETED 相继不重叠；双侧终态零 LOCKED_SKIP。
- **原文不覆盖**：J08 三层 r1/r2/r3 各自独立笔记、r1 原文备份未被覆盖（双侧）。
- **溯源可查**：App「原始来源」展示 capture_id/revision/哈希/版本链（LE j08_19）；KB 文件三件套逐层锚定。
- **认知防火墙**：未标注发言者内容不做 NJX 归因（ED J02/J07 笔记内文实证）。
- **注入免疫**：LE J10「rm -rf」字样按纯数据整理 COMPLETED。
- **隔离**：KB_ROOT 独立、插件可停用（503/排队/补传双侧实证）、external_send=disabled。
- **工作台真实 UI**：J11 双侧 Playwright 真实 Chromium 完成 ADD→SEARCH→PREVIEW→CONVERSATION，零 API 替代。

## 3. 本轮缺陷修复

无。R3 未触发 §13 失效规则；前轮修复点（串行化/ revisions / 红字 / 横幅）全部复核生效（DEFECT_CYCLE.md）。

## 4. 质量证据

- Workbench 单测：tests/mobile_capture_bridge 13/13 PASS（候选 92892d66，前轮实跑结果本轮无代码变化继续有效）。
- HAP：单一 canonical a7302224…（39,206,998 B），构建 PASS，双实例同字节部署。
- 实操：LE fresh child 13/13 COMPLETED；ED 本人套件 14/14 COMPLETED；双侧零 FAILED 残留（LE J03b/J07 首轮看门狗超时经产品内重试成功，attempts=2 如实记录）。
- 截图证据：136 张双套（ed-personal 49 + local-executor 87），sha256 逐张锚定（SCREENSHOT_INDEX.md）；ED 已逐张目验关键图（VISUAL_INSPECTION_RECEIPT.md）。

## 5. 已知限制（如实）

- REAL_DEVICE_NOT_REVIEWED：仅 OpenHarmony 模拟器（合同范围内，SIMULATOR_FIRST_UNTIL_1_0）。
- 生产/公网部署未验证；真实私人数据未用；多模态 future work；完整索引规模未验证；看门狗 600s 参数调优 future work。
- 环境怪相：模拟器状态栏时钟慢 12h（D-LE3-03）、captured_timezone 与偏移不一致（D-LE3-06）、uitest 中文前导 %（D-LE3-02）。
- 前端注入层既有渲染怪相：搜索结果 MOC 条目摘要串显示匹配内容（OBS-ED3-03，不在 candidate 改动面）。
- OBS-ED-01（继承）：App「历史」前缀不可达（会话 ephemeral 设计 + onChanged 时序），无用户可见影响。
