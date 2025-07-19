#!/bin/bash

ENV=$1
echo "🩺 Health check para entorno: $ENV"

FAIL=0

check_vote() {
    if curl -fs http://localhost/healthz > /dev/null; then
        echo "✅ App vote OK"
    else
        echo "❌ App vote caído"
        FAIL=1
    fi
}

check_result() {
    if curl -fs http://localhost:3000/healthz > /dev/null; then
        echo "✅ App result OK"
    else
        echo "❌ App result caído"
        FAIL=1
    fi
}

if [[ $ENV == "staging" ]]; then
    check_vote
    check_result
elif [[ $ENV == "production" ]]; then
    check_vote
    check_result
else
    echo "⚠️ Entorno no reconocido, ejecutando ambos chequeos por defecto"
    check_vote
    check_result
fi

# Salir con código de error si falló algo
if [[ $FAIL -ne 0 ]]; then
    echo "❌ Chequeo de salud falló."
    exit 1
else
    echo "✅ Todos los servicios están saludables."
fi