# GOAL-KK-04 R2-final — ALLOWED_PATH_DIFF_RECEIPT

> 2026-09-23 · ED context ED-KK04-FINAL-EVIDENCE-COMPLETION-20260923-A1F7
> 目的：实跑 diff 证明候选相对 preimage 的全部改动、以及本轮（R1 缺陷修复）增量，均落在执行合同允许路径内；禁区零触碰。

## 1. 本轮增量（10d8291..c0171d4 / e548883b..92892d66）——实跑输出

App（`git diff --stat 10d8291 c0171d4`）：

```
 .../entry/src/main/ets/pages/Index.ets             | 70 +++++++++++++++++-----
 1 file changed, 56 insertions(+), 14 deletions(-)
```

Workbench（`git diff --stat e548883b 92892d66`）：

```
 lingxi/scripts/mobile_capture_bridge/isolated.sh |  6 +++++
 lingxi/server/mobile_capture_bridge/pipeline.py  | 26 ++++++++++++++++------
 lingxi/server/mobile_capture_bridge/routes.py    | 15 ++++++++++++-
 tests/mobile_capture_bridge/test_bridge.py       | 28 ++++++++++++++++++++++++
 4 files changed, 67 insertions(+), 8 deletions(-)
```

判定：App 仅 Index.ets；Workbench 仅 isolated.sh / pipeline.py / routes.py / test_bridge.py。**全部在允许路径内，无一越界。**

## 2. 全量（preimage..candidate）——实跑输出

App（`git diff --stat be400447 c0171d4`，13 files，+2105/−853）：改动全部位于 `prototypes/knowme-knowledge-02-voice-speaker-verification/` 内（ets 源码：Index.ets、bridge/LingxiBridgeClient.ets、bridge/SyncController.ets、capture/CaptureCore.ets、capture/CaptureStore.ets、capture/WavWriter.ets、agent/AgentContext.ets（4 行）、voice/VoiceSessionController.ets（4 行）、module.json5、string.json）+ `reports/integration/goal-kk-04/` 工程文档 3 份（CAPABILITY_REUSE_MATRIX / IMPLEMENTATION_PLAN / INTERFACE_CONTRACT）。

Workbench（`git diff --stat 0f559579 92892d66`，12 files，+1745/−4）：`lingxi/server/mobile_capture_bridge/`（__init__.py / plugin.py / routes.py / pipeline.py / store.py）、`lingxi/scripts/mobile_capture_bridge/`（isolated.sh / make_demo_audio.sh / demo_audio/）、`lingxi/server/dsh_acp_client.py`（15 行，DSH 调用参数）、`lingxi/server/lingxi_server.py`（12 行，插件挂载）、`tests/mobile_capture_bridge/test_bridge.py`。

## 3. 禁区核验（逐条）

| 禁区 | 核验方式 | 结果 |
|---|---|---|
| governance/** | 双端 diff 文件清单 grep | 零触碰 |
| AGENTS.md | 同上 | 零触碰 |
| kbctl.py | 同上 | 零触碰 |
| skills/** | 同上 | 零触碰 |
| vendor/** | 同上 | 零触碰 |
| public_gateway.py | 同上 | 零触碰 |
| 生产 /Users/njx/njx-knowledge | 本轮全程未写；仅生产健康检查只读 GET（收尾轮 200） | 零触碰 |
| 生产 8787 服务 | 未重启、未部署、未改配置 | 零触碰 |

## 4. worktree 洁净

`git -C kk04-ed2/app status --porcelain` 与 `git -C kk04-ed2/workbench status --porcelain` 均为空（2026-09-23 实跑）。
