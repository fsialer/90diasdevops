#!/bin/bash
# dynamodb-stats.sh

echo "📊 Estadísticas de DynamoDB LocalStack"
echo "======================================"

echo "🗂️  Total de tablas:"
#awslocal dynamodb list-tables --query 'length(TableNames)'
aws --endpoint-url=http://localhost:4566 dynamodb list-tables --query 'length(TableNames)'

echo ""
echo "📋 Lista de tablas:"
#awslocal dynamodb list-tables --query 'TableNames' --output table
aws --endpoint-url=http://localhost:4566 dynamodb list-tables --query 'TableNames' --output table

echo ""
echo "📄 Items por tabla:"
for table in $(awslocal dynamodb list-tables --query 'TableNames[]' --output text); do
    #count=$(awslocal dynamodb scan --table-name $table --select COUNT --query 'Count')
    count=$(aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name $table --select COUNT --query 'Count')
    echo "  $table: $count items"
done

echo ""
echo "🔧 Configuración de tablas:"
for table in $(awslocal dynamodb list-tables --query 'TableNames[]' --output text); do
    echo "  === $table ==="
    #awslocal dynamodb describe-table --table-name $table \
    #    --query 'Table.[KeySchema,ProvisionedThroughput]' --output table
    aws --endpoint-url=http://localhost:4566 dynamodb describe-table --table-name $table \
        --query 'Table.[KeySchema,ProvisionedThroughput]' --output table
done