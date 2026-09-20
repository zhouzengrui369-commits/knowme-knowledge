# LOCAL EXECUTION RECEIPT — GOAL-KK-02 Contract R3 FINAL RUN 2 (simulator)

> 本回执为 **RUN 2(final re-run)**。RUN 1(SHA `2d4e14e501caba65be3856a89ccd480aed550c36`,2026-09-20 10:39–11:03)已按合同缺陷循环作废并归档至 `/tmp/kk02-r3-le/invalidated-run1/`;作废原因:ED 在 RUN 1 后发现并修复新 defect **R3-D21**(dismissResult 在权限拒绝态下把 micState 强制刷成 IDLE,导致拒绝横幅与系统设置深链在手动保存后消失),修复提交使候选 SHA 变更,依据合同规则全部 final evidence 须在新 SHA 上重取。

- 执行者 ID: LE-KK-GOAL02-R3-FINAL-20260920-C61A-01
- 执行日期时间: 2026-09-20 11:15–11:28 (设备时钟)
- Worktree: `/Users/njx/Project/KnowME knowledge/KnowME knowledge/kk02-r3-le` (detached HEAD, LE 专用)
- HEAD SHA: `06b013cf776d308737cf6726afcff7ee4831f5f4` — `git rev-parse HEAD` 逐字一致;`git status --porcelain` 为空(clean)
- 声纹模型: `3dspeaker_speech_eres2net_base_200k_sv_zh-cn_16k-common.onnx`,provision-models.sh 报 OK,sha256 `e2d2048292e055f7b61cdec3db010503f35369b245bf0b3bbad021c9a91e4053`
- 单元测试: `Tests run: 46, Failure: 0, Error: 0, Pass: 46, Ignore: 0`(Hypium 设备端;较 RUN 1 多 1 个 R3-D21 回归用例,与预期一致)
- 产物 sha256(新构建):
  - main hap `entry-default-unsigned.hap`: `bc5f06a65ff9adce4073d84a79355817d11955abc5a897b351d4f0ee83ae0473`
  - ohosTest hap `entry-ohosTest-unsigned.hap`: `96ec99345aaa3be748665e8b1784d58c3d1048189653fb0bf9380df1f8d7b757`
- 模拟器环境: OpenHarmony API 24 手机模拟器 @ `127.0.0.1:5555`;bundle `com.knowme.knowledge.voiceprototype`;干净起点 = 卸载后重装新 main hap + 冷启动(麦克风权限未授予)
- 截图目录: `/tmp/kk02-r3-le/shots/`(全部 `hdc shell snapshot_display`,RUN 1 截图已随归档清空后重拍)

## 18 项必拍旅程(le-01..le-17 + 新增 le-18 D21 回归)

| # | 旅程 | 结果 | 截图 | 观察 |
|---|------|------|------|------|
| 1 | Agent-first 首屏 | PASS | le-01-agent-first-home | 头部"灵犀 · KnowME 语音原型"+Agent 开场白+对话区;语音捕获为下方附加区 |
| 2 | 模拟器/非真机披露 | PASS | le-02-emulator-disclosure | 常态披露条完整:"OpenHarmony 模拟器演示环境·非 Mate60 真机·真机未验证"、"原型声纹验证≠生产身份认证·全程本地·无云端上传" |
| 3 | mic denied → 手动输入 | PASS | le-03a-mic-denied-banner, le-03b-manual-entry-saved | 系统弹窗拒绝后 app 深链系统应用信息页;返回后横幅"麦克风权限未授予,无法录音;可以改用手动文本记录"不崩溃;手动记录入"已保存的知识(1)"带"手动文本"来源 |
| 4 | 权限恢复后数据仍在 | PASS | le-04-permission-restored-data-intact | 系统设置 Toggle 坐标点开(dump 确认 checked=true);返回后知识 1 条仍在,状态"权限已授予·待开始" |
| 5 | force-stop / cold reopen 数据仍在 | PASS | le-05-cold-reopen-data-restored | 冷开后知识 1 条在;"已从本地恢复 1 条…"标记恰好一次(R3-D20 未复发) |
| 6 | Agent context return | PASS | le-06-agent-context-return | 冷开后 denied 引导、"已记下"确认、恢复标记等历史消息完整;一次性开场白"我是灵犀"仍显示(首启同实例恢复) |
| 7 | TEST_FIXTURE UI 可达 | PASS | le-07-test-fixture-entry | 输入框+"生成 TEST_FIXTURE 演示候选"可达;披露"TEST_FIXTURE≠真实语音识别,不代表机主身份,真机未验证" |
| 8 | candidate correction | PASS | le-08-candidate-corrected | 候选卡出现,文本可编辑,保存修正后卡片即时更新。注:自动化 inputText 落点被键盘顶移致插入位置错乱(已知自动化坑,非应用缺陷) |
| 9 | candidate confirm = +1 | PASS | le-09-confirm-plus-one | 确认入库 1→2,新条目带"TEST_FIXTURE 演示"来源标识,Agent 消息含来源披露 |
| 10 | candidate reject = +0 | PASS | le-10-reject-no-change | 第二候选丢弃后知识仍 2,提示"已丢弃这段语音转写,知识没有变化" |
| 11 | 注册/本次验证状态分离 | PASS | le-11a-enrolled, le-11b-enroll-vs-verify-separate | 3 次采样完成→"注册档案:已注册(本地声纹档案)·注册完成(3/3)";"本次验证:—(尚未捕获)"独立不变;采样全程无回声被误标为验证结果 |
| 12 | 真实语音捕获 + trust gate | PASS | le-12a-recording, le-12b-trust-gate-blocked | 开始→停止→"本次验证:VERIFIED·相似度 0.626·停止→结果 429ms";即使 VERIFIED 仍被"信任门拦截:本地能力不可用(NOT_AVAILABLE),无云端回退"拦截不入库;丢弃后知识仍 2 |
| 13 | 错误恢复 | PASS | le-13-rapid-toggle-recovered | 4 次 <0.5s 快速交替开始/停止,无崩溃不死录音态,回空闲("点开始说话"/"麦克风:已停止");拦截消息如实显示 |
| 14 | 知识条目详情展开 | PASS | le-14-entry-detail-source | 点条目展开显示"来源:手动文本输入(非语音,未做声纹验证)" |
| 15 | 权限撤销(杀进程)后数据仍在 | PASS | le-15-permission-revoked-data-intact | 设置里关 Toggle(dump 确认 checked=false)→重新 aa start→知识 2 条+对话上下文完整恢复,"已从本地恢复 2 条…"恰好一次;撤销后 denied 横幅+深链仍在(再次佐证 D21) |
| 16 | 重置回归 | PASS | le-16a-reset-dialog, le-16b-reset-confirmed | 弹窗明示只删声纹、知识不受影响;取消→一切不变(仍已注册);确认重置→"注册档案:未注册·已重置",知识 2 条保留,"本次验证:—(尚未捕获)" |
| 17 | D1-D17 回归核对 | PASS | le-17-regression-final-state | 见下表逐条结论;关键补证:重置后最终状态(未注册/本次验证空/知识 2 条保留) |
| 18 | **R3-D21 回归(新增必验)** | PASS | le-18-d21-banner-persists-after-manual-save | 权限拒绝态手动保存 1 条后,拒绝横幅"麦克风未授权。不授权也能继续…"与"去系统设置开启麦克风(可选)"深链**仍然可见**;点击深链成功跳转系统应用信息页(可达)。D21 修复行为实证成立 |

## D1-D17 逐条回归结论(本构建 06b013c)

依据来源:缺陷定义取自 git 历史提交说明(cedc8e4=D1-D5,1d44589=D6-D7,ef5d668=D8-D9,d721093=D10-D11,2a4364c=D12-D13,2bd6652=R2-D14,6bf181a=R2-D15,b02bca6=R2-D16/D17);仓内无独立 D 清单文件。另核 R3-D20、R3-D21。

| 编号 | 结论 | 一句依据 |
|------|------|----------|
| D1 重复捕获引擎复用 | OK | le-13 四次快速交替无资源耗尽、无崩溃 |
| D2 重启档案加载(TextDecoder) | OK | le-05/le-15 冷开加载正常,无 RangeError 表现 |
| D3 麦克风启动失败诚实标注 | OK | le-03 denied 走授权引导文案,未误标为 STT 类提示 |
| D4 录音中 startSession 重入保护 | OK | le-13 录音中快速再点开始,无双会话、无卡死 |
| D5 STT beginSession 失败如实上报 | OK | le-12 NOT_AVAILABLE 被如实显示为拦截原因,非静默 |
| D6 权限拒绝死路 | OK | denied 后深链按钮+Agent 引导+手动文本路径均可用(le-03/le-18) |
| D7 会话陈旧不渲染 | OK | 全程 Agent 消息即时渲染(已记下/已入库/已丢弃/拦截/恢复) |
| D8 前台权限刷新 | OK | le-04 设置往返后状态即刷"权限已授予·待开始",未重跑请求流 |
| D9 注册后声纹状态刷新 | OK | le-11 第 3 次采样停止即显示"已注册·注册完成(3/3)" |
| D10 STT NOT_AVAILABLE 降级手动入口 | OK | le-12 拦截卡给出手动文本路径,不伪造转写 |
| D11 dismissResult 清场 | OK | 确认/丢弃/重置后候选/拦截/结果卡全部清场无残留 |
| D12 Agent 消息即时渲染 | OK | 修正→保存→确认全链消息即时出现 |
| D13 onPageShow 冲掉 live verdict | OK | le-15 设置往返(含撤销)后状态未被刷新逻辑冲掉;注册档案与本次验证始终独立 |
| R2-D14 注册/重置后状态条陈旧 | OK | le-11 注册后、le-16 重置后状态条即时刷新 |
| R2-D15 重置需确认 | OK | le-16 AlertDialog 取消保留/确认删除语义正确 |
| R2-D16 STT 部分失败覆盖披露文案 | OK | le-12 拦截消息如实给出真实原因(NOT_AVAILABLE),披露文案未被覆盖 |
| R2-D17 重置/新捕获后旧结果卡残留 | OK | le-16b/le-17 重置后"本次验证:—(尚未捕获)",旧相似度无残留 |
| R3-D20 恢复标记重复 | OK | le-05、le-15 两次冷开恢复标记均恰好一次 |
| R3-D21 拒绝态手动保存后横幅/深链消失 | OK(FIXED VERIFIED) | le-18:手动保存后横幅+深链仍可见可达;le-15 撤销后同样成立 |

## 发现的 defect

NONE(本 run 未发现新缺陷)。

非缺陷观察记录:
- O1: le-08 自动化 inputText 落点被弹出键盘顶移,修正文本插入位置错乱(任务书已知自动化坑 #2),非应用缺陷;修正/保存/确认链路功能正确。
- O2: 模拟器无声源环境下,le-12 真实捕获达 VERIFIED 0.626 但仍被 NOT_AVAILABLE(本地转写能力不可用)拦截——trust gate 纵深防御如实工作;UNCERTAIN 与 NOT_VERIFIED 本 run 未触发。
- O3: denied 后点主按钮 app 直接深链系统应用信息页(D6 设计行为)。
- O4: le-14 操作中一次点击误命中 Agent 历史消息 Text 节点("已丢弃…"文本),未造成任何状态变化;自动化定位噪声,非应用缺陷。

## 声明

- 本次运行未修改任何源码/测试/脚本/治理文件;worktree 全程 clean(只读操作 + 构建产物 + 运行时模型资产)。
- 未做任何 git 写操作(无 commit/push/checkout 分支切换;worktree SHA 切换由调用者完成,本 LE 仅核验)。
- 截图全部经 `hdc shell snapshot_display` 采集,无 macOS 截屏。
- 本回执仅记录 PASS/FAIL 观察,不声明任何治理状态(不声明 Engineering Ready / Candidate Admission / Product Experience 等)。
- RUN 1(SHA 2d4e14e)全部证据依合同作废,本回执为唯一有效 final evidence。
