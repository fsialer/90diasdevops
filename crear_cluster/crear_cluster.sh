#!/bin/bash
# Crear cluster
kind create cluster --config kind-config.yml

# Verificar que funciona
kubectl get nodes