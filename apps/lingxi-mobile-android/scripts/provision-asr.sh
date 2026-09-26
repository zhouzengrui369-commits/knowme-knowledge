#!/bin/bash
# provision-asr.sh — 获取 sherpa-onnx AAR 与本机中文 ASR 模型资源
# 来源固定 + sha256 校验；文件不进 Git；缺失时构建/运行时如实报 NOT_PROVISIONED。
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LIBS_DIR="$APP_DIR/app/libs"
ASSETS_DIR="$APP_DIR/app/src/main/assets/asr"
DL_DIR="$SCRIPT_DIR/.downloads"

AAR_NAME="sherpa-onnx-1.13.8.aar"
ARCHIVE_URL="https://github.com/k2-fsa/sherpa-onnx/releases/download/v1.13.8/sherpa-onnx-v1.13.8-android.tar.bz2"

# Zipformer 中英双语流式 small（J13 参照模型；版本/文件名冻结，hash 在下载后打印待录入回执）
MODEL_URL="https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-streaming-zipformer-bilingual-zh-en-2023-02-20.tar.bz2"

mkdir -p "$LIBS_DIR" "$ASSETS_DIR" "$DL_DIR"

echo "== 1/2 sherpa-onnx AAR =="
if [ -f "$LIBS_DIR/$AAR_NAME" ]; then
  echo "already present: $LIBS_DIR/$AAR_NAME"
else
  curl -sL --retry 3 -o "$DL_DIR/sherpa-android.tar.bz2" "$ARCHIVE_URL"
  tar -xjf "$DL_DIR/sherpa-android.tar.bz2" -C "$DL_DIR"
  find "$DL_DIR" -name "*.aar" -exec cp {} "$LIBS_DIR/$AAR_NAME" \;
fi
shasum -a 256 "$LIBS_DIR/$AAR_NAME"

echo "== 2/2 ASR 模型（随包预置）=="
if [ -f "$ASSETS_DIR/encoder.onnx" ]; then
  echo "already present"
else
  curl -sL --retry 3 -o "$DL_DIR/asr-model.tar.bz2" "$MODEL_URL"
  tar -xjf "$DL_DIR/asr-model.tar.bz2" -C "$DL_DIR"
  MODEL_ROOT="$(find "$DL_DIR" -name "tokens.txt" -path "*zipformer*" | head -1 | xargs dirname)"
  cp "$MODEL_ROOT/encoder"*.onnx "$ASSETS_DIR/encoder.onnx" 2>/dev/null || cp "$MODEL_ROOT/encoder.onnx" "$ASSETS_DIR/encoder.onnx"
  cp "$MODEL_ROOT/decoder.onnx" "$ASSETS_DIR/decoder.onnx"
  cp "$MODEL_ROOT/joiner.onnx" "$ASSETS_DIR/joiner.onnx"
  cp "$MODEL_ROOT/tokens.txt" "$ASSETS_DIR/tokens.txt"
fi
shasum -a 256 "$ASSETS_DIR"/*.onnx "$ASSETS_DIR/tokens.txt"

echo "DONE. 把以上 sha256 抄入 CANONICAL_ARTIFACT_RECEIPT.md"
