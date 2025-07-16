#!/bin/bash
echo "🔍 Verificando app..."

curl -f http://localhost:3000/ping && echo "✅ Ping OK"
curl -f http://localhost:3000/health && echo "✅ Health OK"
curl -f http://localhost:3000/ && echo "✅ Home OK"