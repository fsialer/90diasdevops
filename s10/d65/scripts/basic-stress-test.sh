#!/bin/bash
# basic-stress-test.sh - Stress test con herramientas básicas
APP_URL="http://localhost:3001"
RESULTS_DIR="stress-results"
mkdir -p $RESULTS_DIR
LOG_FILE="$RESULTS_DIR/basic-stress.log"

echo "🔥 STRESS TEST BÁSICO">> $LOG_FILE
echo "===================">> $LOG_FILE


# Verificar que la app responde
echo "📋 1. Verificación inicial...">> $LOG_FILE
if ! curl -s $APP_URL/health > /dev/null; then
    echo "❌ App no responde, verifica que esté corriendo" >> $LOG_FILE
    exit 1
fi
echo "✅ App responde correctamente" >> $LOG_FILE

# Test 1: Requests simples en paralelo
echo "">> $LOG_FILE
echo "🚀 2. Test de requests paralelos (50 requests simultáneos)...">> $LOG_FILE
start_time=$(date +%s)

for i in {1..50}; do
    curl -s $APP_URL/ > /dev/null &
done
wait  # Esperar que terminen todos

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "✅ 50 requests completados en ${duration}s">> $LOG_FILE

# Test 2: Carga sostenida por 60 segundos
echo "">> $LOG_FILE
echo "⏰ 3. Carga sostenida por 60 segundos...">> $LOG_FILE
echo "   (5 requests por segundo durante 1 minuto)">> $LOG_FILE

request_count=0
start_test=$(date +%s)
end_test=$((start_test + 60))

while [ $(date +%s) -lt $end_test ]; do
    for i in {1..5}; do
        curl -s $APP_URL/ > /dev/null &
        ((request_count++))
    done
    sleep 1
done
wait

echo "✅ Completados $request_count requests en 60 segundos">> $LOG_FILE

# Test 3: CPU intensive endpoint
echo "">> $LOG_FILE
echo "💻 4. Test de endpoint CPU-intensive...">> $LOG_FILE
start_time=$(date +%s)
for i in {1..10}; do
    curl -s $APP_URL/cpu-intensive > /dev/null &
done
wait
end_time=$(date +%s)
duration=$((end_time - start_time))
echo "✅ 10 requests CPU-intensive completados en ${duration}s">> $LOG_FILE

echo "">> $LOG_FILE
echo "🎉 Stress test básico completado!">> $LOG_FILE
echo "💡 Próximo paso: monitoring avanzado">> $LOG_FILE