# Local Executor 任务书(GOAL-KK-02 真机阶段 · 待发)

> 本文件是派发给 Local Executor 子代理的完整任务书模板。ED 在 Mate60 连接 + 签名材料就绪后,把 `<...>` 占位替换为实际值,以全新 context 派发。**Local Executor 不得修代码**;发现任何缺陷 → 停止 → 回 ED → 新 SHA → 旧证据作废 → 全量重测。

## 角色与上下文

```text
ROLE=LOCAL_EXECUTOR
CONTEXT_ID=LE-KK-GOAL02-VOICE-SPEAKER-FINAL-<NEW_UNIQUE_ID>
PROVISIONAL_FINAL_SHA=<冻结时的精确 40 位 SHA,当前基线 8ddc7d5,冻结前须重新确认 HEAD>
```

## 执行序列(严格按序)

1. **fresh exact-SHA materialization**:新目录 `git clone` 后 `git checkout <PROVISIONAL_FINAL_SHA>`,`git status` 必须干净;`git rev-parse HEAD` 输出记入 receipt
2. **本机 build**:按 README/Runbook 环境变量构建 signed HAP(签名材料路径由 ED 在派发时告知,材料不进 git)
3. **Mate60 安装**:`hdc list targets` 确认真机 serial;`hdc install -r <signed.hap>`;失败按 Runbook §3 排查并如实记录
4. **实际运行冒烟**:首屏三行状态 + 引擎就绪行
5. **五条 Journey**(逐条截图 P01–P20,编号约定见 `docs/evidence/10-screenshot-index.md`):
   - A 真实麦克风权限(弹窗/拒绝/设置深链/授予/返回刷新)
   - B Owner 注册 + 验证(3 采样 → ENROLLED)
   - C 捕获入库(VERIFIED → 候选 → 确认 → 知识 +1)
   - D 修正确认(修正文本 → 确认入库;消息即时渲染为 D12 回归点)
   - E 离线(飞行模式,程序见 Runbook §4.3)
6. **sample matrix**:模板 `docs/evidence/06-sample-matrix.md`。正≥5(VERIFIED≥4/5)、负≥5(误识 0/5,来源按 Owner 决定标注)、安静 STT≥5(核心语义≥4/5)
7. **offline**:Journey E 数据 + 网络留观 → `07-offline-receipt.md`
8. **screenshots**:命名 P01–P20,全部过隐私净化(Runbook §5.2)
9. **sanitized receipts**:填写 `docs/evidence/` 下 03/05/06/07/08 五份(02 由 ED 填,04 由 ED 本人复跑填,01/09/10 ED 汇总)

## 硬规则

- 不改任何代码/配置;环境故障如实记录,不绕行
- 负样本音频不出本机;截图净化后才入库
- 任何网络外联观测到 = 立即停并记录(CLOUD_AUDIO_UPLOAD=FORBIDDEN)
- 声纹阈值数值如 ED 已在真机标定阶段调整,以 ED 派发时给的 SHA 内数值为准,不现场改

## 交付物回传

- 填好的 5 份 receipt + shots/ 截图目录 + 采样矩阵原始记录 → ED 汇总进 evidence 分支
