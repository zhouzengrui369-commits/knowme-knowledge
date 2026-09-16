# Local Execution Request — GOAL-KK-01 Candidate

```yaml
protocol_version: DELIVERY-LIFECYCLE-1.0
goal_id: GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
requesting_role: ENGINEERING_DELIVERY
requesting_context_id: ED-KK-GOAL01-AGENT-NATIVE-MATE60-PROTOTYPE-R1-20260916-1013-4A7D
evidence_bucket: engineering_required

repository: zhouzengrui369-commits/knowme-knowledge
candidate_sha: fb432162e7dd099a32fec7b52ff00659982942f3
candidate_tree: aed8058e5139948fbf8c4a3152a8fbf122ce8b5a
candidate_parent: 563997a0eca61800c8c72d23a83888821a6e0841
engineering_branch: engineering/goal-kk-01-agent-native-mate60-prototype-r1

local_repository: /Users/njx/Project/knowme-knowledge
materialization_note: >-
  ED works from a fresh GitHub clone inside the Kimi workspace
  (/Users/njx/Project/KnowME knowledge/KnowME knowledge/knowme-knowledge).
  Local Executor must materialize the exact candidate SHA from GitHub into a
  NEW empty temporary directory (git clone + git checkout <sha>), never reuse
  the ED worktree, and verify commit/tree identity before any execution.

authorized_executor: LOCAL_EXECUTOR sub-agent
executor_context_id: LE-KK-GOAL01-FINAL-CANDIDATE-20260916-1058-B3E9

prescribed_steps:
  - materialize exact SHA from GitHub; verify commit + tree identity
  - cd prototypes/knowme-knowledge-01-agent-native-mate60
  - npm ci
  - npm run build (record result)
  - npm run dev (record actual URL / port)
  - run tests/browser_assertions.py with the Homebrew Python Playwright
    interpreter against the running product (observation only)
  - open a real Chromium browser at viewport 360x780 (MATE60_CLASS_SIMULATION)
  - operate Journeys A-E by real interaction
  - capture screenshots LE-P01..LE-P07 into a temp directory
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
