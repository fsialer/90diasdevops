#!/bin/bash
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