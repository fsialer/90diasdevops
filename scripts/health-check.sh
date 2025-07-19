#!/bin/bash
ENV=$1
echo "health check $ENV"
check_vote() {
    curl -fs http://localhost/healthz && echo "✅ App vote OK" || echo "❌ App vote caído"
}

check_result() {
    curl -fs http://localhost:3000/healthz && echo "✅ App result OK" || echo "❌ App result caído"
}

if [[ $ENV == "staging" ]]; then
    check_vote
    check_result
elif [[ $ENV == "production" ]]; then
    check_vote
    check_resul
else
    check_vote
    check_resul
fi