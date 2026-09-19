# PRIVACY_EVIDENCE_RECEIPT — GOAL-KK-02 Contract R2

## 声纹档案

```text
存储:应用沙箱 /data/app/el2/100/base/com.knowme.knowledge.voiceprototype/haps/entry/files/kk02_speaker_profile.json
内容:嵌入向量(浮点数组)+ 采样数 + 创建时间 + 引擎标识;不存原始音频,不存 PCM。
持久化/加载:D2 修复后 TextDecoder 安全读写;重启/重装(-r)存续实证。
重置:resetEnrollment() 删除内存 + 磁盘档案;hdc ls 实证文件消失(ED 复核 ed-16b)。
界面披露:「原型声纹验证 ≠ 生产身份认证 · 全程本地 · 无云端上传」常驻。
```

## 音频数据

```text
PCM 仅存在于录音会话内存,stopSession 后即弃;不写盘、不上传(NETWORK_BOUNDARY_RECEIPT)。
转写文本:仅当用户显式「确认入库」才进入知识条目;丢弃/拦截路径不落库(旅程 8/12/14 实证)。
```

## 知识条目

```text
内存态存储(0.1 原型);fixture 来源条目带 fixture 标记与披露文案,永不伪装为真实识别。
```

## 权限

```text
仅 MICROPHONE(使用时);拒绝路径:Agent 消息 + 系统设置引导,无静默重试、无功能绑架。
```

## 结论

```text
PRIVACY_BOUNDARY=PASS:语音/声纹/知识全程本地沙箱,用户显式确认是唯一入库通道。
```
