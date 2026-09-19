# RUNTIME_ERROR_RECEIPT — GOAL-KK-02 Contract R2

## 模拟器 faultlog 全量核查(hdc shell ls /data/log/faultlog/faultlogger/)

```text
jscrash-…-20260919100639601.log
jscrash-…-20260919100645666.log
jscrash-…-20260919100704063.log
jscrash-…-20260919100743739.log
```

**四条崩溃全部发生在 2026-09-19 10:06–10:07,即 ohosTest 测试基建 bring-up 窗口**:
当时测试包缺 `OpenHarmonyTestRunner` 入口(从未生成过该模板文件)且 hypium 未安装,
`aa test` 启动 TestAbility 即 RuntimeError「Cannot find module …/testrunner/OpenHarmonyTestRunner」。

修复:entry 模块 `ohpm install`(@ohos/hypium)+ 补入官方 testrunner 模板(7bbc884)。
此后 10:07 至今 **零新增崩溃**——覆盖:fixture 开发调试期、LE RUN 1、LE RUN 2 全程 18 段旅程、
ED 本人复核全程。

## 运行时错误的如实上报设计(非崩溃,用户可见)

```text
STT 1002200010(Write audio failed / start listening failed):状态条如实显示,
  转写成功时合成披露(R2-D16 修复后),不覆盖无云端声明
STT 1002200003:同路径如实显示
STT 引擎初始化失败:本地语音识别不可用 (NOT_AVAILABLE,无云端回退),捕获入口禁用并说明
STT 会话启动失败:STT 会话启动失败(本地引擎拒绝开始,无云端回退)
信任门拦截:UNCERTAIN / NOT_AVAILABLE / NOT_ENROLLED 各有明确文案+可选动作(重说/手动文本/注册)
权限拒绝:Agent 消息「麦克风权限未授予,无法录音」+ 引导系统设置页
```

## 结论

```text
FINAL_SHA_RUNTIME_CRASHES=NONE
错误恢复旅程(快速开始/停止)PASS:错误条显示后下一次捕获正常(LE RUN 2 旅程 15)
```
