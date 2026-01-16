#Arquitectura 3: Sistema de notificaciones

#Paso 1: Crear cola SQS y topic SNS
# Crear cola SQS para eventos
awslocal sqs create-queue --queue-name roxs-notifications-queue
aws --endpoint-url=http://localhost:4566 sqs create-queue --queue-name roxs-notifications-queue

# Crear topic SNS para notificaciones
awslocal sns create-topic --name roxs-notifications
aws --endpoint-url=http://localhost:4566 sns create-topic --name roxs-notifications

# Obtener URLs/ARNs
queue_url=$(awslocal sqs get-queue-url --queue-name roxs-notifications-queue --query 'QueueUrl' --output text)
queue_url=$(aws --endpoint-url=http://localhost:4566 sqs get-queue-url --queue-name roxs-notifications-queue --query 'QueueUrl' --output text)
topic_arn=$(awslocal sns list-topics --query 'Topics[0].TopicArn' --output text)
topic_arn=$(aws --endpoint-url=http://localhost:4566 sns list-topics --query 'Topics[0].TopicArn' --output text)

echo "Queue URL: $queue_url"
echo "Topic ARN: $topic_arn"
#Paso 2: Crear tabla de historial de notificaciones
# Tabla para historial de notificaciones
awslocal dynamodb create-table \
    --table-name RoxsNotificationHistory \
    --attribute-definitions \
        AttributeName=NotificationId,AttributeType=S \
        AttributeName=CreatedAt,AttributeType=N \
    --key-schema \
        AttributeName=NotificationId,KeyType=HASH \
        AttributeName=CreatedAt,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

aws --endpoint-url=http://localhost:4566 dynamodb create-table \
    --table-name RoxsNotificationHistory \
    --attribute-definitions \
        AttributeName=NotificationId,AttributeType=S \
        AttributeName=CreatedAt,AttributeType=N \
    --key-schema \
        AttributeName=NotificationId,KeyType=HASH \
        AttributeName=CreatedAt,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

#Paso 3: Función procesadora de notificacione
# el codigo se enceuntra en el directorio de notification_processor

#Paso 4: Desplegar sistema de notificaciones
# Empaquetar función
zip notification-processor.zip notification_processor.py

# Crear función
awslocal lambda create-function \
    --function-name roxs-notification-processor \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler notification_processor.lambda_handler \
    --zip-file fileb://notification-processor.zip \
    --timeout 30 \
    --description "Sistema de notificaciones: SQS → Lambda → SNS → DynamoDB"

aws --endpoint-url=http://localhost:4566 lambda create-function \
    --function-name roxs-notification-processor \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler notification_processor.lambda_handler \
    --zip-file fileb://notification-processor.zip \
    --timeout 30 \
    --description "Sistema de notificaciones: SQS -> Lambda -> SNS -> DynamoDB"

#Paso 5: Probar sistema de notificaciones
# Suscribirse al topic SNS (para ver las notificaciones)
awslocal sns subscribe \
    --topic-arn arn:aws:sns:us-east-1:000000000000:roxs-notifications \
    --protocol email \
    --notification-endpoint admin@roxs.com

aws --endpoint-url=http://localhost:4566 sns subscribe \
    --topic-arn arn:aws:sns:us-east-1:000000000000:roxs-notifications \
    --protocol email \
    --notification-endpoint admin@roxs.com

# Enviar notificación de prueba
awslocal lambda invoke \
    --function-name roxs-notification-processor \
    --payload '{
        "type": "alert",
        "recipient": "admin@roxs.com",
        "title": "Sistema de monitoreo",
        "message": "CPU usage above 90% on server-01",
        "priority": "high"
    }' \
    notification-result.json

aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name roxs-notification-processor \
    --payload '{
        "type": "alert",
        "recipient": "admin@roxs.com",
        "title": "Sistema de monitoreo",
        "message": "CPU usage above 90% on server-01",
        "priority": "high"
    }' \
    --cli-binary-format raw-in-base64-out \
    notification-result.json

cat notification-result.json

# Enviar notificación informativa
awslocal lambda invoke \
    --function-name roxs-notification-processor \
    --payload '{
        "type": "info",
        "recipient": "team@roxs.com", 
        "title": "Deploy completado",
        "message": "La versión 2.1.0 se desplegó exitosamente",
        "priority": "normal"
    }' \
    notification-result2.json

aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name roxs-notification-processor \
    --payload '{
        "type": "info",
        "recipient": "team@roxs.com", 
        "title": "Deploy completado",
        "message": "La versión 2.1.0 se desplegó exitosamente",
        "priority": "normal"
    }' \
    --cli-binary-format raw-in-base64-out \
    notification-result2.json

# Verificar historial en DynamoDB
awslocal dynamodb scan --table-name RoxsNotificationHistory \
    --projection-expression "NotificationId,Title,#status,Priority,ProcessedAt" \
    --expression-attribute-names '{"#status": "Status"}'

aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name RoxsNotificationHistory \
    --projection-expression "NotificationId,Title,#status,Priority,ProcessedAt" \
    --expression-attribute-names '{"#status": "Status"}'

# Ver mensajes en SNS (si hay subscriptores)
awslocal sns list-subscriptions
aws --endpoint-url=http://localhost:4566 sns list-subscriptions