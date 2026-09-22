# GOAL-KK-03 — Voice-to-Note First-Use Prototype

> 本目录同时保留 GOAL-KK-02(已关闭,candidate `33174690`)的语音捕获/声纹
> 验证能力说明(见下文「GOAL-KK-02 能力基线」)。GOAL-KK-03 在同一原型上
> 叠加首用「语音→笔记」产品闭环。

Frozen contract:
`governance/milestones/GOAL-KK-03-VOICE-TO-NOTE-FIRST-USE-PROTOTYPE/CONTRACT.md`
@ `f38e48956dfcd8820cc090f04026839132508ece` (FROZEN). Activation: Issue #30
comment `5759411988`. Engineering context:
`ED-KK-GOAL03-VOICE-TO-NOTE-FIRST-USE-20260921-1935-D8F4`.

## GOAL-KK-03 value loop (contract-frozen)

clean first view (purpose + recording entry + voice-identity entry, no scroll)
→ start recording → unmistakable RECORDING feedback (red state + ticking
clock) → stop / cancel → honest transcript candidate (never silently saved)
→ correct / reject / explicit 整理成笔记 → editable note draft (title +
editable body; deterministic organizer, no LLM claim) → original transcript
+ source provenance inspectable → explicit save (exactly +1, double-tap
safe) / cancel (+0) → saved note reopenable with title/body/source/original
transcript → survives force-stop / cold reopen (bounded prototype
persistence) → Agent explains what changed, context preserved.

First-use hard rule: TEST_FIXTURE tooling and technical diagnostics are
SECONDARY and collapsed by default; the primary path never requires
engineering knowledge.

Voice identity: 声纹档案(长期状态,未录入/已录入)与本次验证(单次结果)分离
展示;录入/重录/查看入口在首屏可发现。

Defect loop record: D-KK03-01 — simulator STT punctuation-only output(如
「。」)曾被当成有效转写放行候选;修复为 `hasMeaningfulTranscript` 门控
(按无可用转写处理,VERIFIED + BLOCKED_NOT_AVAILABLE,披露式测试转写路径
保持可用),附回归测试。

## GOAL-KK-02 能力基线(保留)

Frozen contract:
`governance/milestones/GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE/CONTRACT.md`
@ `73701b2f3069a0384568977909b601504c9fc591` (FROZEN, GOAL_MILESTONE_CLOSED).
Activation: Issue #13 comment `5715249689`.

## Value loop (contract-frozen)

real Mate60 mic permission/start/stop → local-first Mandarin STT →
enrolled-speaker state (VERIFIED / NOT_VERIFIED / UNCERTAIN / NOT_AVAILABLE)
→ trust gate → transcript candidate → Owner correct / reject / explicit
confirm → knowledge candidate flow → Agent context preserved.

Voice is an attached 灵犀 Agent capture capability, not a standalone recorder
app or developer console.

## Technical approach (Engineering-selected, benchmark-verified on device)

- Platform: HarmonyOS NEXT ArkTS (stage model), compatibleSdkVersion 5.0.0(12),
  built with DevEco SDK HarmonyOS 6.1.1(24) Release.
- Audio capture: AudioCapturer PCM (explicit start/stop/cancel; honest
  permission state machine IDLE / PERMISSION_REQUIRED / PERMISSION_GRANTED /
  PERMISSION_DENIED / RECORDING / STOPPED / UNAVAILABLE).
- Local-first STT: CoreSpeechKit `speechRecognizer`
  (@hms.ai.speechRecognizer, SystemCapability.AI.SpeechRecognizer) in
  offline request mode where the device provisions it; availability probed at
  runtime via `canIUse` — if unavailable the product honestly reports
  NOT_AVAILABLE (no silent cloud fallback, cloud audio upload forbidden).
  sherpa-onnx retained as the evaluated alternative (see Technical Receipt).
- Speaker enrollment/verification: local on-device embedding + cosine
  similarity against the enrolled Owner profile; enrollment create / complete /
  failure / reset; states VERIFIED / NOT_VERIFIED / UNCERTAIN / NOT_AVAILABLE;
  disclosed as PROTOTYPE_VERIFICATION, never production authentication.
- Trust gate: NOT_VERIFIED / UNCERTAIN / NOT_AVAILABLE can never auto-confirm
  or silently ingest knowledge; VERIFIED still requires Owner explicit confirm.

## Build

```bash
scripts/build-hap.sh   # uses DevEco-bundled node/JBR/hvigor/ohpm, outputs entry-default-unsigned.hap
```

Device installation requires Owner-authorized signing (debug certificate)
and an hdc-connected Mate60.

## Privacy boundary

Raw Owner audio, speaker embeddings/voiceprints, private transcripts and
secrets are forbidden in git (see `.gitignore`). Durable evidence is
sanitized aggregates only.
