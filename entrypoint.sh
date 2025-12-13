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
./setup.sh

# Configure cron schedule
echo "Scheduling backup job..."
echo "$CRON_SCHEDULE /app/run.sh" > /app/crontab
echo "Backup job scheduled!"

# Run from CMD or "docker run"/"kubectl run"
exec "$@"
