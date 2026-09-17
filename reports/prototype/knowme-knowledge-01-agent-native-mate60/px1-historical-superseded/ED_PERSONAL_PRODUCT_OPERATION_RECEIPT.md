# ED Personal Product Operation Receipt — GOAL-KK-01 PX Findings Correction R1

```text
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
ROLE=ENGINEERING_DELIVERY personal user-perspective operation
CONTEXT_ID=ED-KK-GOAL01-PX-FINDINGS-CORRECTION-R1-20260916-2100-4F8C
OPERATED_CANDIDATE_SHA=0e859d93960e630965a5b71a3ff4c07e631d8570 (post-commit HEAD re-verified)
```

Operation harness: Playwright-driven Chromium at 360x780
MATE60_CLASS_SIMULATION against the dev server (port 5173) — same harness as
all prior rounds. Full scripted journey with 115 hard assertions plus visual
review of 12 screenshots.

## Operated value loops (final exact SHA)

1. **KK-PX-R5-01 two-topic semantic consistency — OPERATED.** Captured and
   confirmed 读书笔记复核 (复利曲线…) and 健身计划 (每周三次…); asked each by
   exact title and by natural wording; opened each detail and work surface.
   Every path rendered the item's own content; captured topics showed the
   honest 没有可模拟的确定性结论 note; 冲突 displayed 0 项(无虚构); no
   AOG/ABC template appeared outside AOG topics; an unknown question
   (火星基地…) produced an honest 已知空白 with zero reference chips.
2. **KK-PX-R5-02 sensing visibility — OPERATED.** Across Knowledge,
   Knowledge Detail, Work Surface, Calendar and Todo: the in-sheet sensing
   bar shows 后台持续感知中 + 模拟·无真实 ASR; 暂停 switches both the in-sheet
   bar and the global strip to paused (感知已暂停, disclosure intact); 恢复
   resumes. Verified in both SENSING=ON and PAUSED states; no overlap, no
   horizontal scroll at 360x780.
3. **KK-PX-R5-03 confirm semantics — OPERATED.** Capture → 修正 → 保存修正
   returns to the candidate card (count unchanged, hint visible) → explicit
   确认入库 ingests (count +1, item tagged 已确认, never 待确认); reject path
   leaves the count unchanged; detail/date navigation consistent.
4. **KK-PX-R5-04 return label match — OPERATED.** Knowledge navigation →
   item → work surface → 返回 Agent 对话 lands directly on the conversation;
   Agent next action → detail → work surface → same landing; earlier
   conversation (including captured topics) fully preserved.
5. **R5 regression — OPERATED.** 五维/九维 maps, knowledge calendar 日/周/月,
   Calendar 日/周/月, Todo→Calendar deep link, schedule/todo quick actions
   (完成/顺延) and 引用对话 with quote cards; postponed schedule stays
   time-ordered (P3); reference replies no longer duplicate dates (P3).

```text
RESULT=115/115 assertions; console_errors=[]; page_errors=[]
SCREENSHOTS=screenshots/ed-personal/PX1-ED-P01..P12 (sha256 table in SCREENSHOT_INDEX.md)
ASSERTION_RECEIPT=ed-browser-assertions.json (sha256 49af4cfea4652bc4de86de2ed0eab723372a7790f1bb21ab29fbced47ca89000)
DEFECTS_FOUND_ON_FINAL_SHA=NONE
UNRESOLVED_WITHIN_CONTRACT=NONE
```
