#!/bin/bash
echo "🏥 Monitor de salud - Presiona Ctrl+C para parar"

while true; do
    clear
    echo "=== ESTADO DE PODS EN DEV ==="
    kubectl get pods -n dev -l app=mi-app -o wide
    
    echo ""
    echo "=== HEALTH CHECKS ==="
    kubectl describe pods -n dev -l app=mi-app | grep -A 5 "Liveness\|Readiness" || echo "No health checks configurados"
    
    echo ""
    echo "=== ÚLTIMOS EVENTOS ==="
    kubectl get events -n dev --sort-by='.lastTimestamp' | tail -5
    
    echo ""
    echo "Actualizando en 10 segundos..."
    sleep 10
done