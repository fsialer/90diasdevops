#!/bin/bash
# Crear ambientes
kubectl create namespace ecommerce-dev
kubectl create namespace ecommerce-staging
kubectl create namespace ecommerce-prod

# Verificar
kubectl get namespaces | grep ecommerce

# crear secretos
kubectl create secret generic postgres-secret \
  --from-literal=POSTGRES_PASSWORD=devops2024 \
  --from-literal=POSTGRES_USER=ecommerce_user \
  --from-literal=POSTGRES_DB=ecommerce_db \
  -n ecommerce-dev

# Construir imagen
cd apps/backend
docker build -t ecommerce-backend:latest .
cd ../..

# Aplicar deployment
kubectl apply -f k8s/backend/backend.yaml

# Verificar
kubectl get pods -n ecommerce-dev -l app=backend
kubectl logs -f -l app=backend -n ecommerce-dev

# Construir imagen
cd apps/frontend
docker build -t ecommerce-frontend:latest .
cd ../..

# Aplicar deployment
kubectl apply -f k8s/frontend/frontend.yaml

# Verificar
kubectl get pods -n ecommerce-dev -l app=frontend
kubectl get svc -n ecommerce-dev

# Instalar con Helm
helm install ecommerce ./helm-charts/ecommerce \
  --values ./helm-charts/ecommerce/values/dev.yaml

# Verificar
helm list
kubectl get all -n ecommerce-dev

# Upgrade si necesitas cambios
helm upgrade ecommerce ./helm-charts/ecommerce \
  --values ./helm-charts/ecommerce/values/dev.yaml

# Pasos para obtener kubeconfig
cp ~/.kube/config kubeconfig-ngrok.yaml