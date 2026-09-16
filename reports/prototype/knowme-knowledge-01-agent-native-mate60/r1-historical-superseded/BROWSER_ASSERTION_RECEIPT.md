# Browser Assertion Receipt — GOAL-KK-01

```text
ARTIFACT=BROWSER_ASSERTION_RECEIPT
ACTOR_ROLE=ENGINEERING_DELIVERY
CANDIDATE_SHA=fb432162e7dd099a32fec7b52ff00659982942f3
RUNTIME_URL=http://127.0.0.1:5173 (ED) / http://127.0.0.1:5174 (Local Executor)
VIEWPORT=360x780 MATE60_CLASS_SIMULATION
SUITE=prototypes/knowme-knowledge-01-agent-native-mate60/tests/browser_assertions.py
RESULT=41/41 PASSED (ED run) · 41/41 PASSED (Local Executor independent run)
CONSOLE_ERRORS=[] (both runs)
PAGE_ERRORS=[] (both runs)
MACHINE_RECEIPTS=ed-browser-assertions.json · le-assertions.json
```

Required browser assertions (contract §29) and where each is proven:

| Assertion | Result | Proof |
|---|---|---|
| FIRST_VIEW_AGENT_IDENTITY | PASS | header identity + role text visible (ED-P01, LE-P01) |
| ASK_AGENT_WORKS | PASS | real input → deterministic reply (ED-P02, LE-P02) |
| AGENT_RESPONSE_REFERENCES_CONTEXT | PASS | ref chips name current knowledge items |
| NEXT_ACTION_OPENS_CONTEXTUAL_WORK | PASS | next-action opened knowledge detail overlay |
| TEXT_CAPTURE_WORKS | PASS | capture sheet + textarea → candidate |
| CONFIRM_WORKS | PASS | context count 7→8 after direct confirm |
| CORRECT_WORKS | PASS | edited candidate confirmed (「已修正」 in context) |
| REJECT_WORKS | PASS | rejection explained, context count unchanged |
| CONFIRMED_KNOWLEDGE_CHANGES_CONTEXT | PASS | 6→7 条知识, 10→12 条连接 (ED-P04, LE-P04) |
| AGENT_EXPLAINS_CONTEXT_CHANGE | PASS | 「已确认入库…第 7 条已确认知识」 message |
| KNOWLEDGE_ITEM_OPENS | PASS | detail sheet for 供应风险记录 |
| SOURCE_STATE_VISIBLE | PASS | MOCK_SOURCE + CONFIRMED + evidence shown |
| RETURN_PRESERVES_CONTEXT | PASS | conversation intact after work-surface round trip (ED-P07, LE-P07) |
| CAPABILITY_OPENS_CONTEXTUAL_WORK | PASS | calendar mock schedule work surface (ED-P06, LE-P06) |
| PROTOTYPE_STATE_DISCLOSED | PASS | persistent disclosure pill + per-channel/per-capability chips |
| NOT_CONNECTED_NOT_CONNECTED | PASS | calendar/todo labeled NOT_CONNECTED; never CONNECTED |
| NO_HORIZONTAL_BLOCKING_OVERFLOW | PASS | scrollWidth=360 = clientWidth=360 |
| NO_HOVER_ONLY_CRITICAL_ACTION | PASS | all critical controls are BUTTON/INPUT |
| NO_UNCAUGHT_PAGE_ERROR | PASS | page_errors empty in both runs |
| NO_BLOCKING_CONSOLE_ERROR | PASS | console_errors empty in both runs |

Additional coverage beyond the required list: UNKNOWN_TOPIC_ACKNOWLEDGES_GAP,
UNKNOWN_TOPIC_NEXT_ACTION_CAPTURE, VOICE_KEY_HONEST_DISCLOSURE,
STATE_* journey-state transitions (8), CONVERSATION_PRESERVED_UNDER_OVERLAY,
REJECT_DOES_NOT_GROW_CONTEXT, TODO_STATE_CHANGES, SKILLS_PLANNED_DISCLOSED,
CAPTURE_CHANNELS_DISCLOSED.

`TEST_PASS != PRODUCT_WORKS` is acknowledged: this receipt only became
engineering evidence together with the Local Executor's independent real
operation and ED's personal operation of the same exact candidate.
