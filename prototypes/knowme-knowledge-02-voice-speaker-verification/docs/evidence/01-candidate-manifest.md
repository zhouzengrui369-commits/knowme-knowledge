# 01 · Candidate Manifest(模板 · 未填写)

> 冻结 final SHA 后由 ED 填写。所有字段必须可机器复核。

- CANDIDATE_SHA=TBD(精确 40 位)
- CANDIDATE_TREE=TBD(`git rev-parse HEAD^{tree}`)
- CANDIDATE_PARENT=TBD
- BRANCH=engineering/goal-kk-02-voice-speaker-prototype-r1
- PR=#18(Draft)
- BUILD_ARTIFACT=TBD(signed HAP 文件名 + sha256)
- MIN_API_VERSION=40100011(路线 B,HarmonyOS 4.2 适配)
- 允许改动范围核对:仅 `prototypes/knowme-knowledge-02-voice-speaker-verification/**` → TBD(`git diff --name-only` 附后)
- 签名材料不入库核对:TBD(`git ls-files | grep -E '\.(p12|csr|cer|p7b)$'` 应为空)
