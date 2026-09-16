# Ecosystem delivery policy

Authority: exact central Product Governance 0.3.0-alpha pinned in ../.github/skills/chatgpt-parent-pm/GOVERNANCE_LOCK.json; project intake is [Issue #40](https://github.com/zhouzengrui369-commits/knowme-ecosystem/issues/40), with [authority correction](https://github.com/zhouzengrui369-commits/knowme-ecosystem/issues/40#issuecomment-5690665232). The old ecosystem parent-pm/projects.yaml registry is not this project's authority and must remain unchanged.

AGENTS.md defines mandatory reads and separated role ownership. One Goal equals one Milestone. Bootstrap is a governance prerequisite of PRODUCT_WEIGHT=0%, not an active product Goal or Engineering ticket. No active contract, approved Change Request, candidate or Engineering handoff exists at bootstrap.

Before Engineering, Product Governance must freeze exactly one bounded contract, pin its commit/tree/path and Engineering authority/preimage, and assign every evidence item to exactly one of engineering_required, admission_required, review_required, product_experience, human_owner. Missing classification blocks handoff. Engineering builds in a separate context. Local Agent observations do not replace the owning role's adjudication. Candidate admission, review eligibility, independent experience, Owner acceptance, release and closure are distinct transitions.

Every transition records protocol, Goal/Milestone, actor/context, input/output state, contract/candidate identity, evidence references, forbidden-claim acknowledgement and issue time. Candidate or contract changes invalidate downstream states per central state machine; never rewrite historical receipts. Material product/security/acceptance changes require approved CR.

Security follows actual user count, exposure, data sensitivity, reversibility and automation authority. For fewer than ten local-first personal users, protect secrets, identity, payment/authentication, health/private knowledge/media and irreversible actions; no unrelated enterprise gate may block core value. Human Owner alone authorizes sensitive and production actions.

The one GitHub-generated initialization commit is the sole creation exception. All subsequent work uses reviewed branches; no direct main write, automatic merge/release, force push, historical amend or old registry migration. Product source/test/build/deploy/runtime implementation is forbidden in this bootstrap.
