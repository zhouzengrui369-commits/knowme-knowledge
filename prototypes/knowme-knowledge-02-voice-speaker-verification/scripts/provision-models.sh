#!/bin/bash
# GOAL-KK-02 — model provisioning (runtime asset, NOT committed to git).
# Downloads the exact pinned speaker-embedding model into the app rawfile dir
# and verifies its sha256 before any build. Prototype evidence records these
# identities; the bytes themselves stay out of GitHub (repo hygiene) and
# on-device only (privacy boundary).
set -euo pipefail
cd "$(dirname "$0")/.."

MODEL_NAME="3dspeaker_speech_eres2net_base_200k_sv_zh-cn_16k-common.onnx"
MODEL_SHA256="e2d2048292e055f7b61cdec3db010503f35369b245bf0b3bbad021c9a91e4053"
DEST="entry/src/main/resources/rawfile/models/${MODEL_NAME}"

# Primary: k2-fsa GitHub release asset. Mirror: csukuangfj HF repo (same bytes).
URL_PRIMARY="https://github.com/k2-fsa/sherpa-onnx/releases/download/speaker-recongition-models/${MODEL_NAME}"
URL_MIRROR="https://hf-mirror.com/csukuangfj/speaker-embedding-models/resolve/main/${MODEL_NAME}"

check() {
  if [ -f "${DEST}" ]; then
    echo "$(shasum -a 256 "${DEST}" | awk '{print $1}')" | grep -qx "${MODEL_SHA256}"
  else
    return 1
  fi
}

if check; then
  echo "model already provisioned: ${DEST} (sha256 OK)"
  exit 0
fi

mkdir -p "$(dirname "${DEST}")"
for url in "${URL_MIRROR}" "${URL_PRIMARY}"; do
  echo "downloading ${MODEL_NAME} from ${url}"
  curl -sL --retry 3 -C - -o "${DEST}" "${url}" && check && break
  echo "source failed or hash mismatch, trying next"
done

if ! check; then
  echo "PROVISION FAILED: sha256 mismatch or download incomplete" >&2
  exit 1
fi
echo "provisioned ${DEST}"
echo "sha256 ${MODEL_SHA256}"
