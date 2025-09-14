#!/bin/bash
# Desplegar todo
kubectl apply -f complete-config.yaml

# Verificar que todo esté funcionando
kubectl get configmaps
kubectl get secrets
kubectl get pods
kubectl get services

# Ver el contenido del ConfigMap
kubectl describe configmap webapp-config

# Ver las claves del Secret (no los valores)
kubectl describe secret webapp-secrets

# Entrar en un pod para verificar las variables
kubectl exec -it <pod-name> -- env | grep -E "(ENVIRONMENT|LOG_LEVEL|DB_PASSWORD)"

# Ver archivos montados
kubectl exec -it <pod-name> -- ls -la /etc/app-secrets/
kubectl exec -it <pod-name> -- cat /usr/local/apache2/conf/extra/httpd-vhosts.conf

# Si no ves los valores actualizados, ejecuta
kubectl rollout restart deployment webapp

# Editar ConfigMap
kubectl edit configmap webapp-config

# O actualizar desde archivo
kubectl apply -f complete-config.yaml

# Los pods necesitan reiniciarse para aplicar cambios
kubectl rollout restart deployment webapp

kubectl diff -f archivo.yaml