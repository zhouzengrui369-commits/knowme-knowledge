# KnowME Knowledge — Product Baseline

```text
PRODUCT_BASELINE_ID=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v2
PRODUCT_BASELINE_STATUS=FROZEN_BY_PRODUCT_GOVERNANCE
SUPERSEDES_PRODUCT_BASELINE_ID=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v1
CHANGE_REQUEST=CR-KK-01-OWNER-DIRECTED-R2-R3
SOURCE_INTAKE=knowme-ecosystem Issue #40
```

This successor baseline preserves the original product positioning/runtime boundaries and incorporates explicit Human Owner corrections issued during hands-on prototype review. Historical baseline v1 remains immutable in Git history.

## Product positioning

KnowME Knowledge 是面向 Human Owner 的 Mate60 手机端 Agent-first 个人知识管理系统。用户主要通过语音或自然语言与 Agent 协作，Agent 的记忆、知识上下文和可调用能力持续成长，同时保留对笔记、知识、日程和待办的直接可视化管理能力。目标平台为 HarmonyOS，单 Human Owner，本地优先。

它不是普通笔记 App + AI 聊天框、Obsidian clone、纯云端聊天机器人、单纯 RAG UI、纯日历/待办 App、Codex developer console 或 MiniMax client。

## Required capabilities and journeys

Agent 必须支持语音交互、文本交互、多轮上下文、工具/技能调用，以及记忆、能力和知识持续成长。

Voice product direction：语音录入、本地优先语音转文字、Owner enrolled-speaker identification / verification。正式能力需后续 bounded Goal 在真实 Mate60 上验证。本 0.1 原型 Goal 仅要求持续后台感知的交互语义，以 deterministic mock 呈现，并明确标注无真实 ASR / 声纹；不得将模拟感知伪装成真实监听或真实转写。

Import 路线覆盖 Excel、Word、Markdown、PowerPoint、PDF、Image、Audio、Video、Website。0.1 不要求一次全部真实实现；具体格式通过 bounded Goal 逐步交付。

Offline：无网络仍能查看本地知识、创建笔记、编辑笔记、保存修改、浏览已存在日程/待办。云模型不可用不得导致本地笔记系统不可用。

Knowledge management 采用 Obsidian 类原则：Markdown / block semantic representation、Wiki links、Backlinks、Daily notes、Knowledge graph/context relations、Incremental organization。

冻结的数据链：

```text
RAW_ASSET
→ EXTRACTED_TEXT_AND_STRUCTURE
→ CANONICAL_EDITABLE_NOTE
→ TIMESTAMPED_HTML_SNAPSHOT
→ METADATA_AND_PROVENANCE
→ FULL_TEXT_INDEX
→ VECTOR_EMBEDDING
→ WIKI_BACKLINK_DAILY_INDEX
RAW_ASSET=保留原始证据，不得静默丢弃
CANONICAL_EDITABLE_NOTE=Markdown / block semantic form
HTML=带时间戳的稳定渲染/归档快照
HTML_IS_ONLY_CANONICAL_SOURCE=NO
```

HTML 不得作为唯一可编辑真相源。RAG 要求 local-first index、incremental embedding、incremental re-index、source/provenance traceability。模型生成内容不得无来源覆盖原始知识。

每日知识成长核心旅程：一天的信息持续进入 → Daily Note → Agent 整理 → Owner 可检查 → Wiki 增量更新 → backlinks/index/embedding 增量更新 → 后续 Agent 可重新调用。

## Owner-frozen knowledge navigation semantics

知识必须同时提供：

```text
KNOWLEDGE_NAVIGATION=REQUIRED
KNOWLEDGE_CALENDAR_VIEW=REQUIRED
FIVE_DIMENSION_KNOWLEDGE_MAP=REQUIRED
NINE_DIMENSION_COGNITIVE_GRAPH=REQUIRED
```

五维知识地图：

```text
工作记录=我做了什么
生活感悟=我如何感受
人生规划=我想走向哪里
系统思考=我如何理解
行业洞察=我看见什么变化
```

九维认知图谱：

```text
01 身份角色
02 价值认知
03 能力复用
04 人物关系
05 知识与工具
06 行为与表达
07 目标与项目
08 决策与反馈
09 动态与情景
```

这些结构是 Owner 指定的知识导航语义。原型可以使用 deterministic mock 数据，但维度、计数、展开与零数据状态必须诚实，不得通过虚构真实 Owner 数据营造完整度。

## Calendar / Todo product semantics

Calendar 同时支持 Agent 创建/修改/查询日程，以及可视化日历界面直接管理；Todo 同时支持 Agent 创建/修改/完成/查询待办，以及可视化待办界面直接管理。Knowledge / Calendar / Todo 通过同一个 Agent Context 协作，不得成为三个互不相关的 App。

Owner 冻结可视化日历语义：

```text
CALENDAR_MONTH_VIEW=REQUIRED
CALENDAR_WEEK_VIEW=REQUIRED
CALENDAR_DAY_VIEW=REQUIRED
CALENDAR_TODO_VISUAL_LINKAGE=REQUIRED
```

月/周/日三视图必须能够形成同一时间上下文，并允许 Todo 与对应日期建立可理解的视觉关联。当前 0.1 Goal 允许 deterministic mock；真实系统日历/待办后端仍为后续 Goal。

## Exact KnowMe UI / product-lineage authority

For this product baseline, the Human Owner-provided KnowMe-NJX-Demo is the exact current visual/product lineage authority:

```text
UI_AUTHORITY_REPOSITORY=zhouzengrui369-commits/knowme-knowledge
UI_AUTHORITY_EVIDENCE_COMMIT=15a50071202536af05c51e45e04b738dcc81cbdf
UI_AUTHORITY_EVIDENCE_TREE=a63446138525020ab269c630c6507b6e7be74870
UI_AUTHORITY_PATH=reports/prototype/knowme-knowledge-01-agent-native-mate60/r3-ui-authority/KnowMe-NJX-Demo.html
UI_AUTHORITY_BLOB=097e2c978877f5480a63e9da55acf5fb27e60a43
AUTHORITY_SOURCE=HUMAN_OWNER_PROVIDED
```

The earlier KnowMe repository authority (`baa61e693c4681445b8ef0f34c2113292f68e8c7`) remains a historical lineage reference but is superseded as the exact UI authority for current KnowME Knowledge product work.

Core product grammar remains:

```text
CENTER=AGENT_CONVERSATION_AND_CALLABLE_WORK
BACKGROUND=EVOLVING_PERSONAL_KNOWLEDGE_CONTEXT
CAPTURE=VOICE_FILE_WEB_TEXT_CAPTURE
CAPABILITIES=KNOWLEDGE_CALENDAR_TODO_SKILLS
ACTIVE_WORK=CONTEXTUAL_WORK_SURFACE_WITH_AGENT_CONTEXT_PRESERVED
DASHBOARD_FIRST=FORBIDDEN
GENERIC_CHAT_WIDGET_ONLY=FORBIDDEN
```

## Prototype review transport

For code-blind Product Experience and Human Owner inspection of browser prototypes, a self-contained HTML review artifact is required when localhost/local preview transport is unreliable or unavailable.

```text
SELF_CONTAINED_HTML_REVIEW_ARTIFACT=REQUIRED_FOR_CURRENT_0_1_GOAL
ARTIFACT_MUST_BE_BOUND_TO_EXACT_CANDIDATE_SOURCE=YES
LOCALHOST_URL_ALONE_IS_SUFFICIENT_REVIEW_EVIDENCE=NO
```

The HTML artifact is a review transport artifact, not a separate product candidate and not release authority.

## Runtime architecture boundaries

```text
INITIAL_HARNESS=CODEX_HARNESS
PRODUCT_OWNED_HARNESS_ADAPTER=REQUIRED
HARNESS_REPLACEABLE=YES
INITIAL_CLOUD_PROVIDER=MINIMAX
PRODUCT_OWNED_MODEL_PROVIDER_ADAPTER=REQUIRED
MODEL_PROVIDER_REPLACEABLE=YES
SILENT_PROVIDER_FALLBACK=FORBIDDEN
TOOL_REGISTRY=PRODUCT_OWNED
LOCAL_INFERENCE_PREFERRED=YES
CLOUD_ESCALATION_WHEN_LOCAL_CAPACITY_INSUFFICIENT=EXPLICIT
```

KnowMe Healthy HF2 experience remains relevant: Codex Harness × MiniMax structured-output/provider compatibility must be fresh-verified in its own Goal. No older translator is automatically reusable.

Boundary: HarmonyOS App / KnowMe UI → Agent Experience → Harness Adapter → Model Provider Adapter (local / MiniMax / future); Product Tool Registry provides knowledge/search/calendar/todo/import/daily organizer; Context / Memory Boundary separates session memory, owner memory, canonical knowledge and skills; Local Store retains raw assets, editable notes, HTML snapshots, provenance, FTS, vectors and wiki/backlinks.

## Mate60 device capability rule

Do not freeze model size, quantization, inference framework, local/cloud split, embedding model or ASR model from paper specifications. Later bounded real-device Goals must measure cold/warm start, resident memory, first-token latency, tokens/sec, Chinese instruction/tool-call reliability, embedding throughput, thermal/battery behavior, foreground/background recovery, offline ASR behavior, speaker-verification proxies and offline indexing throughput.

MNN, llama.cpp and sherpa-onnx remain benchmark candidates rather than frozen selections.

## Security and version horizons

```text
USER_SCALE=<10
EXPOSURE=PERSONAL_LOCAL_FIRST
SECURITY_MODEL=RISK_PROPORTIONAL
```

Prioritize secrets, identity/payment/authentication, private knowledge/media/health data and irreversible actions. Unrelated enterprise controls must not block core value validation.

0.1=Prototype; 1.0=MVP; 2.0=Continuous Evolution. VERSION_HORIZON != GOVERNANCE_MILESTONE. One Goal = One Milestone remains mandatory. Material changes to product boundary, core journey, acceptance, evidence ownership, security or closure require Change Request.