# GOAL-KK-04 — 允许路径 diff 核对回执（ALLOWED_PATH_DIFF_RECEIPT）

> GOAL-KK-04 · ALLOWED_PATH_DIFF_RECEIPT · ED context ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E
> Final pair：App `10d829195ebb7f6c4c576b0d116e45087ec2b35a` / Workbench `e548883b1d696b8245631bad129dd3737afcc5b7`
> 日期：2026-09-22

## 1. 结论

对两仓库工程分支相对各自 preimage 的 `git diff --name-status` 实跑逐文件核对：**全部改动落在合同 §7 允许路径内；禁区（governance、AGENTS、.github、kbctl.py、skills/**、vendor/、public_gateway.py、生产知识/secret、8787 生产服务）零触碰**。授权的最小挂载改动仅涉及 lingxi_server.py 与 dsh_acp_client.py 两文件（lingxi_bot.py / lingxi_ai.py 未改）。

## 2. 实跑命令与原始输出

### 2.1 App（knowme-knowledge）

命令：`git -C kk04-ed/app diff --name-status be40044..HEAD`

```
M	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/agent/AgentContext.ets
A	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/bridge/LingxiBridgeClient.ets
A	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/bridge/SyncController.ets
A	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/capture/CaptureCore.ets
A	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/capture/CaptureStore.ets
A	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/capture/WavWriter.ets
M	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/pages/Index.ets
M	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/voice/VoiceSessionController.ets
M	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/module.json5
M	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/resources/base/element/string.json
A	reports/integration/goal-kk-04/CAPABILITY_REUSE_MATRIX.md
A	reports/integration/goal-kk-04/IMPLEMENTATION_PLAN.md
A	reports/integration/goal-kk-04/INTERFACE_CONTRACT.md
```

规模：13 files changed, 2063 insertions(+), 853 deletions(-)。

逐文件核对：

| 文件 | 允许路径判定 |
|---|---|
| prototypes/knowme-knowledge-02-voice-speaker-verification/**（10 个） | ✅ `prototypes/knowme-knowledge-02-voice-speaker-verification/**` 允许 |
| reports/integration/goal-kk-04/**（3 个） | ✅ `reports/integration/goal-kk-04/**` 允许 |

注：module.json5 新增 ohos.permission.INTERNET / GET_NETWORK_INFO 属授权明确允许项。

### 2.2 Workbench（njx-knowledge）

命令：`git -C kk04-ed/workbench diff --name-status 0f55957..HEAD`

```
A	lingxi/plugins/mobile_capture_bridge/demo_audio/.gitignore
A	lingxi/plugins/mobile_capture_bridge/demo_audio/kk04_reading_30s.wav
A	lingxi/scripts/mobile_capture_bridge/isolated.sh
A	lingxi/scripts/mobile_capture_bridge/make_demo_audio.sh
M	lingxi/server/dsh_acp_client.py
M	lingxi/server/lingxi_server.py
A	lingxi/server/mobile_capture_bridge/__init__.py
A	lingxi/server/mobile_capture_bridge/pipeline.py
A	lingxi/server/mobile_capture_bridge/plugin.py
A	lingxi/server/mobile_capture_bridge/routes.py
A	lingxi/server/mobile_capture_bridge/store.py
A	tests/mobile_capture_bridge/test_bridge.py
```

逐文件核对：

| 文件 | 允许路径判定 |
|---|---|
| lingxi/plugins/mobile_capture_bridge/**（2 个） | ✅ 允许 |
| lingxi/scripts/mobile_capture_bridge/**（2 个） | ✅ 允许 |
| lingxi/server/mobile_capture_bridge/**（5 个） | ✅ 允许 |
| tests/mobile_capture_bridge/**（1 个） | ✅ 允许 |
| lingxi/server/lingxi_server.py（M） | ✅ 授权最小挂载改动（纯追加挂载段，+12 行追加块） |
| lingxi/server/dsh_acp_client.py（M） | ✅ 授权最小挂载改动（路径 env 化，默认值逐字不变） |

## 3. 禁区零触碰核验

对两份 diff 输出逐一匹配禁区前缀：`governance/`、`AGENTS*`、`.github/`、`kbctl.py`、`skills/`、`lingxi/vendor/`（vendor 字节仅本机复制到隔离根，不进 Git）、`public_gateway.py`、生产知识目录、secret 文件——**零命中**。两个工程分支的提交序列（App 2 个、Workbench 3 个 commit）亦未触碰禁区（diff 全集即上表）。

## 4. 环境披露

- 核验基于本机隔离 worktree（kk04-ed/app、kk04-ed/workbench），HEAD/tree 与 origin 已推分支一致（见 CANDIDATE_MANIFEST.md §2）。
- 本机 git 直连 GitHub 不通，推送经 `-c http.proxy=http://127.0.0.1:7897`；不影响本地 diff 核验有效性。
- 运行时物料（隔离 KB_ROOT、DSH vendor 字节、5min 演示音频、截图）均不进 Git，不在本 diff 范围，属合同允许的隔离部署行为。
