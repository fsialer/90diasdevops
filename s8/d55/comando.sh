# Definir cluster
kind create cluster --config kind-config-observability.yaml
kubectl get nodes -o wide --show-labels

# Instalar helm y agrega repositorios
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo add elastic https://helm.elastic.co
helm repo update

# Crea Namespaces
kubectl create namespace monitoring     # Prometheus, Grafana, AlertManager
kubectl create namespace tracing       # Jaeger
kubectl create namespace logging       # ELK Stack

# Instala Prometheus Stack
helm install prometheus-stack prometheus-community/kube-prometheus-stack \
    --namespace monitoring \
    --values values/prometheus-stack.yaml \
    --wait

# Instala Jaeger
helm install jaeger jaegertracing/jaeger \
    --namespace tracing \
    --values values/jaeger.yaml \
    --wait

# Instala ELK Stack
helm install elasticsearch elastic/elasticsearch \
    --namespace logging \
    --values values/elasticsearch.yaml \
    --wait

# Instala Kibana
helm install kibana elastic/kibana \
    --namespace logging \
    --values values/kibana.yaml \
    --wait


kubectl port-forward svc/jaeger-query 30092:16686 -n tracing &
kubectl port-forward svc/elasticsearch-master 9200:9200 -n logging &
kubectl port-forward svc/kibana-kibana 30093:30093 -n logging &
kubectl get secret elasticsearch-master-credentials -n logging -o jsonpath='{.data.username}' | base64 --decode; echo # ver usuario
kubectl get secret elasticsearch-master-credentials -n logging -o jsonpath='{.data.password}' | base64 --decode; echo # ver la contraseña