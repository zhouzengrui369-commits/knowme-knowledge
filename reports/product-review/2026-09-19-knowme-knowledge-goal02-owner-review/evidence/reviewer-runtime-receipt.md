# Reviewer runtime binding receipt

Operator: PX-KK02-OWNER-DIRECT-20260919-HDC. These are reviewer observations, not Engineering PASS.

On 2026-09-19 the existing local working-directory HAP had another hash and was not used. Both preserved artifacts under `/private/tmp/kk02-le-run2/prototypes/knowme-knowledge-02-voice-speaker-verification/entry/build/default/outputs/` were hashed:
- default/entry-default-unsigned.hap: c2971591bc835759924f1e0d6bfa50dbd040861fee805578e20e1d2ca73d03ab
- ohosTest/entry-ohosTest-unsigned.hap: 5d500af654ff45ef95b8f3a285695486a5af4ce33322f3e4987bae900e955792

Reviewer executed hdc install -r with both HAP paths in one command. Tool output returned `install bundle successfully` for each, followed by `AppMod finish`. Reviewer force-stopped and started EntryAbility in com.knowme.knowledge.voiceprototype. Captures 01–02 start the candidate-bound sequence. No build or technical tests executed. Installed bundle metadata was read only for identity.

Four WLAN-on utterances after enrollment yielded UNCERTAIN .480/.541/.606/.506; a WLAN-off utterance yielded NOT_VERIFIED .444. Short no-intentional-speech probes yielded UNCERTAIN. No threshold/state/code edits or fabricated transcripts were used.

Acoustic stimulus was host say with Tingting, rate 170, synthetic phrases such as “这是一段产品审核合成语音。明天下午三点整理读书笔记，所有内容只用于模拟器体验演示。” Three distinct synthetic utterances formed enrollment. Actual acoustic coupling was not calibrated; these do not prove ASR quality or biological identity. Raw audio/embeddings were not collected for publication.

Permission changed via real simulator Settings microphone toggle, then restored. WLAN toggle changed via real Settings, then restored. No host network setting changed. The app-network subpage failed to load; WLAN-off is a bounded observation, not proof of total network isolation.

Screenshots precede layout in early capture calls and may show transition frames; key evidence was repeated in stable states. From 45 onward helper recaptures PNG after layout retrieval. Original early screenshots are not retrospectively corrected. See published selection and records in EVIDENCE.md.

At end: microphone allowed; WLAN enabled; no active recording; synthetic enrollment retained (final delete confirmation pending); no product/tracked source modification. Git working tree was clean at final check.
