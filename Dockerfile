ARG URL=https://github.com
ARG OWNER=Atomicbeast101
ARG REPO_NAME=unknown
ARG VERSION=0000.00.00
FROM alpine:3.22
LABEL org.opencontainers.image.source=${URL}/${OWNER}/${REPO_NAME}
LABEL org.opencontainers.image.version=${VERSION}

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
CMD ["/usr/bin/supercronic", "-json", "/app/crontab"]
