#!/bin/bash
echo "🔥 Generando errores para testing SLO alerts..."

# Generar tráfico que causa muchos 500s
for i in {1..200}; do
  # El endpoint /api/users tiene 10% de probabilidad de error
  # Con 200 requests, deberíamos tener ~20 errores
  curl -s http://localhost:30080/api/users > /dev/null &
done

wait
echo "✅ Chaos test completado. Revisar alertas en 2-3 minutos."
