#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${IMAGE_NAME:-kots2007-linux-build-musl}"
DOCKERFILE="${DOCKERFILE:-docker/linux-build-musl.Dockerfile}"

if [ "$#" -gt 0 ]; then
  BUILD_CMD=("$@")
else
  BUILD_CMD=(make -C game clean all)
fi

echo "[kots2007] Building musl Docker image: ${IMAGE_NAME}"
docker build -f "${ROOT_DIR}/${DOCKERFILE}" -t "${IMAGE_NAME}" "${ROOT_DIR}"

echo "[kots2007] Running build command in musl container: ${BUILD_CMD[*]}"
docker run --rm \
  -v "${ROOT_DIR}:/workspace" \
  -w /workspace \
  "${IMAGE_NAME}" \
  "${BUILD_CMD[@]}"
