# GOAL-KK-04 r3-gap-closure — 候选清单（CANDIDATE_MANIFEST）

> GOAL-KK-04 · CANDIDATE_MANIFEST · r3-gap-closure · ED context ED-KK04-ADMISSION-GAP-CLOSURE-20260923-B2C4
> Final pair：App knowme-knowledge PR #37（Draft OPEN）HEAD `c0171d4fa5a988272afa76cabd42b4b6ddbaea8d` / Workbench njx-knowledge PR #8（Draft OPEN）HEAD `92892d66d059211113379b7e49d7f034b7ec921c`
> 日期：2026-09-23 ｜ 本清单 supersede r2-final 同名文件（旧文件不删不改）

## 1. 结论

双候选在**同一 exact pair + 同一 canonical HAP 字节**上完成：fresh LE child（agent-3）J01–J12 全旅程 13/13 COMPLETED，ED 本人核心套件 14/14 COMPLETED（含 J06a/J06b/J11 双要件双侧实证），PX-KK03-01/02/03 无回退，合同内缺陷零。两 worktree HEAD/tree 于本文件起草时重新实跑核验一致、`git status --porcelain` 为空。BRANCH_HEAD=PR_HEAD=YES。

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

两端 worktree `git status --porcelain` 均为空（WORKTREE_CLEAN=YES）。

## 3. Preimage 绑定（冻结合同身份）

- App preimage：`be400447c1d68062d22ae5e9ea0d169d929514df` / tree `48b4f641c5ba6a9bdcbf899dba79c27160666dac`
- Workbench preimage：`0f559579978bd3c0d552f0827326d7a4c971fafd` / tree `1bcca08b8e70737c102c422d9347b00dfb386f15`
- 产品合同：CONTRACT.md blob `19c950767a799d4c04712820f643cb46ab9e0077`
- 执行合同：ENGINEERING_EXECUTION_CONTRACT.md blob `15d75345004ffefb53ed0799b89a963e463c49a9`
- 本轮（Admission Gap Closure）执行合同：Issue #35 comment **5791881544**（落盘 kk04-ed2/governance/issue35-comment-5791881544.md）；本轮 BLOCK 裁定 **5791626362**；被 supersede 的旧 terminal **5790730168**
- ED skill：chatgpt-engineering-delivery @ `8bcf9da5…`（kk04-ed2/governance/ed-commit.json）

## 4. 失效历史 pair（仅追加失效说明，不改写）

- 本轮 R3 零源码改动：pair 不变。c0171d4/92892d66 继续为唯一有效候选。
- App `10d8291` / Workbench `e548883b`：R1 缺陷循环前的 pair，失效（详见 r2-final 包 §4）。
- 更早失效 pair：App `fef1b07` / Workbench `6e27ada8`。

## 5. 构建产物身份（HAP）—— GAP-C 关闭

**MAIN_HAP_SHA256=a73022244985e93a3f227b967bd771e8070dd562d499d16ddca4a91b8d721549**

| 项 | 值 |
|---|---|
| 文件 | entry-default-unsigned.hap（39,206,998 B；冻结副本 kk04-ed2/canonical/，只读） |
| 构建 | 2026-09-23 13:09 于 c0171d4 唯一一次真实构建（BUILD SUCCESSFUL）；18:45 验证性增量重跑 no-op，字节不变 |
| 构建命令 | `prototypes/knowme-knowledge-02-voice-speaker-verification/scripts/build-hap.sh`（hvigorw assembleHap） |
| 部署 | LE（18243）与 ED（18241）均安装此同一文件：ED_PREINSTALL=LE_RECEIVED=LE_PREINSTALL=ED_FINAL_PREINSTALL=a7302224…（ALL_EQUAL=YES，详见 CANONICAL_ARTIFACT_RECEIPT.md） |

GAP-C 说明：上轮（r2-final）LE/ED 各自复构建、双 hash（a7302224 / eef7cabb）并行，被 5791626362 BLOCK；本轮起冻结单一 canonical 字节，任何复构建 hash 只放历史观察区。历史观察：r2-final §5 的 eef7cabb…（LE R2 复构建）自本轮起不作 runtime identity。

## 6. 关键物料身份

- 插件：mobile_capture_bridge v1.0.0（enabled，external_send=disabled）
- 协议：/api/mobile-capture/v1（INTERFACE_CONTRACT）
- DSH：dsh_acp_client（TokenHub DeepSeek-V4.1-Flash）；ASR：mlx-whisper/small；organizer：instant-note-organizer-v4（schema v4.0）
- 单测：workbench tests/mobile_capture_bridge 13/13 PASS（候选 92892d66 上实跑）
