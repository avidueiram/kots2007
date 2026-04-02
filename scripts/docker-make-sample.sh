#!/usr/bin/env bash
set -euo pipefail

# Minimal sample wrapper specifically for make.
# Usage examples:
#   bash scripts/docker-make-sample.sh
#   bash scripts/docker-make-sample.sh -C game all

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${IMAGE_NAME:-kots2007-linux-build}"

if [ "$#" -gt 0 ]; then
  MAKE_ARGS=("$@")
else
  MAKE_ARGS=(-C game)
fi

docker run --rm \
  -v "${ROOT_DIR}:/workspace" \
  -w /workspace \
  "${IMAGE_NAME}" \
  make "${MAKE_ARGS[@]}"
