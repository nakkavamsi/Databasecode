#!/bin/bash
# Cursor afterFileEdit hook: stamp new migration SQL files with a unique Migration-Id.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INPUT="$(cat)"

FILE_PATH="$(printf '%s' "$INPUT" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("file_path",""))')"

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

case "$FILE_PATH" in
  *Deployments/Migrations/*/*.sql)
    python3 "$ROOT/scripts/stamp-migration-id.py" --quiet "$FILE_PATH" || true
    ;;
esac

exit 0
