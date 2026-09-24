# RUNTIME_RUNBOOK — r3-gap-closure

2026-09-23 ｜ context ED-KK04-ADMISSION-GAP-CLOSURE-20260923-B2C4 ｜ 复跑手册：任何人可按本文件在本机重建本轮环境并复现证据。

## 1. 前置

- macOS（Apple Silicon）+ DevEco Studio（hdc：`/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc`）
- OpenHarmony 模拟器在线（`hdc list targets` → 127.0.0.1:5555）
- 双 worktree：app @ c0171d4fa5a988272afa76cabd42b4b6ddbaea8d（detached）、workbench @ 92892d66d059211113379b7e49d7f034b7ec921c（detached），porcelain 均为空
- canonical HAP：sha256 `a73022244985e93a3f227b967bd771e8070dd562d499d16ddca4a91b8d721549`，39,206,998B（构建命令：`scripts/build-hap.sh`，即 hvigorw --mode module -p product=default -p buildMode=debug assembleHap --no-daemon）

## 2. 隔离工作台实例（本轮双实例）

```bash
WS=/path/to/kk04-ed2
# ED 实例
KK04_ROOT="$WS/ed-runtime" KK04_PORT=18241 \
  bash "$WS/workbench/lingxi/scripts/mobile_capture_bridge/isolated.sh" start
# LE 实例
KK04_ROOT="$WS/le-runtime" KK04_PORT=18243 \
  bash "$WS/workbench/lingxi/scripts/mobile_capture_bridge/isolated.sh" start
# init 自动：KB_ROOT 独立初始化、插件 v1.0.0 enabled、external_send=disabled、前端模板部署
# 停止：同一脚本 stop；日志 $KK04_ROOT/runtime/logs/isolated-<port>.log
```

## 3. 设备转发与 App

```bash
hdc rport tcp:18246 tcp:18241        # ED：设备→主机（注意方向是 rport）
hdc rport tcp:18247 tcp:18243        # LE
hdc install entry-default-unsigned.hap
hdc shell "aa start -b com.knowme.knowledge.voiceprototype -a EntryAbility"
# App 内工作台地址：ED 填 http://127.0.0.1:18246，LE 填 http://127.0.0.1:18247
```

## 4. 驱动与取证配方

- 截图：`hdc shell "snapshot_display -i 0 -f /data/local/tmp/x.jpeg"`（必须 .jpeg + 显式 `-i 0`）+ `hdc file recv`
- UI 驱动：`uitest dumpLayout -p /data/local/tmp/cur.json` 取坐标 → `uitest uiInput click x y` / `inputText x y <text>`（中文注入可能残留前导 `%`，工具瑕疵已披露）
- 浏览器：`hdc shell "aa start -A ohos.want.action.viewData -U <url>"`
- J11 Workbench UI：Playwright 驱动本机真实浏览器访问 `http://127.0.0.1:18241/`（ED）/ `:18243/`（LE），完成 add/search/preview/conversation（本轮双侧均为真实 UI 路径，非 API 等价）
- DB 只读：`sqlite3 'file:<KB_ROOT>/lingxi/mobile_capture/mobile_capture.db?mode=ro'`（表 captures/tasks/events）
- 单测：workbench 根 `python -m unittest discover -s tests/mobile_capture_bridge`（13/13 PASS）

## 5. 旅程复现要点

J01 连接/撤销重连；J02 文本主链；J03 演示音频（/demo-audio 提供，合成朗读已披露）；**J04 断网：本轮实测 `hdc rport --remove` 在本机失败（「ruler is not exist」，OBS-ED3-01），等效断连改用 `isolated.sh stop <port>` 停服法**——冷开→恢复（start）补传链路实证一致；J05 插件 disable/enable；J06 幂等连点+同名同分钟双 ID；J07 昨日捕获（captured_at 昨日）；J08 r1→修正 r2→补充 r3 版本链；J09 当前/历史回执辨识；J10 命令字样文本按纯数据处理；J11 浏览器工作台前端真实 UI；J12 uninstall+install 全新首屏。

## 6. 收尾

isolated.sh stop（ED 18241 / LE 18243）；`hdc fport ls`/`rport` 转发项清理（或保留无妨，重启模拟器自动失效）；生产健康只读检查 `curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8787/api/health` → 200。生产目录与 8787 全程只读，不做任何写操作。
