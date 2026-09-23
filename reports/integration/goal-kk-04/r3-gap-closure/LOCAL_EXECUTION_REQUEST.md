# LOCAL_EXECUTION_REQUEST — r3-gap-closure

context: ED-KK04-ADMISSION-GAP-CLOSURE-20260923-B2C4 ｜ 2026-09-23

## 委托身份

```text
PARENT=ED-KK04-ADMISSION-GAP-CLOSURE-20260923-B2C4
CHILD=agent-3（Agent 工具句柄）
CHILD_RUN_ID=NOT_EXPOSED_BY_TOOL（Agent 工具不暴露 run id，合同允许如实标注）
```

## 委托范围

fresh LE child（observation-only）在 LE 隔离实例（kk04-ed2/le3，端口 18243，rport 18247）上，使用 canonical HAP（a7302224…，39,206,998B）全新安装后，fresh 实操完整 J01–J12：

- J01 首连/能力/撤销/拒绝/重连；J02 在线文本；J03 30s + 5min 音频；J04 离线→冷开→恢复；J05 插件停启；J06a 连点幂等 + **J06b 同名同分钟双 ID**（本轮 GAP-A 要件）；J07 昨日捕获；J08 三层修正链；J09 早前/当前+冷启；J10 注入安全；**J11 Workbench 真实 UI（Playwright，非 API）**（本轮 GAP-B 要件）；J12 清理/边界。

## 约束

- 只读 DB 实证（sqlite3 mode=ro）；不触碰 ED 实例 18241 与生产 8787；截图存 le3/shots/；回执 le3/LE_RECEIPT.md。
- 发现合同内缺陷须报 DEFECT（触发失效规则 §13）；环境/工具问题如实区分。

## 执行记录

agent-3 两次 max_steps=100 触限后以 resume 续跑（恢复点记录在 LE_RECEIPT 附录），最终完成全部旅程。
