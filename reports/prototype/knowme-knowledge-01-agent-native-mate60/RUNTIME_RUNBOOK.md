# Runtime Runbook — GOAL-KK-01 Prototype

```text
ARTIFACT=RUNTIME_RUNBOOK
ACTOR_ROLE=ENGINEERING_DELIVERY
OPERATED_CANDIDATE_SHA=fb432162e7dd099a32fec7b52ff00659982942f3
PROTOTYPE_DIR=prototypes/knowme-knowledge-01-agent-native-mate60
```

## Prerequisites

- Node.js 18+ (verified on v24.15.0) and npm
- For browser assertions: Python 3.13 with Playwright + Chromium
  (verified interpreter: `/opt/homebrew/opt/python@3.13/bin/python3.13`,
  Playwright 1.61.0, system chromium cache)

## Materialize the exact candidate

```bash
git clone https://github.com/zhouzengrui369-commits/knowme-knowledge.git
cd knowme-knowledge
git checkout fb432162e7dd099a32fec7b52ff00659982942f3
git rev-parse HEAD        # fb432162e7dd099a32fec7b52ff00659982942f3
git rev-parse HEAD^{tree} # aed8058e5139948fbf8c4a3152a8fbf122ce8b5a
```

## Install / build / run

```bash
cd prototypes/knowme-knowledge-01-agent-native-mate60
npm ci          # lockfile-pinned install (62 packages)
npm run build   # vite build -> dist/
npm run dev     # dev server, default http://127.0.0.1:5173
# or: npm run preview  # serves dist/ at http://127.0.0.1:4173
```

If port 5173 is occupied, pass another port:
`npm run dev -- --port 5174 --strictPort` (Local Executor did exactly this;
record the actual URL in any evidence).

## Browser technical assertions

With the product running:

```bash
python3 tests/browser_assertions.py \
  --url http://127.0.0.1:5173 \
  --out <receipt.json> [--shots <screenshot_dir> --prefix ED]
```

Expected: 41/41 assertions pass, empty console/page error arrays, exit code 0.
Viewport is fixed at 360x780 and recorded as MATE60_CLASS_SIMULATION
(browser simulation, not an on-device measurement).

## Journey smoke path (manual)

1. Cold open → Agent identity, disclosure pill, context strip, known/unknown chips (Journey A).
2. Ask `ABC 供应商延迟会影响什么?` → referenced mock answer + next-action button (Journey B).
3. 捕获 → type text → 生成候选知识 → 确认入库 / 修正 / 拒绝 (Journey C).
4. 知识 → open item → 来源与状态 → 打开上下文工作面 → 返回 (Journey D).
5. 日历 / 待办 (NOT_CONNECTED mock work surfaces) · 技能 (PLANNED) (Journey E).

## Known runtime notes

- All state is in-memory; reload resets the prototype (allowed limitation
  NO_REAL_PERSISTENCE_REQUIRED).
- No network calls, no credentials, no real Owner data.
