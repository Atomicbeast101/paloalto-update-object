FROM alpine:3.22
ARG URL=https://github.com
ARG OWNER=Atomicbeast101
ARG REPO_NAME=unknown
ARG VERSION=0000.00.00
LABEL org.opencontainers.image.source=${URL}/${OWNER}/${REPO_NAME}
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.description="Simple Ansible playbook to automatically update address object's IP address based on results from api.ipify.org. This has been used to automatically update my WAN IP so NAT can still work if public IP gets changed due to modem/router reboots."

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
