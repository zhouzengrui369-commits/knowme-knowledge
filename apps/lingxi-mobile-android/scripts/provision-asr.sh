#!/bin/bash
# provision-asr.sh — 获取 sherpa-onnx Android 包与随包中文 ASR 模型（可复现）
# 用法：bash scripts/provision-asr.sh
# 产物：app/src/main/jniLibs/arm64-v8a/*.so + app/src/main/assets/asr/{encoder,decoder,joiner}.onnx + tokens.txt
# 来源与 sha256 固定；任意一项校验失败即退出，不许带病构建。
set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JNILIBS="$APP_DIR/app/src/main/jniLibs/arm64-v8a"
ASSETS="$APP_DIR/app/src/main/assets/asr"
DL="$(mktemp -d)"

# ── 1) sherpa-onnx v1.13.8 Android 包（jniLibs）─────────────────────────────
SHERPA_TARBALL="sherpa-onnx-v1.13.8-android.tar.bz2"
SHERPA_URL="https://github.com/k2-fsa/sherpa-onnx/releases/download/v1.13.8/$SHERPA_TARBALL"
SHERPA_TARBALL_SHA256="2ff63469a71cb6009aa2e3ed5f4a670f8abdcbe4bb9ffd23776afc792a6b4f44"

# ── 2) 中文 ASR 模型（mobile 变体，J13 随包预置）──────────────────────────────
MODEL_TARBALL="sherpa-onnx-streaming-zipformer-bilingual-zh-en-2023-02-20-mobile.tar.bz2"
MODEL_URL="https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/$MODEL_TARBALL"
MODEL_TARBALL_SHA256="45b8d04fe8faf5146397ff2e71d90ca8effdfcbe9adc30fdce769e92cabd6b03"

fetch() { # fetch <url> <out>
  curl -sL --retry 3 --max-time 600 -o "$2" "$1"
}

verify() { # verify <file> <sha256>
  local actual
  actual="$(shasum -a 256 "$1" | awk '{print $1}')"
  if [ "$actual" != "$2" ]; then
    echo "SHA256 MISMATCH: $1 实际 $actual 期望 $2" >&2
    exit 1
  fi
}

echo "== 1/2 sherpa-onnx jniLibs =="
if [ -f "$JNILIBS/libsherpa-onnx-jni.so" ]; then
  echo "已存在，跳过"
else
  mkdir -p "$JNILIBS"
  fetch "$SHERPA_URL" "$DL/sherpa.tar.bz2"
  verify "$DL/sherpa.tar.bz2" "$SHERPA_TARBALL_SHA256"
  tar -xjf "$DL/sherpa.tar.bz2" -C "$DL"
  cp "$DL/jniLibs/arm64-v8a/"*.so "$JNILIBS/"
fi
ls -la "$JNILIBS"

echo "== 2/2 ASR 模型（int8 encoder / fp32 decoder / int8 joiner / tokens）=="
if [ -f "$ASSETS/encoder.onnx" ]; then
  echo "已存在，跳过"
else
  mkdir -p "$ASSETS"
  fetch "$MODEL_URL" "$DL/model.tar.bz2"
  verify "$DL/model.tar.bz2" "$MODEL_TARBALL_SHA256"
  tar -xjf "$DL/model.tar.bz2" -C "$DL"
  MR="$DL/sherpa-onnx-streaming-zipformer-bilingual-zh-en-2023-02-20-mobile"
  cp "$MR/encoder-epoch-99-avg-1.int8.onnx" "$ASSETS/encoder.onnx"
  cp "$MR/decoder-epoch-99-avg-1.onnx" "$ASSETS/decoder.onnx"
  cp "$MR/joiner-epoch-99-avg-1.int8.onnx" "$ASSETS/joiner.onnx"
  cp "$MR/tokens.txt" "$ASSETS/tokens.txt"
  cp "$MR/README.md" "$ASSETS/PROVENANCE.md"
fi
shasum -a 256 "$ASSETS"/*.onnx "$ASSETS"/tokens.txt

echo "DONE. 上面的逐文件 sha256 与 tarball 级 sha256 即 CANONICAL_ARTIFACT_RECEIPT 的绑定值。"
