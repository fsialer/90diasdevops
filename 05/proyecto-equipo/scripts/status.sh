#!/bin/bash
echo "📊 Estado de todos los ambientes"
echo "================================"

for env in dev staging prod; do
    echo ""
    echo "🏷️ Ambiente: $env"
    
    if terraform workspace select $env 2>/dev/null; then
        echo "   Estado: $(terraform workspace show)"
        
        # Verificar si hay recursos
        resource_count=$(terraform state list 2>/dev/null | wc -l)
        echo "   Recursos: $resource_count"
        
        # Verificar contenedores
        containers=$(docker ps -q --filter label=environment=$env | wc -l)
        echo "   Contenedores activos: $containers"
    else
        echo "   ❌ Workspace no existe"
    fi
done