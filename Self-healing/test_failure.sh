#!/bin/bash

echo "🔴 Simulating NGINX failure..."
docker stop selfhealing-nginx-1

echo "⏳ Waiting for alert to trigger..."
sleep 30

echo "🔍 Checking alerts..."
curl -s http://localhost:9093/api/v2/alerts | jq .

echo "📋 Checking logs..."
tail -n 20 nohup.out
