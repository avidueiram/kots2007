#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${IMAGE_NAME:-kots2007-linux-build}"
DOCKERFILE="${DOCKERFILE:-docker/linux-build.Dockerfile}"

# Default build command can be overridden by passing args:
#   bash scripts/docker-build.sh make -C game all
if [ "$#" -gt 0 ]; then
  BUILD_CMD=("$@")
else
  BUILD_CMD=(make -C game)
fi

echo "[kots2007] Building Docker image: ${IMAGE_NAME}"
docker build -f "${ROOT_DIR}/${DOCKERFILE}" -t "${IMAGE_NAME}" "${ROOT_DIR}"

echo "[kots2007] Running build command in container: ${BUILD_CMD[*]}"
docker run --rm \
  -v "${ROOT_DIR}:/workspace" \
  -w /workspace \
  "${IMAGE_NAME}" \
  "${BUILD_CMD[@]}"
