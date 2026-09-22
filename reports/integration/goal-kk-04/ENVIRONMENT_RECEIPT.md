# GOAL-KK-04 — 环境回执（ENVIRONMENT_RECEIPT）

> GOAL-KK-04 · ENVIRONMENT_RECEIPT · ED context ED-KK04-LINGXI-CAPTURE-20260922-R1-8B6E
> Final pair：App `10d829195ebb7f6c4c576b0d116e45087ec2b35a` / Workbench `e548883b1d696b8245631bad129dd3737afcc5b7`
> 日期：2026-09-22

## 1. 结论

全部实操在 HarmonyOS 模拟器 + 本机隔离工作台实例上完成。模拟器与隔离部署存在若干已知怪癖与限制，均不影响合同结论的证据效力，逐项如实披露如下。生产环境（8787）全程只读核验健康、零污染。

## 2. 模拟器环境（QEMU）

| 项 | 事实 | 影响与处置 |
|---|---|---|
| 网络 | QEMU slirp，设备 eth0=10.0.2.15；hdc fport 对模拟器不产生设备侧监听 | App 直连 `http://10.0.2.2:<port>`（主机 127.0.0.1 的 slirp 别名）；uvicorn 无需改绑定。2026-09-22 17:55 实测确认，已写入 RUNBOOK |
| 麦克风 | mic 无声（实测 peak=9/32767）；沙箱/公共存储 shell 均无写权限，hdc push 音频文件方案不可行 | J03 改用 demo-audio HTTP 导入：工作台 `GET /demo-audio[/name]`（认证+防穿越）serve `lingxi/plugins/mobile_capture_bridge/demo_audio/`，App 三按钮下载入箱。ASR 仍是工作台真实 MLX Whisper；合同 J03 允许合成朗读 |
| 状态栏时钟 | J04–J08 期间 App 状态栏时钟显示异常（06:xx） | Date API 与时间戳（+08:00）均正确；仅状态栏渲染异常，截图证据中如实披露，不影响时间字段证据 |
| Intl 时区 | 设备 Intl 报 `America/Chicago`，但 shell date 与主机一致为 +08:00 | 模拟器 region 设置怪癖；时间偏移以 +08:00 为准，`captured_timezone` 字段按实际携带，证据（J07）如实披露 |
| 截图规格 | 原图 1256x2760 | uitest 坐标按此计算 |

## 3. DSH vendor 字节复用

- `lingxi/vendor/dsh` 被 gitignore，worktree 中不存在；隔离部署由 isolated.sh 从生产机 `/Users/njx/njx-knowledge/lingxi/vendor/dsh` **复制字节**到隔离 KB_ROOT（含模型/凭证配置），不进 Git、不打印凭证。
- 隔离环境使用独立 DSH home/session：`LINGXI_DSH_HOME` env 指向隔离根，`dsh_sessions.json` 在 init 时清空，不复制生产会话。该能力依赖 dsh_acp_client.py 的授权最小补丁（硬编码路径 env 化，默认值逐字不变）。

## 4. 端口冲突史

- 最初规划隔离端口 18787（IMPLEMENTATION_PLAN 拓扑节仍留有该早期数字，属历史笔迹）；实测 **18787 被生产 lan_proxy（LaunchAgent com.njx.lingxi-lan-proxy）占用** → ED 实例改用 **18231**（KK04_ROOT=kk04-ed/runtime/kb-root），LE 实例用 **18232**（KK04_ROOT=kk04-ed/le/runtime/kb-root）。生产端口与服务未动。

## 5. 生产隔离核验

- 生产 8787（lingxi.sh LaunchAgent）：全程未重启、未修改；多轮实操开始/结束时 `curl /api/health` 均 200。
- 生产 daily / 知识库：冒烟及 J01–J12 期间核验无 KK04 数据写入、无变化；J11 回归确认隔离实例（18231/18232）检索/预览/会话正常且生产无污染。
- 隔离实例 `external_send=disabled`：全流程无企业微信外发（cap_smoke001 冒烟起即核验）。
- 凭证：DSH/TokenHub 凭证由本机安全注入隔离 DSH home，不进 Git、不打印、不提交。

## 6. 未验证项（如实）

真机安装与真实麦克风采集、生产环境部署、公网入口、多模态、完整索引——均不在本 Goal 验证范围。E1（DSH/TokenHub 时段性 600s 超时）为环境性风险，统计与处置见 DEFECT_CYCLE.md。
