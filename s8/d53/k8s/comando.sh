# Crear cluster
kind create cluster --config kind-config.yaml

# Verificar
kubectl get nodes -o wide
kubectl cluster-info

# minikube
minikube start --cpus=4 --memory=8192 --driver=docker
minikube addons enable metrics-server

# instalacion con helm
# Agregar repo de Prometheus Community
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Crear namespace
kubectl create namespace monitoring

# Instalar stack completo
helm install kube-prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.service.type=NodePort \
  --set prometheus.service.nodePort=30000 \
  --set grafana.service.type=NodePort \
  --set grafana.service.nodePort=30001 \
  --set alertmanager.service.type=NodePort \
  --set alertmanager.service.nodePort=30002 \
  --set grafana.adminPassword=admin123 \
  --wait

helm upgrade kube-prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.prometheusSpec.serviceMonitorNamespaceSelector.matchNames[0]=monitoring \
  --set prometheus.prometheusSpec.serviceMonitorNamespaceSelector.matchNames[1]=mi-app

helm upgrade --install kube-prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  -f values-prometheus.yml

  helm upgrade --install kube-prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --values values-prometheus.yml \
  --wait
# Verificar instalación
kubectl get pods -n monitoring

#Acceder a las Interfaces
# Grafana
echo "Grafana: http://localhost:30001"
echo "Usuario: admin, Password: admin123"

# Prometheus
echo "Prometheus: http://localhost:30000"

# AlertManager  
echo "AlertManager: http://localhost:30002"

#Port forwarding alternativo
kubectl port-forward -n monitoring svc/kube-prometheus-grafana 3000:80 &
kubectl port-forward -n monitoring svc/prometheus-operated 9090:9090 &
kubectl port-forward -n monitoring svc/prometheus-operated 30092:5778 &


# Desplegar la app

kubectl apply -f app-namespace.yaml
kubectl apply -f app-deployment.yaml
kubectl apply -f app-service.yaml

# Verificar
kubectl get pods -n mi-app -o wide
kubectl get svc -n mi-app

# Probar la app
curl http://localhost:30080/
curl http://localhost:30080/api/users

#ServiceMonitor para tu app
kubectl apply -f app-servicemonitor.yml

# Verificar que se creó
kubectl get servicemonitor -n mi-app

# Deployment de Load Tester
kubectl apply -f load-tester.yml
# Ver logs del load tester
kubectl logs -f deployment/load-tester -n mi-app

#  Scaling y Service Discovery en Acción
# Escalar a 5 replicas
kubectl scale deployment mi-app --replicas=5 -n mi-app

# Ver pods nuevos apareciendo
kubectl get pods -n mi-app -w

# En Prometheus, ver nuevos targets apareciendo automáticamente
# http://localhost:30000/targets

## Probar failover
# Eliminar un pod específico
kubectl delete pod $(kubectl get pods -n mi-app -l app=mi-app -o jsonpath='{.items[0].metadata.name}') -n mi-app

# HorizontalPodAutoscaler (HPA):
kubectl apply -f - <<EOF
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: mi-app-hpa
  namespace: mi-app
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: mi-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
EOF

# Ver HPA en acción
kubectl get hpa -n mi-app -w


# Ver en Grafana cómo el pod desaparece de las métricas
# Y cómo K8s crea uno nuevo automáticamente

# Alertas para K8s
kubectl apply -f app-alerts.yaml

# Verificar alertas en Prometheus
# http://localhost:30000/alerts