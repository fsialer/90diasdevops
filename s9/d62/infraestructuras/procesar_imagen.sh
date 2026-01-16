#Paso 1: Configurar buckets S3
# Crear buckets especializados
awslocal s3 mb s3://roxs-images-original
aws --endpoint-url=http://localhost:4566 s3 mb s3://roxs-images-original
awslocal s3 mb s3://roxs-images-original
aws --endpoint-url=http://localhost:4566 s3 mb s3://roxs-images-original
awslocal s3 mb s3://roxs-images-processed
aws --endpoint-url=http://localhost:4566 s3 mb s3://roxs-images-processed
awslocal s3 mb s3://roxs-images-thumbnails
aws --endpoint-url=http://localhost:4566 s3 mb s3://roxs-images-thumbnails

# Verificar creación
awslocal s3 ls
aws --endpoint-url=http://localhost:4566 s3 ls

# Paso 2: Crear tabla DynamoDB para metadata
# Tabla para guardar información de procesamiento de imágenes
awslocal dynamodb create-table \
    --table-name RoxsImageMetadata \
    --attribute-definitions \
        AttributeName=ImageId,AttributeType=S \
        AttributeName=UploadTimestamp,AttributeType=N \
    --key-schema \
        AttributeName=ImageId,KeyType=HASH \
        AttributeName=UploadTimestamp,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

aws --endpoint-url=http://localhost:4566 dynamodb create-table \
    --table-name RoxsImageMetadata \
    --attribute-definitions \
        AttributeName=ImageId,AttributeType=S \
        AttributeName=UploadTimestamp,AttributeType=N \
    --key-schema \
        AttributeName=ImageId,KeyType=HASH \
        AttributeName=UploadTimestamp,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

# Verificar tabla
awslocal dynamodb describe-table --table-name RoxsImageMetadata
aws --endpoint-url=http://localhost:4566 dynamodb describe-table --table-name RoxsImageMetadata

# Paso 3: Crear función Lambda procesadora
# La aplicacion se encuentra en el directorio procesar_image

# Paso 4: Desplegar la función
# Empaquetar función
zip image-processor.zip image_processor.py

# Crear función Lambda
awslocal lambda create-function \
    --function-name roxs-image-processor \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler image_processor.lambda_handler \
    --zip-file fileb://image-processor.zip \
    --timeout 60 \
    --description "Procesador de imágenes: S3 → Lambda → DynamoDB"

aws --endpoint-url=http://localhost:4566  lambda create-function \
    --function-name roxs-image-processor \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler image_processor.lambda_handler \
    --zip-file fileb://image-processor.zip \
    --timeout 60 \
    --description "Procesador de imágenes: S3 -> Lambda -> DynamoDB"

# Verificar función
awslocal lambda list-functions --query 'Functions[?FunctionName==`roxs-image-processor`]'
aws --endpoint-url=http://localhost:4566 lambda list-functions --query 'Functions[?FunctionName==`roxs-image-processor`]'

# Paso 5: Probar la arquitectura
# 1. Crear imagen de prueba
echo "Esta es una imagen de prueba en formato texto" > test-image.jpg
echo "Otra imagen para procesar" > vacation-photo.png

# 2. Subir imágenes a S3
awslocal s3 cp test-image.jpg s3://roxs-images-original/
aws --endpoint-url=http://localhost:4566 s3 cp test-image.jpg s3://roxs-images-original/
awslocal s3 cp vacation-photo.png s3://roxs-images-original/photos/
aws --endpoint-url=http://localhost:4566 s3 cp vacation-photo.png s3://roxs-images-original/photos/

# 3. Procesar primera imagen
awslocal lambda invoke \
    --function-name roxs-image-processor \
    --payload '{
        "bucket": "roxs-images-original",
        "key": "test-image.jpg"
    }' \
    image-result1.json

aws --endpoint-url=http://localhost:4566  lambda invoke \
    --function-name roxs-image-processor \
    --payload '{
        "bucket": "roxs-images-original",
        "key": "test-image.jpg"
    }' \
    --cli-binary-format raw-in-base64-out \
    image-result1.json

cat image-result1.json

# 4. Procesar segunda imagen
awslocal lambda invoke \
    --function-name roxs-image-processor \
    --payload '{
        "bucket": "roxs-images-original", 
        "key": "photos/vacation-photo.png"
    }' \
    image-result2.json

aws --endpoint-url=http://localhost:4566  lambda invoke \
    --function-name roxs-image-processor \
    --payload '{
        "bucket": "roxs-images-original", 
        "key": "photos/vacation-photo.png"
    }' \
    --cli-binary-format raw-in-base64-out \
    image-result2.json

cat image-result2.json

# 5. Verificar que se crearon los archivos procesados
awslocal s3 ls s3://roxs-images-processed/ --recursive
aws --endpoint-url=http://localhost:4566 s3 ls s3://roxs-images-processed/ --recursive
awslocal s3 ls s3://roxs-images-thumbnails/ --recursive
aws --endpoint-url=http://localhost:4566 s3 ls s3://roxs-images-thumbnails/ --recursive

# 6. Verificar metadata en DynamoDB
awslocal dynamodb scan --table-name RoxsImageMetadata \
    --projection-expression "ImageId,OriginalKey,Status,ProcessedAt"

aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name RoxsImageMetadata \
    --expression-attribute-names '{"#st":"Status"}' \
    --projection-expression "ImageId,OriginalKey,#st,ProcessedAt"