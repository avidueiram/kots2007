#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_SO="${ROOT_DIR}/game/gamei386.so"
TARGET_DIR="${ROOT_DIR}/docker/quake2/config/data/quake2/kots2007"
TARGET_SO="${TARGET_DIR}/gamearm64.so"

if [ ! -f "${SOURCE_SO}" ]; then
  echo "[kots2007] Missing ${SOURCE_SO}. Building first..."
  bash "${ROOT_DIR}/scripts/docker-build.sh" make -C game clean all
fi

mkdir -p "${TARGET_DIR}"
cp "${SOURCE_SO}" "${TARGET_SO}"

echo "[kots2007] Synced module to ${TARGET_SO}"
