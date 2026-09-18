# GOAL-KK-02 真机取证 Runbook(Mate60)

> Engineering Delivery 内部程序文档。模拟器开发轮已收尾(HEAD `ef5d668`),本清单用于 Mate60 真机到位后的取证执行。合同 §20:只有真机证据计入验收;模拟器证据永不作为验收证据。

## 0. 前置条件(Owner 配合项)

| 项 | 状态 | 说明 |
| --- | --- | --- |
| Mate60 数据线连接 + USB 调试(HDC) | ☐ | 开发者选项 → USB 调试;`hdc list targets` 出现非 `127.0.0.1:5555` 设备 |
| HarmonyOS 版本号 | ☑ | **4.2.0.210**(2026-09-18 Owner 截图,工作区 `mate60-version.jpg`);截图同时显示"新版本已下载 · 升级尝鲜" |
| 华为开发者账号登录 DevEco | ☑ | 2026-09-18 Owner 确认已登录 |
| 负样本来源决定 | ☐ | 二选一:同意的非机主真人朗读 / 披露的 replay 重放(须写入 receipt) |

## 0.1 ⚠️ 版本兼容决策点(必须先解决)

原型当前 `compatibleSdkVersion 5.0.0(12)`(HarmonyOS NEXT 目标)。Mate60 现为 **HarmonyOS 4.2.0(API ≤ 11)**,无法直接安装 NEXT HAP。两条路:

- **路线 A(推荐)**:在手机上完成"升级尝鲜"已下载的新版本。若升级为 HarmonyOS NEXT 5.x,现有构建直接兼容(5.x ≥ 5.0.0(12)),CoreSpeechKit 离线语音按设计可用。模拟器为 6.1.1(24) Release,特性面接近。
- **路线 B(回退目标)**:`compatibleSdkVersion` 降至 `4.1.0(11)` 适配现状系统。已核实 `@hms.ai.speechRecognizer` 声明 `@since 4.1.0(11)`,但 4.2 设备是否内置离线语音模型/服务未知;sherpa-onnx 原生库在 4.x 的可用性也需实测。此路线 STT 有降级为 NOT_AVAILABLE 的风险(诚实链可承载,但 Journey C/D 体验受损)。

决定权在 Owner。升级前不要做路线 B 的改造。

## 1. 签名(真机必须,模拟器免签名不代表真机)

当前 `build-profile.json5` 的 `signingConfigs` 为空,真机 `hdc install` 会失败。步骤:

1. DevEco Studio 打开本工程 → **File → Project Structure → Project → Signing Configs**
2. 勾选 **Automatically generate signature**(已登录账号会自动生成 debug 证书 + profile)
3. 应用后 `build-profile.json5` 会出现 `signingConfigs` 条目;**该条目含本地证书路径,不提交 git**(确认 .gitignore 覆盖 `*.p12` / `*.csr` / `*.cer` / `*.p7b`,必要时把 signingConfigs 材料放 `~/.ohos/config` 并在 json5 中引用)
4. 重新构建:`scripts/build-hap.sh`(或 hvigorw assembleHap),产物应为 **signed** HAP

## 2. 真机探测

```bash
HDC=/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc
$HDC list targets                          # 确认真机 serial
$HDC shell "param get const.ohos.fullname" # 系统版本
$HDC shell "param get const.product.model" # 机型确认 Mate60
$HDC shell "hidumper -s 3301 | grep -i speech" 2>/dev/null || true  # CoreSpeechKit 线索
$HDC shell "bm dump -a | grep -i -E 'speech|ai'" || true            # 语音服务包
```

## 3. 安装与冒烟

```bash
$HDC install -r entry/build/default/outputs/default/entry-default-signed.hap
$HDC shell "aa start -a EntryAbility -b com.knowme.knowledge.voiceprototype"
```

冒烟检查:首屏三行状态(麦克风/STT/声纹)、引擎就绪行、无伪造文案。

## 4. 关键未知项实测(优先级排序)

1. **CoreSpeechKit STT 端到端**:真机应带离线语音模型。录一句中文 → 期望非空转写;若同样报错,记录错误码进 TECHNICAL_RECEIPT 并按诚实链处理(NOT_AVAILABLE,绝不伪造)
2. **真人正负样本阈值标定**(合同允许 engineering 在真机 benchmark 调阈值数值,"uncertain 带必须存在"规则冻结):
   - 正样本:Owner 真人朗读 ≥5 句,记录相似度分布
   - 负样本:按 Owner 决定来源 ≥5 句,记录相似度分布
   - 安静/噪声 ≥5 次,记录 STT 行为
   - 依据分布重定标 VERIFIED / uncertain / REJECTED 三带数值,依据写入 TECHNICAL_RECEIPT
   - 参考:模拟器 TTS 重放同嗓 0.800 / 异嗓 0.786 无区分度(重放通道压缩所致,真机真人预计拉开)
3. **真实离线 Journey E**:飞行模式 → 全链路应照常(声纹本地 sherpa-onnx)+ STT 离线应可用;任何网络调用即违约(CLOUD_AUDIO_UPLOAD=FORBIDDEN)
4. **候选流**:STT 有非空转写后,修正 → 确认 → 入库 → 知识计数 +1 全链

## 5. 取证执行(冻结 SHA 后)

1. 缺陷循环收敛 → 冻结 final SHA → 推 candidate 分支
2. **Local Executor 子代理**:全新 context,按精确 SHA 物化工作区,真机五 Journey(A 权限 / B 注册验证 / C 捕获入库 / D 修正确认 / E 离线),P01–P20 截图,产出六份 receipt
3. **ED 本人同 SHA 复跑**:ED-P01–P09 截图
4. **采样矩阵**:5 正 / 5 负 / 5 安静 STT,记录全部相似度与转写
5. evidence 分支:20 份 receipt + 截图 + 采样矩阵原始数据
6. Issue #13 terminal receipt → PR #18 body 重写(终态版)→ 对话末 PARENT_PM_HANDOVER_PROMPT(A–I 节)→ 停(不 merge,不 release)

## 6. 已知遗留(真机阶段处理)

- 声纹阈值数值(0.62 当前值仅脚手架默认,必须真机真人重定标)
- STT 真机可用性(模拟器:1002200010 / 1002200003 均如实上报)
- 首屏顶部安全区空白(cosmetic,不阻塞)
- `signingConfigs` 材料不进 git
