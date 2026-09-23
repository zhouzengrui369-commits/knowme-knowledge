# ED_PERSONAL_OPERATION_RECEIPT — r3-gap-closure

operator: ED 本人（context ED-KK04-ADMISSION-GAP-CLOSURE-20260923-B2C4）｜ 2026-09-23 20:46–21:55 ｜ 实例 18241 ｜ canonical HAP a7302224…

合同 §14：ED 本人不得只审 LE 产物，必须在同一 canonical HAP 上亲自重做核心套件。本回执为 ED 本人实操总账；全程原始日志 kk04-ed2/ed/ed3_runlog.md，截图 shots/ed-personal/ed3_*。

## 前置

- 20:46 ED_PREINSTALL：uninstall + install canonical 文件（shasum 复核 = a7302224…）。
- 20:47 App 启动，KB_ROOT=runtime/kb-root fresh（captures=0 / tasks=0），前端 200，rport 18246→18241。

## 旅程总账（DB 只读实证）

| 旅程 | capture_id | task_id | attempts | 终态 | 关键图 |
|---|---|---|---|---|---|
| J02 文本主链 | cap_62c67e14…d74234 | task_baffc2b4521b4706 | 1 | COMPLETED 20:53:12 | s01–s03 |
| J03 音频 30s | cap_74910c64…d7e6ac（wav 1,024,078B） | task_d6ade1777bc44c0a | 1 | COMPLETED 20:56:56 | s04–s06 |
| J04 离线→冷开→恢复 | cap_aa1fef82…35592bf | task_ac4b649c60544ac1 | 2 | COMPLETED 21:04:53 | s07–s11 |
| J05 插件停/启 | cap_d3f4c0df…81437e1 | task_cfb159386fd64257 | 1 | COMPLETED 21:08:07 | s12–s14 |
| J06a 连点×3 | cap_4961e72f…ca14a3a8 (r1) | task_d5671c86eafb4795 | 1 | COMPLETED 21:10:22 | s15–s16 |
| J06b 双 ID | cap_f1c40d62…fd5cdec8 + cap_c40b9f58…d1e7a181 | task_89e803e5706346ec + task_28d8055aa31a4680 | 1+1 | COMPLETED 21:18:08 / 21:20:08 | s17–s20 |
| J07 昨日捕获 | cap_8789e635…06b29ca5 | （COMPLETED 21:22:52） | 1 | captured=09-22T21:00 / received=09-23T21:21:01 / organized=21:22:52 | s21–s23 |
| J08 三层链 | cap_818c95ef…9e67a1f9 r1/r2/r3 | 3 task 各 COMPLETED | 1/1/1 | 21:25:40 / 21:29:11 / 21:32:04 | s24–s28 |
| J09 早前/当前+冷启 | —（会话层验证） | — | — | 前缀分层 + 冷启零陈旧 | s29–s31 |
| J11 真实 UI | —（工作台侧） | — | — | ADD→SEARCH→PREVIEW→CONVERSATION | w01–w09 |

终态：captures 14 / tasks 14 全部 COMPLETED，零 FAILED、零残留 PROCESSING。

## 如实记录的两次操作失误（均非产品缺陷，已重做达标）

1. J04 首尝：hdc rport/fport rm 无法移除 18246 转发（"ruler is not exist"），采集 cap_cbc56ba3…10f8d5 被在线误提交（task_6422609889084814 COMPLETED 21:01:01）。改用停服务器（isolated.sh stop）实现真离线后重做。
2. J06b 首尝：J06a 连点残余击点误触「现场修正」，J06b 首条保存成 cap_4961e72f 的 r2 correction（task_968fb99b361b4c78 COMPLETED）。退出修正模式后用双采集重做达标。

## PX-KK03-01/02/03 回归（ED 侧实证）

- PX-01 原始捕获可追溯：J08 assets r1/r2/r3 三层并存，r1 raw-transcript.backup 原文未被覆盖（grep 实证），三层 note 各自独立。
- PX-02 重复操作无副作用：J06a 三连点 1 capture/1 task/1 note；无系统设置跳转、无自动录音、无外发。
- PX-03 当前/历史分离：J04 failure→retry→success（attempts=2）、J05 disable→enable 补传、J09 冷启零陈旧、早前/当前前缀分层。

## 环境观察（继承口径）

captured_timezone=America/Chicago 与 captured_at +08:00 偏移不一致（同 LE D-LE3-06：模拟器 region 与时钟配置矛盾的环境怪相，App 如实上报设备值）；状态栏时钟慢 12h（D-LE3-03 同源）；uitest 中文偶发前导 %（工具瑕疵）。

合同内产品缺陷：零。CANDIDATE_REJECTED=NO，本轮零源码改动。
