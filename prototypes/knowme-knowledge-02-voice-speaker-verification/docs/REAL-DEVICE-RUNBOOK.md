# GOAL-KK-02 真机取证 Runbook(Mate60)

> Engineering Delivery 内部程序文档。模拟器缺陷循环进行中(HEAD `2a4364c`,D1–D13 已修并模拟器回归),本清单用于 Mate60 真机到位后的取证执行。合同 §20:只有真机证据计入验收;模拟器证据永不作为验收证据。

## 0. 前置条件(Owner 配合项)

| 项 | 状态 | 说明 |
| --- | --- | --- |
| Mate60 数据线连接 + USB 调试(HDC) | ☐ | 开发者选项 → USB 调试;`hdc list targets` 出现非 `127.0.0.1:5555` 设备 |
| HarmonyOS 版本号 | ☑ | **4.2.0.210**(2026-09-18 Owner 截图,工作区 `mate60-version.jpg`);截图同时显示"新版本已下载 · 升级尝鲜" |
| 华为开发者账号登录 DevEco | ☑ | 2026-09-18 Owner 确认已登录 |
| 负样本来源决定 | ☐ | 二选一:同意的非机主真人朗读 / 披露的 replay 重放(须写入 receipt) |

## 0.1 版本兼容决策(2026-09-18 Owner 已定)

原型原 `compatibleSdkVersion 5.0.0(12)`(HarmonyOS NEXT 目标)。Mate60 现为 **HarmonyOS 4.2.0(API ≤ 11)**。

**Owner 决策:路线 B —— 安装包适配现有 4.2 系统,不升级手机。** 执行顺序(Owner 明确):模拟器开发测试 → 产品体验审核 → 最后才真机安装,不要着急装机。

技术依据与风险:
- `@hms.ai.speechRecognizer` 声明 `@since 4.1.0(11)`,编译面可行;但 4.2 设备是否内置离线语音模型/服务未知,STT 有降级为 NOT_AVAILABLE 的风险(诚实链承载,如实显示)
- sherpa-onnx 原生库在 4.x 的可用性需真机实测
- `compatibleSdkVersion` 降至 `4.1.0(11)` 后,构建期会静态拦截 API 12+ 调用,作为第一道防线
- 模拟器(6.1.1(24))向后兼容,不受影响

~~路线 A(升级尝鲜至 NEXT)已被 Owner 否决,不再考虑。~~

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

安装失败排查:`Error: install sign info inconsistent` = 签名问题,回 §1;`install sdk version` 类报错 = minAPIVersion 不匹配(应为 40100011)。

### 3.1 权限授予(真机步骤)

1. 首启点「授权并按住说话」→ 系统弹窗「允许"灵犀语音原型"访问你的麦克风?」→ **允许**(弹窗内嵌用途说明:录制语音完成本地中文转写与机主声纹验证)
2. 若误拒:应用会自动深链到系统应用信息页 → 麦克风开关打开 → 返回应用(返回后状态条应立即刷新为「权限已授予」,D8 回归点)
3. 全程禁止静默录音:状态条必须如实显示 空闲/录音中/被拒绝(隐私合同:麦克风状态永不暗示)

### 3.2 模型资产确认

- 声纹模型(随 HAP 打包,不依赖系统):sherpa_onnx.har + `3dspeaker_speech_eres2net_base_200k_sv_zh-cn_16k-common.onnx`(rawfile,CPU,16kHz)。装机后首屏应显示「声纹引擎就绪(本地 sherpa-onnx)」;若显示 NOT_AVAILABLE,记录 `engineIdentity()` 文本进 TECHNICAL_RECEIPT
- STT(系统侧 CoreSpeechKit):4.2 是否内置离线中文模型未知 —— 这是真机第一优先级实测项。NOT_AVAILABLE 为可接受诚实降级(触发 D10 降级卡:手动文本入口),伪造转写为违约

冒烟检查:首屏三行状态(麦克风/STT/声纹)、引擎就绪行、无伪造文案。

## 4. 关键未知项实测(优先级排序)

1. **CoreSpeechKit STT 端到端**:真机应带离线语音模型。录一句中文 → 期望非空转写;若同样报错,记录错误码进 TECHNICAL_RECEIPT 并按诚实链处理(NOT_AVAILABLE,绝不伪造)
2. **真人正负样本阈值标定**(合同允许 engineering 在真机 benchmark 调阈值数值,"uncertain 带必须存在"规则冻结):
   - 正样本:Owner 真人朗读 ≥5 句,记录相似度分布
   - 负样本:按 Owner 决定来源 ≥5 句,记录相似度分布
   - 安静/噪声 ≥5 次,记录 STT 行为
   - 依据分布重定标 VERIFIED / uncertain / REJECTED 三带数值,依据写入 TECHNICAL_RECEIPT
   - 参考:模拟器 TTS 重放同嗓 0.800 / 异嗓 0.786 无区分度(重放通道压缩所致,真机真人预计拉开)
3. **真实离线 Journey E**(程序):
   - 开飞行模式,`$HDC shell "param get persist.sys.airplane_mode"` 或状态栏截图确认
   - 另起终端 `$HDC shell "hilog -r | grep -i -E 'http|socket|dns'"` 留观;或用 `netstat`/`cat /proc/net/tcp` 采样本进程无外联
   - 应用内:注册采样→捕获→验证→入库全链路应照常(声纹本地 sherpa-onnx);STT 离线可用则转写,不可用则如实 NOT_AVAILABLE
   - **任何网络调用即违约(CLOUD_AUDIO_UPLOAD=FORBIDDEN)**,一旦发现立即停止并如实记录
   - 关飞行模式,OFFLINE_RECEIPT 记录:离线期间完成的功能清单、降级项、网络边界证据
4. **候选流**:STT 有非空转写后,修正 → 确认 → 入库 → 知识计数 +1 全链;修正确认链路 agent 消息即时显示(D12 回归点);候选/拦截卡出口全部清场(D11 回归点)

## 5. 取证执行(冻结 SHA 后)

1. 缺陷循环收敛 → 冻结 final SHA → 推 candidate 分支
2. **Local Executor 子代理**:全新 context,按精确 SHA 物化工作区,真机五 Journey(A 权限 / B 注册验证 / C 捕获入库 / D 修正确认 / E 离线),P01–P20 截图,产出六份 receipt
3. **ED 本人同 SHA 复跑**:ED-P01–P09 截图(不复用 Local Executor 的任何文件)
4. **采样矩阵**:5 正 / 5 负 / 5 安静 STT,记录全部相似度与转写

### 5.1 负样本政策(合同冻结项)

- 来源二选一,Owner 未定前不执行负样本采集:
  a) **同意的非机主真人朗读** —— 需口头/文字同意,记入 receipt(只记"同意已获",不记身份信息)
  b) **披露的 replay 重放** —— 用另一台设备播放非机主录音,receipt 必须标注"重放样本,非真人在场"
- 负样本期望:NOT_VERIFIED/UNCERTAIN 拦截,**误识(VERIFIED)必须 0/5**;任何误识 = 阻断缺陷,回缺陷循环
- 负样本音频不出本机,不上传任何地方

### 5.2 隐私净化(所有 receipt/截图适用)

- 截图只含原型界面;若误入通知栏/其他应用内容,裁掉或重拍
- receipt 不含:原始音频文件、机主声纹向量数值、完整转写隐私内容(转写示例限测试句式)
- 相似度数值可记(标定依据需要);个人信息一律匿名化
- evidence 分支推送前逐份核对本清单

6. evidence 分支:20 份 receipt + 截图 + 采样矩阵原始数据
7. Issue #13 terminal receipt → PR #18 body 重写(终态版)→ 对话末 PARENT_PM_HANDOVER_PROMPT(A–I 节)→ 停(不 merge,不 release)

## 6. 已知遗留(真机阶段处理)

- 声纹阈值数值(0.62 当前值仅脚手架默认,必须真机真人重定标)
- STT 真机可用性(模拟器:1002200010 / 1002200003 均如实上报)
- D10 降级卡(STT init 失败→手动文本入口):代码与已验证拦截卡同构,但模拟器触发随机未获视觉证据,真机离线场景自然触发时补证
- D12/D13 已在模拟器修复并回归(2a4364c),真机阶段随五 Journey 顺带复核:消息即时渲染、前后台切换判定保持
- `signingConfigs` 材料不进 git
