# KnowMe UI Traceability Matrix — GOAL-KK-01 Prototype (R5)

```text
ARTIFACT=KNOWME_UI_TRACEABILITY_MATRIX
ACTOR_ROLE=ENGINEERING_DELIVERY
ACTOR_CONTEXT_ID=ED-KK-GOAL01-R5-NAVCAL-QUICKACTION-20260916-1610-R5
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
CANDIDATE_SHA=40063afd16a36674e8660f6b4a05315d51f4e546
UI_AUTHORITY=Owner-provided KnowMe-NJX-Demo.html (「这个才是knowme的原型」, 2026-09-16)
UI_AUTHORITY_SHA256=3ef8605a6b74c6514ee7097d24100d5f06e258b2e6bbdb03e591a02a51fc7d9f
UI_AUTHORITY_EVIDENCE_COPY=r3-historical-superseded/r3-ui-authority/KnowMe-NJX-Demo.html (byte-identical)
PRIOR_AUTHORITY=zhouzengrui369-commits/knowme demo @baa61e6… (R1/R2 lineage; superseded by the Owner-provided file)
PROTOTYPE_SOURCE=prototypes/knowme-knowledge-01-agent-native-mate60/
```

The authority Demo was opened and operated read-only in a real browser
(desktop three-column workbench: 神经感知 left / knowledge navigation center
/ 我的下一步 right; brand 灵犀 · Digital Brain; dark tokens). Nothing was
written back. The prototype translates its structure into a Mate60-class
portrait, Agent-first layout.

| Lineage element | KnowMe-NJX-Demo (authority) | Prototype realization | Adaptation |
|---|---|---|---|
| **五维知识地图** | Center-left column: 五维知识地图 with 工作记录·我做了什么 / 生活感悟·我如何感受 / 人生规划·我想走向哪里 / 系统思考·我如何理解 / 行业洞察·我看见什么变化, each with entry count | 知识导航 tab section 五维知识地图: identical five dimensions and subtitles, live-computed counts, expandable to real items | Same dimension model; counts are real (including zero-count dimensions shown honestly, never faked) |
| **九维认知图谱** | Center-right column: 九维认知图谱 01 身份角色 … 09 动态与情景 with counts | 知识导航 tab section 九维认知图谱: identical nine numbered dimensions, live counts, expandable | Same cognitive-dimension model |
| WIKI/MOC navigation | 知识导航 · WIKI MOC header + NOTE/MOC/WIKI knowledge cards | MOC/WIKI/NOTE groups kept below the two maps; kind badges preserved | Coexists with the two maps |
| **日历月/周/日** | Demo organizes by 日记 (9 月 9 日 · 我的知识日记 / 日记回顾); Owner directed explicit three views for the prototype | Calendar capability sheet with 日/周/月 switcher: month grid (correct weekdays, today, event dots, deep-open), full week rows, day schedule + linked todos | Owner-directed extension beyond the Demo; NOT_CONNECTED honesty preserved |
| 神经感知 (sensing) | Left panel 神经感知: 开启语音, 体验感知动效 · 不录音, waveform placeholder, honest "等待你开启语音采集" | Persistent sensing strip (R2): continuous background simulated stream, mic key pause/resume, 模拟感知 · 无真实 ASR | Same honesty standard: the Demo never fakes recording; the prototype never fakes ASR |
| 我的下一步 (next steps) | Right panel: dated plan list (9 月 9 日) with 计划/轨迹/助手 tabs and numbered actions | 待办 capability sheet + calendar 当日关联待办 + todo→calendar deep link | Plan items become operable todos linked to calendar days |
| Agent | Center-bottom 灵犀 AGENT composer (展开对话 / 发送) | Central conversation thread + composer; Agent first and persistent | Desktop bottom composer becomes the mobile main conversation |
| Context field | Header stats (知识 16 · 五维 5 · 九维 9), breadcrumb of knowledge base | ContextStrip: tappable summary (N 条知识 · M 条连接 · 持续生长) + known/unknown chips | Live counts that really change on confirm |
| Capture | Left 附件知识 / 感知 panel with capture drawer | Bottom-sheet Capture: channel cards with honest state chips, pipeline 已采集→AI 整理草稿→确认后入库, candidate 确认/修正/拒绝 | Same confirm-gate semantics |
| Contextual overlay | Center cards open detail flows | Knowledge detail sheet + 上下文工作面 float over the conversation | Conversation DOM never unmounted |
| Visual hierarchy | Dark workbench tokens (deep navy bg, amber accents, mono state labels, rounded cards) | Same token set in `src/styles.css` (--bg/--panel/--amber/--green/--blue/--violet, radius, chips) | Tokens inherited; layout rewritten for portrait |
| Mobile translation | Desktop-only demo (three columns, 1440px design) | Portrait-first 360–520px shell, ≥38px tap targets, no hover dependency, no horizontal overflow (asserted) | The Goal's core product question |

Intentional non-inheritance (contract-compliant): the Demo's 2D 关系 / 3D 星海
graph renderings and Galaxy-style canvas were not ported — they are
desktop-parlor visuals, not required by the frozen contract; Journey/AO
coverage does not depend on them. This is a technical simplification, not a
product-boundary change.
