#!/bin/bash
# deploy-lambda.sh

FUNCTION_NAME=$1
PYTHON_FILE=$2

if [ -z "$FUNCTION_NAME" ] || [ -z "$PYTHON_FILE" ]; then
    echo "Uso: $0 <function-name> <python-file>"
    echo "Ejemplo: $0 my-function lambda_function.py"
    exit 1
fi

echo "🚀 Desplegando función Lambda: $FUNCTION_NAME"

# Empaquetar
echo "📦 Empaquetando..."
zip ${FUNCTION_NAME}.zip $PYTHON_FILE

# Verificar si la función existe
if awslocal lambda get-function --function-name $FUNCTION_NAME >/dev/null 2>&1; then
    echo "🔄 Actualizando función existente..."
    awslocal lambda update-function-code \
        --function-name $FUNCTION_NAME \
        --zip-file fileb://${FUNCTION_NAME}.zip
else
    echo "✨ Creando nueva función..."
    awslocal lambda create-function \
        --function-name $FUNCTION_NAME \
        --runtime python3.9 \
        --role arn:aws:iam::000000000000:role/lambda-role \
        --handler ${PYTHON_FILE%.*}.lambda_handler \
        --zip-file fileb://${FUNCTION_NAME}.zip
fi

echo "✅ Función $FUNCTION_NAME desplegada!"

# Test básico
echo "🧪 Probando función..."
awslocal lambda invoke \
    --function-name $FUNCTION_NAME \
    --payload '{"test": true}' \
    test-output.json

echo "📄 Resultado del test:"
cat test-output.json
echo ""