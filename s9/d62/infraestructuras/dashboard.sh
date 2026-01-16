# Empaquetar dashboard
zip dashboard.zip dashboard.py

# Crear función
awslocal lambda create-function \
    --function-name roxs-dashboard \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler dashboard.lambda_handler \
    --zip-file fileb://dashboard.zip \
    --timeout 30 \
    --description "Dashboard de métricas del sistema completo"

aws --endpoint-url=http://localhost:4566 lambda create-function \
    --function-name roxs-dashboard \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler dashboard.lambda_handler \
    --zip-file fileb://dashboard.zip \
    --timeout 30 \
    --description "Dashboard de métricas del sistema completo"

# Probar dashboard
awslocal lambda invoke \
    --function-name roxs-dashboard \
    dashboard-output.json

aws --endpoint-url=http://localhost:4566  lambda invoke \
    --function-name roxs-dashboard \
    dashboard-output.json

cat dashboard-output.json | jq