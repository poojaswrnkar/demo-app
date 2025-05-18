# Metrics App Deployment Guide

This guide will help you deploy the metrics-app using Helm, KIND, and ArgoCD.

## Prerequisites

Make sure you have the following installed:

- Docker
- kubectl
- kind
- helm
- curl

## Step 1: Set up KIND Cluster and ArgoCD

1. Make the setup script executable:

```bash
chmod +x setup-cluster.sh
```

2. Run the setup script:

```bash
./setup-cluster.sh
```

This will:

- Create a KIND cluster
- Install NGINX ingress controller
- Install ArgoCD
- Display the ArgoCD admin password
- Set up port forwarding for ArgoCD UI

## Step 2: Access ArgoCD UI

1. Open your browser and go to:

```
https://localhost:8080
```

2. Login with:

- Username: admin
- Password: (use the password displayed in terminal after running setup-cluster.sh)

## Step 3: Deploy the Application

### Option 1: Using Helm Directly

1. Navigate to the metrics-app directory:

```bash
cd metrics-app
```

2. Install the Helm chart:

```bash
helm install metrics-app .
```

3. Verify the deployment:

```bash
kubectl get pods
```

### Option 2: Using ArgoCD

1. Apply the ArgoCD application manifest:

```bash
kubectl apply -f argocd-app.yaml
```

2. Check the application status in ArgoCD UI or using:

```bash
kubectl get applications -n argocd
```

## Step 4: Test the Application

1. Check if the pod is running:

```bash
kubectl get pods
```

2. Check if the service is created:

```bash
kubectl get svc
```

3. Check if the ingress is configured:

```bash
kubectl get ingress
```

4. Test the counter endpoint:

```bash
# If using ingress
curl localhost/counter

# If using port-forward
kubectl port-forward svc/metrics-app 8080:8080
curl localhost:8080/counter
```

5. Test multiple calls to verify counter increments:

```bash
for i in $(seq 0 20)
do
  time curl localhost/counter
done
```

## Troubleshooting

### If pod is not running:

```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### If service is not accessible:

```bash
kubectl describe svc metrics-app
```

### If ingress is not working:

```bash
kubectl describe ingress
```

### If port 8080 is already in use:

```bash
# Find the process using port 8080
lsof -i :8080

# Kill the process
kill <process-id>
```

## Cleanup

To remove the deployment:

```bash
# If using Helm
helm uninstall metrics-app

# If using ArgoCD
kubectl delete -f argocd-app.yaml
```

To delete the KIND cluster:

```bash
kind delete cluster --name metrics-cluster
```
