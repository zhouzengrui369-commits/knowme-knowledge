# shots/INDEX.md — GOAL-KK-04 重入轮 LE3 截图证据索引

- operator: LE3（observation-only）
- 生成时间: 2026-09-23 20:35 +08:00（业务时间以 hdc date 为准）
- 双 SHA: App c0171d4fa5a988272afa76cabd42b4b6ddbaea8d / tree 4c88cf33614e93a1b9dc64be12929cd64dd019e7；Workbench 92892d66d059211113379b7e49d7f034b7ec921c / tree b527133111112abea4831fa6b4be2c251e7927be
- canonical HAP sha256: a73022244985e93a3f227b967bd771e8070dd562d499d16ddca4a91b8d721549（39,206,998 B）
- 环境: 隔离实例 127.0.0.1:18243（KB_ROOT=$WS/le3/runtime/kb-root，plugin enabled v1.0.0，external_send=disabled）；设备转发 hdc rport tcp:18247→tcp:18243；App 截图经 hdc 快照，J11 为 Playwright headless Chromium 截图
- 全部哈希算法 sha256，对当前目录下文件实算；capture_id/task_id/note_id 为 DB 只读实证绑定

| 截图 | 旅程 | sha256 | capture_id | task_id | note_id |
|---|---|---|---|---|---|
| chk_state.jpeg | J01(环境检查) | c4185daac7f0c90e5a9bb137fadc92e5f2e8fbeafd0dddb6cdaa7b367c0f66b3 | — | — | — |
| chk_state2.jpeg | J01(环境检查) | 1382b0c37b7fa9de4111141bfbf97a338ae1869000a107d4890b3dd776a91bf8 | — | — | — |
| chk_state3.jpeg | J01(环境检查) | f02cf22273a437f14bb086b9f493f721cc52bb1ccc3fba09541b7dd03a72c8cc | — | — | — |
| chk_state4.jpeg | J01(环境检查) | 761d89fc389987bbeba26b072bcabb8c2aef1a17b681c4208b0f441c24a68090 | — | — | — |
| chk_state5.jpeg | J01(环境检查) | 0224ac39ea45008aff5fcad2368bdcdcc83bc3e33504fd6d5a73165462fc1006 | — | — | — |
| j01_00_first.jpeg | J01 接入/能力/撤销/重连 | 3dfeb26bd682a63acd411a9eb68971538f8b04e72e01d9e0fe240936eca1cd6f | — | — | — |
| j01_01_before_connect.jpeg | J01 接入/能力/撤销/重连 | f56bc14fe803574fc93972b407452ab6722a4ba9dac677e4d5c611f7593c4eb8 | — | — | — |
| j01_02_connected.jpeg | J01 接入/能力/撤销/重连 | 0af934844957d33fe72c883ef4109c965bcb03c3afb45ae51a9290f77a1ceced | — | — | — |
| j01_03_after_connect.jpeg | J01 接入/能力/撤销/重连 | 431a0178bc158ca76dbde861e7492539fdb60d6c1876d460f9d6f346a36d4508 | — | — | — |
| j01_04_capabilities.jpeg | J01 接入/能力/撤销/重连 | 4487517382a7bf13e9ad5379c18d8b090169445da0a6073aa8a76d6be0d54083 | — | — | — |
| j01_05_revoked.jpeg | J01 接入/能力/撤销/重连 | 0d81f1bccc6353be6b47dbf8b56763e55f509b97ee91416ee866ca3a515b8120 | — | — | — |
| j01_06_revoked_submit_before.jpeg | J01 接入/能力/撤销/重连 | 9f26dcfab8e2725476506e7f313ac1571a948b4958e323adc2f9a18d71d9a091 | — | — | — |
| j01_07_revoked_submit_after.jpeg | J01 接入/能力/撤销/重连 | 9f26dcfab8e2725476506e7f313ac1571a948b4958e323adc2f9a18d71d9a091 | — | — | — |
| j01_08_revoked_reject.jpeg | J01 接入/能力/撤销/重连 | 516353294ad20b84582966a67334462f57eaf5942cabc9f216f7cbcc336f7e07 | — | — | — |
| j01_09_reject_t0.jpeg | J01 接入/能力/撤销/重连 | 516353294ad20b84582966a67334462f57eaf5942cabc9f216f7cbcc336f7e07 | — | — | — |
| j01_10_reject_t1.jpeg | J01 接入/能力/撤销/重连 | 516353294ad20b84582966a67334462f57eaf5942cabc9f216f7cbcc336f7e07 | — | — | — |
| j01_11_feed_after_reject.jpeg | J01 接入/能力/撤销/重连 | 70f78d5bd7bcfc5abb1be2bb87e320d20d0a4b79f2477668c7e88daaacaeaa43 | — | — | — |
| j01_12_reconnected.jpeg | J01 接入/能力/撤销/重连 | 93eabc9b5d32d63baf8a1f7f75bb6cccd0c43f629964e03a9c14ac665aabcb0f | — | — | — |
| j02_01_draft_saved.jpeg | J02 在线文本 | da092e71ed240c9abbf2f0be30bf1f53a4c180ac9f0aa054680ff94cb1094922 | cap_9b22b8e8 | task_f2f6a48 | …J02…-6306fdb1 |
| j02_02_after_save_scroll.jpeg | J02 在线文本 | 7d25950b4bf88f0eeb0719721183da11d24b492ae012d49e3a2910a1e82b9ae9 | cap_9b22b8e8 | task_f2f6a48 | …J02…-6306fdb1 |
| j02_03_kb_dismissed.jpeg | J02 在线文本 | 9f26dcfab8e2725476506e7f313ac1571a948b4958e323adc2f9a18d71d9a091 | cap_9b22b8e8 | task_f2f6a48 | …J02…-6306fdb1 |
| j02_04_submitted.jpeg | J02 在线文本 | fba4ad07ad824b2a96fb8d8962f2e79af2586fad009b915b22e56158ed06ecac | cap_9b22b8e8 | task_f2f6a48 | …J02…-6306fdb1 |
| j03_01_demo_submitted.jpeg | J03a 30s音频 | fba4ad07ad824b2a96fb8d8962f2e79af2586fad009b915b22e56158ed06ecac | cap_8876cae5 | task_06fd74e | …演示音频…-349eb728 |
| j03_02_5min_imported.jpeg | J03b 5min音频(404/重试) | 3f2b58459cd9291f45cd7d83466f9b5f341a1a65c5ceab2746d8212a360e105e | cap_be1b1137 | task_1e225c9 | …5分钟…-6faf5466 |
| j03_03_feed_5min.jpeg | J03b 5min音频(404/重试) | a47ac4a2dd67f659e489a35b23142fbbc6210a0984adae576f29f0891ae995d4 | cap_be1b1137 | task_1e225c9 | …5分钟…-6faf5466 |
| j03_04_5min_submitted.jpeg | J03b 5min音频(404/重试) | 51b9f1dabf1de34b88de7f6a65b3e395503a3228ac47b9bc51a1817137f6a80d | cap_be1b1137 | task_1e225c9 | …5分钟…-6faf5466 |
| j03_05_failed_items.jpeg | J03b 5min音频(404/重试) | d51b2a3cb10f9e1c04dc22834f2642e56a9d625402074cdd39a44cacabf380f1 | cap_be1b1137 | task_1e225c9 | …5分钟…-6faf5466 |
| j03_06_retry_before.jpeg | J03b 5min音频(404/重试) | fa819485789af242c029edfc53b72eb2f9f554bafe17137b08c376081cba36e6 | cap_be1b1137 | task_1e225c9 | …5分钟…-6faf5466 |
| j03_07_retry_yesterday_clicked.jpeg | J03b 5min音频(404/重试) | fecc887401cd8ed2c1ae40f97abfc044dbd7695129269889f7acc0b9296debf8 | cap_be1b1137 | task_1e225c9 | …5分钟…-6faf5466 |
| j03_08_retry_5min_clicked.jpeg | J03b 5min音频(404/重试) | 50f5938137484f1aefac5ee279b2d425f6bfec9f8c28c5845a27f8ef9141a823 | cap_be1b1137 | task_1e225c9 | …5分钟…-6faf5466 |
| j04_01_offline_saved.jpeg | J04 断网队列/冷启动/补传 | 834323fed4696d944d699fd8fc879a7b5d8ae571f6fba5a525d3990dd353679a | cap_866c65ba | task_07a43ad | …J04…-bde580ec |
| j04_02_scroll_check.jpeg | J04 断网队列/冷启动/补传 | 9a6eb04960954cd3ce06be287b17ea6dff932cab3a243a2b29a83b9069abcd21 | cap_866c65ba | task_07a43ad | …J04…-bde580ec |
| j04_03_kb_check.jpeg | J04 断网队列/冷启动/补传 | 16047dd85b45fd51d262e5404aa66c75e3f1cf82f127e13449b349cb6ec2f2d6 | cap_866c65ba | task_07a43ad | …J04…-bde580ec |
| j04_04_kb_check2.jpeg | J04 断网队列/冷启动/补传 | a202a2ad480b0b1ca8247cc1c7dc09b1fc479703190d389fe7714da1cac7c3aa | cap_866c65ba | task_07a43ad | …J04…-bde580ec |
| j04_05_offline_submit_before.jpeg | J04 断网队列/冷启动/补传 | 82843a77ce76c7432d2c65cff69a32e5cadd62bc82ac47ba4b41fc25cc0efddd | cap_866c65ba | task_07a43ad | …J04…-bde580ec |
| j04_06_offline_submit_after.jpeg | J04 断网队列/冷启动/补传 | db91f3d08c4c8b2494866cd8c2e7b5e9347663b79813df8e95417de9654c9ed1 | cap_866c65ba | task_07a43ad | …J04…-bde580ec |
| j04_07_coldstart_queue_kept.jpeg | J04 断网队列/冷启动/补传 | e4d140e592d876566711e2da46dfd1a893a76f10c6b29730bcb4c28368446a78 | cap_866c65ba | task_07a43ad | …J04…-bde580ec |
| j04_08_coldstart_item.jpeg | J04 断网队列/冷启动/补传 | f0e53b9189c3a7cd8fe30164778f31b3f297143f98b9d96f208cf642e356b544 | cap_866c65ba | task_07a43ad | …J04…-bde580ec |
| j04_09_coldstart_j04item.jpeg | J04 断网队列/冷启动/补传 | 6caced2b8f86bdf05cf631b7ea2b16805c6d50617b00c060a73a7f5506672fe4 | cap_866c65ba | task_07a43ad | …J04…-bde580ec |
| j04_10_coldstart_j04item2.jpeg | J04 断网队列/冷启动/补传 | 59188d6df974704f3a99f085fe17e0e0e7a86057f78d1232d164da1bf8e155db | cap_866c65ba | task_07a43ad | …J04…-bde580ec |
| j04_11_coldstart_j04item3.jpeg | J04 断网队列/冷启动/补传 | be5f66430d7c673d149263a55f0dcf7c82467e804cd983425a78a295d36424ff | cap_866c65ba | task_07a43ad | …J04…-bde580ec |
| j05_01_saved_plugin_disabled.jpeg | J05 插件停用/恢复补传 | 18ac28e47be2f6f56e887fa7535ff1559c5fb7f5b311472dd0884b93eb66e78a | cap_f21814a4 | task_87dae75 | …J05…-1e73ebe1 |
| j05_02_submit_503.jpeg | J05 插件停用/恢复补传 | cb32bb41a857b3c5675ab7da6010b78b68dca8dca11ef93c4cbd02b9b854338d | cap_f21814a4 | task_87dae75 | …J05…-1e73ebe1 |
| j05_03_kbstate.jpeg | J05 插件停用/恢复补传 | fe6aed27225acc450230ba6b70baa08d9eb8baefc12b2289616d805b82ea29be | cap_f21814a4 | task_87dae75 | …J05…-1e73ebe1 |
| j05_04_after_back.jpeg | J05 插件停用/恢复补传 | dce6d211d0b3deb1064707c9cbf4d1dc5902328004dd584d844c43f06c0e6a74 | cap_f21814a4 | task_87dae75 | …J05…-1e73ebe1 |
| j05_05_submit_attempt.jpeg | J05 插件停用/恢复补传 | 5473a47e764f38536ed196eff7cd324650baee678d885f1190d22aa3ede292d3 | cap_f21814a4 | task_87dae75 | …J05…-1e73ebe1 |
| j06_00_relaunch.jpeg | J06 终态(采集箱并列已整理) | ce1e8258deb6c8d288b5b2853ec3bb26583c3ae4a93555679ec166c3840f9e2a | cap_18f8ccbb;cap_06f9551c;cap_d872942b | task_165a084;task_9ed1997;task_ed88e1b | 三笔记 |
| j06_03_j06a_final.jpeg | J06 终态(采集箱并列已整理) | 146180e4f5b9f09c1dc0c3e2280810960ddd8e8c1d1c4eb2622f5d42068001ef | cap_18f8ccbb;cap_06f9551c;cap_d872942b | task_165a084;task_9ed1997;task_ed88e1b | 三笔记 |
| j06_04_j06b_pair_final.jpeg | J06 终态(采集箱并列已整理) | f691a1e47e7a8e140805b8812c4570c2ac1e2d78e7c9c9bfa480087531efcfd1 | cap_18f8ccbb;cap_06f9551c;cap_d872942b | task_165a084;task_9ed1997;task_ed88e1b | 三笔记 |
| j06a_01_before_triple.jpeg | J06A 幂等连点 | 39c3013fea7950baa083f2c7a7b2ee0b72eb23141393d0e4bdd435ff3a305299 | cap_18f8ccbb | task_165a084 | …J06A…-9643c7fc |
| j06a_02_after_triple.jpeg | J06A 幂等连点 | 1a4ac218f5009c7df9e263c02af20108d90c492a7417ac5090fcdf8f0e774e6d | cap_18f8ccbb | task_165a084 | …J06A…-9643c7fc |
| j06b_01_both_submitted.jpeg | J06B 同分钟同名×2 | ddf84415fd8903df2b5b97a8b7afd619cb7fc76bd24db66da8f587c80d5c4358 | cap_06f9551c / cap_d872942b | task_9ed1997 / task_ed88e1b | …-7b4b9150 / …-20570896 |
| j06b_02_second_submitted.jpeg | J06B 同分钟同名×2 | cff0267b466687ba24fadc8e9345c7c19e819911bc6fd7d7bbf0b78eae59524d | cap_06f9551c / cap_d872942b | task_9ed1997 / task_ed88e1b | …-7b4b9150 / …-20570896 |
| j07_01_yesterday_submitted.jpeg | J07 昨日捕获三时间 | 5833c0a21de7a940848563263b2c758cef108c1c3772762c41214eba5d0a5e4d | cap_c9787970 | task_67c3910 | …昨日捕获…-17390473 |
| j07_02_provenance.jpeg | J07 昨日捕获三时间 | 030ee7c5d740d47ac2ef3f4495d9831efc4df4c6b96153b7a562f282921eee35 | cap_c9787970 | task_67c3910 | …昨日捕获…-17390473 |
| j08_01_before_correction.jpeg | J08 现场修正三层revision | dea6b5637485690da73f6496376153ae658170edc82602609377ce6e0126cca8 | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_02_correction_mode.jpeg | J08 现场修正三层revision | 6c20bbe1b42cd8b7c98487272093c33f2373bc40158177fc29c522e43ea740b4 | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_03_correction_mode2.jpeg | J08 现场修正三层revision | 113ef92ab2bd6b1e0226d252550d19b0311847767a0bc605f3d6765f2cee33ef | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_04_top_banner.jpeg | J08 现场修正三层revision | 0bcb6ebf327656c482246ab233b40c81125546939277d56129a70258a04c8613 | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_05_aborted.jpeg | J08 现场修正三层revision | e6e8a22a7000c3ad0e0e37089df8c19379e5ac745d84a0bdbba45b44b7e53f7b | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_06_correction_clean.jpeg | J08 现场修正三层revision | 6c2202dad1c093496699ab569e2d5f1e57b257b37f8ec2d430c7454c478a52ce | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_07_correction_active.jpeg | J08 现场修正三层revision | 4c5074de2846e985eb7b49db11d7e33331b72ff61bd784f63e0ba4e23ad284b9 | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_08_correction_saved.jpeg | J08 现场修正三层revision | a101e9cd34811ea14099448d5e4d3a1179fc0b507f0fe494806c6e6aec9d014d | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_09_supplement_saved.jpeg | J08 现场修正三层revision | 40f09b154eaf843c21c12bfd340ffbc9c92fe2c12bf92f95d157e0c21d09da15 | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_10_fix3_clicked.jpeg | J08 现场修正三层revision | 2f18ffab79e1f3ea58fc977625505d769b4f79a4988019b97a49fe287815240d | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_11_fix3_mode.jpeg | J08 现场修正三层revision | 7f1b47e61f5df44592b8df3eb3e63b005e2f79e53f12b0ca5bb7e24f102d7eab | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_12_fix3_mode2.jpeg | J08 现场修正三层revision | 7cee5405a7eb9504e45344022b3942884e5f6a0efb7db88a25e1765c30b3fc18 | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_13_rev2_submit_before.jpeg | J08 现场修正三层revision | 789893f9241cd6c02761271bcc0c09686e68f4da09bbf81e8fb3e83f997f18e1 | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_14_rev2_submit_after.jpeg | J08 现场修正三层revision | 50a06eb111cc1038eda07c77fb462a36596e5297899087686763d95902f7ca6c | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_15_rev3_saved.jpeg | J08 现场修正三层revision | 472264303b8852fd2f43b923565ebdb4543df5c52ce20e8f0494b3e2fa808ab8 | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_16_rev3_submit_before.jpeg | J08 现场修正三层revision | a2f474f646aef1e327bc481cbab0e97d78655551ab12b08bb9f04968813c6e6c | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_17_rev3_submitted.jpeg | J08 现场修正三层revision | 64c2c70bc6afb3eed555fa1819dd4211b90473339f6164f7978e3ee7a167cd03 | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 |
| j08_18_provenance_view.jpeg | J08 来源链视图(三层COMPLETED) | 40f2e655120f5cb3fc03aa7e841cecdb3139238f9e463ee63bb6bff45b1b4456 | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 (r1/r2/r3) |
| j08_19_provenance_chain.jpeg | J08 来源链视图(三层COMPLETED) | 63e1fe173eaf14662f73ae5515aace43a841ce69bda3948af0ec774af2ae6bd0 | cap_42487fc3 | task_a030774/a707e90/7e35de5 | …-a53efcf6 (r1/r2/r3) |
| j08j10_saved.jpeg | J08九点首提交 / J10注入提交 | e6c741a952e16f4fccebe5ccd948b6b3bbeb38d792882a7b42137d3619f9721c | cap_42487fc3;cap_6478eabf | task_a030774;task_b783281 | …-a53efcf6;…-999a9fa2 |
| j08j10_submitted.jpeg | J08九点首提交 / J10注入提交 | 386bdbf06d7c54b6819fa7e25cf047a5eeb7cf517a6b8f0151872ce5a8bdde09 | cap_42487fc3;cap_6478eabf | task_a030774;task_b783281 | …-a53efcf6;…-999a9fa2 |
| j09_01_feed_current_history.jpeg | J09 早前/当前状态区分 | ed4e46472129d2f237aa044d82cdd815fae9c6cd125706e9ddf32ffa4ff01794 | — | — | — |
| j11/01_home.png | J11 工作台UI全程(Playwright) | 6bc335dbd50b129e6d5471b434e945c09111959bdae60e2f45ea5401ad4f2145 | — | — | J11验证笔记(三件套落盘) |
| j11/02_add_dialog.png | J11 工作台UI全程(Playwright) | 45d50a8855b33369d35ea85c79ec3e50c43264bd20131f50d31c01bd659f37e0 | — | — | J11验证笔记(三件套落盘) |
| j11/03_add_filled.png | J11 工作台UI全程(Playwright) | bc48e67825a227e8c053bedc860ee985bee936dfd20481ea8c9bd6ee95a3d8e3 | — | — | J11验证笔记(三件套落盘) |
| j11/04_add_submitted.png | J11 工作台UI全程(Playwright) | 4787a5962ce5a96c9ccbeee7ce03ddffdccddb2d6e9719533379c1129da39503 | — | — | J11验证笔记(三件套落盘) |
| j11/05_search_results.png | J11 工作台UI全程(Playwright) | 336c26db42a071616f3c33b04898b818c36e531b6f36e7a78aca2a255d377632 | — | — | J11验证笔记(三件套落盘) |
| j11/06_preview.png | J11 工作台UI全程(Playwright) | 9c04c2adaee4f50ab2651e2069a700d9befed299ecb4bc413892d8a5220b4b68 | — | — | J11验证笔记(三件套落盘) |
| j11/07_conv_typed.png | J11 工作台UI全程(Playwright) | 5c372fa01cc4a8b1198b6111519b507b2547fc8360d84dcbbbbac45fe3b30ba3 | — | — | J11验证笔记(三件套落盘) |
| j11/08_conv_sent.png | J11 工作台UI全程(Playwright) | 2f55502601f4ecdab01165523924d0f5af3d8a56ca2ab4763a8800cd019db702 | — | — | J11验证笔记(三件套落盘) |
| j11/09_conv_wait.png | J11 工作台UI全程(Playwright) | ff69dcb808d57a2aa64df759d35af36e2530b2fe6d264d7e1359af7e7cb4706d | — | — | J11验证笔记(三件套落盘) |
| j11/10_conv_reply.png | J11 工作台UI全程(Playwright) | 89508db5811bd47b5bf3b76a2bb893cce642d1adaa4123457b91a5d9f1a4a21b | — | — | J11验证笔记(三件套落盘) |
