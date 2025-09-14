# ConfigMaps
kubectl get configmaps
kubectl describe configmap <name>
kubectl edit configmap <name>
kubectl delete configmap <name>

# Secrets
kubectl get secrets
kubectl describe secret <name>
kubectl get secret <name> -o yaml
kubectl delete secret <name>

# Ver contenido de Secret (decodificado)
kubectl get secret <name> -o jsonpath='{.data.password}' | base64 -d