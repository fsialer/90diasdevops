#!/bin/bash
echo "🔍 Verificando instalación de LocalStack..."

echo "1. Verificando Docker..."
docker --version || echo "❌ Docker no encontrado"

echo "2. Verificando LocalStack CLI..."
localstack --version || echo "❌ LocalStack CLI no encontrado"

echo "3. Verificando awslocal..."
awslocal --version || echo "❌ awslocal no encontrado"

echo "4. Iniciando LocalStack..."
localstack start -d

echo "5. Esperando que LocalStack esté listo..."
sleep 10

echo "6. Verificando health check..."
curl -s http://localhost:4566/health | jq || echo "❌ LocalStack no responde"

echo "7. Probando S3..."
awslocal s3 mb s3://verification-bucket
awslocal s3 ls | grep verification-bucket || echo "❌ S3 no funciona"

echo "8. Probando DynamoDB..."
awslocal dynamodb list-tables || echo "❌ DynamoDB no funciona"

echo "✅ ¡Verificación completa!"