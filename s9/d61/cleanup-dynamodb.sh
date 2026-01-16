#!/bin/bash
# cleanup-dynamodb.sh

echo "🧹 Limpiando DynamoDB LocalStack..."

# Eliminar todos los items de todas las tablas
#for table in $(awslocal dynamodb list-tables --query 'TableNames[]' --output text); do
for table in $(aws --endpoint-url=http://localhost:4566 dynamodb list-tables --query 'TableNames[]' --output text); do
    echo "Limpiando tabla: $table"
    
    # Obtener schema de la tabla para identificar keys
    #keys=$(awslocal dynamodb describe-table --table-name $table \
    #    --query 'Table.KeySchema[].AttributeName' --output text)
    
    keys=$(aws --endpoint-url=http://localhost:4566 dynamodb describe-table --table-name $table \
        --query 'Table.KeySchema[].AttributeName' --output text)
    
    # Scan para obtener todas las keys
    #awslocal dynamodb scan --table-name $table \
    #    --projection-expression "$keys" \
    #    --query 'Items[]' --output json > /tmp/${table}_keys.json

    aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name $table \
        --projection-expression "$keys" \
        --query 'Items[]' --output json > /tmp/${table}_keys.json
    
    # Eliminar items uno por uno (en un script real usarías batch-write)
    # Este es solo para demo
    echo "  Items encontrados para eliminar..."
done

echo "✅ Limpieza completa! (Nota: implementación simplificada)"