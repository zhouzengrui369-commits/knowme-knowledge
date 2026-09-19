# CR-KK-02-SIMULATOR-FIRST-UNTIL-1.0

```text
PROTOCOL_VERSION=DELIVERY-LIFECYCLE-1.0
ACTOR_ROLE=PRODUCT_GOVERNANCE
CHANGE_REQUEST_ID=CR-KK-02-SIMULATOR-FIRST-UNTIL-1.0
GOAL_ID=GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
MILESTONE_ID=MILESTONE-GOAL-KK-02-VOICE-CAPTURE-SPEAKER-VERIFICATION-PROTOTYPE
OWNER_DIRECTION_DATE=2026-09-19
DECISION=APPROVED
REASON=HUMAN_OWNER_EXPLICIT_DEVELOPMENT_VALIDATION_ORDER_CHANGE
```

## Owner direction

> 先用模拟器做产品测试，1.0版本开发完成并通过产品体验审核后再真机安装。

## Material contract changes

This CR changes validation ordering and evidence ownership for GOAL-KK-02:

- real Mate60 installation/operation is removed from `engineering_required` for GOAL-KK-02;
- simulator / controlled development environment becomes the required Engineering and Product Experience environment for this Goal;
- real-device STT/speaker-verification sample thresholds are removed from this Goal and deferred to a post-1.0 bounded real-device Goal;
- GOAL-KK-02 may reach ENGINEERING_READY, Candidate Admission, Product Review Eligibility, Product Experience and Human Owner Acceptance without Mate60 installation;
- all real-device claims remain forbidden until the future post-1.0 real-device Goal passes;
- privacy and no-silent-cloud-fallback semantics remain frozen and are not weakened.

## Preserved product intent

The customer value remains voice capture + enrolled-speaker trust semantics attached to the Agent-first product. The simulator Goal must still demonstrate permission/capture states, transcript/verification result semantics, trust gating, candidate correction/reject/confirm, error recovery and Agent-context preservation.

## Invalidation

Per DELIVERY-LIFECYCLE-1.0, this Contract change invalidates the prior GOAL-KK-02 Engineering Handoff and any downstream candidate state. Existing Engineering work may be reused only as an exact successor preimage under a new handoff; no prior ENGINEERING_READY exists to transfer.

## Successor authority

Product Governance must freeze CONTRACT-R2.md and ENGINEERING_HANDOFF_R2.md before Engineering resumes.