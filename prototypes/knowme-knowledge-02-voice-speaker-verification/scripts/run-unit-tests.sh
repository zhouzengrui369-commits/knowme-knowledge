#!/bin/bash
# GOAL-KK-02 prototype — build + install + run Hypium unit tests on connected emulator (no GUI, no signing required)
# Usage: scripts/run-unit-tests.sh [test-class-filter]
# Requires: emulator running and visible via `hdc list targets` (e.g. 127.0.0.1:5555)
# Note: hvigor onDeviceTest requires a signed hap for coverage artifacts; this script bypasses that by
#       building the ohosTest package, then installing both unsigned haps (emulator accepts them) and
#       invoking `aa test` directly.
set -euo pipefail
cd "$(dirname "$0")/.."
export DEVECO_SDK_HOME=/Applications/DevEco-Studio.app/Contents/sdk
export NODE_HOME=/Applications/DevEco-Studio.app/Contents/tools/node
export JAVA_HOME=/Applications/DevEco-Studio.app/Contents/jbr/Contents/Home
export PATH="$JAVA_HOME/bin:$NODE_HOME/bin:/Applications/DevEco-Studio.app/Contents/tools/ohpm/bin:/Applications/DevEco-Studio.app/Contents/tools/hvigor/bin:$DEVECO_SDK_HOME/default/openharmony/toolchains:$PATH"
BUNDLE=com.knowme.knowledge.voiceprototype

echo "== ohpm install (entry: @ohos/hypium) =="
(cd entry && ohpm install)

echo "== build main hap =="
hvigorw --mode module -p product=default -p buildMode=debug assembleHap --no-daemon >/dev/null

echo "== build ohosTest hap (coverage step failure is expected/benign for unsigned builds) =="
hvigorw --mode module -p module=entry@ohosTest -p product=default -p buildMode=debug onDeviceTest --no-daemon >/dev/null 2>&1 || true
test -f entry/build/default/outputs/ohosTest/entry-ohosTest-unsigned.hap

echo "== install on emulator =="
hdc install -r entry/build/default/outputs/default/entry-default-unsigned.hap
hdc install -r entry/build/default/outputs/ohosTest/entry-ohosTest-unsigned.hap

echo "== run tests =="
EXTRA=""
if [ $# -ge 1 ]; then EXTRA="-s class $1"; fi
hdc shell "aa test -b $BUNDLE -m entry_test -s unittest OpenHarmonyTestRunner -s timeout 15000 $EXTRA" | tee /tmp/kk02-aatest.log
grep -E "^OHOS_REPORT_RESULT" /tmp/kk02-aatest.log
