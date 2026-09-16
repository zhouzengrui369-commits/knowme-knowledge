# Local Execution Request — GOAL-KK-01 Candidate (R2)

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
goal_id: GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
requesting_role: ENGINEERING_DELIVERY
requesting_context_id: ED-KK-GOAL01-EXACT-CANDIDATE-EVIDENCE-REBIND-20260916-1155-R2
evidence_bucket: engineering_required
evidence_channel_role: NON_CANDIDATE_EVIDENCE
evidence_commit_is_candidate: NO
move_pr9_head: NO

repository: zhouzengrui369-commits/knowme-knowledge
candidate_sha: 9f3071e22def4f99cbf3a4589349e628e9e15a97
candidate_tree: b165a075f4e6a3784c6fc7794fc8c5581dc539c0
candidate_parent: d8290e7a216b647ec2853f9f4522d97f77129281
engineering_branch: engineering/goal-kk-01-agent-native-mate60-prototype-r1

materialization_note: >-
  Governance blocker 5691624112 requires operation evidence on the FINAL
  EXACT candidate. Local Executor must materialize the exact candidate SHA
  from GitHub into a NEW empty temporary directory (git clone + git checkout
  <sha>), never reuse the ED worktree, and verify commit/tree identity
  before any execution.

authorized_executor: LOCAL_EXECUTOR sub-agent
executor_context_id: LE-KK-GOAL01-9F3071E-FINAL-20260916-1205-C7A2

prescribed_steps:
  - materialize exact SHA 9f3071e from GitHub; verify commit + tree identity
  - cd prototypes/knowme-knowledge-01-agent-native-mate60
  - npm ci
  - npm run build (record result)
  - npm run dev (record actual URL / port)
  - run tests/browser_assertions.py with the Homebrew Python Playwright
    interpreter against the running product (observation only)
  - operate all journeys plus R2 surfaces by real interaction:
    sensing strip (visible, ticking, mic-key pause/resume, cross-sheet
    survival), knowledge navigation tab, knowledge calendar tab,
    visual calendar week strip with day switch, todo deep link to
    calendar day
  - capture screenshots R2-LE-P01..P10 into a temp directory
  - record console errors and page errors
  - return sanitized observation receipt with sha256 of every screenshot

allowed_data:
  - prototype deterministic mock fixtures
forbidden_data:
  - real Owner private data
  - credentials / tokens of any kind

source_mutation: FORBIDDEN
test_mutation: FORBIDDEN
commit_push: FORBIDDEN
self_repair: FORBIDDEN
scope_expansion: FORBIDDEN
```

If deployment fails at any step, the Local Executor must NOT repair code. It
returns observations only; Engineering Delivery adjudicates and fixes.
