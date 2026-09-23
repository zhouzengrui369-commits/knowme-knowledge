# GOAL-KK-04 R2-final — 候选清单（CANDIDATE_MANIFEST）

> GOAL-KK-04 · CANDIDATE_MANIFEST · R2-final · ED context ED-KK04-FINAL-EVIDENCE-COMPLETION-20260923-A1F7
> Final pair：App knowme-knowledge PR #37（Draft OPEN）HEAD `c0171d4fa5a988272afa76cabd42b4b6ddbaea8d` / Workbench njx-knowledge PR #8（Draft OPEN）HEAD `92892d66d059211113379b7e49d7f034b7ec921c`
> 日期：2026-09-23

## 1. 结论

双候选（App + Workbench）已在同一 exact pair 上完成：observation-only LE 两轮实操（R1 发现 5 缺陷+E1，R2 全旅程 PASS 9/9 COMPLETED）与 ED 本人 same-pair 独立实操套件（11/11 COMPLETED，23 张截图）。两 worktree HEAD/tree 经本文件起草时重新实跑核验，逐字段一致、`git status --porcelain` 为空。BRANCH_HEAD=PR_HEAD=YES。

## 2. Final pair（当前有效候选）

| 端 | 仓库 | PR | commit | tree | parent |
|---|---|---|---|---|---|
| App | zhouzengrui369-commits/knowme-knowledge | #37 Draft OPEN | `c0171d4fa5a988272afa76cabd42b4b6ddbaea8d` | `4c88cf33614e93a1b9dc64be12929cd64dd019e7` | `10d829195ebb7f6c4c576b0d116e45087ec2b35a` |
| Workbench | zhouzengrui369-commits/njx-knowledge | #8 Draft OPEN | `92892d66d059211113379b7e49d7f034b7ec921c` | `b527133111112abea4831fa6b4be2c251e7927be` | `e548883b1d696b8245631bad129dd3737afcc5b7` |

核验命令（2026-09-23 实跑于本机 detached worktree）：

```
git -C kk04-ed2/app rev-parse HEAD            → c0171d4fa5a988272afa76cabd42b4b6ddbaea8d
git -C kk04-ed2/app rev-parse 'HEAD^{tree}'   → 4c88cf33614e93a1b9dc64be12929cd64dd019e7
git -C kk04-ed2/workbench rev-parse HEAD          → 92892d66d059211113379b7e49d7f034b7ec921c
git -C kk04-ed2/workbench rev-parse 'HEAD^{tree}' → b527133111112abea4831fa6b4be2c251e7927be
```

两端 worktree `git status --porcelain` 均为空（WORKTREE_CLEAN=YES）。LE R2 回执载有其环境下的逐字核对一致记录（LOCAL_EXECUTION_RECEIPT §环境身份）。

### 2.1 本轮（R1 缺陷修复）提交序列

- App（`10d8291..c0171d4`，1 commit）：
  - `c0171d4` fix(mobile-capture): correction+provenance available once RECEIVED (D-LE2-04), in-place disconnected submit feedback (D-LE2-01), correction-mode target banner (D-LE2-05), layered revision chain in provenance view (J08)
- Workbench（`e548883b..92892d66`，1 commit）：
  - `92892d66` fix(mobile-capture-bridge): serialize organize behind lock (E1 LOCKED_SKIP watchdog timeouts) + layered revisions in get_capture (D-LE2-04) + isolated frontend template deploy (D-LE2-02)

## 3. Preimage 绑定（冻结合同身份）

- App preimage：`be400447c1d68062d22ae5e9ea0d169d929514df` / tree `48b4f641c5ba6a9bdcbf899dba79c27160666dac`（branch governance/lingxi-mobile-capture-v3-20260922）
- Workbench preimage：`0f559579978bd3c0d552f0827326d7a4c971fafd` / tree `1bcca08b8e70737c102c422d9347b00dfb386f15`（branch governance/lingxi-mobile-capture-kk04-20260922）
- 产品合同：CONTRACT.md blob `19c950767a799d4c04712820f643cb46ab9e0077`
- 执行合同：ENGINEERING_EXECUTION_CONTRACT.md blob `15d75345004ffefb53ed0799b89a963e463c49a9`（落盘 kk04-ed2/governance/FROZEN_EXECUTION_CONTRACT.md）
- 重入轮执行合同：Issue #35 comment 5788458660（落盘 kk04-ed2/governance/issue35-comment-5788458660.md）；BLOCK 裁定 5787784606；reconciliation 5788276405
- ED skill：chatgpt-engineering-delivery @ `8bcf9da5…`（kk04-ed2/governance/ed-commit.json）

## 4. 失效历史 pair（仅追加失效说明，不改写）

- App `10d829195ebb7f6c4c576b0d116e45087ec2b35a` / Workbench `e548883b1d696b8245631bad129dd3737afcc5b7`：2026-09-22 证据包（上级目录，已 SUPERSEDED）的 final pair。重入轮 LE R1 在同代码 fresh 环境实操时发现 D-LE2-01/02/04/05 与 E1；修复后候选 SHA 改变。按合同 §8，该 pair 的 final 实操证据自 2026-09-23 起失效，仅作缺陷循环历史；LE R2 与 ED 本人套件均在新 pair c0171d4/92892d66 上进行。
- 更早失效 pair：App `fef1b07` / Workbench `6e27ada8`（见旧包 CANDIDATE_MANIFEST §4）。

## 5. 构建产物身份（HAP）

| 项 | 值 |
|---|---|
| 文件 | entry/build/default/outputs/default/entry-default-unsigned.hap（prototype knowme-knowledge-02-voice-speaker-verification） |
| 大小 | 39,206,998 B |
| sha256（ED 从 c0171d4 构建，ED 套件实际部署） | `a73022244985e93a3f227b967bd771e8070dd562d499d16ddca4a91b8d721549` |
| sha256（LE R2 复构建实测，LE 实操实际部署） | `eef7cabb0f4c50ee52690d91e4b2cc6e746c0b0e5a0c7827db743f077289022b` |
| 构建命令 | `prototypes/knowme-knowledge-02-voice-speaker-verification/scripts/build-hap.sh`（hvigorw assembleHap，BUILD SUCCESSFUL） |

如实披露：HAP 为 zip 容器，复构建字节级不稳定（同源码两次构建哈希不同、尺寸完全一致 39,206,998 B）。两套实操各自使用自己构建的 HAP，源码均为 c0171d4。

## 6. 关键物料身份

- 插件：mobile_capture_bridge v1.0.0（enabled，external_send=disabled）
- 协议：/api/mobile-capture/v1（INTERFACE_CONTRACT）
- DSH：dsh_acp_client（TokenHub DeepSeek-V4.1-Flash）；ASR：mlx-whisper/small；organizer：instant-note-organizer-v4（schema v4.0）
- 单测：workbench tests/mobile_capture_bridge 13/13 PASS（候选 92892d66 上实跑）
