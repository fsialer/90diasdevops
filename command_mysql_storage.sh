# Desplegar MySQL
kubectl apply -f mysql-storage.yaml

# Verificar que todo esté funcionando
kubectl get pv,pvc
kubectl get pods
kubectl logs deployment/mysql
