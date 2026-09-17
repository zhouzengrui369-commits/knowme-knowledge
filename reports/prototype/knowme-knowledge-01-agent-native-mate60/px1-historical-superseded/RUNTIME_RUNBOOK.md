# Runtime Runbook — GOAL-KK-01 PX Findings Correction R1 candidate

```text
CANDIDATE_SHA=0e859d93960e630965a5b71a3ff4c07e631d8570
ENGINEERING_BRANCH=engineering/goal-kk-01-px-findings-correction-r1
```

## Materialize and run

```bash
git clone --branch engineering/goal-kk-01-px-findings-correction-r1 --single-branch \
  https://github.com/zhouzengrui369-commits/knowme-knowledge.git <dir>
cd <dir> && git rev-parse HEAD        # must equal 0e859d93960e630965a5b71a3ff4c07e631d8570
cd prototypes/knowme-knowledge-01-agent-native-mate60
npm ci
npm run build                          # vite build, ~0.5–1s
npm run dev -- --port 5173 --strictPort
```

Local Executor used port 5174; ED used 5173. When stopping, kill the port
explicitly (`lsof -ti :5173 | xargs kill`): the npm wrapper exits before its
vite child.

## Browser technical assertions

```bash
python3 tests/browser_assertions.py \
  --url http://127.0.0.1:5173 \
  --out <receipt.json> [--shots <screenshot_dir> --prefix PX1-ED]
```

Expected: 115/115 assertions pass, empty console/page error arrays, exit
code 0. Viewport 360x780, recorded as MATE60_CLASS_SIMULATION.

## Self-contained review artifact

`deliverable/KnowME-Knowledge-01-Prototype.html` opens directly via `file://`
(no server). Verify with:

```bash
python3 tests/browser_assertions.py --url "file://<absolute path>/KnowME-Knowledge-01-Prototype.html" --out <receipt.json>
shasum -a 256 KnowME-Knowledge-01-Prototype.html
# expect 9db96a26a6821c134d2ca543ebd5016f0654ac60bc6eb48976ceb4e3cd6a2a02
```

## PX acceptance smoke path (manual)

1. Capture+confirm two distinct topics (e.g. 读书笔记复核… / 健身计划…);
   ask each by exact title and natural wording → answers bind to own item,
   honest no-conclusion note, no AOG/ABC leakage (KK-PX-R5-01).
2. Open Knowledge / detail / work surface / Calendar / Todo → in-sheet
   sensing bar visible with 模拟·无真实 ASR; 暂停/恢复 works and syncs with
   the global strip (KK-PX-R5-02).
3. Capture → 修正 → 保存修正 → returns to candidate card (count unchanged)
   → 确认入库 → ingests; confirmed item shows 已确认, never 待确认; reject
   does not grow knowledge (KK-PX-R5-03).
4. Knowledge nav → item → work surface → 「返回 Agent 对话」 lands on the
   conversation; Agent next action → detail → work surface → same; context
   preserved (KK-PX-R5-04).
