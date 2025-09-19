# 1. Crear los namespaces
kubectl apply -f tienda-namespaces.yaml

# 2. Desplegar desarrollo
kubectl apply -f tienda-desarrollo.yaml

# 3. Desplegar producción
kubectl apply -f tienda-produccion.yaml

# 4. Verificar todo está funcionando
kubectl get all -n tienda-dev
kubectl get all -n tienda-prod