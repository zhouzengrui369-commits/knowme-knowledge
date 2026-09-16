# CR-KK-01-OWNER-DIRECTED-R2-R3

```yaml
change_request_id: CR-KK-01-OWNER-DIRECTED-R2-R3
goal_id: GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
milestone_id: MILESTONE-GOAL-KK-01-AGENT-NATIVE-MATE60-PROTOTYPE
requester_role: OWNER
current_contract_commit: 563997a0eca61800c8c72d23a83888821a6e0841
reason: >-
  Human Owner personally operated the prototype and issued material product corrections during
  Engineering Delivery. Engineering implemented them and explicitly disclosed them as OWNER_DIRECTED,
  but the original frozen Goal Contract was not amended first. Product Governance must formalize
  those corrections before Candidate Admission.
proposed_change: >-
  Promote the Owner-provided KnowMe-NJX-Demo.html as the exact UI/product-lineage authority for this
  Goal; require persistent background sensing semantics in the prototype with honest PROTOTYPE_ONLY
  disclosure; require knowledge calendar view and knowledge navigation; require five-dimensional
  knowledge map and nine-dimensional cognitive graph; require Calendar month/week/day views and
  visual linkage between schedule and Todo; require a self-contained HTML review artifact for
  code-blind/manual product inspection. Real ASR, speaker verification, real backends and production
  integrations remain out of scope.
product_value_impact: >-
  The prototype better represents the Owner's intended personal knowledge Agent: information is
  continuously sensed at the interaction layer, knowledge is navigable through the intended
  cognitive structures, and time/task context is visually operable rather than represented by a
  generic capability placeholder.
required_journey_impact: >-
  Journeys A, D and E are strengthened. First Encounter includes persistent sensing state; Work From
  Knowledge includes calendar navigation plus five-dimensional and nine-dimensional navigation;
  Capability Attachment requires month/week/day Calendar views and linked Todos. Journeys B and C
  remain semantically unchanged.
risk_and_security_impact: >-
  No increase in authority or real-data exposure for this prototype. Continuous sensing remains a
  deterministic mock with explicit no-real-ASR/no-speaker-verification disclosure. Security tier
  remains SINGLE_USER / LOCAL / PERSONAL / REVERSIBLE / OBSERVE.
schedule_impact: >-
  Requires successor contract freeze and fresh Engineering re-entry/re-adjudication. Existing R3
  implementation may be reused as an exact preimage but prior Engineering Ready is invalidated by
  contract change.
alternatives_considered:
  - "Ignore Owner changes and admit against the old contract — rejected: would violate frozen-contract change control."
  - "Move all corrections to a new Goal — rejected: Owner corrections refine the same bounded 0.1 Agent-native prototype value increment rather than creating an independent product-value increment."
  - "Accept Engineering's OWNER_DIRECTED disclosure without a CR — rejected: Owner direction is authoritative input but does not rewrite an immutable contract retroactively."
product_governance_decision: APPROVED
decision_reason: >-
  The changes are explicit Human Owner product decisions, remain within the 0.1 interactive-prototype
  horizon, preserve one Goal = one Milestone, and materially affect product boundary/journeys/lineage;
  therefore they are approved through Change Request and must be frozen in a successor baseline and
  successor Goal Contract before Engineering can re-establish ENGINEERING_READY.
decision_commit: BOUND_EXTERNALLY_BY_SUCCESSOR_GOVERNANCE_RECEIPT
```

## Exact Owner-provided UI authority promoted by this CR

```text
UI_AUTHORITY_REPOSITORY=zhouzengrui369-commits/knowme-knowledge
UI_AUTHORITY_EVIDENCE_COMMIT=15a50071202536af05c51e45e04b738dcc81cbdf
UI_AUTHORITY_EVIDENCE_TREE=a63446138525020ab269c630c6507b6e7be74870
UI_AUTHORITY_PATH=reports/prototype/knowme-knowledge-01-agent-native-mate60/r3-ui-authority/KnowMe-NJX-Demo.html
UI_AUTHORITY_BLOB=097e2c978877f5480a63e9da55acf5fb27e60a43
AUTHORITY_SOURCE=HUMAN_OWNER_PROVIDED
PRIOR_KNOWME_AUTHORITY_STATUS=HISTORICAL_LINEAGE_REFERENCE_ONLY_FOR_THIS_GOAL
```

## Owner-directed corrections frozen by this CR

```text
CONTINUOUS_BACKGROUND_SENSING_UI=REQUIRED_IN_PROTOTYPE
CONTINUOUS_BACKGROUND_SENSING_REAL_ASR=FORBIDDEN_IN_THIS_GOAL
KNOWLEDGE_CALENDAR_VIEW=REQUIRED
KNOWLEDGE_NAVIGATION=REQUIRED
FIVE_DIMENSION_KNOWLEDGE_MAP=REQUIRED
FIVE_DIMENSIONS=工作记录|生活感悟|人生规划|系统思考|行业洞察
NINE_DIMENSION_COGNITIVE_GRAPH=REQUIRED
NINE_DIMENSIONS=身份角色|价值认知|能力复用|人物关系|知识与工具|行为与表达|目标与项目|决策与反馈|动态与情景
CALENDAR_MONTH_VIEW=REQUIRED
CALENDAR_WEEK_VIEW=REQUIRED
CALENDAR_DAY_VIEW=REQUIRED
CALENDAR_TODO_VISUAL_LINKAGE=REQUIRED
SELF_CONTAINED_HTML_REVIEW_ARTIFACT=REQUIRED
```

This CR changes no release authority and grants no Candidate Admission, Product Experience, Human Owner Acceptance, merge, release or Goal/Milestone closure.