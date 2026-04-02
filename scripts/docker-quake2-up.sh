#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="${ROOT_DIR}/docker/quake2/docker-compose.yml"

bash "${ROOT_DIR}/scripts/docker-quake2-sync-mod.sh"

echo "[kots2007] Starting dedicated Quake2 server container"
docker compose -f "${COMPOSE_FILE}" up -d

echo "[kots2007] Current container status"
docker compose -f "${COMPOSE_FILE}" ps

echo "[kots2007] Tail logs (Ctrl+C to stop viewing)"
docker compose -f "${COMPOSE_FILE}" logs -f --tail=100
