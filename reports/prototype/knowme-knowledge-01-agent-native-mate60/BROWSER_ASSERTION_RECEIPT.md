# Browser Assertion Receipt — GOAL-KK-01 PX Findings Correction R1

```text
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
CANDIDATE_SHA=0e859d93960e630965a5b71a3ff4c07e631d8570
VIEWPORT=360x780 MATE60_CLASS_SIMULATION
SUITE_GROWTH=41 (R1) -> 57 (R2) -> 67 (R3) -> 68 (R4) -> 80 (R5) -> 115 (PX1)
LOCAL_EXECUTOR=115/115 (le-assertions.json, sha256 df5c4151fedfb1c898d00b4bbaf9130ff61ae2ebfea8eb8870a5932d81b384c5)
ED_PERSONAL=115/115 (ed-browser-assertions.json, sha256 49af4cfea4652bc4de86de2ed0eab723372a7790f1bb21ab29fbced47ca89000)
FILE_PROTOCOL_HTML=115/115 (deliverable/file-protocol-assertions.json, sha256 91fe0d8fa3dffa5e98a90ca50e20fb0daa8b323461166d8e4960c5ddba0a4260)
CONSOLE_ERRORS=[] PAGE_ERRORS=[] (all three runs)
```

## Assertions added/changed for the PX correction (+35)

KK-PX-R5-01 knowledge semantic consistency:

```text
PX01_CAPTURE_CONFIRM_TOPIC_A / PX01_CAPTURE_CONFIRM_TOPIC_B
PX01_EXACT_TITLE_QUERY_BINDS_OWN_ITEM      ← exact-title query binds own item
PX01_NO_CROSS_TOPIC_LEAKAGE                ← no AOG/ABC template leakage
PX01_HONEST_NO_CONCLUSION                  ← honest note, no fake conclusion
PX01_NATURAL_QUERY_BINDS_OWN_ITEM          ← natural wording binds own item
PX01_NATURAL_QUERY_NO_LEAKAGE
PX01_UNKNOWN_NO_UNRELATED_REFS             ← honest gap, zero unrelated refs
PX01_DETAIL_OWN_CONTENT
PX01_WORK_SURFACE_OWN_CONTENT
PX01_WORK_SURFACE_HONEST_CONCLUSION
PX01_WORK_SURFACE_NO_FABRICATED_CONFLICT   ← 冲突 0 项(无虚构)
PX01_SEED_WORK_SURFACE_OWN_CONCLUSION      ← seed items keep own conclusion
```

KK-PX-R5-02 sensing visibility under overlays (5 surfaces × 3 checks):

```text
PX02_SENSING_VISIBLE_{KNOWLEDGE,KNOWLEDGE_DETAIL,WORK_SURFACE,CALENDAR,TODO}
PX02_PAUSE_REACHABLE_{…}   ← in-sheet pause syncs global strip to off
PX02_RESUME_REACHABLE_{…}  ← in-sheet resume restores on
```

KK-PX-R5-03 correction/confirmation semantics:

```text
CORRECT_SAVE_HINT_VISIBLE          ← predictability before click
CORRECT_SAVE_RETURNS_TO_CANDIDATE  ← model A: save returns to candidate card
CORRECT_SAVE_NO_DIRECT_INGEST      ← count unchanged after 保存修正
PX03_CONFIRMED_NO_PENDING_TAG      ← confirmed items never show 待确认
```

KK-PX-R5-04 return-target label match (both entry paths):

```text
WORK_BACK_LABEL_MATCHES_TARGET_NAV_PATH    ← navigation path lands on Agent conversation
PX04_AGENT_PATH_BACK_MATCHES_LABEL         ← Agent next-action path lands on Agent conversation
```

P3 (authorized local fixes):

```text
PX_P3_POSTPONED_SCHEDULE_TIME_ORDERED      ← 09-18 renders [10:00, 14:00]
```

## Updated pre-existing assertions (semantics corrected, still binding)

```text
CORRECT_WORKS                    ← now passes only via explicit 确认入库 after save
RETURN_PRESERVES_CONTEXT         ← conversation intact on direct Agent return
```

All R1–R5 regression assertions are unchanged and pass.
