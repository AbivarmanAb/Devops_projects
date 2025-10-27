#!/bin/bash

echo "🧹 Cleaning up..."

# Stop webhook server
if [ -f webhook.pid ]; then
    kill $(cat webhook.pid) 2>/dev/null
    rm webhook.pid
fi

# Stop containers
docker-compose down

echo "✅ Cleanup complete!"
