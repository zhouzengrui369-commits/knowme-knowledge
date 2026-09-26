# UI_TRACEABILITY_MATRIX — GOAL-KK-04 R3 界面血统映射

```text
STATUS=STEP_1_DESIGN_BASELINE
SOURCE_OF_TRUTH_UI=prototypes/knowme-knowledge-01-agent-native-mate60（React/Vite 蓝本，只读）
TARGET=apps/lingxi-mobile-android（Kotlin + Jetpack Compose 新建）
DATE=2026-09-26
```

新 App 界面血统来自 01 原型；旧 HarmonyOS HAP 原型 02 不继承（路线已撤销）。
「血统关系」列说明 01 原型的什么内容被继承、改造或否决。

## 1. 信息架构

| R3 冻结要求（R2 §2 / R3 §1.2） | 01 原型对应 | 新 App（Compose）落位 | 血统关系 |
|---|---|---|---|
| 四目的地：灵犀/记录/知识/我的 | BottomNav + Sheet 体系（单页 + 多个 Sheet） | Navigation bar 四 tab，各自为独立 destination | 架构改造：Sheet 层改正式导航；保留单手底部可达 |
| 首页以 Agent 协作与录入入口为中心 | App 主屏：Header + ContextStrip + Message 流 + Composer + SensingStrip | 「灵犀」tab：会话流 + 输入区（语音/文字/附件）+ 当前任务卡 | 继承对话式主屏与录入核心位置 |
| 状态分项展示（本机/网络/身份/服务/模型/工具） | StateChip（单 chip 枚举 AVAILABLE/NOT_CONNECTED/PLANNED/PROTOTYPE_ONLY） | 状态条：六项独立指示，点开同步详情 | 纠正：单 chip 聚合是 R1 审核 PX-01 病灶之一，改为分项实测状态 |
| 记录：录音控制/质量警告/可编辑转写/原音保留/仅本地或交给灵犀 | CaptureSheet（采集候选→确认→修正） | 「记录」tab + RecordingSheet（FGS 控制条） | 继承候选-确认流；新增质量检测与录音控制条 |
| 知识：在线全量检索 / 离线已下载范围 / 正文默认渲染 / 来源两步可达 | KnowledgeSheet + DimensionMap + KnowledgeDetail + WorkSurface | 「知识」tab + 详情页；YAML/路径/内部 manifest 默认不展示 | 继承知识地图交互；正文渲染纠正 PX-06 |
| 我的：账户/工作区/服务器/设备/模型配置/数据去向/缓存同步/退出恢复 | 无（原型未覆盖） | 「我的」tab，高级诊断收此 | 新建，补合同要求 |

## 2. 组件级映射（01 原型 15 个组件逐一处置）

| 01 原型组件 | 处置 | 新 App 落位 | 说明 |
|---|---|---|---|
| Header | 改造 | 各 tab 顶部栏 | 品牌「灵犀」保留；`prototype-disclosure` 仅未登录演示模式出现 |
| ContextStrip | 继承 | 灵犀 tab 顶部 | 「当前知识上下文」保留，数据源改为真实工作副本统计 |
| Message | 继承 | 会话流消息项 | Agent/Draft/Reference 三类气泡保留 |
| SensingStrip | 否决 | — | 「感知中」采集暗示与 R3「不常听、用户主动开始」原则冲突 |
| Composer | 继承 | 灵犀 tab 底部输入区 | 语音键改真实录音入口（非原型模拟） |
| BottomNav | 改造 | Compose NavigationBar | 四目的地正式化 |
| Sheet | 改造 | 各功能页/Dialog | 不再用单页 Sheet 堆叠 |
| CaptureSheet | 继承+改造 | 记录 tab 的采集确认流 | 修正流程骨架保留，接真实存储/同步 |
| DimensionMap | 继承 | 知识 tab 的可折叠维度图 | 5 维/9 维地图交互保留，数据真实化 |
| KnowledgeSheet | 改造 | 知识 tab 列表 | 真实知识副本 + 缓存范围/时间标注 |
| KnowledgeDetail | 继承+改造 | 知识详情页 | 正文默认渲染；来源两步可达（合同硬要求） |
| WorkSurface | 改造 | 任务工作面 | 接真实 task 状态机与执行端标注 |
| CapabilitySheet | 改造 | 灵犀 tab 能力卡/我的-能力目录 | 能力目录声明 execute_side/可用性（真实实测） |
| App（状态机） | 改造 | Compose state holders | 交互状态机思路保留，实现换 ViewModel+StateFlow |
| fixtures.js（合成数据） | 否决 | — | 正式列表禁止混入静态示例；仅未登录演示模式可用且明确标注 |

## 3. 已知设计债（来自 R1 审核，新 App 预防）

| 审核发现 | 新设计预防 |
|---|---|
| 诊断/工程信息占首屏（PX-06） | 诊断统一收进「我的 → 高级诊断」；首屏不渲染 schema/路径/哈希 |
| 状态滞后/假在线（PX-01） | 所有状态指示由实测 store 驱动；无"记忆中的已连接" |
| 卡片静态假数据（PX-03） | 列表必须有真实 repo 数据源；绑定失败的骨架屏不得像结果卡片 |
| 按钮截断（PX-06/J12） | 主按钮文案 ≤6 字，Compose `BasicText` 不测省略号验证；走查截图存档 |

## 4. 设计走查截图（本步骤产物）

Compose 界面骨架完成后，按以下六屏截图存入 `shots/design-walkthrough/`：
首屏（灵犀）、账户绑定/配对、录音（进行中+转写中）、知识详情（正文+来源入口）、三态展示（离线/Mac 离线/全在线各一）、我的（账户与数据去向）。

状态：骨架未开始，待 SDK 就绪（如实记录，不冒充已完成）。
