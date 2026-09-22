# CANDIDATE MANIFEST — KnowME Knowledge GOAL-KK-03 Voice-to-Note First-Use

## 头部标识

- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1
- PR = #32（draft, OPEN）
- DATE = 2026-09-22
- ENVIRONMENT = OpenHarmony emulator（kk02phone）, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555

## 候选身份

| 字段 | 值 |
|---|---|
| CANDIDATE_SHA（冻结） | d02014f185595ab9f73c423017842d2d2d268252 |
| TREE | fa5ab666c6df25420cdb619fec55a19a88aa72af |
| PARENT | 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8 |
| BRANCH | engineering/goal-kk-03-voice-to-note-first-use-r1（BRANCH_HEAD = PR_HEAD = SHA，操作前后均已核对） |
| PR | #32（draft, OPEN，head 已核对 = d02014f） |
| 构建产物 hap sha256 | 11570648fada5a99bbca2f45ed79c4439260fe8185a9ba6515bfafdad8efcab8 |
| 声纹模型 sha256 | e2d2048292e055f7b61cdec3db010503f35369b245bf0b3bbad021c9a91e4053 |
| 单元测试 | 67 / 67 PASS |
| BUNDLE | com.knowme.knowledge.voiceprototype / EntryAbility |
| 环境 | OpenHarmony emulator, OpenHarmony-6.1.1.125, apiversion 24 |
| 部署 | uninstall + install 干净安装（hdc），非覆盖升级 |

## 允许改动路径声明

本次候选相对治理前像（42eaaa76748d08e875ed843d8a5543d922219ab4）的全部改动均限定在：

```
prototypes/knowme-knowledge-02-voice-speaker-verification/**
```

逐条核对结果见 [ALLOWED_PATH_DIFF_RECEIPT.md](./ALLOWED_PATH_DIFF_RECEIPT.md)：12 个文件全部在允许路径内，越界改动 = 0。

## 证据双轨

- Local Execution run3：RESULT = PASS，22/22 旅程，DEFECTS_FOUND = NONE，76 张截图。完整回执见 [screenshots/local-execution-run3/LOCAL_EXECUTION_RECEIPT.md](./screenshots/local-execution-run3/LOCAL_EXECUTION_RECEIPT.md)。
- Engineering Delivery 本人操作：RESULT = PASS，21 项操作，DEFECTS_FOUND = NONE，与 LE 同构建身份（hap sha256 一致，操作前 shasum 复核）、独立干净安装、独立截图。完整回执见 [screenshots/ed-personal/ED_PERSONAL_OPERATION_RECEIPT.md](./screenshots/ed-personal/ED_PERSONAL_OPERATION_RECEIPT.md)。

## 说明

- 本证据包存放于独立 evidence 分支 `evidence/goal-kk-03-voice-to-note-first-use-r1`（基点 origin/main），不进入候选分支与 main，符合治理合同「证据与候选分离」要求。
- 全部测试输入为合成数据（`say -v Tingting` 合成语音 + 手工键入的测试文本），未使用任何真实个人数据。
