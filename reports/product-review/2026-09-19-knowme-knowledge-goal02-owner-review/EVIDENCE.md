# Evidence Index

All screenshots originate from reviewer screen captures. Published PNGs are losslessly re-encoded with verified identical RGBA pixels; originals remain local. Raw and published hashes are in screenshot-encoding.json. Only the selected PNG files listed below are published; original layout JSON bytes are represented losslessly as parsed objects with per-file raw SHA256 in `evidence/layout-records.jsonl.gz`. Early PNGs can be transition frames; the report identifies those limitations. Initial pre-existing screenshot 00 is excluded. No raw audio, biometric template or private Owner content is published.

Host timestamps from operation-log.jsonl govern ordering; simulator status-bar time is 12 hours behind.

## Published screenshots

| Screenshot | Host capture timestamp | SHA256 |
|---|---|---|
| [02-cold-home](evidence/published/02-cold-home.png) | 2026-09-19T20:46:57.992835+08:00 | `ac296e827613be14c48421495715203af6bdbbb8723a834d1e1d06ed3640e7fc` |
| [04-unenrolled-stop](evidence/published/04-unenrolled-stop.png) | 2026-09-19T20:47:43.245359+08:00 | `15b6841a855e8859286590debe930cf332e59effc59f8b607b46226c8efb644a` |
| [15-voice-start](evidence/published/15-voice-start.png) | 2026-09-19T20:50:46.727816+08:00 | `4e02e9dfe1b4a7ed29de39f480e03bdf7847bb60307e74ef168978ae9dbe8d3a` |
| [26-reset-dialog](evidence/published/26-reset-dialog.png) | 2026-09-19T20:53:45.576070+08:00 | `bddae335f7bb09be12b13452f01dbee209514a387f4696b0eb30e3dcf7f72ea1` |
| [44-cold-recovery](evidence/published/44-cold-recovery.png) | 2026-09-19T20:58:02.519216+08:00 | `c39c43a2a5a4a9da8f43e2c64217c561c5594cd9ed9e2e53580152c82615fa79` |
| [46-stable-uncertain](evidence/published/46-stable-uncertain.png) | 2026-09-19T20:59:12.399861+08:00 | `df4095bd4198d1f7a85641505181aa55256dd9725dbfae3b4c461ecda3b9d418` |
| [49-proof-saved-stable](evidence/published/49-proof-saved-stable.png) | 2026-09-19T20:59:30.541956+08:00 | `9f27fd9bbf18836043bc27a645e86cc9e853e84cbd07efcf2b6fa41e738dd527` |
| [52-wlan-off](evidence/published/52-wlan-off.png) | 2026-09-19T21:00:38.145601+08:00 | `9916e80ada35ff70ba908699f9665b6d1f162725695c1672a02d762be9550fed` |
| [55-offline-stop](evidence/published/55-offline-stop.png) | 2026-09-19T21:01:22.630055+08:00 | `31ac0fa199866fa1d1f75312f5baf46a2d7eb8adef9f4a70907ab83cdd98ca92` |
| [58-offline-saved](evidence/published/58-offline-saved.png) | 2026-09-19T21:02:29.228860+08:00 | `d50899e75c54e1c28c9d07d6bee6190de7840b1bb27dab5329b2907f5757b37e` |
| [60-wlan-restored](evidence/published/60-wlan-restored.png) | 2026-09-19T21:02:45.014584+08:00 | `d7a3de4460f2116f34bb5a60edecd8dfdd4785f9615d6757d6ca74ac59393e55` |
| [66-denied-recovery-view](evidence/published/66-denied-recovery-view.png) | 2026-09-19T21:03:28.157258+08:00 | `9d618ea0150b6062b524b9d9fe906b2a221dcabe389273dc13503d4c33c49557` |
| [69-final-restored](evidence/published/69-final-restored.png) | 2026-09-19T21:03:54.511456+08:00 | `0e9e927bcc6e86dc4232d835c61e282a2c476a0764918caef15a211cb29b9658` |

## Original layout sequence

| Record in layout-records.jsonl.gz | Raw JSON SHA256 |
|---|---|
| 01-bound-start.json | `e6024362e0d5f445de31674e8edfdd03fe1c567b7dd3506bdf421ac682d64659` |
| 02-cold-home.json | `6edba66b6cae5a6e7f395ddb827f5a74050df701275adc0112f3be0cc775f421` |
| 03-unenrolled-record.json | `5e9220b71864db024f5842a4f24b560d7de2c24a67b60ebf0e20977b7da57862` |
| 04-unenrolled-stop.json | `96fd67d7cf2774646c3126f12361e99bf3b3539506c37036c8e94df7ac2a9ee7` |
| 05-manual-input.json | `0a848a23f9d2580eb3f5a5aab805084fe678315371814d0d7f7c49701c11d0bc` |
| 06-manual-record.json | `f11f892043d942f07484d811c66fe36adc7e48ebf5905f55db45ca88fd2492f9` |
| 07-enroll-start.json | `12f7dea511ebfd87f7529e0d0d64231bc2faac3b7ff8994f055db0bcfbc246c6` |
| 08-enroll-cancel.json | `86936de297cea782974f55fecc262af22af05d5a2b4053fd17e1cc568e3a14de` |
| 09-enroll-sample1-start.json | `ad0ea4c026b143f17948e21b48dfb94604c742567ed3537624cf8b6cab81e83f` |
| 10-enroll-sample1-stop.json | `eec348c25121575216ea003e8252cf36ec4faf5e64c41df1f1caa68624ce56c6` |
| 11-enroll-sample2-start.json | `28728259cfb3745473bd5a5cc21c5797a83732376ad830560c2a1c357357cebd` |
| 12-enroll-sample2-stop.json | `64126f817a972d3db08b07943cda03956789c71e4d6397551344702da1c68e56` |
| 13-enroll-sample3-start.json | `3ea64a91a9b8f902863afbdd44f56e7b9641bf1fcf1c006b23cefba4896e2563` |
| 14-enroll-complete.json | `2711c18b0042b497c7c672f3eeb67b7d153a2c218d4c9907c0e868c2805ed098` |
| 15-voice-start.json | `824f5d1049006cc2a37d787747da951deef0151c52541a1538fb781864d02b61` |
| 16-voice-stop.json | `c58ad71509963ff104ae5767750dff6ce173ad5919881e939ea45f794e5c2398` |
| 17-retry-start.json | `8d09afa2343c5e88ed41366a38f002eb1bbf0373e21358378e5e583bf755358f` |
| 18-retry-stop.json | `71364d68b1f1f55fd0598edc8c2caf2bc4cebb36e5fcc669dd842f14493e30e0` |
| 19-retry2-start.json | `021e559b31870fd6a9370547310affd56e2f572871beb14d9eba287a13000fc6` |
| 20-retry2-stop.json | `d4f2a00490c73f2e9c60dad633cf79266e380bf8beb1f49cbb50a53f67a0992f` |
| 21-discard.json | `968bc2f8e47e55a32219eda659132a6ba3b0a46d9af3c8f11e8a90ec0d1de870` |
| 22-home.json | `019c78aadab37a3cfa3d14144ce5a08e520b1f7cae84b569ce532e762e17dba5` |
| 23-return.json | `d4bbbb680872763219746d550fcfa56a4de3bc18021ba0a1743239ddfef9efa5` |
| 24-return-record.json | `8353bad578f2ac50e307f11a156690ec4cd33d38d762899d0da8ea61b92ff34e` |
| 25-return-stop.json | `827b5f8df6c4918f17510bcba8b2e58e82fd1b01843847693ba0e7984dc052db` |
| 26-reset-dialog.json | `dea498ae493eccc268b5ba98f2f98188fad90d19496727a71e38616831cc1eee` |
| 27-reset-cancel.json | `ee9d67516244674ebfa2f9f92e1142b329df5bd44339c4554f861248c3f07756` |
| 28-settings.json | `affbfe662ccad0018332698987a40d8874a62da0c4426c4c2ec27495573cd72d` |
| 29-app-settings.json | `61e2aeffcb5389ea24a3b5cc6087c43a039ab0d58e9c53bc7f9aba8eb7ea93c3` |
| 30-app-info.json | `57cbd6acf74362e2c685a03edcd6a5ca782e982bd97f2cbbfe5fbb62a0cf78d3` |
| 31-mic-permission.json | `34fe7bc2ff160bae2ddbc5638715120aac19f918457a956b93f52cec4ace4abb` |
| 32-mic-off.json | `4a057b29a12ed062c6fff011068ca5e9803f88e6701b6821155c0cebe70a46e2` |
| 33-denied-return.json | `d3c591a999691995b47edd36484c8ea301c54000322e2864baee4a78e7260d5b` |
| 34-request-permission.json | `502f13501e002a92399d7e25a601bc2f84541ffc443e2ba1af34b125769821a1` |
| 35-mic-restored.json | `a5ac239f7eea6b8e76f4122b03cbc8580b2c604d85f12e1ef34506d4c9047a1e` |
| 36-granted-return.json | `5a49f3af38f525bedccb0c6f3dd108d2423293cc9b9d44ce566cf9669d486c7e` |
| 37-network-settings.json | `cf2b8f94813f14964feb0f8ec823ebdd201164b460e0ecb17844c87117b35abc` |
| 38-network-dismiss.json | `da4624ce7d61ede50332ce68d58c56f5ccd41f0313d8b4711a58fa15bd9d6fc0` |
| 39-return-before-final-capture.json | `5a49f3af38f525bedccb0c6f3dd108d2423293cc9b9d44ce566cf9669d486c7e` |
| 40-silence-start.json | `2e2836a72ad4b8242f0e0942346cb6cbf9e2983a06990035bfdec2e083c7ef01` |
| 41-silence-stop.json | `43bbc976af4cc2685a3e88d64852e3d9ad29cafabe5a75e6727e670e9b1ccd0e` |
| 42-continuity-input.json | `d7481f0697a93ec96c2e926886e2021f2c0d097e86964b8c66d44ae04951f9b2` |
| 43-continuity-saved.json | `3f0b7c8ce724d13f2a49d8d14a21c7f3880059fcdebd6e11da8e2ccef632ff31` |
| 44-cold-recovery.json | `b455425818b2a0d58a9eb38b562f272c8f39c4c47948ef6a21ce4b636c5f0311` |
| 45-stable-start.json | `6a237572a921af1320dd585218ebc84204f9ced27370cc3b9505b2dd41a2d57b` |
| 46-stable-uncertain.json | `8cb94ee3ab42319e0a19c2ad126dbe7b52b68f0298bac36fb572a3520c3dafa1` |
| 47-proof-input.json | `3a07f132a0be6e7a9dfb5f69a4e78a44203c3889d20206b0277aaca5e726ffb3` |
| 48-proof-record.json | `24b94dcc0f832e9fdae150215a9a426f0ab3b8357d67bbb8d9c2d28f81160e1e` |
| 49-proof-saved-stable.json | `24b94dcc0f832e9fdae150215a9a426f0ab3b8357d67bbb8d9c2d28f81160e1e` |
| 50-settings-reopen.json | `c4b73ba61cc4ede84fb67ba7994ffb84d08f7512e10d5ad7fe70c78fb24d7345` |
| 51-wlan.json | `d456f16736d7f8728b97452f918f7fb817c3bdc177b2e50d61e029423149de3f` |
| 52-wlan-off.json | `c2f9ca8edea6a576c9ead2695b72b98d4955fa252f86f57312e1961b7339d51a` |
| 53-offline-return.json | `a5457a898fb0c009077219e140985e2923c5e49e455101f6b64a74837fab9330` |
| 54-offline-start.json | `9bc49d4a9760bd4e877d688ebcb3bcf5839eff239e1d05a43319909d1284d1a4` |
| 55-offline-stop.json | `c29f02a749c5e53ad24ff34c127f8c18eae5a9c8dcdca34d0e660a688da07b1b` |
| 56-offline-manual.json | `4b44eb3a1305892967128ad8a56f8095a85c68543fdfd18bab9a67514915918c` |
| 57-offline-record.json | `0a317d2aca1dbf4fc7ed2bf178142c1b980cd4bf6dd2ba0b2f4dad27a11159a8` |
| 58-offline-saved.json | `0a317d2aca1dbf4fc7ed2bf178142c1b980cd4bf6dd2ba0b2f4dad27a11159a8` |
| 59-wlan-before-restore.json | `8a268766a667b8488e62810eadb46b5c9418625f822c0a890db4e6ee8121f133` |
| 60-wlan-restored.json | `b23bb7434c6392122063edda469fafe28b3878d6b8934b6913030f4b127b3674` |
| 61-settings-back.json | `dc6bd61cc7aadf35319578e924912ada048daf621aa92a8207a679b3e6c7306f` |
| 62-app-list.json | `ab2f201ae6559887153248817cb9743b446756cade22c2dc76f8a0150b4fb783` |
| 63-app-info.json | `82c092681b8e26541e81d6a95e9fefef6e8d8a8d766042a3d8bd5f45fb7f4daf` |
| 64-permission-deny.json | `3d30000462f7652c4d7f24c096a093ad698672818fbe6cd653e6a49b420ca2d0` |
| 65-denied-stable.json | `940594cf22d6566829468ed24956ddf671315f0f24a0253d0e02887952436513` |
| 66-denied-recovery-view.json | `940594cf22d6566829468ed24956ddf671315f0f24a0253d0e02887952436513` |
| 67-open-permissions.json | `c6ae801e1db28b5bcf3d83da73221f0ef7ffb8b5c31fba97f94086082b1dd37d` |
| 68-mic-restored.json | `77a4b969485bd32b71b152be89d0317262274a05a30bf4a39b4fc254d074eb32` |
| 69-final-restored.json | `d4b4041b7700ef76c0ecd9e5b8d045f22396547ab33dcc74b07e274fad77d72e` |

## Other evidence

| File | SHA256 |
|---|---|
| [REVIEW.md](REVIEW.md) | `601af3d2044f21176067625d165f54732ebefefec1f80a32cf5ea15940bef2f4` |
| [PARENT_HANDOFF.md](PARENT_HANDOFF.md) | `36c9c66d0414ad9b51fdc532848a1cdac43c8ff6a17468ab13199f33acaa590f` |
| [baseline-v2.md](evidence/baseline-v2.md) | `2376a3a5e568b26f808298df918813cf801477a0a010a17c7a731a0d5b01227e` |
| [contract-r2.md](evidence/contract-r2.md) | `37704bd5d2914a31caa94db8f3ab79d0488389387213376a1fcb2e9aa9a69068` |
| [simulator-policy.md](evidence/simulator-policy.md) | `5a1a900842df98d45f1a342297c39e1d28a33fceb7f70e971ffd6e94fe19724a` |
| [candidate-manifest.md](evidence/candidate-manifest.md) | `de4b010306fbebe7faea1b57e418e67083e13cd090b2daaa063acc0c9cdb2db7` |
| [referral.md](evidence/referral.md) | `33d41a9e9c52381c7a0c42f10fd8767f2c5cb93563c7e9490cd65b08cc4eccda` |
| [stage-a.md](evidence/stage-a.md) | `0ddc4af08bd5a7b9e929be8d83e542efc1e1a1c0d3ce19ebfe9cdd16da88002e` |
| [reviewer-runtime-receipt.md](evidence/reviewer-runtime-receipt.md) | `bb735b99226da6e38222fa395d532afe3826082576360c524c2954f0a69d525c` |
| [layout-records.jsonl.gz](evidence/layout-records.jsonl.gz) | `a2d4b36eb667f6194025a673be15b04943c55dd68c7e8298c87ca932e1361cb7` |
| [operation-log.jsonl](evidence/operation-log.jsonl) | `3d06ff877cdedae1f2be539c1a9065e11a5b8711705782e05bd9616b4ec00aab` |
| [operate.py](evidence/operate.py) | `c843224f355faa03bfa4ff80a8bc08d6b035aae80835e587875b2d19b3378ac0` |
| [runtime-version.txt](evidence/runtime-version.txt) | `b7253ae890ac965e5d0d9a3580cdbd147e35c61938637f0b04810eb7eccdd621` |
