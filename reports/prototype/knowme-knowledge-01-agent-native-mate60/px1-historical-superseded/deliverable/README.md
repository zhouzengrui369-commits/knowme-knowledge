# Self-contained deliverable — KnowME-Knowledge-01-Prototype.html

Built from engineering successor candidate
`0e859d93960e630965a5b71a3ff4c07e631d8570` (PX Findings Correction R1,
PR #12) — `npm run build`, then JS/CSS inlined into a single HTML; no
external asset references (verified by build assertion and by the assertion
suite).

```text
HTML_SHA256=9db96a26a6821c134d2ca543ebd5016f0654ac60bc6eb48976ceb4e3cd6a2a02
SOURCE_CANDIDATE_SHA=0e859d93960e630965a5b71a3ff4c07e631d8570
SOURCE_CANDIDATE_TREE=f93f4cfa9c539c22873e228df2738a21cb2bd1b9
```

- Opens directly via `file://` (no dev server required).
- `file-protocol-assertions.json`: full 115/115 Playwright assertion run
  against the `file://` URL of this exact file (2026-09-16), including all
  KK-PX-R5-01..04 acceptance checks; console/page errors empty.
