# Evidence Manifest — R3 independent focused retest

所有实操记录绑定 PR24 / `06b013cf776d308737cf6726afcff7ee4831f5f4`。候选身份、HAP hash、环境参数见 [reviewer-identity.json](evidence/reviewer-identity.json)。

## 实操原始证据

- [operation-log.jsonl](evidence/operation-log.jsonl)：hdc 实际点击、文本、按键、截图、布局命令及主机 ISO 时间，未执行产品技术测试。
- [operate.py](evidence/operate.py)：审核用操作/截图记录辅助程序，只写本报告 evidence，不是产品代码或技术测试。
- [layouts.jsonl.gz](evidence/layouts.jsonl.gz)：90个布局文件逐文件以 filename + raw_text 原文封装；解压解析后能无损还原。不是用源码构造的假布局。
- [evidence-hashes.json](evidence/evidence-hashes.json)：90组PNG/JSON原文件hash、发布PNG hash、逐张像素相同校验。原始全量PNG保留在Owner本机同目录；GitHub仅发布精选17张以控制体积。
- 图片发布仅重编码PNG压缩，尺寸1256×2760及全部RGBA像素不变，未裁切、画箭头、修改文案或生成替代UI。
- 完整报告 [REVIEW.md](REVIEW.md)，交接 [PARENT_HANDOFF.md](PARENT_HANDOFF.md)。

## 精选截图

| Screenshot | Raw SHA256 | Published SHA256 |
|---|---|---|
| [06-keyboard-dismiss.png](evidence/published/06-keyboard-dismiss.png) | `ae6589e748d1f1899d7b800b9ad488710fe2dca4d0c40bfc1d41f517e261dd72` | `f60a727967a3a5116f78b43e1d089fd6b8c7b571caec4e89141f8e1a57251d9e` |
| [17-save-correction.png](evidence/published/17-save-correction.png) | `4ff3f8fcca52cd5aa4b0adf1ec567439e5a872ae73c169114db4f3a828653eff` | `22b3265cb6497131b76ad9653e0e65c47a8bcb81f2c4e2481bab60f82f848f58` |
| [18-confirm-corrected.png](evidence/published/18-confirm-corrected.png) | `d384333394bf0e4dec30bbb1d6eadb2a9e3db0933a689e07595e8695e4e2894c` | `a3b6b41bdb5cdef42c3e9ef806ad706282300d9e6919d7f2a71ae88a9077bac7` |
| [20-generated-reject.png](evidence/published/20-generated-reject.png) | `b8da53572d76c5c5ae25d339716244b299afa31a07f57f9b7fe8aa9ed399a6fb` | `811dbcf5a0803328515e56a5f895d3e1e67726bf26924f262adefdb21d40167b` |
| [21-reject.png](evidence/published/21-reject.png) | `f70d4cbb8adcea771d517b682d80f05a73d49c7f1718dba84796b08c64c86f3f` | `2e7bfc7b37b26cbe792c22e932e451662b43c4b2b1b110d9ef27b3fb68be252c` |
| [22-recheck-denied-click.png](evidence/published/22-recheck-denied-click.png) | `253e8a0d875a472b34d450fac3625af04a03b0e5853eb5feb1dbafd8abe6568f` | `1914006637fd99b15373bef8e40cbabe4b4a401c5ffff361152b25d0a4af396c` |
| [33-cold-pending-lower.png](evidence/published/33-cold-pending-lower.png) | `d524cb208e745af532e484ef9ebe51e8093f9189342bec81811e6f7ea6792b44` | `49d2541476d97c1b3190ecc18f1076f2e1f0b4064427fddd1e2c55bb1d37b282` |
| [41-enroll-complete.png](evidence/published/41-enroll-complete.png) | `5826640d6049bbbf196d666c195a3cede077878bc19b2fefe3012f54f88267a0` | `e822392272c1ac1b5dd595b9e207d8c145d025721458ec8402a6b1f8f8f8dfc1` |
| [44-verified-unavailable-state.png](evidence/published/44-verified-unavailable-state.png) | `a2410c7d7b9a54694603f4e775bd6dbdc5b11e7b48c576fcabd17c78adfe9122` | `32817d1848e121d6084d397a5187b13d70c15bbb4c847daa21b185ea404aad93` |
| [50-inspect-long-saved-item.png](evidence/published/50-inspect-long-saved-item.png) | `ee50ad17559cdb8ab5690e3c237fc014f6387c4623ca03a8e39a3ee7bcf2b02e` | `f02c5e9ce142bf9b4b3200396f91fb41f8ef253af7d90c366cb5b75d28ecfd35` |
| [65-permission-roundtrip-items.png](evidence/published/65-permission-roundtrip-items.png) | `4988e0679d3a7bd0de2f3d4d63848255de4682fd33c2ee0dfc0664ffb3d88098` | `d7b00daa450b0d7292b58f68dec48673991d82dfbd614a5ace32b4a419efa3d1` |
| [66-reset-dialog.png](evidence/published/66-reset-dialog.png) | `0af966d30e15bc9158748f1e087a8957365681884fc955a2b7766c072b918e8f` | `8988ebba8875808fd4bfa888b48a6f92ad5408792c896b6f51f828bcfc5f1e9c` |
| [73-wlan-off.png](evidence/published/73-wlan-off.png) | `62e0c814ae0e0194dcc9a41a2639136ab7c77db348c6aa20be006aa875426e3b` | `46b7f110597de0ca555507c0f5310156744cd71218a906d03c13edcc0f1d8eb5` |
| [79-offline-manual-save.png](evidence/published/79-offline-manual-save.png) | `977ab4b8452d3929da9737881b0b860e48e9526bbfd03596b82ebf944ee9366f` | `7133e154c0569cb6d686f11aa378814e0bac55ee48a0633e6ed7cc68f20af76d` |
| [85-mic-restored-denied.png](evidence/published/85-mic-restored-denied.png) | `c3d051c771103bdafaee70d4647f0a2ac39313f75a82a1ba4432737468b93aff` | `03ffbb0c92c632f5cad974ed94dd6ae71356a98c88b97892668f0002a2157840` |
| [88-final-detail-corrected.png](evidence/published/88-final-detail-corrected.png) | `85d5c509b72a65fb914a8605ec79ff1b28200027a1b5cda73be3bf3dea1b65fd` | `e6482e2879970cea2a88f4e1ba5c2c968cf462ec931957e276f97220826ad907` |
| [90-final-agent-entry.png](evidence/published/90-final-agent-entry.png) | `e7cff25f0bdbd38fad265d802c8b0f7cb1aaa8cfad4917b6e7cdf595d8054316` | `803fa037d0137c8498654e191bf1ef3af2dc8bc92e85c3fc213e2176e86c1ec9` |

## 恢复命令与采集边界

与UI操作穿插执行的系统生命周期动作：30后 `hdc shell aa start -a EntryAbility -b com.knowme.knowledge.voiceprototype` 返回；31后 force-stop 同bundle再start，采集32/33；85后再次force-stop/start，采集86–90。动作的成功stdout在本轮工具记录中；operation-log只自动记录operate.py发出的命令，不冒称包含全部终端调用。没有 clear-data/uninstall，也没有直接编辑沙盒状态。

01/32/76/86有启动或转场状态；32布局与PNG不一致，其PNG是桌面，不作产品恢复证据。实际恢复用33/65/88/89/90。10是reviewer误以为键盘还在而按Back，退出至此前系统设置；11重入，无设置改动，不归为产品崩溃。52主屏长按只有卸载菜单，未点卸载；随后正常启动系统设置并在UI导航。

当前研究为PRIMED_COGNITIVE_WALKTHROUGH，非盲测。未在后续操作前单独落盘Stage A冻结文档；02–07初始观察保留时间戳，报告没有倒签。没有声学真值、独立人类情绪数据或网络流量审计。

## 背景文档与独立证据区分

AGENTS、governance-lock、PROJECT_STATUS、baseline-v2、contract-r3、cr-r3、candidate-manifest、referral为本轮从GitHub读取的权威/工程背景副本。manifest不是本轮操作结果；PROJECT_STATUS可能仍是冻结合同快照，更新状态以Issue13新转介为准。仅reviewer-identity、UI采集、操作记录、报告裁决属于本轮独立证据。

没有发布HAP、原始Owner音频、embedding、声纹档案、私密转写或凭据。屏幕中的ED旧内容与PX20新内容均是审核合成资料；声纹相似度仅是UI输出，不是有效生物身份结论。

## 校验

[skill-validation.txt](evidence/skill-validation.txt) 为 pinned Skill 的结构/Core hash检查；不是产品测试。四类裁决、未覆盖项和R3-06问题合同见REVIEW.md，不以校验器PASS替代实际体验裁决。
