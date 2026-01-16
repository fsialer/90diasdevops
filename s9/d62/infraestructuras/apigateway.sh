#Arquitectura 4: API Gateway completa
#Función Lambda para AP
# El codigo se encunetra en el directorio api

#Paso 2: Desplegar API Lambda**
# Empaquetar función API
zip api-handler.zip api_handler.py

# Crear función Lambda para API
awslocal lambda create-function \
    --function-name roxs-api-handler \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler api_handler.lambda_handler \
    --zip-file fileb://api-handler.zip \
    --timeout 30 \
    --description "API Gateway handler: rutas completas de la aplicación"
    
aws --endpoint-url=http://localhost:4566 lambda create-function \
    --function-name roxs-api-handler \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler api_handler.lambda_handler \
    --zip-file fileb://api-handler.zip \
    --timeout 30 \
    --description "API Gateway handler: rutas completas de la aplicación"

#Paso 3: Crear API Gateway
# Crear API REST
api_id=$(awslocal apigateway create-rest-api \
    --name 'roxs-complete-api' \
    --description 'API completa con múltiples servicios integrados' \
    --query 'id' --output text)

api_id=$(aws --endpoint-url=http://localhost:4566 apigateway create-rest-api \
    --name 'roxs-complete-api' \
    --description 'API completa con múltiples servicios integrados' \
    --query 'id' --output text)

echo "API ID: $api_id"

# Obtener resource root
root_id=$(awslocal apigateway get-resources \
    --rest-api-id $api_id \
    --query 'items[0].id' --output text)

root_id=$(aws --endpoint-url=http://localhost:4566 apigateway get-resources \
    --rest-api-id $api_id \
    --query 'items[0].id' --output text)

echo "Root Resource ID: $root_id"

# Crear resource para capturar todas las rutas
resource_id=$(awslocal apigateway create-resource \
    --rest-api-id $api_id \
    --parent-id $root_id \
    --path-part '{proxy+}' \
    --query 'id' --output text)

resource_id=$(aws --endpoint-url=http://localhost:4566 apigateway create-resource \
    --rest-api-id $api_id \
    --parent-id $root_id \
    --path-part '{proxy+}' \
    --query 'id' --output text)

echo "Proxy Resource ID: $resource_id"

# Crear método ANY para manejar todos los HTTP methods
awslocal apigateway put-method \
    --rest-api-id $api_id \
    --resource-id $resource_id \
    --http-method ANY \
    --authorization-type NONE

aws --endpoint-url=http://localhost:4566 apigateway put-method \
    --rest-api-id $api_id \
    --resource-id $resource_id \
    --http-method ANY \
    --authorization-type NONE

# Integrar con Lambda
awslocal apigateway put-integration \
    --rest-api-id $api_id \
    --resource-id $resource_id \
    --http-method ANY \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:roxs-api-handler/invocations

aws --endpoint-url=http://localhost:4566 apigateway put-integration \
    --rest-api-id $api_id \
    --resource-id $resource_id \
    --http-method ANY \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:roxs-api-handler/invocations

# También agregar método root
awslocal apigateway put-method \
    --rest-api-id $api_id \
    --resource-id $root_id \
    --http-method ANY \
    --authorization-type NONE

aws --endpoint-url=http://localhost:4566 apigateway put-method \
    --rest-api-id $api_id \
    --resource-id $root_id \
    --http-method ANY \
    --authorization-type NONE

awslocal apigateway put-integration \
    --rest-api-id $api_id \
    --resource-id $root_id \
    --http-method ANY \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:roxs-api-handler/invocations

aws --endpoint-url=http://localhost:4566 apigateway put-integration \
    --rest-api-id $api_id \
    --resource-id $root_id \
    --http-method ANY \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:roxs-api-handler/invocations


# Desplegar API
awslocal apigateway create-deployment \
    --rest-api-id $api_id \
    --stage-name prod

aws --endpoint-url=http://localhost:4566 apigateway create-deployment \
    --rest-api-id $api_id \
    --stage-name prod

echo "API URL: http://localhost:4566/restapis/$api_id/prod/_user_request_"


#Paso 4: Probar API completa
# Guardar API URL para facilidad
API_URL="http://localhost:4566/restapis/$api_id/prod/_user_request_"

# 1. Health check
curl "$API_URL/health" | jq

# 2. Ver estadísticas del sistema
curl "$API_URL/stats" | jq

# 3. Listar imágenes procesadas
curl "$API_URL/images" | jq

# 4. Ver logs recientes
curl "$API_URL/logs" | jq

# 5. Listar archivos en S3
curl "$API_URL/files" | jq

# 6. Crear notificación via API
curl -X POST "$API_URL/notifications" \
    -H "Content-Type: application/json" \
    -d '{
        "title": "Notificación desde API",
        "message": "Esta notificación fue creada via REST API",
        "priority": "high"
    }' | jq

# 7. Verificar endpoint no existente
curl "$API_URL/nonexistent" | jq

