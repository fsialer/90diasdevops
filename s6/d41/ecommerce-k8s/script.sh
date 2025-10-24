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

# Testing completo
# Hacer ejecutable el script
chmod +x scripts/deploy.sh

# Deploy completo
./scripts/deploy.sh dev

# Verificar health checks
kubectl port-forward -n ecommerce-dev svc/backend-service 3000:3000 &
sleep 5
curl http://localhost:3000/health
curl http://localhost:3000/health/ready

# Verificar frontend
kubectl port-forward -n ecommerce-dev svc/frontend-service 8080:80 &
sleep 5
curl http://localhost:8080/health

# Matar port-forwards
pkill -f "kubectl port-forward"

# Ver logs
kubectl logs -f -l app=backend -n ecommerce-dev --tail=10

# Acceso a la aplicación
# Obtener URL de acceso
kubectl get svc -n ecommerce-dev frontend-service

# Si es NodePort (desarrollo)
echo "🌐 Aplicación disponible en: http://localhost:30080"

# Monitorear recursos
kubectl top pods -n ecommerce-dev
kubectl get events -n ecommerce-dev --sort-by='.lastTimestamp'

#Verificación final
# Estado completo del deployment
kubectl get all -n ecommerce-dev

# Health status de todos los servicios  
kubectl get pods -n ecommerce-dev -o wide

# Acceso a la aplicación
echo "✅ E-commerce disponible en: http://localhost:30080"
echo "✅ Todos los conceptos de la semana integrados exitosamente"