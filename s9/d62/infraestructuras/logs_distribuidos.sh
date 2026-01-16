# Paso 1: Crear tabla de índices de logs
# Tabla para indexar logs por timestamp y nivel
awslocal dynamodb create-table \
    --table-name RoxsLogIndex \
    --attribute-definitions \
        AttributeName=LogLevel,AttributeType=S \
        AttributeName=Timestamp,AttributeType=N \
    --key-schema \
        AttributeName=LogLevel,KeyType=HASH \
        AttributeName=Timestamp,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

aws --endpoint-url=http://localhost:4566 dynamodb create-table \
    --table-name RoxsLogIndex \
    --attribute-definitions \
        AttributeName=LogLevel,AttributeType=S \
        AttributeName=Timestamp,AttributeType=N \
    --key-schema \
        AttributeName=LogLevel,KeyType=HASH \
        AttributeName=Timestamp,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

# Bucket para logs raw
awslocal s3 mb s3://roxs-logs-storage
aws --endpoint-url=http://localhost:4566 s3 mb s3://roxs-logs-storage

# Paso 2: Función de procesamiento de logs
# Revisar el codigo en e directorio log_proccesor

#Paso 3: Desplegar sistema de logs
# Empaquetar función
zip log-processor.zip log_processor.py

# Crear función
awslocal lambda create-function \
    --function-name roxs-log-processor \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler log_processor.lambda_handler \
    --zip-file fileb://log-processor.zip \
    --timeout 30 \
    --description "Sistema de logs: Lambda → DynamoDB → S3"

aws --endpoint-url=http://localhost:4566 lambda create-function \
    --function-name roxs-log-processor \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler log_processor.lambda_handler \
    --zip-file fileb://log-processor.zip \
    --timeout 30 \
    --description "Sistema de logs: Lambda -> DynamoDB -> S3"

#Paso 4: Probar sistema de log
# Simular logs de aplicación
awslocal lambda invoke \
    --function-name roxs-log-processor \
    --payload '{
        "logs": [
            {
                "level": "ERROR",
                "message": "Database connection failed",
                "service": "user-api",
                "user_id": "user123"
            },
            {
                "level": "INFO", 
                "message": "User login successful",
                "service": "auth-service",
                "user_id": "user123"
            },
            {
                "level": "WARNING",
                "message": "High memory usage detected",
                "service": "monitoring",
                "user_id": "system"
            }
        ]
    }' \
    logs-result.json

aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name roxs-log-processor \
    --payload '{
        "logs": [
            {
                "level": "ERROR",
                "message": "Database connection failed",
                "service": "user-api",
                "user_id": "user123"
            },
            {
                "level": "INFO", 
                "message": "User login successful",
                "service": "auth-service",
                "user_id": "user123"
            },
            {
                "level": "WARNING",
                "message": "High memory usage detected",
                "service": "monitoring",
                "user_id": "system"
            }
        ]
    }' \
    --cli-binary-format raw-in-base64-out \
    logs-result.json

cat logs-result.json

# Verificar índice en DynamoDB
awslocal dynamodb scan --table-name RoxsLogIndex \
    --projection-expression "LogLevel,#ts,LogId,Message,Service" \
    --expression-attribute-names '{"#ts": "Timestamp"}'

aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name RoxsLogIndex \
    --projection-expression "LogLevel,#ts,LogId,Message,Service" \
    --expression-attribute-names '{"#ts": "Timestamp"}'

# Verificar archivo en S3
awslocal s3 ls s3://roxs-logs-storage/ --recursive
aws --endpoint-url=http://localhost:4566 s3 ls s3://roxs-logs-storage/ --recursive
