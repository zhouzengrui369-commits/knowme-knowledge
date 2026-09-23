# GOAL-KK-04 R2-final — TECHNICAL_RECEIPT

> 2026-09-23 · ED context ED-KK04-FINAL-EVIDENCE-COMPLETION-20260923-A1F7

## 1. 架构与链路

手机 App（OpenHarmony ArkTS，prototype knowme-knowledge-02）→ HTTP 协议 v1（/api/mobile-capture/v1，设备凭证鉴权）→ Workbench 插件 mobile_capture_bridge v1.0.0（routes 接收持久化 → store sqlite WAL → pipeline 串行整理）→ ASR mlx-whisper/small（音频）→ organizer instant-note-organizer-v4（经 DSH/TokenHub DeepSeek-V4.1-Flash）→ KB daily 笔记三产物（.md 正式 / .md.raw-transcript.backup.md 原文 / .md.html 渲染）。

## 2. 关键设计不变式（本轮全部实证）

- **草稿不入库**：未显式「交给灵犀」的内容永不离开本机（ED s10 草稿至终态保持未提交）。
- **离线不丢**：断网排队 → 冷重启保留 → 恢复自动补传（LE 4s，ED 4s）；ACK 前手机副本不删。
- **幂等**：同 capture 重复提交被客户端状态机阻止 + 服务端去重（ED 三连点 DB 实证 1 capture + 1 task）。
- **串行整理**：pipeline `_organize_lock` 全局限流，看门狗从拿锁后起算（E1 修复）；两轮终态零 LOCKED_SKIP（R1 对照：6 任务 4 超时）。
- **原文不覆盖**：修正/补充生成新 revision 行，版本链每层独立保存、各有独立结果笔记（J08 三层实证）。
- **溯源六要素**：raw asset / 最初内容 / 用户修正 / 用户补充 / 正式结果 / revision 关系全部可查（App「原始来源」一击直达 + KB 文件实证）。
- **认知防火墙**：整理输出对未标注发言者的内容不做 NJX 归因（ED J02 笔记实证）。
- **注入免疫**：命令字样文本按纯数据整理（LE J10「rm -rf」实证）。
- **隔离**：KB_ROOT 独立、插件可停用（503 拒绝+排队不丢+启用自动恢复）、external_send=disabled。

## 3. 本轮缺陷修复技术要点（相对失效 pair 的增量）

| 修复 | 端 | 实现 |
|---|---|---|
| E1 串行化 | WB pipeline.py | `_organize_lock` 互斥；看门狗计时起点移至拿锁后；排队任务不再被误判超时 |
| D-LE2-01 未连接原位反馈 | App Index.ets | 撤销/未连接时提交在条目下方原位红字+恢复指引 |
| D-LE2-02 隔离前端部署 | WB isolated.sh | init 自动部署 www/galaxy.html 前端模板 |
| D-LE2-04 RECEIVED 即可修正 | App Index.ets + WB routes.py | 现场修正/原始来源在 RECEIVED 即开放；get_capture 返回全部 revisions + text_body |
| D-LE2-05 修正横幅目标名 | App Index.ets | 修正模式横幅显示目标条目名 |
| J08 版本链视图 | App Index.ets + WB routes.py | 「原始来源」展示 r1..rN 分层链（每层原文/状态/结果链接） |

## 4. 质量证据

- Workbench 单测：tests/mobile_capture_bridge 13/13 PASS（候选 92892d66 实跑，`python -m unittest discover -s tests/mobile_capture_bridge`）。
- HAP 构建：BUILD SUCCESSFUL（build-hap.sh），39,206,998 B。
- 两轮实操：LE R2 9/9 COMPLETED、ED 11/11 COMPLETED，双方零 FAILED 残留（LE 5min 音频经产品内重试第 4 次 COMPLETED，见 DEFECT_CYCLE/E1 节）。

## 5. 已知限制（如实）

- REAL_DEVICE_NOT_REVIEWED：仅 OpenHarmony 模拟器，真机未验证（合同范围内，governance SIMULATOR_FIRST_UNTIL_1_0）。
- 生产/公网部署未验证；真实私人数据未用（全部合成/测试文本）；多模态（图片等）future work；完整索引规模未验证；看门狗参数（600s）对超长音频的调优留作 future work。
- HAP zip 复构建字节级不稳定（CANDIDATE_MANIFEST §5 披露）。
- 模拟器状态栏时钟慢 12h（D-LE3-03）与 uitest 中文注入前导 `%`（D-LE3-02）为环境/工具瑕疵，业务时间戳与链路证据不受影响。
