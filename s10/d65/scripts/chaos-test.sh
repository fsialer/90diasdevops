#!/bin/bash
# chaos-test.sh - Simular fallos reales

echo "💥 CHAOS ENGINEERING TEST"
echo "========================"

APP_URL="http://localhost:3001"

# Test 1: Matar contenedor aleatoriamente
echo "🎲 1. Test de container failure..."
echo "   Matando container de aplicación..."

# Obtener container ID
CONTAINER_ID=$(docker ps --filter "name=stress-test-app" -q | head -1)

if [ -n "$CONTAINER_ID" ]; then
    echo "   Container encontrado: $CONTAINER_ID"
    docker kill $CONTAINER_ID
    
    echo "   ⏰ Esperando 10 segundos..."
    sleep 10
    
    # Reiniciar automáticamente
    echo "   🔄 Reiniciando aplicación..."
    cd stress-test-app
    npm start &
    sleep 5
    
    # Verificar recuperación
    if curl -s $APP_URL/health > /dev/null; then
        echo "   ✅ App recuperada exitosamente"
    else
        echo "   ❌ App no se recuperó"
    fi
else
    echo "   ⚠️  Container no encontrado (usando proceso directo)"
fi

# Test 2: Simular alta carga de CPU
echo ""
echo "🔥 2. Test de CPU stress..."
echo "   Generando carga extrema de CPU por 30 segundos..."

# Instalar stress si no existe
if ! command -v stress &> /dev/null; then
    echo "   Instalando herramienta stress..."
    # macOS: brew install stress
    # Ubuntu: sudo apt-get install stress
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install stress 2>/dev/null || echo "   Manual: brew install stress"
    else
        sudo apt-get install -y stress 2>/dev/null || echo "   Manual: sudo apt-get install stress"
    fi
fi

# Ejecutar stress test
if command -v stress &> /dev/null; then
    echo "   🔥 Ejecutando stress en CPU..."
    stress --cpu 2 --timeout 30s &
    STRESS_PID=$!
    
    # Mientras tanto, probar la app
    echo "   📡 Probando app durante el stress..."
    for i in {1..10}; do
        start_time=$(date +%s%N)
        if curl -s $APP_URL/ > /dev/null; then
            end_time=$(date +%s%N)
            duration=$(( (end_time - start_time) / 1000000 ))
            echo "      Request $i: ${duration}ms"
        else
            echo "      Request $i: FAILED"
        fi
        sleep 2
    done
    
    wait $STRESS_PID
    echo "   ✅ CPU stress test completado"
else
    echo "   ⚠️  Stress tool no disponible, usando método alternativo..."
    # Método alternativo sin stress tool
    python3 -c "
import time
import threading
import multiprocessing

def cpu_stress():
    end_time = time.time() + 30
    while time.time() < end_time:
        x = 0
        for i in range(1000000):
            x += i

threads = []
for i in range(multiprocessing.cpu_count()):
    t = threading.Thread(target=cpu_stress)
    t.start()
    threads.append(t)

print('   🔥 CPU stress iniciado por 30 segundos...')
for t in threads:
    t.join()
print('   ✅ CPU stress completado')
" &
    STRESS_PID=$!
    
    # Probar app durante stress
    for i in {1..10}; do
        if curl -s $APP_URL/ > /dev/null; then
            echo "      Request $i: OK"
        else
            echo "      Request $i: FAILED"
        fi
        sleep 2
    done
    
    wait $STRESS_PID
fi

# Test 3: Simular problemas de red
echo ""
echo "🌐 3. Test de network latency..."
echo "   Simulando latencia de red..."

# Usando tc (traffic control) si está disponible
if command -v tc &> /dev/null; then
    echo "   🐌 Añadiendo 200ms de latency..."
    sudo tc qdisc add dev lo root handle 1: prio
    sudo tc qdisc add dev lo parent 1:3 handle 30: netem delay 200ms 2>/dev/null
    
    # Probar con latencia
    start_time=$(date +%s%N)
    curl -s $APP_URL/ > /dev/null
    end_time=$(date +%s%N)
    duration=$(( (end_time - start_time) / 1000000 ))
    echo "   📊 Request con latency: ${duration}ms"
    
    # Limpiar latencia
    sudo tc qdisc del dev lo root 2>/dev/null
    echo "   ✅ Latencia removida"
else
    echo "   ⚠️  tc no disponible, simulando con timeout..."
    timeout 1s curl $APP_URL/ 2>/dev/null || echo "   📊 Timeout simulado"
fi

echo ""
echo "🎉 Chaos engineering tests completados!"