# Ecosystem delivery policy — active project

Authority: exact GOVERNANCE_LOCK.json, PG core fc4872d9ba33325cf43a0778bb3ea01aea050c0f (0.4.0-alpha), DELIVERY-LIFECYCLE-1.0. This corrects earlier bootstrap-only/0.3 wording for the active project; it changes no central authority. Original ecosystem intake knowme-ecosystem#40 remains historical. Do not modify the old parent-pm/projects.yaml registry.

AGENTS.md governs separated roles. Exactly one active Goal maps to one Milestone, and both close only when the frozen contract's gates are complete. A contract revision is not a new Goal and never erases an earlier FAIL. Current canonical lifecycle is knowme-knowledge#35 with njx-knowledge#6 participation; read latest exact activation before implementation.

Each required evidence item is owned by exactly one bucket: engineering_required, admission_required, review_required, product_experience or human_owner. Engineering operates in a separate context, implements inside allowed paths, dispatches observation-only LE, personally validates the same frozen candidate and returns an atomic ENGINEERING_READY package. PG does not write product source/tests/build/deploy/runtime configuration. Independent reviewer operates code-blind after actual independence and referral; Owner alone grants final 1.0 acceptance and sensitive/production authority.

Current v5/R3 change adds account/workspace/device/server boundaries and a minimum phone Agent to the existing Android/offline value. Security remains proportionate to <10 users: credentials/private audio/knowledge/account isolation and irreversible actions, not enterprise scope. Real data is not default Git content; development evidence uses synthetic/redacted material.

No direct main writes, automatic merge/release, force push, historical amend or product-candidate mutation by PG. Governance changes are committed on reviewed branches and exact unmerged commits may be used only under explicit activation. Candidate/contract changes invalidate subsequent states as defined by the locked state machine. Actual runtime identity is recorded by the executing actor, never invented in governance.
