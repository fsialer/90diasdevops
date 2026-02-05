#!/bin/bash
# test-monitoring.sh - Probar todo el monitoreo

echo "🧪 Probando sistema completo de monitoreo"
echo "========================================="

# 1. Verificar Grafana
echo "📊 1. Probando Grafana..."
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ Grafana funcionando en http://localhost:3000"
else
    echo "❌ Grafana no responde"
fi

# 2. Verificar Prometheus
echo ""
echo "📈 2. Probando Prometheus..."
if curl -s http://localhost:9090/api/v1/query?query=up > /dev/null; then
    echo "✅ Prometheus funcionando en http://localhost:9090"
    
    # Ver métricas disponibles
    METRICS=$(curl -s http://localhost:9090/api/v1/label/__name__/values | jq -r '.data[]' | wc -l)
    echo "   📊 Métricas disponibles: $METRICS"
else
    echo "❌ Prometheus no responde"
fi

# 3. Probar alertas
echo ""
echo "🚨 3. Probando alertas..."
python3 scripts/simple-alerts.py

# 4. Generar reporte
echo ""
echo "📧 4. Generando reporte de prueba..."
python3 scripts/daily-report.py

# 5. Verificar crontab
echo ""
echo "⏰ 5. Verificando tareas programadas..."
crontab -l | grep -E "(alerts|report)" && echo "✅ Crontab configurado" || echo "⚠️ Revisar crontab"

echo ""
echo "🎉 Pruebas completadas!"
echo "💡 Accede a:"
echo "   🔗 Grafana: http://localhost:3000 (admin/admin123)"
echo "   🔗 Prometheus: http://localhost:9090"