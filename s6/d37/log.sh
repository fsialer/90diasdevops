#!/bin/bash
# Logs de desarrollo
kubectl logs -n dev -l app=mi-app --tail=20

# Logs de staging
kubectl logs -n staging -l app=mi-app --tail=20

# Logs de producción
kubectl logs -n prod -l app=mi-app --tail=20