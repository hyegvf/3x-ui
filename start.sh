#!/bin/sh
# ============================================================
# 3x-ui on Railway — startup wrapper (hardened)
# 1. Railway injects the target port via $PORT.
# 2. `/app/x-ui setting -port` initializes the SQLite database
#    (creates tables + default admin/admin user on first run)
#    and sets the panel port to match Railway routing.
# 3. Hands over to the official DockerEntrypoint.sh, which
#    finally `exec`s /app/x-ui.
# ============================================================

PANEL_PORT="${PORT:-2053}"

# Safety: if $PORT is missing/non-numeric/out of range, fall back to 2053
if ! [ "$PANEL_PORT" -ge 1 ] 2>/dev/null || ! [ "$PANEL_PORT" -le 65535 ] 2>/dev/null; then
    echo "[start.sh] PORT='$PORT' is not a valid port, falling back to 2053"
    PANEL_PORT="2053"
fi

echo "[start.sh] Configuring 3x-ui panel port -> ${PANEL_PORT}"
if /app/x-ui setting -port "${PANEL_PORT}"; then
    echo "[start.sh] Panel port configured successfully"
else
    echo "[start.sh] WARNING: could not pre-set port; fresh DB will use default (2053)"
fi

echo "[start.sh] Launching official 3x-ui entrypoint..."
exec /app/DockerEntrypoint.sh
