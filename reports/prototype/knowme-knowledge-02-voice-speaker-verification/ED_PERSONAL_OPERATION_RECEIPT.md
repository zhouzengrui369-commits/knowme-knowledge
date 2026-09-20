# ED PERSONAL OPERATION RECEIPT — GOAL-KK-02 Contract R3 FINAL RUN 2

- 操作者：ED-KK-GOAL02-PX01-CORRECTION-R3-20260920-0750-C61A（本人，非 LE 截图转述）
- 日期时间：2026-09-20 11:25–11:45（设备时钟）
- Exact SHA：`06b013cf776d308737cf6726afcff7ee4831f5f4`（与 LE run2 相同）
- 构建：与 LE run2 完全相同的 main hap 二进制（sha256 `bc5f06a65ff9adce4073d84a79355817d11955abc5a897b351d4f0ee83ae0473`；ED 工作区构建产物未用于本 run）
- 环境：同一台模拟器 `127.0.0.1:5555`（API 24）；起点 = 卸载后重装该 hap + 冷启动
- 截图：`screenshots/ed-personal/ed2-*.jpeg`，全部 `hdc shell snapshot_display` 本人采集，独立于 LE 截图

## 必验清单逐项（任务书 13 项 + 补充）

| # | 项 | 结果 | 截图 | 观察 |
|---|----|------|------|------|
| 1 | Agent-first 首屏 | PASS | ed2-01 | 灵犀头部+开场白+对话区；语音捕获为附加区 |
| 2 | 模拟器/非真机披露 | PASS | ed2-01 | 披露条常态可见（模拟器/非真机/≠生产认证/本地无云端） |
| 3 | mic denied → 手动输入 | PASS | ed2-02, ed2-03 | 系统弹窗拒绝→横幅+引导不崩溃（拒绝后 app 深链系统应用信息页=D6 设计）；手动保存 1 条来源=手动文本；**横幅在深链往返后仍可见（D21 本人实证）** |
| 4 | 权限恢复后数据仍在 | PASS | ed2-04 | 设置 Toggle 开（dump checked=true）→返回知识 1 条在 |
| 5 | force-stop / cold reopen 数据仍在 | PASS | ed2-05 | 冷开知识+上下文恢复，恢复标记恰好一次（D20 不复发） |
| 6 | Agent context return | PASS | ed2-05 | "已记下"等历史消息完整 |
| 7 | TEST_FIXTURE UI 可达 | PASS | ed2-06 | 入口+披露完整 |
| 8 | candidate correction | PASS | ed2-07 | 追加【修正】标记→保存修正即时更新（插入位置错位=已知自动化坑） |
| 9 | candidate confirm = +1 | PASS | ed2-08 | 1→2，TEST_FIXTURE 演示来源 chip |
| 10 | candidate reject = +0 | PASS | ed2-09 | 仍 2，"知识没有变化" |
| 11 | 注册状态/本次验证状态分离 | PASS | ed2-10 | 3 采样完成"注册档案:已注册(本地声纹档案)·注册完成(3/3)"；"本次验证:—(尚未捕获)"独立；无采样回声误标（D19 不复发） |
| 12 | 真实捕获 + trust gate | PASS | ed2-11, ed2-12 | VERIFIED 0.656 仍被"信任门拦截:本地能力不可用(NOT_AVAILABLE),无云端回退"拦截；丢弃后仍 2 |
| 13 | 错误恢复 | PASS | ed2-13 | 4 次 <0.5s 快速交替无崩溃回空闲（"麦克风:已停止"+按钮可用） |
| 14 | 知识条目详情展开（补充） | PASS | ed2-14 | 展开显示"来源:手动文本输入(非语音,未做声纹验证)。" |
| 15 | 权限撤销（杀进程）数据仍在（补充） | PASS | ed2-15 | Toggle checked=false→重开知识 2 条+上下文完整，恢复标记一次 |
| 16 | 重置回归（补充） | PASS | ed2-16a, ed2-16b | 弹窗明示只删声纹；取消保留；确认后"未注册·已重置"知识 2 条保留 |
| 17 | D1-D17 regression | PASS | 见 REGRESSION_RECEIPT | 本人全程操作未观察到任何 D1-D17 行为回归 |

## 本人在 final run 前的 defect 发现（defect loop 如实记录）

- R3-D18（探索期发现）：DENIED 横幅不可达 → 已修，探索期 ed-21 实证。
- R3-D19（探索期发现）：注册采样回声被显示成"本次验证"结果 → 已修，探索期 ed-23/ed-24 实证。
- R3-D20（探索期发现）：恢复标记跨重启累积 → 已修，final run 四次恢复均恰好一次。
- R3-D21（final run1 本人操作中发现）：手动保存冲掉拒绝横幅 → 已修（SHA 2d4e14e→06b013c），全部 final 证据作废重跑（本 run 即重跑结果），le-18 + ed2-03 实证。

## 声明

- 本 run 全部操作为本人亲自执行（uitest 驱动 + 界面文本/dump 核验 + 本人逐屏截图），未复用 LE 任何截图作为本人证据。
- 未声明任何越权状态；最高仅支持 ENGINEERING_READY。
