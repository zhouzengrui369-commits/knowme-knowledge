# lingxi-mobile-android

GOAL-KK-04 R3（账户化移动工作台）Android App 工程。

## 定位

- 原生 Kotlin + Jetpack Compose，单 Activity，四目的地：灵犀 / 记录 / 知识 / 我的。
- minSdk 26 / targetSdk 34 / arm64-v8a。
- 离线中文 ASR：sherpa-onnx（Apache-2.0）+ 随包/预置模型资源（J13 飞行模式冷开要求）。
- 同步：mobile-capture 协议 v2（接口合同见 `reports/integration/goal-kk-04-r3-account-agent/INTERFACE_CONTRACT.md`）。
- 手机 Agent：轻量 Kotlin 运行时 + 用户自配 OpenAI 兼容模型 API（**不是完整 DSH**，披露见 IMPLEMENTATION_PLAN §5）。

## 构建

```bash
export JAVA_HOME=/opt/homebrew/opt/openjdk@17
export ANDROID_HOME=$HOME/Library/Android/sdk
./gradlew assembleDebug
```

产物：`app/build/outputs/apk/debug/app-debug.apk`（debug 未签名/测试签名——正式取回件为签名 APK，见 APK_DELIVERY_RECEIPT）。

## ASR 资源 provisioning（J13 前置）

模型打入 `app/src/main/assets/asr/`（竖切联调时指定文件清单 + sha256，进入 CANONICAL_ARTIFACT_RECEIPT）。
未 provision 时引擎如实报 `NOT_PROVISIONED`，UI 不会假装在转写。

## 账户与隔离

- 绑定：`我的` → 输入工作台地址 + 配对码（服务端 `/v2/session/pair`）。
- 账户维度数据隔离：Room 行级 `accountId` + 账户目录；切换账户零继承。
- 未登录：通用壳 + 引导，不出现真实知识。

## 验证约定

- `./gradlew testDebugUnitTest`：Room 幂等/隔离、outbox 恢复、状态仓行为。
- 真机旅程 J01–J23 由合同规定的 fresh LE 与 ED 本人双套实操完成，不用单测冒充。
