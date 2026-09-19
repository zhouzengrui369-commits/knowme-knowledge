# TECHNICAL_RECEIPT — GOAL-KK-02 Contract R2

## 构建

```text
工具链:hvigor 6.24.3(DevEco Studio 自带),hvigor-config modelVersion 6.1.1
命令:scripts/build-hap.sh(assembleHap,debug)/ scripts/run-unit-tests.sh(含 ohosTest 打包)
结果:BUILD SUCCESSFUL;警告 1 条(getHostContext 需 SDK 12+,4.1.0(11) 下降级告警,编译通过,
     运行路径未触发异常 — 见 RUNTIME_ERROR_RECEIPT)
产物:见 CANDIDATE_MANIFEST(sha256 绑定)
```

## 单元测试(Hypium,模拟器上真机执行,非 host 模拟)

```text
框架:@ohos/hypium 1.0.21 + OpenHarmonyTestRunner(官方 hvigor 模板)
执行:aa test -b com.knowme.knowledge.voiceprototype -m entry_test(scripts/run-unit-tests.sh)
结果演进:22/22(7bbc884)→ 23/23(2bd6652,D14 回归)→ 24/24(b02bca6,D17 回归)
终态:Tests run: 24, Failure: 0, Error: 0, Pass: 24(LE RUN 2 与 ED 复核一致)
覆盖:VoiceCore 14 用例(PCM 分帧/门控映射/相似度等)+ FixtureTranscript 9 用例
     (fixture 五重守卫全拒绝路径 + golden 解锁 + dismiss 清标记 + D14 + D17 回归)
```

## R2 期间修复的缺陷(接 R1 D1–D13)

```text
R2-D14:注册完成(3/3)后状态条滞留 NOT_ENROLLED(D13 守卫误挡注册生命周期刷新)
        → forceRefreshSpeakerState();模拟器实证 + 回归测试
R2-D15:重置声纹单击即不可逆清空档案(自动化误触真实复现:消息增长布局下移,旧坐标命中重置键)
        → AlertDialog 二次确认;取消/确认两路径模拟器实证
R2-D16(LE D-LE-01):STT 部分失败时裸错误覆盖「离线中文/无云端」披露文案
        → 转写成功时合成披露:「CoreSpeechKit 离线中文 (on-device,无云端) · 转写成功,但会话收尾报错已如实记录:…」
        LE RUN 2 FIXED VERIFIED + ED 本人复核
R2-D17(LE D-LE-02):确认重置后旧相似度/时延残留(NOT_ENROLLED 旁挂着已删声纹的 0.762)
        → clearResultForReset() 一并清除;回归测试 + LE RUN 2 FIXED VERIFIED + ED 本人复核
```

## 缺陷循环执行记录

```text
LE RUN 1 @2094597 → 发现 D16/D17 → ED 修复(b02bca6)→ 技术回归 24/24 PASS
→ LE RUN 2 @b02bca6 全旅程重跑 PASS、无新缺陷 → ED 本人同 SHA 同构建同模拟器复跑 PASS
旧 final 证据作废并归档:reports/.../defect-loop-run1/
```

## 已知限制(不伪造)

```text
1. ohosTest 不能经 hvigor onDeviceTest 覆盖率路径完成(未签名构建缺 signed.hap);
   已绕行为:手动两包同装 + aa test,测试结果真实可信。签名构建属 post-1.0。
2. NOT_VERIFIED 模拟器自然不可达(SIMULATOR_ENVIRONMENT_RECEIPT §3),门控由单元测试覆盖。
3. 知识条目内存态不持久(O1,观察项非缺陷,0.1 原型范围外)。
```
