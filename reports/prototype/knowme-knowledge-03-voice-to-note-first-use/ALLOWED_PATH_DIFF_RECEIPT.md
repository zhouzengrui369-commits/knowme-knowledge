# ALLOWED PATH DIFF RECEIPT — 允许改动路径核对

## 头部标识

- EXACT_SHA = d02014f185595ab9f73c423017842d2d2d268252
- TREE = fa5ab666c6df25420cdb619fec55a19a88aa72af
- PARENT = 15ff3a8a59fe6c2c0012bbe17b19154ce6adbfb8
- BRANCH = engineering/goal-kk-03-voice-to-note-first-use-r1
- PR = #32（draft, OPEN）
- DATE = 2026-09-22
- ENVIRONMENT = OpenHarmony emulator（kk02phone）, OpenHarmony-6.1.1.125, apiversion 24, hdc 127.0.0.1:5555

## 命令与输出（原样）

命令：

```
git diff --stat 42eaaa76748d08e875ed843d8a5543d922219ab4..d02014f185595ab9f73c423017842d2d2d268252
```

输出（治理前像 42eaaa76 → 冻结候选 d02014f，2026-09-22 在 evidence 分支上实跑）：

```
 prototypes/knowme-knowledge-02-voice-speaker-verification/.gitignore                                     |    4 +
 prototypes/knowme-knowledge-02-voice-speaker-verification/README.md                                      |   43 +-
 prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/agent/AgentContext.ets      |   66 +-
 prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/core/VoiceCore.ets          |   33 +
 prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/note/NoteFlow.ets           |  184 ++++
 prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/pages/Index.ets             | 1121 ++++++++++++--------
 prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/voice/SpeakerVerificationController.ets |    9 +-
 prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/voice/VoiceSessionController.ets  |   66 +-
 prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/test/FixtureTranscript.test.ets   |   21 +
 prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/test/List.test.ets      |    2 +
 prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/test/NoteFlow.test.ets  |  253 +++++
 prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/test/VoiceCore.test.ets |   44 +
 12 files changed, 1396 insertions(+), 450 deletions(-)
```

`git diff --name-status` 输出（同区间）：

```
M	prototypes/knowme-knowledge-02-voice-speaker-verification/.gitignore
M	prototypes/knowme-knowledge-02-voice-speaker-verification/README.md
M	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/agent/AgentContext.ets
M	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/core/VoiceCore.ets
A	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/note/NoteFlow.ets
M	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/pages/Index.ets
M	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/voice/SpeakerVerificationController.ets
M	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/voice/VoiceSessionController.ets
M	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/test/FixtureTranscript.test.ets
M	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/test/List.test.ets
A	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/test/NoteFlow.test.ets
M	prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/test/VoiceCore.test.ets
```

## 逐条核对（允许路径 = `prototypes/knowme-knowledge-02-voice-speaker-verification/**`）

| # | 状态 | 路径 | 在允许路径内 |
|---|---|---|---|
| 1 | M | prototypes/knowme-knowledge-02-voice-speaker-verification/.gitignore | ✅ |
| 2 | M | prototypes/knowme-knowledge-02-voice-speaker-verification/README.md | ✅ |
| 3 | M | prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/agent/AgentContext.ets | ✅ |
| 4 | M | prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/core/VoiceCore.ets | ✅ |
| 5 | A | prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/note/NoteFlow.ets | ✅ |
| 6 | M | prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/pages/Index.ets | ✅ |
| 7 | M | prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/voice/SpeakerVerificationController.ets | ✅ |
| 8 | M | prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/main/ets/voice/VoiceSessionController.ets | ✅ |
| 9 | M | prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/test/FixtureTranscript.test.ets | ✅ |
| 10 | M | prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/test/List.test.ets | ✅ |
| 11 | A | prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/test/NoteFlow.test.ets | ✅ |
| 12 | M | prototypes/knowme-knowledge-02-voice-speaker-verification/entry/src/ohosTest/ets/test/VoiceCore.test.ets | ✅ |

## 核对结论

- 改动文件总数 = 12；越界路径 = 0。
- **结论：全部改动均在允许路径 `prototypes/knowme-knowledge-02-voice-speaker-verification/**` 内，PASS。**
