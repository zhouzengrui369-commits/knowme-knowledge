# SUPERSEDED NOTICE — R1 Evidence Package

```text
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
HISTORICAL_RECEIPT_REWRITE=NO
SUPERSEDED_FOR_ENGINEERING_EVIDENCE_BINDING=YES
SUPERSEDED_BY=reports/prototype/knowme-knowledge-01-agent-native-mate60/ (R2, same branch)
SUPERSEDING_CANDIDATE_SHA=9f3071e22def4f99cbf3a4589349e628e9e15a97
```

Everything in this directory is a byte-identical restore of the R1 evidence
package as committed in `d8290e7a216b647ec2853f9f4522d97f77129281`
(reports/ tree), produced against R1 operated candidate
`fb432162e7dd099a32fec7b52ff00659982942f3`.

History, for the record:

1. R1 terminal receipt declared `ENGINEERING_READY` for candidate
   `d8290e7…` (Issue #3 comment 5691532300).
2. Product Governance blocked admission with
   `FINAL_EXACT_CANDIDATE_OPERATION_EVIDENCE_IDENTITY_MISMATCH`
   (Issue #3 comment 5691624112): the operation evidence was bound to the
   parent commit `fb43216…`, not to the final exact candidate `d8290e7…`.
3. Governance required: evidence bytes outside the candidate; a fresh
   successor candidate; brand-new operation evidence on the final exact SHA.
4. Before the R2 loop ran, the Owner personally reviewed the prototype and
   directed four product modifications (continuous background sensing,
   knowledge calendar view, knowledge navigation, visual calendar linking
   for schedule/todo). Per the governance blocker's own rule, product
   modification exits the evidence-only lane; R2 therefore produced an
   entirely new successor candidate `9f3071e…` and an entirely new evidence
   set.

The R1 receipts below are preserved unmodified as historical fact. They are
**not** valid engineering evidence for the current candidate. Do not cite
them for admission of `9f3071e…`.
