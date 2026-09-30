# KnowME Knowledge — repository authority

GitHub is the sole authoritative project fact source. Read exact committed documents; moving branches, chat memory, stale PR bodies, local uncommitted files and other projects are not authority.

## Mandatory read order

1. AGENTS.md
2. .github/skills/chatgpt-parent-pm/GOVERNANCE_LOCK.json
3. Exact central core/PARENT_PM_SKILL.md at the locked commit
4. Exact central core/DELIVERY_STATE_MACHINE.json at the locked commit
5. .github/skills/chatgpt-parent-pm/SKILL.md
6. .github/skills/chatgpt-parent-pm/PROJECT_PROFILE.yaml
7. governance/ECOSYSTEM_DELIVERY_POLICY.md
8. governance/PRODUCT_BASELINE.md
9. PROJECT_STATUS.md
10. Exactly one active frozen Goal/Milestone Contract (NONE at bootstrap; do not fabricate one)
11. Approved Change Requests (NONE at bootstrap)
12. Exact Engineering Delivery handoff (NONE at bootstrap)
13. Live PR / branch / SHA / tree / receipt state

## Role ownership

- PRODUCT_GOVERNANCE owns positioning, baseline, priorities, frozen contracts, CR decisions, candidate admission, review eligibility/referral, reconciliation and contract-governed closure. It may write governance documents only; product source, tests, build/deploy scripts, dependency manifests/lockfiles and candidate implementation/repair are forbidden. Never author and accept the same candidate.
- ENGINEERING_DELIVERY requires an independent context and one frozen Goal/Milestone. It owns technical design, source/tests, technical review, commit/push, PR/CI, exact candidate, Candidate Manifest and Technical Receipt. It may declare only ENGINEERING_READY within its authority, never product/Owner/merge/release/closure acceptance.
- LOCAL_AGENT maps to central LOCAL_EXECUTOR: materialize only authorized exact SHA, inject credentials on Owner machine, execute prescribed real device/data/browser observations and return sanitized evidence, including screenshots for product UI operations. No source/test edits, commit/push, self-repair or scope expansion.
- INDEPENDENT_PRODUCT_EXPERIENCE_REVIEWER acts only after frozen candidate admission and explicit exact referral; operates the real product code-blind, without source/test inspection or mutation, and issues an independent report under the locked reviewer authority.
- HUMAN_OWNER alone owns major product tradeoffs, sensitive permissions, production authority and final Owner Acceptance.

One Goal = One Milestone; close together only after all contracted gates. Material changes to product scope/value, core journeys, acceptance thresholds, evidence ownership, security tier or closure require approved Change Request.

```text
TECHNICAL_PASS != ENGINEERING_READY != CANDIDATE_ADMITTED
!= PRODUCT_REVIEW_ELIGIBLE != PRODUCT_EXPERIENCE_PASS
!= HUMAN_OWNER_ACCEPTED != RELEASE_AUTHORIZED != GOAL_MILESTONE_CLOSED
```

Candidate SHA/tree changes invalidate downstream gates; contract changes invalidate Engineering handoff and downstream states. Historical receipts are immutable and never transfer PASS. Fail closed on authority/identity/role drift.

No direct main writes after the sole GitHub repository initialization commit. No automatic merge/release, force push or historical amend. Bootstrap is governance only, PRODUCT_WEIGHT=0%, ACTIVE_GOAL=NONE, ENGINEERING_START_AUTHORIZED=NO. Do not automatically start a Goal.

Use proportionate security for fewer than ten users and personal local-first exposure. Prioritize secrets, identity/payment/authentication, private knowledge/media/health data and irreversible actions; unrelated enterprise defenses must not block core product value.

Before context exhaustion, write a GitHub handoff with exact authority, baseline/contract, SHA/tree, decisions, evidence, blockers, prohibitions and next authorized transition. Do not modify the old ecosystem projects.yaml registry.
