# REGRESSION_RECEIPT — GOAL-KK-02 Contract R2

## 单元测试回归序列(模拟器真执行,Hypium)

| 时点 | SHA | 用例数 | 结果 | 触发 |
|---|---|---|---|---|
| R2 fixture 落地 | 7bbc884 | 22 | 22/22 PASS | TEST_FIXTURE 守卫 8 用例新增 |
| D14 修复 | 2bd6652 | 23 | 23/24 → 修复后 23/23 PASS | D14 回归用例新增 |
| D16/D17 修复 | b02bca6 | 24 | 24/24 PASS | D17 回归用例新增 |
| LE RUN 2 终验 | b02bca6 | 24 | 24/24 PASS | fresh materialization 独立复跑 |

每份 OHOS_REPORT_RESULT 原始行:`Tests run: 24, Failure: 0, Error: 0, Pass: 24, Ignore: 0`

## 行为回归(模拟器旅程级)

```text
R2-D14 回归点:注册完成即时 ENROLLED —— LE RUN 2 PASS + ED 本人 PASS
R2-D15 回归点:重置需二次确认;取消保留/确认删除 —— LE RUN 2 PASS + ED 本人 PASS
R2-D16 回归点:STT 部分失败不再覆盖披露文案 —— LE RUN 2 FIXED VERIFIED + ED 本人 PASS
R2-D17 回归点:确认重置清除旧结果(相似度/时延/转写/候选)—— LE RUN 2 FIXED VERIFIED + ED 本人 PASS
R1 D1–D13 回归:权限/注册/捕获/取消/重复/UNCERTAIN/NOT_AVAILABLE/门控/修正/丢弃/确认/
  手动兜底/Agent 响应/状态清除/前后台/离线降级/layout 溢出/错误恢复 —— LE RUN 2 18 段旅程全 PASS
```

## 缺陷循环合规

```text
LE RUN 1 发现 D16/D17 → ENGINEERING_READY 冻结 → ED 修复 → 新 SHA b02bca6
→ 技术回归 24/24 → LE RUN 2 全量重跑(旧证据作废归档 defect-loop-run1/)→ ED 本人重跑
符合合同 §9 缺陷循环全流程。
```

## 未覆盖声明(诚实)

```text
NOT_VERIFIED(<0.45)模拟器自然不可达:门控映射由 VoiceCore 单元测试覆盖,行为级未自然触发。
真机回归:整体属 post-1.0(REAL_DEVICE_NOT_REVIEWED=YES)。
```
