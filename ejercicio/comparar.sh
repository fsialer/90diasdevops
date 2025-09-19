# Ver diferencias entre desarrollo y producción
#!/bin/bash
echo "=== DESARROLLO ==="
kubectl get pods -n tienda-dev

echo "=== PRODUCCIÓN ==="
kubectl get pods -n tienda-prod

# Comparar réplicas
kubectl get deployments -n tienda-dev
kubectl get deployments -n tienda-prod

# Ver los servicios
kubectl get services -n tienda-dev
kubectl get services -n tienda-prod