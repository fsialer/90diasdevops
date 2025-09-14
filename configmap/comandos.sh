#!/bin/bash

# Desde valores literales
kubectl create configmap app-config \
  --from-literal=database_url=mysql://db:3306/myapp \
  --from-literal=debug_mode=true \
  --from-literal=max_connections=100

# Desde archivo
echo "log_level=info
cache_size=512MB
timeout=30s" > app.properties

kubectl create configmap app-config-file --from-file=app.properties


# Aplicar el ConfigMap
kubectl apply -f configmap.yml

# Ver ConfigMaps
kubectl get configmaps
kubectl describe configmap app-config