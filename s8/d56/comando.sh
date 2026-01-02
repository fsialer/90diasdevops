# Desplegar voting app instrumentada
kubectl apply -f voting-app-observability.yaml

# Verificar pods
kubectl get pods -n voting-app

# Aplicar ServiceMonitors
kubectl apply -f voting-app-servicemonitors.yaml

# Verificar en Prometheus
echo "Verificar targets en: http://localhost:30090/targets"

# Crear ConfigMap con dashboards
kubectl create configmap voting-dashboards \
  --from-file=grafana-dashboards/ \
  -n monitoring

# Agregar label para que Grafana los auto-importe
kubectl label configmap voting-dashboards grafana_dashboard=1 -n monitoring


# Aplicar alertas
kubectl apply -f voting-app-alerts.yaml

# Verificar en Prometheus
echo "Ver alertas en: http://localhost:30090/alerts"

# configurar Jaeger Agent (si no está):
## Verificar que Jaeger puede recibir traces
kubectl get pods -n tracing

## Port-forward para acceder a Jaeger UI
kubectl port-forward -n tracing svc/jaeger-query 16686:16686 &

echo "Jaeger UI: http://localhost:16686"

# Test de tracing end-to-end
./test-tracing-end-to-end.sh

# Logs Estructurados en Kibana
## Verificar logs en Kibana
# Acceder a Kibana
#echo "Kibana: http://localhost:30093"

# Crear index pattern para logs de voting app
#echo "1. Go to Kibana > Stack Management > Index Patterns"
#echo "2. Create pattern: 'filebeat-*'"
#echo "3. Time field: '@timestamp'"
#echo "4. Go to Discover and filter by: kubernetes.namespace:voting-app"

## Queries útiles en Kibana
### Logs de errores
kubernetes.namespace:"voting-app" AND level:"ERROR"

### Logs de votos procesados
kubernetes.namespace:"voting-app" AND message:"Vote processed"

### Logs por servicio
kubernetes.namespace:"voting-app" AND kubernetes.container.name:"vote"

# Load Testing para Demo
chmod +x load-test-demo.sh
./load-test-demo.sh