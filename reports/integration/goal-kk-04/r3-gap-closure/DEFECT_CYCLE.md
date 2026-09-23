# DEFECT_CYCLE — r3-gap-closure

2026-09-23 ｜ 本轮缺陷循环台账

## 本轮（R3 gap closure）新发现

**合同内产品缺陷：零。** ED 本人套件与 LE fresh child 均未发现合同内缺陷 → CANDIDATE_REJECTED=NO，本轮零源码改动，不制造无意义 commit（合同 §18）。

### 观察项（不定级为产品缺陷，如实记录）

| 编号 | 观察 | 定性 |
|---|---|---|
| D-LE3-01 | 5min 演示音频需部署时现生成（isolated.sh 只部署模板） | 环境部署观察 |
| D-LE3-02/04 | uitest 工具瑕疵（中文前导 % 等） | 工具瑕疵 |
| D-LE3-03 | 模拟器状态栏时钟慢 ~12h | 环境怪相 |
| D-LE3-05 | 环境类 | 环境 |
| D-LE3-06 | captured_timezone=America/Chicago 与 +08:00 偏移不一致 | 环境怪相（region 与时钟配置矛盾，App 如实上报；ED 侧同现复核） |
| D-LE3-07 | J08 三层 events 的 note_revision 均=1 | 设计一致（每层生成独立 note 文件，各自 v1 正确） |
| OBS-ED3-01 | ED J04 首尝：hdc rport/fport rm 无法移除转发（"ruler is not exist"），改用停服实现真离线 | ED 操作/工具层，非产品缺陷 |
| OBS-ED3-02 | ED J06a 连点残余击点误触「现场修正」入修正模式（横幅正确带目标名） | 操作失误；修正链行为正确 |
| OBS-ED3-03 | 搜索结果 MOC 条目 em 摘要串显示匹配内容而非自身摘要 | 部署前端注入层既有渲染怪相，不在 candidate 改动面，留治理 |
| OBS-ED3-04 | 离线/停用期间顶部「连接：已连接」为陈旧显示（逐条红字是设计反馈面） | 既有设计，记录 |

## 前轮缺陷循环（R1→R2，已收官并本轮复核无回退）

前轮 5 缺陷修复（pipeline 串行化 / get_capture 全 revisions / isolated.sh 前端模板 / RECEIVED 即可修正 / 原位红字 / 修正横幅目标名）→ successor pair c0171d4 + 92892d66 → 本轮全部复核生效：
- 串行化：ED 14 task ORGANIZE_COMPLETED 不重叠 ✓
- J08 三层链双侧达成（依赖 get_capture revisions）✓
- 原位红字：J04/J05 双侧可见 ✓
- 修正横幅带目标名：ed3_s16/s26 实证 ✓

历史 receipt（r2-final 及更早）不删除不改写，本包为追加。
