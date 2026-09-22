# GOAL-KK-04 — 候选清单（CANDIDATE_MANIFEST）

> GOAL-KK-04 · CANDIDATE_MANIFEST · ED context ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E
> Final pair：App knowme-knowledge `engineering/goal-kk-04-lingxi-mobile-capture-bridge-r1` @ `10d829195ebb7f6c4c576b0d116e45087ec2b35a` / Workbench njx-knowledge `engineering/goal-kk-04-mobile-capture-bridge` @ `e548883b1d696b8245631bad129dd3737afcc5b7`
> 日期：2026-09-22

## 1. 结论

双候选（App + Workbench）已在同一 exact pair 上完成 ED 实操、observation-only LE 两轮实操（R1 发现缺陷、R2 复验通过）与 ED 本人 same-pair 复核。两 worktree HEAD/tree 经本文件起草时重新实跑核验，逐字段一致、status 干净。本清单绑定两端候选身份、构建产物身份与全部物料。

## 2. Final pair（当前有效候选）

| 端 | 仓库 | 工程分支 | commit | tree | parent |
|---|---|---|---|---|---|
| App | zhouzengrui369-commits/knowme-knowledge | engineering/goal-kk-04-lingxi-mobile-capture-bridge-r1 | `10d829195ebb7f6c4c576b0d116e45087ec2b35a` | `2f669b599d9a9e05fe10b9708d69a7716fb2accb` | `fef1b0714c548f7a4d83ac873e2453de24501c5e` |
| Workbench | zhouzengrui369-commits/njx-knowledge | engineering/goal-kk-04-mobile-capture-bridge | `e548883b1d696b8245631bad129dd3737afcc5b7` | `bcfeb544bfc16cbe63fdca2e250c4df9e85feed3` | `6e27ada8cb575a64537e3f1b463ae0856312422c` |

核验命令（2026-09-22 实跑于本机 worktree）：

```
git -C kk04-ed/app rev-parse HEAD          → 10d829195ebb7f6c4c576b0d116e45087ec2b35a
git -C kk04-ed/app rev-parse 'HEAD^{tree}' → 2f669b599d9a9e05fe10b9708d69a7716fb2accb
git -C kk04-ed/workbench rev-parse HEAD          → e548883b1d696b8245631bad129dd3737afcc5b7
git -C kk04-ed/workbench rev-parse 'HEAD^{tree}' → bcfeb544bfc16cbe63fdca2e250c4df9e85feed3
```

两分支均已推 origin；两端 worktree `git status --porcelain` 为空（干净）。

### 2.1 各端提交序列

- App（`be40044..HEAD`）：
  - `fef1b07` feat(mobile-capture): KK04 mobile capture app — capture box, durable queue, sync, demo audio import
  - `10d8291` fix(mobile-capture): D-KK04-04 import buttons stuck disabled + D-KK04-05 organize retry
- Workbench（`0f55957..HEAD`）：
  - `3ae92969` feat(mobile-capture-bridge): workbench plugin — device auth, durable receive, ASR/organize pipeline
  - `6e27ada8` feat(mobile-capture-bridge): demo-audio endpoints + 30s sample for emulator J03 chain
  - `e548883b` fix(mobile-capture-bridge): D-KK04-05 retry endpoint + honor auto_organize=false

## 3. Preimage 绑定（冻结合同身份）

- App preimage：`be400447c1d68062d22ae5e9ea0d169d929514df` / tree `48b4f641c5ba6a9bdcbf899dba79c27160666dac`（branch governance/lingxi-mobile-capture-v3-20260922）
- Workbench preimage：`0f559579978bd3c0d552f0827326d7a4c971fafd` / tree `1bcca08b8e70737c102c422d9347b00dfb386f15`（branch governance/lingxi-mobile-capture-kk04-20260922）
- 合同：CONTRACT.md blob `19c950767a799d4c04712820f643cb46ab9e0077`；ENGINEERING_EXECUTION_CONTRACT.md blob `15d75345004ffefb53ed0799b89a963e463c49a9`
- 参与授权：njx-knowledge@0f55957:governance/mobile-capture/GOAL_KK04_PARTICIPATION.md blob `619fa4f239b3036c88c5bc8852844904dc0bb8f7`
- 治理 PR（open draft，unmerged）：App #36（base governance/lingxi-mobile-capture-v3-20260922）、Workbench #7（base governance/lingxi-mobile-capture-kk04-20260922）

## 4. 失效历史 pair（仅追加失效说明，不改写）

- App `fef1b07` / Workbench `6e27ada8`：2026-09-22 19:15 曾冻结为 provisional final；LE R1 在其上完成首轮实操后发现 D-KK04-04/D-KK04-05/E2，ED 修复后候选 SHA 改变。按合同 §8，该 pair 的 final 实操证据自 2026-09-22 21:05 起失效，仅作历史记录；LE R2 与 ED same-pair 复核均在新 pair 10d8291/e548883b 上进行。

## 5. 构建产物身份（HAP）

| 项 | 值 |
|---|---|
| 文件 | entry/build/default/outputs/default/entry-default-unsigned.hap（App prototype knowme-knowledge-02-voice-speaker-verification） |
| 大小 | 39,201,171 B |
| sha256（LE R2 实测，final pair 首次构建） | `44cd0c0030bd0286e43287ba7367de8ea611a55ba170a62ba7e2d639b63db732` |
| 构建命令 | `prototypes/knowme-knowledge-02-voice-speaker-verification/scripts/build-hap.sh`（DevEco SDK /Applications/DevEco-Studio.app，hvigorw assembleHap），构建结果 BUILD SUCCESSFUL |

如实披露：本证据包起草时对 worktree 内现存 HAP 重新 `shasum -a 256` 得 `801f9c0e9a60414e76c6513477170c8037ed807c88906fa8a22bc021debf4465b`（尺寸同为 39,201,171 B）。该文件时间戳 2026-09-22 20:56，为同一代码的复构建产物；HAP 为 zip 容器，复构建字节级不稳定，故哈希与 LE R2 记录不同、尺寸完全一致。以 LE R2 记录的 `44cd0c00…` 为 final 实操时部署到模拟器的实际构建哈希。失效 R1 pair 的 HAP：39,196,961 B，sha256 `2d292a9897a6a603547f1a100de36bf7bf69d629e84ee0df2e1d782685540b56`（历史）。

## 6. 工作台侧回归

`python -m unittest discover -s tests/mobile_capture_bridge`（项目 Python `/Users/njx/.workbuddy/binaries/python/envs/default/bin/python`）：**12 用例全过**（本证据包起草时复跑：Ran 12 tests, OK, 2.6s）。注意：用无 fastapi 的解释器跑会 ImportError，须用上述项目环境。

## 7. 物料清单

### 7.1 Workbench（njx-knowledge，全部在允许路径）

- 插件本体 `lingxi/server/mobile_capture_bridge/`：`__init__.py`、`plugin.py`（插件对象/启停/manifest）、`store.py`（SQLite 四表 devices/captures/tasks/events，WAL，token 只存 sha256）、`pipeline.py`（接收→校验→落盘→MLX ASR→今日接收主源→organizer→COMPLETED）、`routes.py`（APIRouter 全部端点）
- 演示音频 `lingxi/plugins/mobile_capture_bridge/demo_audio/`：`kk04_reading_30s.wav`（32.0s / 1,024,078 B，进 Git）+ `.gitignore`（5min 样本不进 Git，用时现生成）
- 脚本 `lingxi/scripts/mobile_capture_bridge/`：`isolated.sh`（隔离实例 init/start/stop/restart/status/log）、`make_demo_audio.sh`
- 测试 `tests/mobile_capture_bridge/test_bridge.py`（12 用例）
- 最小挂载改动：`lingxi/server/lingxi_server.py`（纯追加插件挂载段）、`lingxi/server/dsh_acp_client.py`（路径 env 化，默认值逐字不变）

### 7.2 App（knowme-knowledge，prototype 路径内）

- 新增 `entry/src/main/ets/capture/`：`CaptureCore.ets`（纯逻辑状态机）、`CaptureStore.ets`（沙箱持久化）、`WavWriter.ets`（PCM→WAV 16k/mono/s16le）
- 新增 `entry/src/main/ets/bridge/`：`LingxiBridgeClient.ets`（HTTP 客户端）、`SyncController.ets`（队列/补传调度）
- 修改：`pages/Index.ets`（首屏三区）、`agent/AgentContext.ets`（KK04 引导文案）、`voice/VoiceSessionController.ets`、`module.json5`（新增 INTERNET/GET_NETWORK_INFO 权限）、`resources/base/element/string.json`
- 证据：`reports/integration/goal-kk-04/`（设计三件套 + 本证据包）

### 7.3 运行时物料（不进 Git，隔离环境）

- 隔离数据根：ED `kk04-ed/runtime/kb-root`（端口 18231）、LE `kk04-ed/le/runtime/kb-root`（端口 18232）
- DSH vendor 字节：从生产机 `/Users/njx/njx-knowledge/lingxi/vendor/dsh` 复制到隔离根（vendor 被 gitignore；凭证不打印不提交）
- skills/ 与 ASR 脚本：只读复制进隔离根；DSH session 独立（不复制生产会话）
- 5min 演示音频：337.299s / 10,793,598 B，sha256 `8dbc7bae…aaf3`（`make_demo_audio.sh` 现生成，gitignore）

## 8. 运行时依赖身份（实测）

- 工作台服务：FastAPI + uvicorn，`lingxi/server/lingxi_server.py`（约 10k 行），端口 env `LINGXI_PORT`
- ASR：mlx-whisper（`mlx-community/whisper-small-mlx`，GPU 常驻），回退 openai-whisper；ffmpeg 转 16k 单声道
- 整理：`skills/instant-note-organizer-v4`（SKILL.md + ino_render.py / ino_gate.py）
- DSH：ACP v1 per-call spawn；模型 pin `tencent-tokenhub / deepseek/deepseek-flash`
- App 工具链：HarmonyOS ArkTS，compatibleSdkVersion 4.1.0(11)，DevEco SDK 6.1.1，hvigor 构建，hdc 3.2.0d 部署，模拟器 127.0.0.1:5555
- 协议：lingxi-mobile-capture-bridge v1.0.0，BASE_PATH=/api/mobile-capture/v1（见 INTERFACE_CONTRACT.md）

## 9. 环境披露（详见 ENVIRONMENT_RECEIPT.md）

- 全部实操在 HarmonyOS 模拟器（QEMU slirp，App 直连 `http://10.0.2.2:<port>`）与本机隔离工作台实例上进行；真机、生产、公网未验证。
- 模拟器 mic 无声（peak=9/32767），J03 音频走 demo-audio HTTP 导入方案；模拟器状态栏时钟异常、Intl 报 America/Chicago（region 怪癖，Date 时间戳 +08:00 正确）——证据中如实标注。
- 生产 8787 全程只读核验健康、无污染；隔离端口 18231/18232（18787 被生产 lan_proxy 占用弃用）。
