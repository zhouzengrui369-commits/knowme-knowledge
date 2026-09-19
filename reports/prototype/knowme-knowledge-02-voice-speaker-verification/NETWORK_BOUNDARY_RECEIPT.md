# NETWORK_BOUNDARY_RECEIPT — GOAL-KK-02 Contract R2

## 静态证据

```text
1. 权限清单:entry/src/main/module.json5 的 requestPermissions 仅 ohos.permission.MICROPHONE。
   未声明 ohos.permission.INTERNET —— 系统层面应用无法发起网络请求。
2. 代码扫描:entry/src/main/ets/** 无 http/fetch/rcp/socket/remoteCommunication 任何网络 API 调用。
3. STT:CoreSpeechKit 离线中文(on-device);界面常驻披露「on-device,无云端」。
4. 声纹:sherpa-onnx 本地推理(3dspeaker eres2net 模型文件在应用 rawfile,本地加载)。
5. 无云端回退:所有不可用路径文案明示「无云端回退」,NOT_AVAILABLE 如实拦截。
```

## 动态证据

```text
全部旅程(LE RUN 1/RUN 2、ED 本人)在未授予任何网络权限的模拟器实例上完成,
语音捕获→声纹验证→STT→候选→入库全链路功能正常 —— 证明链路不依赖网络。
```

## 结论

```text
NO_SILENT_CLOUD_AUDIO=PASS
音频数据不出设备:无网络权限 + 无网络代码 + 全旅程离线可用,三重证据。
```
