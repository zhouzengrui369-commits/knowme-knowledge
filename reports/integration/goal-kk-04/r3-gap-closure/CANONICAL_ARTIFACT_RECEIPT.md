# CANONICAL_ARTIFACT_RECEIPT — r3-gap-closure

context: ED-KK04-ADMISSION-GAP-CLOSURE-20260923-B2C4 ｜ 日期 2026-09-23 ｜ 状态 FINAL

## 身份字段（合同 §14）

```text
APP_SHA=c0171d4fa5a988272afa76cabd42b4b6ddbaea8d
APP_TREE=4c88cf33614e93a1b9dc64be12929cd64dd019e7
WORKBENCH_SHA=92892d66d059211113379b7e49d7f034b7ec921c
WORKBENCH_TREE=b527133111112abea4831fa6b4be2c251e7927be
HAP_FILENAME=entry-default-unsigned.hap
HAP_SIZE=39206998
CANONICAL_HAP_SHA256=a73022244985e93a3f227b967bd771e8070dd562d499d16ddca4a91b8d721549
BUILD_COMMAND=scripts/build-hap.sh（hvigorw --mode module -p product=default -p buildMode=debug assembleHap --no-daemon；工程 prototypes/knowme-knowledge-02-voice-speaker-verification）
BUILD_STARTED_AT=2026-09-23T13:09+08:00（c0171d4 源码唯一一次真实构建）
BUILD_FINISHED_AT=2026-09-23T13:09+08:00（同上，BUILD SUCCESSFUL）
ED_PREINSTALL_SHA256=a73022244985e93a3f227b967bd771e8070dd562d499d16ddca4a91b8d721549
LE_RECEIVED_SHA256=a73022244985e93a3f227b967bd771e8070dd562d499d16ddca4a91b8d721549
LE_PREINSTALL_SHA256=a73022244985e93a3f227b967bd771e8070dd562d499d16ddca4a91b8d721549
ED_FINAL_PREINSTALL_SHA256=a73022244985e93a3f227b967bd771e8070dd562d499d16ddca4a91b8d721549
ALL_EQUAL=YES
```

## 过程实录（如实）

- c0171d4 源码仅有过一次真实构建：2026-09-23 13:09（BUILD SUCCESSFUL），产物即本 canonical 文件。
- 18:45:27–18:45:44 做过一次验证性增量重跑（canonical/BUILD_STARTED_AT.txt / BUILD_FINISHED_AT.txt 记录的是这一次）：hvigor 增量无操作（no-op，1.5s 级 BUILD SUCCESSFUL），产物字节不变——证明构建可复现且 canonical 字节未被改写。
- canonical 文件冻结于 `$WS/canonical/entry-default-unsigned.hap`，置只读；本轮全程（LE 实例 18243、ED 实例 18241）安装的都是这一个文件。
- ED_PREINSTALL：2026-09-23 20:46 uninstall + install canonical 文件成功，安装前 shasum 复核 = canonical。
- LE_PREINSTALL：LE_RECEIPT.md §环境身份记录 = canonical（39,206,998 字节逐字一致）。
- 最终 Candidate Manifest 唯一 MAIN_HAP_SHA256=a7302224…；本包不含任何其他复构建 hash 作为 runtime identity。

## 历史观察区（非 runtime identity）

- 前轮（R2-final）构建产物 hash 随源码 10d8291→c0171d4 已失效，仅留 r2-final 包内历史，不在本轮引用。
