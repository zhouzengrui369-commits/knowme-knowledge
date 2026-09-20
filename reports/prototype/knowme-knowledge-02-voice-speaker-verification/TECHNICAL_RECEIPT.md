# TECHNICAL RECEIPT — GOAL-KK-02 Contract R3

## 构建环境

- macOS（本机），DevEco Studio SDK：`DEVECO_SDK_HOME=/Applications/DevEco-Studio.app/Contents/sdk`
- hvigorw（DevEco 自带），buildMode=debug，product=default；unsigned hap（模拟器可装，按仓内脚本既定方式）
- hdc `Ver: 3.2.0d`（`/Users/njx/apps/deveco-tools/command-line-tools/sdk/default/openharmony/toolchains/hdc`）

## 构建与测试命令（LE 于 exact SHA 06b013c 执行）

```bash
cd prototypes/knowme-knowledge-02-voice-speaker-verification
./scripts/provision-models.sh     # 模型已 provision，sha256 校验 OK
./scripts/run-unit-tests.sh       # 构建 main+ohosTest 两 hap → 同命令安装 → aa test
```

## 单元测试结果（设备端 Hypium，final run2）

```text
OHOS_REPORT_RESULT: stream=Tests run: 46, Failure: 0, Error: 0, Pass: 46, Ignore: 0
OHOS_REPORT_CODE: 0
TestFinished-ResultCode: 0
```

测试构成：VoiceCore 14 + FixtureTranscript 10 + AgentContextPersistence 10（含 R3-D20 回归 ×2）+ FixtureDemo 12（含 R3-D21 回归 ×1）。

## 构建历程（defect loop 如实记录）

| 轮次 | SHA | 测试 | 说明 |
|------|-----|------|------|
| 实现 | 2d4e14e 工作区 | 45/45 PASS | R3 实现 + D18/D19/D20 修复后 |
| LE run1 | 2d4e14e | 45/45 PASS | 17/17 旅程 PASS，证据后因 SHA 变更作废 |
| ED run1 | 2d4e14e | — | ED 本人操作中发现 R3-D21 |
| 修复 | 06b013c 工作区 | 46/46 PASS | +D21 回归用例 |
| LE run2（final） | 06b013c | 46/46 PASS | 18/18 旅程 PASS（含 le-18 D21 回归） |
| ED run2（final） | 06b013c（同 LE 构建二进制） | — | 13 项必验 + 条目展开 + 重置回归，全 PASS |

## 产物 sha256（final，LE run2 构建）

- main hap: `bc5f06a65ff9adce4073d84a79355817d11955abc5a897b351d4f0ee83ae0473`
- ohosTest hap: `96ec99345aaa3be748665e8b1784d58c3d1048189653fb0bf9380df1f8d7b757`

## 已知构建注意点

- hvigor 增量构建曾未感知 ohosTest 测试文件改动（10:14 旧 hap 复用导致一度跑出 43/43 旧数）；`hvigorw clean` 全量重建后数字正确。final 两轮均基于 clean 构建。
- 同签名 `hdc install -r` 保留应用数据（ED 探针实证）；跨构建/卸载重装会清数据（平台行为，非产品缺陷），final run 均在安装后再操作。
