# GOAL-KK-04 R2-final — RUNTIME_RUNBOOK

> 2026-09-23 · 复跑手册：任何人可按本文件在本机重建本轮环境并复现证据。

## 1. 前置

- macOS + DevEco Studio（hdc：`/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc`）
- OpenHarmony 模拟器在线（`hdc list targets` → 127.0.0.1:5555）
- 本机 Python（单测用 `/Users/njx/.workbuddy/binaries/python/envs/default/bin/python`）
- 双 worktree：app @ c0171d4（detached）、workbench @ 92892d66（detached）

## 2. 隔离工作台实例

```bash
WS=/path/to/kk04-ed2
KK04_ROOT="$WS" KK04_PORT=18241 \
  bash "$WS/workbench/lingxi/scripts/mobile_capture_bridge/isolated.sh" start
# init 自动：KB_ROOT=$KK04_ROOT/runtime/kb-root 初始化、插件 v1.0.0 enabled、
# external_send=disabled、前端模板 www/galaxy.html 部署（D-LE2-02 修复后）
# 停止：同一脚本 stop；日志 $KK04_ROOT/runtime/logs/isolated-<port>.log
```

## 3. 设备转发与 App

```bash
hdc rport tcp:18246 tcp:18241        # 设备→主机（注意方向是 rport 不是 fport）
# 构建：prototypes/knowme-knowledge-02-voice-speaker-verification/scripts/build-hap.sh
hdc install entry-default-unsigned.hap
hdc shell "aa start -b com.knowme.knowledge.voiceprototype -a EntryAbility"
# App 内工作台地址填 http://127.0.0.1:18246
```

## 4. 驱动与取证配方

- 截图：`hdc shell "snapshot_display -i 0 -f /data/local/tmp/x.jpeg"`（必须 .jpeg + 显式 `-i 0`）+ `hdc file recv`
- UI 驱动：`uitest dumpLayout -p /data/local/tmp/cur.json` 取坐标 → `uitest uiInput click x y` / `inputText x y <text>`（中文注入可能残留前导 `%`，D-LE3-02 工具瑕疵）
- 浏览器：`hdc shell "aa start -A ohos.want.action.viewData -U <url>"`
- DB 只读：`sqlite3 'file:<KB_ROOT>/lingxi/mobile_capture/mobile_capture.db?mode=ro'`（表 captures/tasks/events）
- 单测：workbench 根 `python -m unittest discover -s tests/mobile_capture_bridge`（13/13 PASS）

## 5. 旅程复现要点

J01 连接/撤销重连；J02 文本主链；J03 演示音频（30s/5min 由 /demo-audio 提供，合成朗读已披露）；J04 断网（`hdc rport --remove` 等效断连）→冷开→恢复补传；J05 插件 disable/enable；J06 幂等连点+同名对；J07 昨日捕获（captured_at 昨日）；J08 r1→现场修正 r2→补充 r3 版本链；J09 当前/历史回执辨识；J10 命令字样文本按纯数据处理；J11 浏览器开 `http://127.0.0.1:18246/` 工作台前端；J12 uninstall+install 全新首屏。

## 6. 收尾

isolated.sh stop（ED 18241 / LE 18242）；生产健康只读检查 `curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8787/api/health` → 200。生产目录与 8787 全程只读，不做任何写操作。
