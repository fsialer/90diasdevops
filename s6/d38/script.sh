chmod +x tests/test-app.sh
# Probar rollback automatico

## Simular una imagen rota
### Crear una versión "rota" del deployment
cp k8s/dev/app-dev.yaml k8s/dev/app-dev-broken.yaml

# Editar para usar una imagen que no existe
# Cambiar: image: nginx:alpine
# Por:     image: nginx:imagen-que-no-existe

### Aplicar la versión rota
# Aplicar la versión rota
kubectl apply -f k8s/dev/app-dev-broken.yaml

# Ver qué pasa (va a fallar)
kubectl get pods -n dev -w

### Ver el rollback automático
# Kubernetes no va a matar los pods buenos hasta que los nuevos estén listos
echo "🔍 Viendo el estado..."
kubectl get pods -n dev

echo "📊 Estado del deployment:"
kubectl describe deployment mi-app -n dev

# Hacer rollback manual si es necesario
kubectl rollout undo deployment/mi-app -n dev

echo "✅ Rollback completado"
kubectl get pods -n dev

### Comandos para Monitorear
# Estado detallado de los pods
kubectl get pods -n dev -o wide

# Ver eventos (muy útil para debugging)
kubectl get events -n dev --sort-by='.lastTimestamp'

# Describir un pod específico
kubectl describe pod -n dev -l app=mi-app

### Monitorear health checks
# Ver logs del kubelet sobre health checks
kubectl logs -n dev deployment/mi-app

# Ver el historial de rollouts
kubectl rollout history deployment/mi-app -n dev

# Ver el status en tiempo real
kubectl rollout status deployment/mi-app -n dev -w

### Script de monitoreo automático
chmod +x scripts/monitor-health.sh