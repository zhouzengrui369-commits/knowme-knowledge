# Research and non-duplication baseline

Source: [ecosystem Issue #40](https://github.com/zhouzengrui369-commits/knowme-ecosystem/issues/40). This matrix preserves intake research; license labels are intake observations, not fresh legal conclusions or approved technical selection. Before reuse, Engineering must verify exact upstream revision, license and dependencies, distribution compatibility and Mate60/HarmonyOS feasibility. AGPL/GPL code is not authorized for copying merely because it is open source.

STUDY_ONLY=YES means architecture/UX study only. DIRECT_REUSE_CANDIDATE=YES means future evaluation, never approved reuse. LICENSE_REVIEW_REQUIRED=YES for every row. DEVICE_SPIKE_REQUIRED=YES means validate proposed transfer/integration on Mate60 in a bounded future Goal before adoption; no device evidence exists now.

| Repository | Research scope | STUDY_ONLY | DIRECT_REUSE_CANDIDATE | LICENSE_REVIEW_REQUIRED | DEVICE_SPIKE_REQUIRED | Intake license note |
| --- | --- | --- | --- | --- | --- | --- |
| siyuan-note/siyuan | ARCHITECTURE_AND_UX_STUDY: blocks, backlinks, editing, clipping | YES | NO | YES | YES | AGPL per intake |
| siyuan-note/siyuan-harmony | HarmonyOS local-first PKM reference | YES | NO | YES | YES | AGPL study default per intake |
| k2-fsa/sherpa-onnx | Offline STT/TTS/VAD and enrolled speaker verification | NO | YES | YES | YES | Apache-2.0 per intake |
| volcengine/OpenViking | ARCHITECTURE_AND_UX_STUDY: context filesystem, hierarchy, memory/wiki, Hooks/MCP | YES | NO | YES | YES | AGPL per intake |
| mem0ai/mem0 | Memory create/update/merge/skip and retrieval policies | NO | YES | YES | YES | Apache-2.0 per intake |
| microsoft/markitdown | Multi-format extraction/normalization contract; phone-native feasibility unproven | NO | YES | YES | YES | MIT per intake |
| alibaba/MNN | Mobile inference / HarmonyOS capability benchmark | NO | YES | YES | YES | Apache-2.0 per intake |
| ggml-org/llama.cpp | Local C/C++ inference; benchmark against MNN | NO | YES | YES | YES | MIT per intake |
| asg017/sqlite-vec | Embedded vector retrieval; HarmonyOS loading/bindings spike | NO | YES | YES | YES | Apache-2.0 per intake |
| logseq/logseq | ARCHITECTURE_AND_UX_STUDY: daily journal, graph, backlinks | YES | NO | YES | YES | AGPL per intake |
| laurent22/joplin | Offline editing, attachments, sync/conflicts, clipping | YES | NO | YES | YES | License not fixed here; verify exact snapshot |
| khoj-ai/khoj | ARCHITECTURE_AND_UX_STUDY: second brain, RAG, agents, schedules | YES | NO | YES | YES | AGPL per intake |
| tasks/tasks | Task/repeat/reminder UX and data model | YES | NO | YES | YES | GPL per intake |
| Etar-Group/Etar-Calendar | Calendar navigation/visual conventions | YES | NO | YES | YES | GPL per intake |

SiYuan, OpenViking, Logseq and Khoj default to ARCHITECTURE_AND_UX_STUDY and LICENSE_REVIEW_REQUIRED. sherpa-onnx, MNN, mem0, sqlite-vec, MarkItDown and llama.cpp are future Engineering evaluation candidates only. No dependency or runtime is selected by this document.

Product-owned adapter, tool registry, context/memory and canonical knowledge boundaries are frozen in PRODUCT_BASELINE.md; study external patterns instead of duplicating an entire stack. Corrected internal UI lineage:

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
```

Metadata correction accepted from Issue #40 comment 5690665232; source assets unchanged. No UI assets copied or implemented.
