#!/bin/bash
echo "🔍 COMPARACIÓN DE AMBIENTES"
echo "=========================="

for env in tienda-dev tienda-prod; do
    echo ""
    echo "📁 Ambiente: $env"
    echo "-------------------"
    
    echo "Pods:"
    kubectl get pods -n $env --no-headers | wc -l | xargs echo "  Total:"
    
    echo "Réplicas frontend:"
    kubectl get deployment frontend -n $env -o jsonpath='{.spec.replicas}' | xargs echo "  "
    
    echo "Acceso web:"
    if [ "$env" = "tienda-dev" ]; then
        echo "  http://$(minikube ip):30110"
    else
        echo "  http://$(minikube ip):30210"
    fi
done