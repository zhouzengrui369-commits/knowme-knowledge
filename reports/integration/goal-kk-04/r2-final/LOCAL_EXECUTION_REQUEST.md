# GOAL-KK-04 R2-final — LOCAL_EXECUTION_REQUEST

> 2026-09-23 · ED → LE（child agent-2）实操委托书（observation-only）。
> 本文件为委托书存档；执行结果见 LOCAL_EXECUTION_RECEIPT。

## 1. 委托身份

- 委托方：ED（context ED-KK04-FINAL-EVIDENCE-COMPLETION-20260923-A1F7）
- 执行方：LE = child agent-2（observation-only，独立环境、独立账号语义、不得修改候选代码与治理文件）
- 轮次：R1（失效 pair，缺陷发现）与 R2（final pair c0171d4/92892d66，复测）

## 2. 委托范围（R2）

在 fresh 隔离环境（KB_ROOT=le2/runtime/kb-root、端口 18242、rport 18245、App 先 uninstall 再 install）上按合同旅程表实操 J01–J12：

- J01 接入（连接/能力/撤销/撤销后提交/重连）
- J02 在线文本主链（COMPLETED 为 PASS 门槛）
- J03 音频（a=30s、b=5min；含 ASR 真实性与资产哈希三端一致）
- J04 离线与重启（断网排队/冷开保留/恢复补传时延）
- J05 弱网与服务恢复（含插件 disable/enable 持久恢复）
- J06 幂等与串行化（E1 回归：LOCKED_SKIP 计数；重复提交；同名同分钟双 capture）
- J07 跨日/跨时区（昨日捕获三时间，不改系统时钟）
- J08 来源链（r1→r2→r3 版本链、六要素、一击溯源）
- J09 当前状态≠历史回执
- J10 隔离与权限（命令字样文本按纯数据；无凭证 DEVICE_UNAUTHORIZED；外发 disabled）
- J11 工作台回归（前端真实页面 + add/search/preview/conversation）
- J12 首屏可理解性（全新安装）

## 3. 纪律

- observation-only：不改代码、不改环境配置以外的任何东西；缺陷只记录不修复。
- PASS 门槛：以 COMPLETED/实际可见为准；E1 类异常不标 PASS、不作「环境原因算过」，attempts 如实。
- 截图必须 hdc snapshot_display 真实页面；每张绑定旅程与时间。
- 环境怪相（jetsam/时钟/uitest 瑕疵）如实记录并区分产品缺陷与非产品原因。
- 中断点明示，供 resume；R1 证据在缺陷修复后 SUPERSEDED。

## 4. 交付物

LE_RECEIPT（逐旅程结论+缺陷清单+中断点+终态快照）+ shots/（真实截图+INDEX）。
