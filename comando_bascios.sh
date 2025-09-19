# Crear namespace para desarrollo
kubectl create namespace mi-app-dev

# Crear namespace para producción
kubectl create namespace mi-app-prod

# Ver que se crearon
kubectl get ns

# Aplicar el archivo
kubectl apply -f mis-namespaces.yaml

# Verificar con labels
kubectl get ns --show-labels