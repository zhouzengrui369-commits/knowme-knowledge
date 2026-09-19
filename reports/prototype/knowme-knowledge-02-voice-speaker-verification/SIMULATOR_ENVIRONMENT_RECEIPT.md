# SIMULATOR_ENVIRONMENT_RECEIPT — GOAL-KK-02 Contract R2

## 声明的模拟器(the declared simulator)

```text
实例名=kk02phone(DevEco Studio Emulator, phone 形态)
连接=127.0.0.1:5555(hdc)
镜像=OpenHarmony-6.1.1.125(param get const.ohos.fullname)
API=apiversion 24(param get const.ohos.apiversion)
产品型号=emulator(param get const.product.model / name)
宿主=macOS(Apple Silicon),音频链路:Mac 扬声器 → Mac 麦克风 → 模拟器 mic 输入
```

## 应用目标版本与镜像差异(如实记录)

```text
应用 compatibleSdkVersion=4.1.0(11)(apiCompatibleVersion=40100011,bm dump 实证)
模拟器镜像=apiversion 24
两者不一致属预期:目标版本 ≤ 镜像版本,向前兼容运行。不得改写为"一致"。
构建期仅 1 条相关警告:Index.ets 使用 getHostContext(SDK 12+ 可用),在 4.1.0(11) 下告警但编译通过、
运行未触发该路径异常(RUNTIME_ERROR_RECEIPT 记录)。
```

## 启动与管理方式(可复现)

```text
启动:nohup …/command-line-tools/bin/Emulator -start kk02phone >/tmp/emu.log 2>&1 &
     (必须 nohup;shell 退出会杀进程。首次须 Emulator -license accept)
就绪:param get bootevent.boot.completed = true(冷启动约 30s)
停止:Emulator -stop kk02phone
数据:冷启动后 userdata.img 保留(注册/权限存续);hap 换装须两包同命令
```

## 已知模拟器特异行为(全部如实披露)

```text
1. STT 可用性按 boot 掷骰:部分 boot CoreSpeechKit 报 1002200010/1002200003 全程不可用,
   部分 boot 完全可用。fixture 旅程利用"VERIFIED + 无转写"的自然窗口实证。
2. 声纹区分度:该声学路径上全音源相似度 0.55–0.82,跨说话人/跨语言/白噪声均 ≥0.62 阈值。
   VERIFIED 仅证明管线活性,不证明说话人区分能力;标定属 post-1.0 真机事项。
3. NOT_VERIFIED(<0.45)在该路径自然不可达(LE RUN 2 附 9 次探测分数矩阵),门控映射由单元测试覆盖。
4. 一次 CLI 启动的 boot 曾宿主 mic 静默(相似度恒 0.613=静音特征),重启后恢复。
```
