#!/bin/bash

echo "Cleaning up metrics-app deployment..."

# Kill any kubectl port-forward processes
echo "Killing kubectl port-forward processes..."
pkill -f "kubectl port-forward"

# Kill any processes using port 8080
echo "Killing processes using port 8080..."
lsof -ti:8080 | xargs kill -9 2>/dev/null || true

# Uninstall Helm release
echo "Uninstalling Helm release..."
helm uninstall metrics-app 2>/dev/null || true

# Delete ArgoCD application
echo "Deleting ArgoCD application..."
kubectl delete -f argocd-app.yaml 2>/dev/null || true

# Delete KIND cluster
echo "Deleting KIND cluster..."
kind delete cluster --name metrics-cluster 2>/dev/null || true

# Wait for processes to be killed
sleep 2

# Verify no processes are running on port 8080
if lsof -i:8080 >/dev/null 2>&1; then
    echo "Warning: Some processes are still using port 8080"
    lsof -i:8080
else
    echo "Port 8080 is now free"
fi

echo "Cleanup complete!" 