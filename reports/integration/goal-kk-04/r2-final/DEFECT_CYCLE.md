# GOAL-KK-04 R2-final — DEFECT_CYCLE

> 2026-09-23 · 重入轮缺陷循环全程记录：发现 → 定级 → 修复 → 新 pair → 复测确认。

## 1. R1（失效 pair 10d8291/e548883b，fresh 环境 LE R1）发现

| ID | 缺陷 | 定级 | 修复 | 复测 |
|---|---|---|---|---|
| D-LE2-01 | 撤销/未连接时提交无原位反馈 | 产品缺陷 | App Index.ets：条目下方原位红字+恢复指引 | LE j01_04 PASS |
| D-LE2-02 | 隔离实例未部署前端模板（浏览器 404/空页） | 环境/部署缺陷 | isolated.sh init 自动部署 www/galaxy.html | LE j11_01 PASS |
| D-LE2-04 | RECEIVED（整理中）条目不可现场修正/看原始来源 | 产品缺陷 | App 状态门控放宽至 RECEIVED + get_capture 返回全部 revisions+text_body | LE j08_01/05、ED s09 PASS |
| D-LE2-05 | 修正模式横幅不带目标条目名 | 产品缺陷 | App 横幅显示目标名 | LE j08_02、ED s07 PASS |
| E1 | 并发整理触发看门狗误杀：6 任务 4 超时 FAILED（LOCKED_SKIP） | 产品缺陷（严重） | pipeline `_organize_lock` 串行化，看门狗从拿锁后起算 | 两轮终态零 LOCKED_SKIP（LE 9/9、ED 11/11） |

（第 5 项 UI 类缺陷并入上述修复提交；全部修复落在允许路径，见 ALLOWED_PATH_DIFF_RECEIPT。）

## 2. 缺陷循环治理动作

- 修复产出新 pair：App c0171d4（1 commit）/ Workbench 92892d66（1 commit）；旧 pair 证据 SUPERSEDED 不删不改（合同 §8）。
- 新 pair 上重做全部 final-pair 实操：LE R2 全旅程 + ED 本人套件，非「只复测缺陷点」。
- 单测扩充 +28 行（串行化/revisions 用例），13/13 PASS。

## 3. R2/R3 新发现（环境/工具类，全部闭环）

| ID | 事项 | 性质 | 处置 |
|---|---|---|---|
| D-LE3-01 | LE 工作台进程遭 macOS jetsam 杀（~13:37） | 环境（内存压力） | 产品按设计持久恢复，数据零丢失；不计产品缺陷，已闭环 |
| D-LE3-02 | uitest inputText 中文注入残留前导「%」 | 测试工具瑕疵 | 非产品缺陷；受影响标题如实保留并披露 |
| D-LE3-03 | 模拟器状态栏时钟慢 12h | 环境 | 业务时间戳全对（hdc date 为准）；披露 |
| OBS-ED-01 | 「历史」前缀不可达（ephemeral 设计 + ensureIntro 持久化时序） | 观察项 | 无用户可见影响，不定级，留 governance（PX_REGRESSION_RECEIPT §PX-KK03-03） |

R2 终版：**无新产品缺陷发现**（LOCAL_EXECUTION_RECEIPT §缺陷清单终版）。

## 4. E1 终版（J03(b) 5min 音频，LE）

- 传输链 PASS（10,793,598B/hash 一致/337s）。
- 整理：3 次看门狗超时 FAILED（13:31→13:49，与 jetsam 崩溃期重叠）→ 产品内「重试整理」1 次（13:55:21，attempts=4）→ 14:01:39 COMPLETED，产物齐全。
- 按 E1 纪律：不标静默 PASS、不作「环境原因算过」；重试机制有效，未记 BLOCKED。
- ED 侧对照：30s 音频与全部 10 个文本任务 attempts=1 一次成功。
