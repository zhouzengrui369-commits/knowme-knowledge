# DEFECT CYCLE — 缺陷循环完整记录

## 头部标识

- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1
- PR = #32（draft, OPEN）
- DATE = 2026-09-22
- ENVIRONMENT = OpenHarmony emulator（kk02phone）, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555

## 循环总览（发现 → 修复 → 候选变动 → 旧证据作废 → 重跑）

候选演进：`4771c85`（修复前）→（D-KK03-01 / D-KK03-02 修复）→ `15ff3a8` →（D-KK03-03 修复）→ `d02014f`（冻结候选，PARENT = 15ff3a8）。

按治理规则 §28：候选 SHA 变化即作废此前针对旧候选的验收证据。作废证据仅保留作废说明，不再作为验收依据：

- 工作区 `kk03-le-screenshots/`：LE run1 @4771c85 截图（发现 D-LE-01 的那一轮），已作废。
- 工作区 `kk03-le-final-screenshots/`：LE run2 @15ff3a8 截图（21/21 PASS 后因 D-KK03-03 候选变动作废），已作废。
- 当前有效证据：run3 @d02014f（本证据包 screenshots/local-execution-run3/）与 ED 本人操作 @d02014f（本证据包 screenshots/ed-personal/）。

## D-KK03-01 — 纯标点转写曾放行成为候选

| 字段 | 内容 |
|---|---|
| 发现者 / 轮次 | ED 探索轮（@4771c85 修复前） |
| 现象 | 纯标点转写（如「。」）曾通过流程放行成为候选 |
| 根因 | 缺少转写意义性门控：仅按「有转写文本」判断，未判断是否有意义 |
| 修复 | `hasMeaningfulTranscript` 门控：无意义转写按无可用转写诚实拦截 |
| 作废旧证据范围 | 4771c85 上的探索轮观察记录 |
| 回归证据（d02014f） | LE-22c（OBSERVED_NATURALLY）：VERIFIED 0.663/0.713 + NOT_AVAILABLE 拦截自然出现；截图 49、71 |

## D-KK03-02 = D-LE-01 — 长采样停止后主线程冻结（APP_FREEZE）

| 字段 | 内容 |
|---|---|
| 发现者 / 轮次 | LE run1（@4771c85） |
| 现象 | ~67s 声纹采样停止后主线程阻塞，APP_FREEZE，被系统杀掉 |
| 根因 | 停止采样后对全量 PCM 做声纹计算，主线程长阻塞；faultlog 栈：sherpa compute←extract←addEnrollmentSample←stopSession |
| 修复 | `boundedAnalysisPcm` 10 秒上限，分析输入有界化；候选变动 → 15ff3a8 |
| 作废旧证据范围 | LE run1 全部截图（kk03-le-screenshots/）作废，仅保留缺陷发现记录 |
| 回归证据 | run2 @15ff3a8：73s 长采样回归无冻结（该轮后亦作废，回归由 run3 重验继承）；run3 @d02014f：LE-20 70 秒+采样不冻结、计数 02:06、录入完成(3/3)，截图 39~44 |

## D-KK03-03 — 注入测试转写误拒且按钮静默

| 字段 | 内容 |
|---|---|
| 发现者 / 轮次 | ED 本人（@15ff3a8） |
| 现象 | 注入测试转写路径在纯标点场景被 `length>0` 误拒；且拒绝时按钮静默无反应，用户无任何反馈 |
| 根因 | 拒绝条件只看文本长度（length>0 即拒），把「已有无意义（纯标点）转写」误判为「已有真实转写」；且拒绝分支不发任何消息 |
| 修复 | 改为只在已有有意义转写时拒绝 + 拒绝时给解释文案；候选变动 → d02014f（冻结候选） |
| 作废旧证据范围 | LE run2 @15ff3a8 全部截图（kk03-le-final-screenshots/，21/21 PASS）作废 |
| 回归证据（d02014f） | LE-22a（PASS）：VERIFIED 0.713 + NOT_AVAILABLE 下注入成功、全程 TEST_FIXTURE 标注、保存 +1（3→4），截图 71~75（前置轨迹 60~70）；LE-22b（PASS）：空输入注入被拒且解释「注入被拒绝:请输入测试转写文本;若已有真实转写,请先丢弃再试。」，截图 47/53/54；LE-22c（OBSERVED_NATURALLY）：纯标点门控自然观察到，截图 49/71 |

## 单元测试

- 67 / 67 PASS（d02014f）；新增 NoteFlow / FixtureTranscript / VoiceCore 测试覆盖上述修复路径（见 ALLOWED_PATH_DIFF_RECEIPT.md 与 REGRESSION.md）。

## 结论

三个缺陷均完成「发现 → 根因 → 修复 → 候选变动 → 旧证据作废 → 新候选重跑回归」的完整闭环；最终候选 d02014f 双轨验收 DEFECTS_FOUND = NONE。
