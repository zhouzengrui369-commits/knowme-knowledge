#!/bin/bash
# GOAL-KK-02 prototype — local build helper (DevEco CLI, no GUI required)
set -euo pipefail
cd "$(dirname "$0")/.."
export DEVECO_SDK_HOME=/Applications/DevEco-Studio.app/Contents/sdk
export NODE_HOME=/Applications/DevEco-Studio.app/Contents/tools/node
export JAVA_HOME=/Applications/DevEco-Studio.app/Contents/jbr/Contents/Home
export PATH="$JAVA_HOME/bin:$NODE_HOME/bin:/Applications/DevEco-Studio.app/Contents/tools/ohpm/bin:/Applications/DevEco-Studio.app/Contents/tools/hvigor/bin:$PATH"
ohpm install
hvigorw --mode module -p product=default -p buildMode="${BUILD_MODE:-debug}" assembleHap --no-daemon
ls -la entry/build/default/outputs/default/*.hap
