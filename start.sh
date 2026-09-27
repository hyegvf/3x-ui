#!/bin/sh
# ============================================================
# 3x-ui on Railway — startup wrapper
# 1. Railway injects the target port via $PORT.
# 2. `/app/x-ui setting -port` initializes the SQLite database
#    (creates tables + default admin/admin user on first run)
#    and sets the panel port to match Railway routing.
# 3. Hands over to the official DockerEntrypoint.sh, which
#    finally `exec`s /app/x-ui.
# ============================================================

PANEL_PORT="${PORT:-2053}"

echo "[start.sh] Configuring 3x-ui panel port -> ${PANEL_PORT}"
/app/x-ui setting -port "${PANEL_PORT}" || echo "[start.sh] WARNING: could not pre-set port (fresh DB will default to it on first boot)"

echo "[start.sh] Launching official 3x-ui entrypoint..."
exec /app/DockerEntrypoint.sh
