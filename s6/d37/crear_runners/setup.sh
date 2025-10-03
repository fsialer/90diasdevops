#!/bin/bash
# Añadir repo de Helm
helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller

# Instalar ARC Controller
helm install arc \
    --namespace arc-systems \
    --create-namespace \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller

# Verificar instalación
kubectl get pods -n arc-systems

# Crear namespace para runners
kubectl create namespace arc-runners

# crear secret github
kubectl apply -f secret_github.yml

# Asignar permisos
kubectl apply -f rbac_runner.yml 

# Instalar Runner Scale Set

GITHUB_CONFIG_URL="https://github.com/fsialer/90diasdevops"
export GITHUB_CONFIG_URL

# Instalar runners
helm install mi-runners \
    --namespace arc-runners \
    --set githubConfigUrl="$GITHUB_CONFIG_URL" \
    --set githubConfigSecret=github-auth-secret \
    --set maxRunners=3 \
    --set minRunners=0 \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set

# Verificar
kubectl get pods -n arc-runners