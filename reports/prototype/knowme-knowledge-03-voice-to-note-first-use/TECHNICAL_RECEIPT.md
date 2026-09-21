# TECHNICAL RECEIPT — 技术栈与构建

## 头部标识

- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1
- PR = #32（draft, OPEN）
- DATE = 2026-09-22
- ENVIRONMENT = OpenHarmony emulator（kk02phone）, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555

## 构建

- 构建工具：hvigor；结果 **BUILD SUCCESSFUL**（LE run3 回执记录）。
- 构建产物身份：hap sha256 = `11570648fada5a99bbca2f45ed79c4439260fe8185a9ba6515bfafdad8efcab8`。
  - LE run3 与 ED 本人操作使用同一构建产物；ED 操作前 shasum 复核一致。
- 声纹模型 sha256 = `e2d2048292e055f7b61cdec3db010503f35369b245bf0b3bbad021c9a91e4053`。

## 单元测试

- **67 / 67 PASS**（LE run3 回执记录，候选 d02014f 上执行）。
- 候选相对治理前像新增/修改的测试文件（见 ALLOWED_PATH_DIFF_RECEIPT）：
  - 新增 `entry/src/ohosTest/ets/test/NoteFlow.test.ets`（+253 行）
  - 新增断言 `entry/src/ohosTest/ets/test/FixtureTranscript.test.ets`（+21 行）
  - 新增断言 `entry/src/ohosTest/ets/test/VoiceCore.test.ets`（+44 行）
  - 修改 `entry/src/ohosTest/ets/test/List.test.ets`（+2 行）

## 部署

- 方式：`hdc` uninstall + install 干净安装，非覆盖升级。
- 目标：OpenHarmony emulator（kk02phone），OpenHarmony-6.1.1.125，apiversion 24，hdc 127.0.0.1:5555。
- BUNDLE = com.knowme.knowledge.voiceprototype / EntryAbility。

## 运行期架构要点（与证据旅程对应）

- **持久化**：已保存知识与对话上下文以 snapshot v4 持久化于本地；force-stop 冷启后已存知识恢复（ED-18「已从本地恢复 2 条已保存知识与对话上下文(0.1 原型有界本地存储,非生产备份)。」，截图 ed-21；LE-16 截图 25）。未保存草稿不持久化、不复活（ED-19 截图 ed-22/ed-23；LE-17 截图 26/27）。
- **确定性整理器**：「整理成笔记」为确定性整理，非真实 LLM，无 LLM 依赖——草稿编辑器明示「确定性整理(非真实 LLM):只重排你说过的话,不新增内容」（ED-11，截图 ed-12；LE-09/10，截图 13）。
- **声纹验证**：机主声纹为本地档案（3 段采样录入，ED-08 / LE-20）；「本次验证」与长期档案语义分离（ED-07 / LE-02 / LE-19d）。相似度对合成语音在模拟器上波动 0.45~0.82，短句易 UNCERTAIN，信任门按设计诚实拦截（ED 回执非缺陷观察 N2）。
- **转写**：依赖系统 STT；模拟器上间歇报 1002200010（Write audio failed because the start listening is failed），应用如实披露并走 NOT_AVAILABLE 诚实拦截，无云端回退（LE 回执非缺陷观察 1，截图 46；详见 RUNTIME_ERROR.md）。

## 证据来源

- [screenshots/local-execution-run3/LOCAL_EXECUTION_RECEIPT.md](./screenshots/local-execution-run3/LOCAL_EXECUTION_RECEIPT.md)（头部标识、合规声明）
- [screenshots/ed-personal/ED_PERSONAL_OPERATION_RECEIPT.md](./screenshots/ed-personal/ED_PERSONAL_OPERATION_RECEIPT.md)（头部标识、ED-07/08/11/18/19）
