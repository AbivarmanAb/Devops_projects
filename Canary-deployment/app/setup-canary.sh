#!/bin/bash

set -e

echo "Setting up Canary Deployment with K3s and Istio..."

# Install K3s
echo "Installing K3s..."
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik" sh -
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config
export KUBECONFIG=~/.kube/config

# Install Istio
echo "Installing Istio..."
curl -L https://istio.io/downloadIstio | sh -
cd istio-*
sudo cp bin/istioctl /usr/local/bin/
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled
kubectl apply -f samples/addons/

# Wait for Istio components to be ready
echo "Waiting for Istio components..."
kubectl wait --for=condition=ready pod -l app=istio-ingressgateway -n istio-system --timeout=300s

# Deploy application
echo "Deploying application..."
kubectl apply -f ../K3s/

echo "Setup completed!"
echo "Get the ingress IP: kubectl get svc -n istio-system istio-ingressgateway"
