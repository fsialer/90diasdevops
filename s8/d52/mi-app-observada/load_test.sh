#!/bin/bash
echo "🚀 Iniciando load test..."

# Función para hacer requests en paralelo
make_requests() {
    for i in {1..50}; do
        curl -s http://localhost:5000/ > /dev/null &
        curl -s http://localhost:5000/api/users > /dev/null &
        curl -s -X POST http://localhost:5000/api/login > /dev/null &
    done
    wait
}

# Ejecutar por 2 minutos
echo "📈 Generando tráfico por 2 minutos..."
for round in {1..24}; do  # 24 rounds * 5 seconds = 2 minutos
    echo "Round $round/24"
    make_requests
    sleep 5
done

echo "✅ Load test completado!"
# SIMULADOR DE PROBLEMAS
## Problema 1: App Sobrecargada
# Stress test que genera muchos errores
for i in {1..200}; do
  curl -s http://localhost:5000/api/users > /dev/null &
  curl -s -X POST http://localhost:5000/api/login > /dev/null &
done

## Problema 2: App Caída
# "Romper" la app
docker stop mi-app

# Esperar 1 minuto, ver métricas en Grafana
# Después "arreglar":
docker start mi-app

## Problema 3: Base de Datos Lenta
# Hacer muchos requests al endpoint que simula timeouts
for i in {1..50}; do
  curl -s http://localhost:5000/api/users > /dev/null &
done
