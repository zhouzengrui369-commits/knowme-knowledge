# Runtime Runbook — GOAL-KK-01 Prototype (R5, final exact candidate)

```text
ARTIFACT=RUNTIME_RUNBOOK
ACTOR_ROLE=ENGINEERING_DELIVERY
EVIDENCE_CHANNEL_ROLE=NON_CANDIDATE_EVIDENCE
EVIDENCE_COMMIT_IS_CANDIDATE=NO
MOVE_PR9_HEAD=NO
OPERATED_CANDIDATE_SHA=40063afd16a36674e8660f6b4a05315d51f4e546
OPERATED_CANDIDATE_TREE=72464ee6727af4837cb24b77238f7ddadeca02ed
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
git checkout 40063afd16a36674e8660f6b4a05315d51f4e546
git rev-parse HEAD        # 40063afd16a36674e8660f6b4a05315d51f4e546
git rev-parse HEAD^{tree} # 72464ee6727af4837cb24b77238f7ddadeca02ed
```

## Install / build / run

```bash
cd prototypes/knowme-knowledge-01-agent-native-mate60
npm ci          # lockfile-pinned install (62 packages)
npm run build   # vite build -> dist/
npm run dev     # dev server, default http://127.0.0.1:5173
```

If port 5173 is occupied, pass another port:
`npm run dev -- --port 5174 --strictPort` (Local Executor did exactly this;
record the actual URL in any evidence). When stopping, kill the port
explicitly (`lsof -ti :5173 | xargs kill`): the npm wrapper exits before its
vite child, which otherwise lingers.

## Browser technical assertions

```bash
python3 tests/browser_assertions.py \
  --url http://127.0.0.1:5173 \
  --out <receipt.json> [--shots <screenshot_dir> --prefix R5-ED]
```

Expected: 80/80 assertions pass, empty console/page error arrays, exit
code 0. Viewport 360x780, recorded as MATE60_CLASS_SIMULATION.

## Journey smoke path (manual)

1. Cold open → Agent identity, disclosure pill, sensing strip (ticking,
   honest mock label), context strip, known/unknown chips (Journey A).
2. Ask `ABC 供应商延迟会影响什么?` → referenced mock answer + next action
   (Journey B).
3. 捕获 → type text → 生成候选知识 → 确认入库 / 修正 / 拒绝 (Journey C).
4. 知识 → 知识导航 tab: **五维知识地图** and **九维认知图谱** (tap a
   dimension to expand its real items), MOC/WIKI/NOTE groups; → 按日历查看
   tab: day groups; → open item → 来源与状态 → 上下文工作面 → 返回
   (Journey D).
5. 日历 → **日/周/月 switcher**: 日 (schedule + 当日关联待办), 周 (Mon–Sun
   rows), 月 (September 2026 grid, today highlight, event dots, tap a day to
   deep-open); 待办 (toggle + 日历深链); 技能 (PLANNED) (Journey E).
6. Close everything → conversation and sensing strip fully preserved.

## Known runtime notes

- All state is in-memory; reload resets (allowed limitation
  NO_REAL_PERSISTENCE_REQUIRED).
- The sensing stream is a local timer with simulated text; no microphone
  access is requested or used.
- Calendar weekday labels are astronomically correct for September 2026
  (2026-09-16 = Wednesday); all calendar data is mock.
- No network calls, no credentials, no real Owner data.
