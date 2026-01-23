# 🚀 ¡Desplegar tu infraestructura!
# Paso 1: Inicializar Terraform
# Ir a la carpeta de terraform
cd terraform

# Inicializar Terraform (solo la primera vez)
terraform init

#Paso 2: Validar la configuración
# Verificar que no hay errores de sintaxis
terraform validate

#Paso 3: Ver qué se va a crear
# Ver el plan de ejecución
terraform plan -var="student_name=TU_NOMBRE_AQUI"

#Paso 4: ¡Crear la infraestructura!
# Ver todos los outputs
terraform output

#Probar tu infraestructura
#Verificar que todo se creó correctamente
# 1. Verificar buckets S3
awslocal s3 ls

# 2. Verificar tablas DynamoDB
awslocal dynamodb list-tables

# 3. Verificar función Lambda
awslocal lambda list-functions --query 'Functions[].FunctionName'

# 4. Probar la función Lambda
awslocal lambda invoke \
    --function-name mi-lambda-TU_NOMBRE \
    --payload '{"test": "Hola desde Terraform!"}' \
    output.json

# 5. Ver el resultado
cat output.json | jq

#Agregar datos de prueba
# Agregar un usuario a DynamoDB
awslocal dynamodb put-item \
    --table-name mi-tabla-usuarios-TU_NOMBRE \
    --item '{
        "user_id": {"S": "user001"},
        "name": {"S": "Usuario Terraform"},
        "email": {"S": "usuario@terraform.local"},
        "created_by": {"S": "Terraform"}
    }'

# Verificar que se guardó
awslocal dynamodb get-item \
    --table-name mi-tabla-usuarios-TU_NOMBRE \
    --key '{"user_id": {"S": "user001"}}'

# Subir un archivo a S3
echo "Archivo creado con Terraform" > test-terraform.txt
awslocal s3 cp test-terraform.txt s3://mi-bucket-archivos-TU_NOMBRE/

# Verificar que se subió
awslocal s3 ls s3://mi-bucket-archivos-TU_NOMBRE/

#Limpiar recursos
# Eliminar TODO lo que creamos
terraform destroy -var="student_name=TU_NOMBRE_AQUI"

#Usar el script
# Hacer el script ejecutable
chmod +x deploy.sh

# Ejecutar con tu nombre
./deploy.sh tu-nombre-aqui