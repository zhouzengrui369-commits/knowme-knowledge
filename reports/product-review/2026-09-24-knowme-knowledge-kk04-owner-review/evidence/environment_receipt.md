# ENVIRONMENT_RECEIPT — r3-gap-closure

2026-09-23 ｜ context ED-KK04-ADMISSION-GAP-CLOSURE-20260923-B2C4

## 硬件/系统

- 主机：macOS（Apple Silicon），DevEco Studio SDK（/Applications/DevEco-Studio.app）。
- 设备：OpenHarmony 模拟器（udid 454D5504D4143041524D0EBC8B2BA27804780A4028A571EABB1B400000000000），hdc 127.0.0.1:5555。
- 浏览器：本机 Chromium（Playwright 1.61 驱动，headless）。

## 隔离实例

| 项 | ED | LE |
|---|---|---|
| KK04_ROOT | kk04-ed2 | kk04-ed2/le3 |
| 端口 | 18241（fport 18246） | 18243（rport 18247） |
| KB_ROOT | kk04-ed2/runtime/kb-root（fresh） | le3/runtime/kb-root（fresh） |
| 插件 | mobile_capture_bridge v1.0.0 enabled，external_send=disabled | 同 |
| DB 终态 | captures 14 / tasks 14 全 COMPLETED | captures 13 / tasks 13 全 COMPLETED |

- canonical HAP：a73022244985e93a3f227b967bd771e8070dd562d499d16ddca4a91b8d721549（39,206,998B），双实例安装同一字节文件（CANONICAL_ARTIFACT_RECEIPT）。
- 生产实例 8787 全程未触碰；本轮无公网访问、无真实私人数据、无真实声纹。
- 演示音频：workbench make_demo_audio.sh 现生成（30s / 5min，gitignored 部署物）。

## 已知环境怪相（继承披露，非产品缺陷）

1. 模拟器状态栏时钟慢 ~12h（D-LE3-03）。
2. captured_timezone=America/Chicago 与 captured_at +08:00 偏移不一致（D-LE3-06；region 与时钟配置本身矛盾，App 如实记录设备上报值）。
3. uitest inputText 中文偶发前导 %（工具瑕疵；LE 侧「%J06A」截图可见）。
4. 5min 演示音频需部署时现生成（D-LE3-01，isolated.sh 只部署模板）。
