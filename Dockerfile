# ============================================================
#  3x-ui Panel — Railway Deployment
#  Uses the OFFICIAL image (ghcr.io/mhsanaei/3x-ui:latest)
#  => Every Railway build automatically pulls the latest
#     official release (currently v3.8.5).
# ============================================================
FROM ghcr.io/mhsanaei/3x-ui:latest

# fail2ban requires NET_ADMIN capability which Railway does not
# grant, so it must be disabled (the official entrypoint checks
# this env var and skips fail2ban when it is not "true").
ENV XUI_ENABLE_FAIL2BAN="false"

# Startup wrapper: aligns the panel port with Railway's assigned
# port, then hands over to the official entrypoint.
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Default panel port of 3x-ui (Railway also accepts PORT env)
EXPOSE 2053

# Keep the official entrypoint flow (DockerEntrypoint.sh ends
# with `exec /app/x-ui`), but route it through our wrapper first.
ENTRYPOINT ["/app/start.sh"]
