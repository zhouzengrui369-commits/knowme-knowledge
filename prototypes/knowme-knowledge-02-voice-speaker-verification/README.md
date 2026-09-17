# GOAL-KK-02 — Voice Capture + Enrolled-Speaker Verification Prototype

Frozen contract:
`governance/milestones/GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE/CONTRACT.md`
@ `73701b2f3069a0384568977909b601504c9fc591` (FROZEN). Activation: Issue #13
comment `5715249689`. Engineering context:
`ED-KK-GOAL02-VOICE-SPEAKER-PROTOTYPE-R1-20260917-A7C4`.

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
