# KnowME Knowledge — Product Baseline

```text
PRODUCT_BASELINE_ID=PRODUCT-BASELINE-KNOWME-KNOWLEDGE-20260916-v1
PRODUCT_BASELINE_STATUS=FROZEN_BY_PRODUCT_GOVERNANCE
SOURCE_INTAKE=knowme-ecosystem Issue #40
ENGINEERING_START_AUTHORIZED=NO
```

Source: [intake](https://github.com/zhouzengrui369-commits/knowme-ecosystem/issues/40), [UI metadata correction](https://github.com/zhouzengrui369-commits/knowme-ecosystem/issues/40#issuecomment-5690665232). Frozen on the exact governance commit referenced by the bootstrap PR/receipt; unmerged does not imply merge approval or implementation.

## Product positioning

KnowME Knowledge 是面向 Human Owner 的 Mate60 手机端 Agent-first 个人知识管理系统。用户主要通过语音或自然语言与 Agent 协作，Agent 的记忆、知识上下文和可调用能力持续成长，同时保留对笔记、知识、日程和待办的直接可视化管理能力。目标平台为 HarmonyOS，单 Human Owner，本地优先。

它不是普通笔记 App + AI 聊天框、Obsidian clone、纯云端聊天机器人、单纯 RAG UI、纯日历/待办 App、Codex developer console 或 MiniMax client。

## Required capabilities and journeys

Agent 必须支持语音交互、文本交互、多轮上下文、工具/技能调用，以及记忆、能力和知识持续成长。

Voice：语音录入、本地优先语音转文字、Owner enrolled-speaker identification / verification；非 Owner 声音不得默认写入个人知识。声纹阈值和算法不在基线虚构，必须在后续 bounded Mate60 真机 Goal 验证。

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

Calendar 同时支持 Agent 创建/修改/查询日程，以及可视化日历界面直接管理。Todo 同时支持 Agent 创建/修改/完成/查询待办，以及可视化待办界面直接管理。Knowledge / Calendar / Todo 通过同一个 Agent Context 协作，不得成为三个互不相关的 App。

## Exact KnowMe UI lineage

```text
UI_AUTHORITY_REPOSITORY=zhouzengrui369-commits/knowme
UI_AUTHORITY_COMMIT=baa61e693c4681445b8ef0f34c2113292f68e8c7
UI_AUTHORITY_TREE=3bad5f228b47c8e76ccd4203744e5e40b2f30fe4
UI_AUTHORITY_ROOT=tasks/pm/20260721-knowme-cognitive-surface-demo-r5/
UI_AUTHORITY_APP=tasks/pm/20260721-knowme-cognitive-surface-demo-r5/src/App.jsx
UI_AUTHORITY_APP_BLOB=4523e61d60017d63e99b2a58cff763f1a82d6b49
UI_AUTHORITY_STYLES=tasks/pm/20260721-knowme-cognitive-surface-demo-r5/src/styles.css
UI_AUTHORITY_STYLES_BLOB=9667f012df8e03496395ee176a93ea2db976a697
UI_AUTHORITY_OFFLINE_HTML=tasks/pm/20260721-knowme-cognitive-surface-demo-r5/KnowMe-Demo-Offline.html
UI_AUTHORITY_OFFLINE_HTML_BLOB=2b00d2e158619f5c20380cbf06b90236c33eb55b
CENTER=AGENT_CONVERSATION_AND_CALLABLE_WORK
BACKGROUND=EVOLVING_PERSONAL_KNOWLEDGE_CONTEXT
LEFT=VOICE_FILE_WEB_CAPTURE_AND_IMPORT
RIGHT=KNOWLEDGE_CALENDAR_TODO_SKILLS_AND_CAPABILITIES
ACTIVE_WORK=CONTEXTUAL_WORK_SURFACE_WITH_AGENT_CONTEXT_PRESERVED
DASHBOARD_FIRST=FORBIDDEN
GENERIC_CHAT_WIDGET_ONLY=FORBIDDEN
```

本轮仅记录血统，不复制、修改或实现 UI 文件。纠正保留同一 commit、Demo root、App/CSS/Offline HTML blobs，仅修复继承的无效 tree 元数据；PRODUCT_DIRECTION_CHANGE=NO、UI_DESIGN_CHANGE=NO、SOURCE_ASSET_CHANGE=NO、CHANGE_REQUEST_REQUIRED=NO。历史 KnowMe Healthy #117/#119 不改写。

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

来自 Issue #40 所记录的 KnowMe Healthy HF2 经验：Codex Harness × MiniMax 曾发生真实 structured-output / compatibility 问题。后续 Engineering 必须 fresh 验证本产品 exact provider route，不得把旧 translator 当已知可用实现；不得把 MiniMax API 或 Codex /responses 语义直接绑定普通产品逻辑，不得假设所有 Provider 支持同一种 structured output。必须经过产品自有 Adapter boundary；本轮不实现 Adapter。

边界：HarmonyOS App / KnowMe UI → Agent Experience → Harness Adapter → Model Provider Adapter（local / MiniMax / future）；Product Tool Registry 提供 knowledge/search/calendar/todo/import/daily organizer；Context / Memory Boundary 分离 session memory、owner memory、canonical knowledge、skills；Local Store 保留 raw assets、editable notes、HTML snapshots、provenance、FTS、vectors、wiki/backlinks。禁止无复用评估地从零构建单体知识/AI 全栈。

## Mate60 device capability rule

不得根据纸面硬件规格冻结模型大小、量化等级、推理框架、端侧/云端分工、embedding model 或 ASR model。后续独立 bounded Goal 在真实 Mate60 上测量：cold start、warm start、resident memory、first-token latency、tokens/sec、Chinese instruction quality、tool-call reliability、embedding throughput、10-minute thermal behavior、battery consumption、foreground/background recovery、offline ASR latency、ASR accuracy、noise robustness、speaker-verification false accept/reject proxy、offline indexing throughput。

MNN、llama.cpp、sherpa-onnx 必须真机 benchmark 后再做 Engineering 技术选型。Core Speech Kit、Agent Framework Kit、Intents Kit、MindSpore Lite、Neural Network Runtime、NDK 仅作为 intake 提出的待核验原生集成选项，不替代 Codex Harness 产品边界。

## Security and version horizons

USER_SCALE=<10；EXPOSURE=PERSONAL_LOCAL_FIRST；SECURITY_MODEL=RISK_PROPORTIONAL。优先保护密码、API key、认证 token、姓名/身份、支付/认证、私人知识、私密音视频、健康/私密数据及不可逆操作。尚未存在的单用户 MVP 不引入无关企业级安全工程来阻塞产品价值。

0.1=Prototype；1.0=MVP；2.0=Continuous Evolution。VERSION_HORIZON != GOVERNANCE_MILESTONE。详见 VERSION_HORIZONS.md；本轮不冻结任何 active Goal。改变产品边界、核心旅程、验收、安全级别或关闭条件必须走 Change Request。
