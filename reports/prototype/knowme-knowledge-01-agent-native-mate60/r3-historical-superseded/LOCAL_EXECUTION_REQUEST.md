# Local Execution Request — GOAL-KK-01 Candidate (R3)

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
goal_id: GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
requesting_role: ENGINEERING_DELIVERY
requesting_context_id: ED-KK-GOAL01-R3-DEMO-AUTHORITY-20260916-1320-R3
evidence_bucket: engineering_required
evidence_channel_role: NON_CANDIDATE_EVIDENCE
evidence_commit_is_candidate: NO
move_pr9_head: NO

repository: zhouzengrui369-commits/knowme-knowledge
candidate_sha: e6e9c3d87a1c87fa0614aa1a4ec44e354117adde
candidate_tree: beeb0d6e136419036fb71fe5bd31aa8863f9227f
candidate_parent: 9f3071e22def4f99cbf3a4589349e628e9e15a97
engineering_branch: engineering/goal-kk-01-agent-native-mate60-prototype-r1

materialization_note: >-
  Local Executor must materialize the exact candidate SHA from GitHub into a
  NEW empty temporary directory (git clone + git checkout <sha>), never reuse
  the ED worktree, and verify commit/tree identity before any execution.

authorized_executor: LOCAL_EXECUTOR sub-agent
executor_context_id: LE-KK-GOAL01-E6E9C3D-FINAL-20260916-1330-D4E1

prescribed_steps:
  - materialize exact SHA e6e9c3d from GitHub; verify commit + tree identity
  - cd prototypes/knowme-knowledge-01-agent-native-mate60
  - npm ci
  - npm run build (record result)
  - npm run dev (record actual URL / port)
  - run tests/browser_assertions.py with the Homebrew Python Playwright
    interpreter against the running product (observation only)
  - operate all journeys plus R2/R3 surfaces by real interaction:
    sensing strip; knowledge navigation incl. 五维知识地图 / 九维认知图谱
    expansion; knowledge calendar tab; calendar 月/周/日 three views with
    month-cell and week-row deep-open; todo deep link to calendar day
  - capture screenshots R3-LE-P01..P12 into a temp directory
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
