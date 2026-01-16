# 1. Crear tabla para metadata de archivos
awslocal dynamodb create-table \
    --table-name RoxsFileMetadata \
    --attribute-definitions \
        AttributeName=FileId,AttributeType=S \
    --key-schema \
        AttributeName=FileId,KeyType=HASH \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

aws --endpoint-url=http://localhost:4566 dynamodb create-table \
    --table-name RoxsFileMetadata \
    --attribute-definitions \
        AttributeName=FileId,AttributeType=S \
    --key-schema \
        AttributeName=FileId,KeyType=HASH \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5


# 2. Desplegar función completa
zip complete-system.zip complete_system.py
awslocal lambda create-function \
    --function-name roxs-complete-system \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler complete_system.lambda_handler \
    --zip-file fileb://complete-system.zip \
    --timeout 60

aws --endpoint-url=http://localhost:4566 lambda create-function \
    --function-name roxs-complete-system \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler complete_system.lambda_handler \
    --zip-file fileb://complete-system.zip \
    --timeout 60

# 3. Crear archivo de prueba en S3
echo -e "Este es un archivo de prueba\nCon múltiples líneas\nPara probar el sistema completo\nLocalStack + Lambda + DynamoDB + S3" > test-complete.txt
awslocal s3 cp test-complete.txt s3://roxs-bucket/
aws --endpoint-url=http://localhost:4566 s3 mb s3://roxs-bucket
aws --endpoint-url=http://localhost:4566 s3 cp test-complete.txt s3://roxs-bucket/

# 4. Procesar archivo con el sistema
awslocal lambda invoke \
    --function-name roxs-complete-system \
    --payload '{
        "action": "process_file",
        "bucket": "roxs-bucket",
        "key": "test-complete.txt"
    }' \
    complete-output.json

aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name roxs-complete-system \
    --payload '{
        "action": "process_file",
        "bucket": "roxs-bucket",
        "key": "test-complete.txt"
    }' \
    --cli-binary-format raw-in-base64-out \
    complete-output.json


cat complete-output.json

# 5. Ver estadísticas del sistema
awslocal lambda invoke \
    --function-name roxs-complete-system \
    --payload '{"action": "get_file_stats"}' \
    stats-output.json

aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name roxs-complete-system \
    --payload '{"action": "get_file_stats"}' \
    --cli-binary-format raw-in-base64-out \
    stats-output.json

cat stats-output.json

# 6. Verificar que se creó el reporte
awslocal s3 ls s3://roxs-bucket/reports/
aws --endpoint-url=http://localhost:4566 s3 ls s3://roxs-bucket/reports/
awslocal s3 cp s3://roxs-bucket/reports/test-complete.txt-analysis.json report.json
aws --endpoint-url=http://localhost:4566 s3 cp s3://roxs-bucket/reports/test-complete.txt-analysis.json report.json
cat report.json


