#Parte 2: Primer despliegue (25 minutos)
#Inicializar Terraform:

cd terraform
terraform init

#Validar configuración:

terraform validate

#Ver el plan:

terraform plan -var="student_name=tu-nombre"

#Desplegar infraestructura:

terraform apply -var="student_name=tu-nombre"

#Ver los outputs:

terraform output

#🧪 Parte 3: Probar la infraestructura (15 minutos)
#Verificar recursos creados:

awslocal s3 ls
aws --endpoint-url=http://localhost:4566 s3 ls
awslocal dynamodb list-tables
aws --endpoint-url=http://localhost:4566 dynamodb list-tables
awslocal lambda list-functions
aws --endpoint-url=http://localhost:4566 lambda list-functions

#Probar la función Lambda:

awslocal lambda invoke \
    --function-name mi-lambda-tu-nombre \
    --payload '{"mensaje": "Hola Terraform!"}' \
    resultado.json

aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name mi-lambda-fernando \
    --payload '{"mensaje": "Hola Terraform!"}' \
    --cli-binary-format raw-in-base64-out \
    resultado.json

cat resultado.json

#Agregar datos de prueba:

# Usuario en DynamoDB
awslocal dynamodb put-item \
    --table-name mi-tabla-usuarios-tu-nombre \
    --item '{"user_id": {"S": "test001"}, "name": {"S": "Usuario Test"}}'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name mi-tabla-usuarios-tu-nombre \
    --item '{"user_id": {"S": "test001"}, "name": {"S": "Usuario Test"}}'

# Archivo en S3
echo "Mi primer archivo con Terraform" > test.txt
awslocal s3 cp test.txt s3://mi-bucket-archivos-tu-nombre/
aws --endpoint-url=http://localhost:4566 s3 cp test.txt s3://mi-bucket-archivos-tu-nombre/

#Parte 5: Limpieza
#Eliminar toda la infraestructura:

terraform destroy -var="student_name=tu-nombre"

#Verificar que todo se eliminó:

awslocal s3 ls
aws --endpoint-url=http://localhost:4566 s3 ls
awslocal dynamodb list-tables
aws --endpoint-url=http://localhost:4566 dynamodb list-tables
awslocal lambda list-functions
aws --endpoint-url=http://localhost:4566 lambda list-functions