# Runtime Runbook — GOAL-KK-01 Prototype (R2, final exact candidate)

```text
ARTIFACT=RUNTIME_RUNBOOK
ACTOR_ROLE=ENGINEERING_DELIVERY
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
OPERATED_CANDIDATE_SHA=9f3071e22def4f99cbf3a4589349e628e9e15a97
OPERATED_CANDIDATE_TREE=b165a075f4e6a3784c6fc7794fc8c5581dc539c0
PROTOTYPE_DIR=prototypes/knowme-knowledge-01-agent-native-mate60
```

## Prerequisites

- Node.js 18+ (verified on v24.15.0) and npm
- For browser assertions: Python 3.13 with Playwright + Chromium
  (verified interpreter: `/opt/homebrew/opt/python@3.13/bin/python3.13`)

## Materialize the exact candidate

```bash
git clone https://github.com/zhouzengrui369-commits/knowme-knowledge.git
cd knowme-knowledge
git checkout 9f3071e22def4f99cbf3a4589349e628e9e15a97
git rev-parse HEAD        # 9f3071e22def4f99cbf3a4589349e628e9e15a97
git rev-parse HEAD^{tree} # b165a075f4e6a3784c6fc7794fc8c5581dc539c0
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
`npm run dev -- --port 5174 --strictPort` (record the actual URL in any
evidence). When stopping, kill the port explicitly
(`lsof -ti :5173 | xargs kill`): the npm wrapper exits before its vite
child, which otherwise lingers.

## Browser technical assertions

With the product running:

```bash
python3 tests/browser_assertions.py \
  --url http://127.0.0.1:5173 \
  --out <receipt.json> [--shots <screenshot_dir> --prefix R2-ED]
```

Expected: 57/57 assertions pass, empty console/page error arrays, exit
code 0. Viewport is fixed at 360x780 and recorded as
MATE60_CLASS_SIMULATION (browser simulation, not an on-device measurement).

## Journey smoke path (manual)

1. Cold open → Agent identity, disclosure pill, **sensing strip
   (后台持续感知中, ticking, 模拟感知 · 无真实 ASR)**, context strip,
   known/unknown chips (Journey A). Mic key pauses/resumes sensing.
2. Ask `ABC 供应商延迟会影响什么?` → referenced mock answer + next-action
   button (Journey B).
3. 捕获 → type text → 生成候选知识 → 确认入库 / 修正 / 拒绝 (Journey C).
4. 知识 → **知识导航** tab (MOC/WIKI/NOTE) ↔ **按日历查看** tab (day groups;
   today's confirmed capture under 今天) → open item → 来源与状态 →
   打开上下文工作面 → 返回 (Journey D).
5. 日历 (**week strip, day switch, 当日关联待办**) / 待办 (toggle +
   **日历深链**) / 技能 (PLANNED) (Journey E).
6. Close everything → conversation and sensing strip fully preserved.

## Known runtime notes

- All state is in-memory; reload resets the prototype (allowed limitation
  NO_REAL_PERSISTENCE_REQUIRED).
- The sensing stream is a local timer with simulated text; no microphone
  access is requested or used.
- No network calls, no credentials, no real Owner data.
