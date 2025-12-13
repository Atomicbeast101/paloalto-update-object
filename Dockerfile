FROM alpine:3.22

# Dependencies
COPY packages.txt /tmp/packages.txt
RUN apk update && apk add --no-cache $(awk '{print $1}' /tmp/packages.txt)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Environment Variables
ENV REQUIRED_VARS="FIREWALL_HOST FIREWALL_USERNAME FIREWALL_PASSWORD FIREWALL_OBJECT_NAME PUSHOVER_USER_KEY PUSHOVER_APP_TOKEN"
ENV CRON_SCHEDULE="0 0 * * *"
ENV SFTP_PORT=22

# Start App
WORKDIR /app
COPY requirements.txt .
COPY requirements.yml .
COPY playbook.yml .
COPY *.sh .
RUN chmod +x /app/*.sh && chown appuser:appgroup /app -R
USER appuser
ENTRYPOINT ["./entrypoint.sh"]
CMD ["supercronic", "-json", "/app/cronjob"]
