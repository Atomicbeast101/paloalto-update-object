#!/bin/sh

# Check required environment variables
for var in $REQUIRED_VARS; do
    if [ -z "$(eval echo \$$var)" ]; then
        echo "❌ ERROR: Required environment variable '$var' is not set."
        exit 1
    fi
done
echo "✅ All required environment variables are set."

# Setup .env environment
echo "Setting up environment..."
./setup.sh

# Configure cron schedule
echo "Scheduling backup job..."
echo "$CRON_SCHEDULE cd /app && /app/run.sh >> /var/log/cron.log 2>&1" > /etc/crontabs/root

# Load all env variables to /etc/environment for cron to access
printenv > /etc/environment

# Run cron in foreground
echo "Started cron job!"
exec crond -f && tail -f /var/log/cron.log
