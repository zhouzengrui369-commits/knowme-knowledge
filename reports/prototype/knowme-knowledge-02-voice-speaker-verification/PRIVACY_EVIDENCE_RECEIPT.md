# PRIVACY EVIDENCE RECEIPT — GOAL-KK-02 Contract R3

## 数据落点（设备实测）

- 应用沙盒（el2）：`/data/app/el2/100/base/com.knowme.knowledge.voiceprototype/haps/entry/files/`
  - `kk02_agent_context.json` — 有界（messages≤30 / knowledge≤100）已确认知识与对话上下文；合成演示内容。
  - `kk02_speaker_profile.json` — 本地声纹档案（注册后存在；重置后删除，le-16/ed2-16 实证）。
  - 声纹模型 onnx — 首次启动从 rawfile 拷贝，只读使用。
- 全部数据留在应用沙盒；无共享存储写入、无云端上传（见 NETWORK_BOUNDARY_RECEIPT）。

## 进入 Git 的内容边界

- 入 Git 的仅有：源码、测试、脚本、本证据包（合成非敏感截图与回执）。
- 未入 Git：raw Owner 音频、声纹 embedding/档案文件、私密转写、模型二进制（.gitignore 运行时资产）、任何凭据。
- 截图内容均为合成演示文本（"ED本人验证条目甲"等），无真实个人数据。

## 权限使用

- 仅声明并使用 MICROPHONE；权限拒绝/撤销全程有诚实 UI 路径（DENIED_MANUAL_FALLBACK_RECEIPT）。
- 注册声纹明示"原型验证,非生产身份认证"；重置仅删声纹、不动知识，且需显式确认（R2-D15）。

## 结论

PRIVACY_BOUNDARY=沙盒本地 + Git 无敏感物。合成内容演示，隐私承诺与实测一致。
