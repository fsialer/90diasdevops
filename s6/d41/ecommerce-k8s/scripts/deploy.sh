#!/bin/bash
set -e

ENV=${1:-dev}
echo "🚀 Desplegando en ambiente: $ENV"

# Construir imágenes
echo "🏗️ Construyendo imágenes..."
docker build -t ecommerce-backend:latest ./apps/backend
docker build -t ecommerce-frontend:latest ./apps/frontend

# Crear namespace
kubectl create namespace ecommerce-$ENV --dry-run=client -o yaml | kubectl apply -f -

# Deploy con Helm
echo "📦 Desplegando con Helm..."
helm upgrade --install ecommerce ./helm-charts/ecommerce \
  --values ./helm-charts/ecommerce/values/$ENV.yaml \
  --wait --timeout=10m

# Verificar deployment
echo "✅ Verificando deployment..."
kubectl get pods -n ecommerce-$ENV
kubectl get svc -n ecommerce-$ENV

echo "🎉 ¡Deployment completado!"

if [ "$ENV" = "dev" ]; then
  echo "🌐 Accede a: http://localhost:30080"
fi