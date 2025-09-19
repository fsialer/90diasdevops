# Ver todos los namespaces
kubectl get ns

# Crear namespace rápido
kubectl create namespace mi-nuevo-proyecto

# Ver recursos en namespace específico
kubectl get pods -n mi-namespace
kubectl get all -n mi-namespace

# Describir un namespace
kubectl describe namespace mi-namespace

# Eliminar namespace (¡cuidado! elimina todo lo que contiene)
kubectl delete namespace mi-namespace

# Cambiar namespace por defecto
kubectl config set-context --current --namespace=mi-namespace

# Ver en qué namespace estás trabajando
kubectl config view --minify | grep namespace

# Ver recursos de todos los namespaces
kubectl get pods -A
kubectl get services -A