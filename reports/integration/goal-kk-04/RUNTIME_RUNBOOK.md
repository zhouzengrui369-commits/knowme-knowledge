# GOAL-KK-04 — 运行复现手册（RUNTIME_RUNBOOK）

> GOAL-KK-04 · RUNTIME_RUNBOOK · ED context ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E
> Final pair：App `10d829195ebb7f6c4c576b0d116e45087ec2b35a` / Workbench `e548883b1d696b8245631bad129dd3737afcc5b7`
> 日期：2026-09-22

## 1. 结论

以下步骤在本机（macOS，装有 DevEco SDK 6.1.1 / hdc 3.2.0d / 项目 Python）可把 final pair 从零复现到「模拟器 App ↔ 隔离工作台实例」可实操状态。全程不触碰生产 8787、LaunchAgent、公网网关。

## 2. 物料准备

```
ROOT="$HOME/Project/KnowME knowledge/KnowME knowledge/kk04-ed"
# 两 worktree 已在 final pair：
#   $ROOT/app        @ 10d8291 (engineering/goal-kk-04-lingxi-mobile-capture-bridge-r1)
#   $ROOT/workbench  @ e548883b (engineering/goal-kk-04-mobile-capture-bridge)
git -C "$ROOT/app" status --porcelain        # 应为空
git -C "$ROOT/workbench" status --porcelain  # 应为空
```

项目 Python（含 fastapi 等依赖）：`/Users/njx/.workbuddy/binaries/python/envs/default/bin/python`（isolated.sh 内置）。用系统/其它解释器跑测试会因缺 fastapi 报 ImportError。

## 3. 启动隔离工作台实例（isolated.sh）

脚本：`workbench/lingxi/scripts/mobile_capture_bridge/isolated.sh`，子命令 `init|start|stop|restart|status|log`。

关键环境变量（默认值见脚本头注释）：

| 变量 | 默认 | 说明 |
|---|---|---|
| `KK04_ROOT` | `~/Project/KnowME knowledge/KnowME knowledge/kk04-ed` | 隔离工作根（LE 复验时指到 `kk04-ed/le`） |
| `KK04_KB_ROOT` | `$KK04_ROOT/runtime/kb-root` | 独立数据根 |
| `KK04_PORT` | `18231` | 独立端口（LE 用 18232；**不要用 18787**，被生产 lan_proxy LaunchAgent com.njx.lingxi-lan-proxy 占用） |

```
cd "$ROOT/workbench/lingxi/scripts/mobile_capture_bridge"
./isolated.sh start     # 首次自动 init：建 KB_ROOT 目录树、只读复制 skills/ 与 ASR 脚本、
                        # 从生产机复制 vendor/dsh 字节（不进 Git、不打印凭证）、清空隔离 DSH session
./isolated.sh status    # lsof 核验端口监听
./isolated.sh log       # 跟随日志
```

start 时注入：`LINGXI_KB_ROOT=$KK04_KB_ROOT`、`LINGXI_DIR=$KK04_KB_ROOT/lingxi`、`LINGXI_DSH_HOME=$KK04_KB_ROOT/lingxi/vendor/dsh/runtime/home`、`LINGXI_PORT=$KK04_PORT`（dsh_acp_client.py 的 env 化补丁使这些生效，生产默认值不变）。

健康检查：`curl http://127.0.0.1:$KK04_PORT/api/health`；插件状态：`curl http://127.0.0.1:$KK04_PORT/api/mobile-capture/v1/capabilities`（注册端点除外均需 Bearer 设备凭证）。

## 4. 构建 HAP（build-hap.sh）

```
cd "$ROOT/app/prototypes/knowme-knowledge-02-voice-speaker-verification"
scripts/build-hap.sh    # DevEco SDK /Applications/DevEco-Studio.app，hvigorw assembleHap
# 产物：entry/build/default/outputs/default/entry-default-unsigned.hap
# final pair 实测：BUILD SUCCESSFUL，39,201,171 B，
# sha256 44cd0c0030bd0286e43287ba7367de8ea611a55ba170a62ba7e2d639b63db732（LE R2 记录；
# 复构建字节级不稳定，尺寸一致、哈希可能不同——见 CANDIDATE_MANIFEST §5 披露）
```

## 5. 部署到模拟器（hdc）

```
hdc list targets                          # 应见 127.0.0.1:5555（模拟器在线）
hdc -t 127.0.0.1:5555 uninstall com.example.knowme_voice   # 重置状态用（可选）
hdc -t 127.0.0.1:5555 install entry/build/default/outputs/default/entry-default-unsigned.hap
```

模拟器 UI 自动化技巧（uitest）：inputText 支持中文；DEL=2071 从光标删除不可靠，重置状态用 uninstall+install；截图坐标按原图 1256x2760。

## 6. 网络拓扑：10.0.2.2 直连（关键）

模拟器是 QEMU slirp 网络（设备 eth0=10.0.2.15）。**hdc fport 对模拟器不产生设备侧监听**，因此 App 内工作台地址必须填 `http://10.0.2.2:$KK04_PORT`（10.0.2.2 是 slirp 的主机 127.0.0.1 别名）。uvicorn 无需改绑定（默认 127.0.0.1 即可）。此点于 2026-09-22 17:55 实测确认（此前走 fport 不通）。

## 7. 演示音频生成（J03 用）

模拟器 mic 无声（实测 peak=9/32767），音频链路走 demo-audio HTTP 导入方案：

- 30s 样本已进 Git：`workbench/lingxi/plugins/mobile_capture_bridge/demo_audio/kk04_reading_30s.wav`（32.0s / 1,024,078 B；上传后服务端 sha256 `1e95b1be…` 与源文件逐字节一致）。
- 5min 样本不进 Git，用时现生成：
  ```
  workbench/lingxi/scripts/mobile_capture_bridge/make_demo_audio.sh   # 合成 337.299s / 10,793,598 B，sha256 8dbc7bae…aaf3
  ```
- 服务端经 `GET /api/mobile-capture/v1/demo-audio[/name]`（Bearer 认证 + 防路径穿越）提供下载；App 首屏「导入演示音频 / 导入·昨日捕获 / 导入·5分钟」按钮触发 `bridge.downloadDemoAudio`（ARRAY_BUFFER）入采集箱。

## 8. 一轮最小冒烟（文本主链路）

1. App 首屏填 `http://10.0.2.2:18231` → 注册设备（服务端 devices 表出现 dev_…）。
2. 采集区输入文本 → 本地保存（草稿，服务端 0 行）→「交给灵犀」→ 已接收。
3. 约 40s–6min（真实 organizer，受 E1 后端时段影响）后状态回「已整理(可查看)」→ 查看灵犀结果（note_id 双端一致）与原始来源（capture_id/captured_at/sha256/原文/三时间）。
4. 工作台侧核验：`curl -H "Authorization: Bearer <token>" http://127.0.0.1:18231/api/mobile-capture/v1/captures/<capture_id>` 三时间分离、result_refs 非空。

## 9. 收尾与隔离核验

```
./isolated.sh stop
curl http://127.0.0.1:8787/api/health    # 生产实例应始终 200 且无任何 KK04 数据
```

生产核验贯穿全程：8787 健康、daily 无变化、LaunchAgent/公网网关/腾讯云未动（见 ENVIRONMENT_RECEIPT.md §5）。
