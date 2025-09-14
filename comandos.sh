#!/bin/bash
kubectl exec -it <pod-name> -- printenv | grep -E 'DATABASE_URL|DB_PASSWORD'

#Validación avanzada:
kubectl exec -it <pod-name> -- ls -l /etc/secrets
kubectl exec -it <pod-name> -- cat /etc/nginx/conf.d/default.conf