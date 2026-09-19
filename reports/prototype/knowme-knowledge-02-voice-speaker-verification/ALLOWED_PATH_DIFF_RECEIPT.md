# ALLOWED_PATH_DIFF_RECEIPT — GOAL-KK-02 Contract R2

合同允许改动路径:

```text
prototypes/knowme-knowledge-02-voice-speaker-verification/**
reports/prototype/knowme-knowledge-02-voice-speaker-verification/**
```

## 实测:`git diff --name-only 4b23b82..b02bca6`(R2 代码改动全部)

```text
prototypes/knowme-knowledge-02-voice-speaker-verification/docs/LOCAL-EXECUTOR-BRIEF-R2-SIMULATOR.md
prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/agent/AgentContext.ets
prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/pages/Index.ets
prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/voice/VoiceSessionController.ets
prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/test/FixtureTranscript.test.ets
prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/test/List.test.ets
prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/testrunner/OpenHarmonyTestRunner.ets
prototypes/knowme-knowledge-02-voice-speaker-verification/scripts/kk02_ui.py
prototypes/knowme-knowledge-02-voice-speaker-verification/scripts/run-unit-tests.sh
```

证据归档提交(55371ae / 1c2f257 / 395a6b1)仅触及:

```text
reports/prototype/knowme-knowledge-02-voice-speaker-verification/**
```

## 结论

```text
ALLOWED_PATH_VIOLATIONS=NONE
governance/ 未触碰;.github/ 未触碰;AGENTS.md 未触碰;旧 PR #18 未再接收 R2 commit
```
