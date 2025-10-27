#!/bin/bash

echo "🚀 Setting up Self-Healing Infrastructure..."

# Create directories
mkdir -p playbooks

# Install dependencies
echo "📦 Installing dependencies..."
pip3 install flask requests

# Start the stack
echo "🐳 Starting Docker containers..."
docker-compose up -d

# Wait for services to start
echo "⏳ Waiting for services to initialize..."
sleep 30

# Start webhook server in background
echo "🌐 Starting webhook server..."
python3 webhook_server.py &

echo "✅ Setup complete!"
echo "📊 Access services:"
echo "   Prometheus: http://localhost:9090"
echo "   Alertmanager: http://localhost:9093"
echo "   NGINX: http://localhost:8080"
