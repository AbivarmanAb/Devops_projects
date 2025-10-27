#!/bin/bash

echo "🔴 Simulating NGINX failure..."
docker stop selfhealing-nginx

echo "⏳ Waiting for alert to trigger..."
sleep 25

echo "🔍 Checking alerts in Alertmanager..."
curl -s http://localhost:9093/api/v2/alerts | jq '.[] | {alertname: .labels.alertname, state: .status.state}'

echo "📋 Checking webhook logs..."
tail -n 10 webhook.log

echo "🔄 Checking NGINX status..."
docker ps | grep nginx
