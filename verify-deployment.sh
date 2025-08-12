#!/bin/bash
# verify-deployment.sh

echo "🔍 Verificando despliegue..."

# Verificar contenedores
echo "Contenedores activos:"
docker ps --filter "label=project=roxs-voting-app"

# Verificar conectividad
echo "Probando conectividad:"
curl -f http://localhost:8080 && echo "✅ Vote app OK"
curl -f http://localhost:3000 && echo "✅ Result app OK"

# Verificar logs
echo "Logs recientes:"
docker logs roxs-voting-vote-1 --tail 5
docker logs roxs-voting-result-1 --tail 5