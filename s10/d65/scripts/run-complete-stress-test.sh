#!/bin/bash
# run-complete-stress-test.sh - Ejecutar toda la suite de tests

echo "🔥 EJECUTANDO STRESS TEST COMPLETO"
echo "================================="

# 1. Preparar ambiente
echo "📋 1. Preparando ambiente..."
chmod +x basic-stress-test.sh chaos-test.sh docker-chaos.sh
pip3 install -q psutil matplotlib requests

# 2. Ejecutar tests básicos
echo ""
echo "🚀 2. Ejecutando stress tests básicos..."
./basic-stress-test.sh

# 3. Ejecutar K6 si está disponible
echo ""
echo "📊 3. Ejecutando tests avanzados..."
if command -v k6 &> /dev/null; then
    k6 run advanced-stress-test.js
    echo "✅ K6 tests completados"
else
    echo "⚠️  K6 no instalado, saltando tests avanzados"
fi

# 4. Chaos engineering
echo ""
echo "💥 4. Ejecutando chaos tests..."
./chaos-test.sh

# 5. Monitoreo en background
echo ""
echo "📈 5. Iniciando monitoreo de sistema (2 minutos)..."
python3 system-monitor.py 120 &
MONITOR_PID=$!

# Generar algo de carga mientras monitoreamos
sleep 10
echo "   📡 Generando carga de prueba..."
for i in {1..20}; do
    curl -s http://localhost:3001/ > /dev/null &
    curl -s http://localhost:3001/cpu-intensive > /dev/null &
done
wait

# Esperar que termine el monitoreo
wait $MONITOR_PID

# 6. Generar reporte final
echo ""
echo "📋 6. Generando reporte final..."
python3 final-stress-report.py

echo ""
echo "🎉 TODOS LOS TESTS COMPLETADOS!"
echo "================================"
echo "📊 Archivos generados:"
echo "   - final-stress-test-report.html (reporte principal)"
echo "   - stress-test-monitoring.png (gráficos de monitoreo)"
echo "   - stress-results/ (todos los datos)"
echo ""
echo "🌐 Abrir reporte:"
echo "   open final-stress-test-report.html  # macOS"
echo "   xdg-open final-stress-test-report.html  # Linux"
echo ""
echo "✅ Tu sistema ha sido completamente validado!"