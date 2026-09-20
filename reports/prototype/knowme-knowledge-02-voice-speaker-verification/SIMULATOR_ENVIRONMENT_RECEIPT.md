# SIMULATOR ENVIRONMENT RECEIPT — GOAL-KK-02 Contract R3

## 设备（hdc param get 实测）

```text
const.product.model            = emulator
const.ohos.apiversion          = 24
const.product.software.version = emulator 6.1.0.126(SP1DEVC00E120R4P11)
```

- 连接：`127.0.0.1:5555`（本机 OpenHarmony 手机模拟器，DevEco 工具链启动）
- hdc：`Ver: 3.2.0d`
- App bundle：`com.knowme.knowledge.voiceprototype`（version 0.1.0）

## 披露义务对应

- 本环境为**模拟器**，非 Mate60 真机；产品首屏常态披露条明示"OpenHarmony 模拟器演示环境 · 非 Mate60 真机 · 真机未验证"（le-02 / ed2-01 截图实证）。
- 模拟器无声学真值：真实语音捕获可达 VERIFIED/UNCERTAIN 判定，但 NOT_VERIFIED 在模拟器上诚实标注为不可稳定触发；STT 本地能力不可用时如实 NOT_AVAILABLE，绝不走云端（le-12 / ed2-12 实证）。
- 无 REAL_DEVICE_VALIDATED 声明。

## 数据与隐私边界（本环境实测）

- 应用沙盒：`/data/app/el2/100/base/com.knowme.knowledge.voiceprototype/haps/entry/files/`
- 持久化文件：`kk02_agent_context.json`（有界：messages≤30、knowledge≤100）、`kk02_speaker_profile.json`（本地声纹档案）、模型 onnx（首次启动拷贝）。
- 全部内容为本地产物；raw Owner 音频、声纹 embedding、私密转写均未进入 Git（合成非敏感内容演示）。
