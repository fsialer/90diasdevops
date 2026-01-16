#Tarea del Día
#Parte 1: Arquitectura básica
#Crear toda la infraestructura:
# Buckets
awslocal s3 mb s3://mi-images-original
aws --endpoint-url=http://localhost:4566 s3 mb s3://mi-images-original
awslocal s3 mb s3://mi-images-processed
aws --endpoint-url=http://localhost:4566 s3 mb s3://mi-images-processed

# Tabla DynamoDB
awslocal dynamodb create-table \
    --table-name MiImageMetadata \
    --attribute-definitions AttributeName=ImageId,AttributeType=S \
    --key-schema AttributeName=ImageId,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

aws --endpoint-url=http://localhost:4566 dynamodb create-table \
    --table-name MiImageMetadata \
    --attribute-definitions AttributeName=ImageId,AttributeType=S \
    --key-schema AttributeName=ImageId,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

#Desplegar función procesadora (usar código del ejemplo)
#Probar con tus propias imágenes:
echo "Mi primera imagen" > mi-foto.jpg
awslocal s3 cp mi-foto.jpg s3://mi-images-original/
aws --endpoint-url=http://localhost:4566 s3 cp mi-foto.jpg s3://mi-images-original/

# Procesar
awslocal lambda invoke \
    --function-name roxs-image-processor \
    --payload '{"bucket": "mi-images-original", "key": "mi-foto.jpg"}' \
    mi-resultado.json

aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name roxs-image-processor \
    --payload '{"bucket": "mi-images-original", "key": "mi-foto.jpg"}' \
    --cli-binary-format raw-in-base64-out \
    mi-resultado.json

#Parte 2: Sistema de logs
#Desplegar sistema de logs (usar código del ejemplo)
#Generar logs de tu aplicación imaginaria:
awslocal lambda invoke \
    --function-name roxs-log-processor \
    --payload '{
        "logs": [
            {
                "level": "INFO",
                "message": "Usuario TU_NOMBRE inició sesión",
                "service": "mi-auth-service",
                "user_id": "TU_NOMBRE"
            },
            {
                "level": "ERROR",
                "message": "Falló conexión a base de datos",
                "service": "mi-api",
                "user_id": "system"
            }
        ]
    }' \
    mis-logs.json
aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name roxs-log-processor \
    --payload '{
        "logs": [
            {
                "level": "INFO",
                "message": "Usuario TU_NOMBRE inició sesión",
                "service": "mi-auth-service",
                "user_id": "TU_NOMBRE"
            },
            {
                "level": "ERROR",
                "message": "Falló conexión a base de datos",
                "service": "mi-api",
                "user_id": "system"
            }
        ]
    }' \
    --cli-binary-format raw-in-base64-out \
    mis-logs.json

#Parte 3: API básica
#Crear una versión simplificada de la API:
#Crear función API simple:
# El codigo se encuentra en el directorio api
# Desplegar y probar
aws --endpoint-url=http://localhost:4566 lambda create-function \
    --function-name mi-api-handler \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler mi_api.lambda_handler \
    --zip-file fileb://mi-api.zip \
    --timeout 30 \
    --description "API Gateway handler: rutas completas de la aplicación"

api_id=$(aws --endpoint-url=http://localhost:4566 apigateway create-rest-api \
    --name 'mi-complete-api' \
    --description 'API completa con múltiples servicios integrados' \
    --query 'id' --output text)

root_id=$(aws --endpoint-url=http://localhost:4566 apigateway get-resources \
    --rest-api-id $api_id \
    --query 'items[0].id' --output text)

resource_id=$(aws --endpoint-url=http://localhost:4566 apigateway create-resource \
    --rest-api-id $api_id \
    --parent-id $root_id \
    --path-part '{proxy+}' \
    --query 'id' --output text)

aws --endpoint-url=http://localhost:4566 apigateway put-method \
    --rest-api-id $api_id \
    --resource-id $resource_id \
    --http-method ANY \
    --authorization-type NONE

aws --endpoint-url=http://localhost:4566 apigateway put-integration \
    --rest-api-id $api_id \
    --resource-id $resource_id \
    --http-method ANY \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:mi-api-handler/invocations

aws --endpoint-url=http://localhost:4566 apigateway put-method \
    --rest-api-id $api_id \
    --resource-id $root_id \
    --http-method ANY \
    --authorization-type NONE

aws --endpoint-url=http://localhost:4566 apigateway put-integration \
    --rest-api-id $api_id \
    --resource-id $root_id \
    --http-method ANY \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:mi-api-handler/invocations


aws --endpoint-url=http://localhost:4566 apigateway create-deployment \
    --rest-api-id $api_id \
    --stage-name prod

# Consultas
aws --endpoint-url=http://localhost:4566 lambda list-functions \
  --query "Functions[*].{Name:FunctionName, Runtime:Runtime}"

# consultar tablas
aws --endpoint-url=http://localhost:4566 dynamodb list-tables

# consultar bucket y su contenido
for b in $(aws --endpoint-url=http://localhost:4566 s3 ls | awk '{print $3}'); do
  echo "Bucket: $b"
  aws --endpoint-url=http://localhost:4566 s3 ls s3://$b --recursive
done

# consultar api
# 1. Health check
curl "$API_URL/health" | jq

# 2. Ver estadísticas del sistema
curl "$API_URL/stats" | jq

# Si neceistas actualizar codigo
aws --endpoint-url http://localhost:4566  lambda update-function-code \
  --function-name mi-api-handler \
  --zip-file  fileb://mi-api.zip