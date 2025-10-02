#!/bin/bash
# Crear los tres ambientes
kubectl create namespace dev
kubectl create namespace staging
kubectl create namespace prod
# Verificar
kubectl get namespaces

# Crear directorios
mkdir -p k8s/dev k8s/staging k8s/prod