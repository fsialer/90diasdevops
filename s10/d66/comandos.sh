# Paso 1: Alertas Básicas con Slack
# 1.1 Configurar webhook de Slack
# 📱 Crear webhook en Slack (ir a api.slack.com/apps)
# Copiar la URL del webhook
SLACK_WEBHOOK="WEBHOOK"

# 1.2 Script de alerta simple
# Crear scripts/simple-alerts.py

#1.3 Ejecutar alertas cada 5 minutos
# Hacer script ejecutable
chmod +x scripts/simple-alerts.py

# Agregar a crontab
echo "*/5 * * * * cd /tu/directorio && python3 scripts/simple-alerts.py" | crontab -

# Ver crontab
crontab -l

#1.4 Probar alerta manual
# Script de prueba rápida
# Crear en scripts/manual-alert.py

# Paso 2: Dashboard Simple en Grafana
# 2.1 Instalar Grafana con Docker
# 📈 Grafana súper simple con Docker
mkdir -p grafana-simple
cd grafana-simple

cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin123
    volumes:
      - grafana-data:/var/lib/grafana
      - ./dashboards:/etc/grafana/provisioning/dashboards
      - ./datasources:/etc/grafana/provisioning/datasources
    restart: unless-stopped

  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--web.enable-lifecycle'
    restart: unless-stopped

  node-exporter:
    image: prom/node-exporter:latest
    ports:
      - "9100:9100"
    restart: unless-stopped

volumes:
  grafana-data:
EOF

# Iniciar todo
docker-compose up -d

# 2.2 Configuración básica de Prometheus
# prometheus.yml - Configuración súper simple

# 2.3 Datasource automático para Grafana
# datasources/prometheus.yml

# 2.4 Dashboard simple
# dashboards/simple-dashboard.json

# 2.5 Configurar dashboard automático
# dashboards/dashboard-provider.yml

# Paso 3: Email Automático de Reportes
# 3.1 Script de reporte diario
# scripts/daily-report.py

# 3.2 Automatizar reporte diario
# Agregar a crontab - reporte cada día a las 8 AM
echo "0 8 * * * cd /tu/directorio && python3 scripts/daily-report.py" | crontab -

# Para testing, ejecutar ahora
python3 scripts/daily-report.py

# Paso 4: Probar Todo el Sistema
# 4.1 Script de pruebas completas
# test-monitoring.sh

# Paso 5: Documentación Simple
# 5.1 Crear guía rápida
# 📊 Guía Rápida - Sistema de Monitoreo

## 🚀 Accesos Rápidos
- **Grafana**: http://localhost:3000 (admin/admin123)
- **Prometheus**: http://localhost:9090
- **Alertas**: Se envían a Slack cada 5 minutos
- **Reportes**: Email diario a las 8 AM

## 🚨 Si Algo Falla

### Grafana no carga
docker-compose restart grafana

# Alertas no llegan
# Verificar webhook de Slack
python3 scripts/simple-alerts.py

# Ver logs de cron
tail -f /var/log/cron

# Email no llega
# Verificar configuración
python3 scripts/daily-report.py

#Prometheus - Alertas Predictivas
#alerts/alert.yml


#Grafana - Dashboard de SLA
#grafana-simple/dashboard/dashboard-sla.json


#Jaeger - Instrumentación
# jaeger/app.js
#Métricas de SLA/SLO
#Service Level Indicators (SLIs)
availability_sli:
  description: "Percentage of successful requests"
  query: "sum(rate(http_requests_total{status!~'5..'}[5m])) / sum(rate(http_requests_total[5m]))"

latency_sli:
  description: "95th percentile response time"
  query: "histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))"

error_rate_sli:
  description: "Percentage of failed requests"
  query: "sum(rate(http_requests_total{status=~'5..'}[5m])) / sum(rate(http_requests_total[5m]))"

#Comandos Útiles
#Prometheus - Testing Queries
# Verificar métricas disponibles
curl http://prometheus:9090/api/v1/label/__name__/values
# Probar query
curl -G 'http://prometheus:9090/api/v1/query' \
  --data-urlencode 'query=up'
# Query con rango de tiempo
curl -G 'http://prometheus:9090/api/v1/query_range' \
  --data-urlencode 'query=rate(http_requests_total[5m])' \
  --data-urlencode 'start=2024-01-01T00:00:00Z' \
  --data-urlencode 'end=2024-01-01T01:00:00Z' \
  --data-urlencode 'step=15s'

# Jaeger - Health Check
# Verificar Jaeger UI
curl http://jaeger:16686/api/services

# Buscar traces
curl "http://jaeger:16686/api/traces?service=my-service&limit=10"

#Runbooks Automáticos
#Ejemplo de Runbook
## runbook-high-cpu.yml


# Métricas de Éxito
# MTTD (Mean Time To Detection): < 2 minutos
# MTTR (Mean Time To Recovery): < 15 minutos
# Alert Noise Ratio: < 5% falsos positivos
# Dashboard Load Time: < 3 segundos



