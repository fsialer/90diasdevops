# Ver recursos en namespaces específicos:
# Ver pods en desarrollo
kubectl get pods -n mi-app-dev

# Ver pods en producción
kubectl get pods -n mi-app-prod

# Ver todo en un namespace
kubectl get all -n mi-app-dev

# Ver recursos en TODOS los namespaces
kubectl get pods -A
kubectl get all -A

#Cambiar namespace por defecto:

# Cambiar a namespace de desarrollo
kubectl config set-context --current --namespace=mi-app-dev

# Ahora todos los comandos serán en mi-app-dev
kubectl get pods  # Solo verás pods de mi-app-dev

# Ver qué namespace estás usando
kubectl config view --minify | grep namespace

# Volver al namespace default
kubectl config set-context --current --namespace=default