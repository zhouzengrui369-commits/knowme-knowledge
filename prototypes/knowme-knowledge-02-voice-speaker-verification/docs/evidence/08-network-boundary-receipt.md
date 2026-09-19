# 08 · Network Boundary Receipt(静态部分已实测,动态留观待真机)

> CLOUD_AUDIO_UPLOAD=FORBIDDEN 的实证。应用运行时全程网络留观。

## 静态检查(2026-09-18 已实测 @ SHA a5c1b04,unsigned debug HAP)

- ✅ 源码 `entry/src/main/module.json5`:仅声明 `ohos.permission.MICROPHONE`(`when: inuse`),无 INTERNET
- ✅ 打包产物 `entry-default-unsigned.hap` 解包 `module.json`:最终 requestPermissions = `['ohos.permission.MICROPHONE']`,依赖未注入 INTERNET
- ✅ 全代码静态扫描:无 http/socket/fetch/rcp/axios/upload 调用点,零 URL 字面量
- 结论:无 INTERNET 权限,系统层面任何网络请求都会被拒;CLOUD_AUDIO_UPLOAD 在静态层面不可能
- ⚠️ 签名 HAP 生成后需重跑解包核对(SHA 变化)

## 动态留观(真机阶段填写)

- 留观方法:TBD(hilog 过滤 / /proc/net/tcp 采样 / 其他)
- 留观时段与操作清单:TBD(注册/捕获/入库/离线 Journey 全覆盖)
- 观测到的外联(应为零):TBD
- 任何违例发现即违约,停止并如实记录:TBD
- RESULT=TBD(期望:零外联)
