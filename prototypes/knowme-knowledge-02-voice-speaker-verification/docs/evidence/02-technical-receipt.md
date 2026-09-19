# 02 · Technical Receipt(模板 · 未填写)

> ED 填写。技术决策与实测依据,一条一条来,不许概括。

## 构建与兼容
- 构建命令 / 环境(SDK、hvigor、node 版本):TBD
- compatibleSdkVersion=4.1.0(11) 静态拦截验证:TBD
- useNormalizedOHMUrl=false 依据(spec 限制):已在仓,真机复核 TBD

## 真机关键实测
- CoreSpeechKit STT 可用性(4.2 是否内置离线模型):TBD(可用则附转写示例;不可用则附错误码,诚实链处理)
- sherpa-onnx 原生库 4.2 兼容性:TBD
- 声纹阈值重定标:当前 0.62 仅脚手架默认。真机真人正负样本分布:TBD;最终 VERIFIED / uncertain / REJECTED 三带数值与依据:TBD(规则冻结:uncertain 带必须存在)
- STT init flaky(模拟器约 1/10)真机表现:TBD
- D10 降级卡视觉证据(模拟器 18 次未触发):TBD

## 缺陷登记
D1–D13 修复清单与回归状态:TBD(引用各 commit SHA)

## 已知限制(诚实声明)
- 原型声纹验证 ≠ 生产身份认证
- Agent 为确定性壳,无真实 LLM
- TBD
