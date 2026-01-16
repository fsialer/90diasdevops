# Parte 1: Crear tu esquema de datos
# Crear tabla de perfiles de estudiantes:
awslocal dynamodb create-table \
    --table-name RoxsStudents \
    --attribute-definitions \
        AttributeName=StudentId,AttributeType=S \
    --key-schema \
        AttributeName=StudentId,KeyType=HASH \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

aws --endpoint-url=http://localhost:4566 dynamodb create-table \
    --table-name RoxsStudents \
    --attribute-definitions \
        AttributeName=StudentId,AttributeType=S \
    --key-schema \
        AttributeName=StudentId,KeyType=HASH \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

# Crear tabla de progreso diario:
awslocal dynamodb create-table \
    --table-name RoxsProgress \
    --attribute-definitions \
        AttributeName=StudentId,AttributeType=S \
        AttributeName=Day,AttributeType=N \
    --key-schema \
        AttributeName=StudentId,KeyType=HASH \
        AttributeName=Day,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

aws --endpoint-url=http://localhost:4566 dynamodb create-table \
    --table-name RoxsProgress \
    --attribute-definitions \
        AttributeName=StudentId,AttributeType=S \
        AttributeName=Day,AttributeType=N \
    --key-schema \
        AttributeName=StudentId,KeyType=HASH \
        AttributeName=Day,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

# Parte 2: Poblar con datos
# Agregar tu perfil:
awslocal dynamodb put-item \
    --table-name RoxsStudents \
    --item '{
        "StudentId": {"S": "Fernando"},
        "Name": {"S": "Tu Nombre Real"},
        "Email": {"S": "fernando@ejemplo.com"},
        "StartDate": {"S": "2024-05-01"},
        "Country": {"S": "Peru"},
        "TechSkills": {"SS": ["Java", "Javascript", "Python"]},
        "CurrentDay": {"N": "61"},
        "IsActive": {"BOOL": true}
    }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name RoxsStudents \
    --item '{
        "StudentId": {"S": "fernando"},
        "Name": {"S": "Fernando Sialer"},
        "Email": {"S": "fsialer@ejemplo.com"},
        "StartDate": {"S": "2024-05-01"},
        "Country": {"S": "Peru"},
        "TechSkills": {"SS": ["Java", "Javascript", "Python"]},
        "CurrentDay": {"N": "61"},
        "IsActive": {"BOOL": true}
    }'

# Agregar tu progreso hasta hoy:
# Día 59 - S3
awslocal dynamodb put-item \
    --table-name RoxsProgress \
    --item '{
        "StudentId": {"S": "TU_NOMBRE_AQUI"},
        "Day": {"N": "59"},
        "Topic": {"S": "S3 con LocalStack"},
        "Completed": {"BOOL": true},
        "Notes": {"S": "Aprendí a simular S3 localmente"},
        "Difficulty": {"N": "3"},
        "CompletedAt": {"S": "2024-06-01T18:00:00Z"}
    }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name RoxsProgress \
    --item '{
        "StudentId": {"S": "fernando"},
        "Day": {"N": "59"},
        "Topic": {"S": "S3 con LocalStack"},
        "Completed": {"BOOL": true},
        "Notes": {"S": "Aprendí a simular S3 localmente"},
        "Difficulty": {"N": "3"},
        "CompletedAt": {"S": "2024-06-01T18:00:00Z"}
    }'

# Día 60 - Lambda
awslocal dynamodb put-item \
    --table-name RoxsProgress \
    --item '{
        "StudentId": {"S": "TU_NOMBRE_AQUI"},
        "Day": {"N": "60"},
        "Topic": {"S": "Lambda con LocalStack"},
        "Completed": {"BOOL": true},
        "Notes": {"S": "Creé funciones serverless locales"},
        "Difficulty": {"N": "4"},
        "CompletedAt": {"S": "2024-06-02T19:30:00Z"}
    }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name RoxsProgress \
    --item '{
        "StudentId": {"S": "fernando"},
        "Day": {"N": "60"},
        "Topic": {"S": "Lambda con LocalStack"},
        "Completed": {"BOOL": true},
        "Notes": {"S": "Creé funciones serverless locales"},
        "Difficulty": {"N": "4"},
        "CompletedAt": {"S": "2024-06-02T19:30:00Z"}
    }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name RoxsProgress \
    --item '{
        "StudentId": {"S": "TU_NOMBRE_AQUI"},
        "Day": {"N": "60"},
        "Topic": {"S": "Lambda con LocalStack"},
        "Completed": {"BOOL": true},
        "Notes": {"S": "Creé funciones serverless locales"},
        "Difficulty": {"N": "4"},
        "CompletedAt": {"S": "2024-06-02T19:30:00Z"}
    }'



# Día 61 - DynamoDB (hoy)
awslocal dynamodb put-item \
    --table-name RoxsProgress \
    --item '{
        "StudentId": {"S": "TU_NOMBRE_AQUI"},
        "Day": {"N": "61"},
        "Topic": {"S": "DynamoDB con LocalStack"},
        "Completed": {"BOOL": true},
        "Notes": {"S": "Bases de datos NoSQL son increíbles"},
        "Difficulty": {"N": "4"},
        "CompletedAt": {"S": "2024-06-03T20:00:00Z"}
    }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name RoxsProgress \
    --item '{
        "StudentId": {"S": "fernando"},
        "Day": {"N": "61"},
        "Topic": {"S": "DynamoDB con LocalStack"},
        "Completed": {"BOOL": true},
        "Notes": {"S": "Bases de datos NoSQL son increíbles"},
        "Difficulty": {"N": "4"},
        "CompletedAt": {"S": "2024-06-03T20:00:00Z"}
    }'

# Parte 3: Consultas y análisis
# Consultar tu perfil:
awslocal dynamodb get-item \
    --table-name RoxsStudents \
    --key '{"StudentId": {"S": "TU_NOMBRE_AQUI"}}'

aws --endpoint-url=http://localhost:4566 dynamodb get-item \
    --table-name RoxsStudents \
    --key '{"StudentId": {"S": "fernando"}}'

# Ver todo tu progreso:
awslocal dynamodb query \
    --table-name RoxsProgress \
    --key-condition-expression "StudentId = :sid" \
    --expression-attribute-values '{":sid": {"S": "TU_NOMBRE_AQUI"}}'

aws --endpoint-url=http://localhost:4566 dynamodb query \
    --table-name RoxsProgress \
    --key-condition-expression "StudentId = :sid" \
    --expression-attribute-values '{":sid": {"S": "fernando"}}'

# Estadísticas de dificultad:
awslocal dynamodb scan \
    --table-name RoxsProgress \
    --filter-expression "StudentId = :sid" \
    --expression-attribute-values '{":sid": {"S": "TU_NOMBRE_AQUI"}}' \
    --projection-expression "Day,Topic,Difficulty"

aws --endpoint-url=http://localhost:4566 dynamodb scan \
    --table-name RoxsProgress \
    --filter-expression "StudentId = :sid" \
    --expression-attribute-values '{":sid": {"S": "fernando"}}' \
    --expression-attribute-names '{"#d": "Day"}' \
    --projection-expression "#d,Topic,Difficulty"

# Desplegar y probar:

zip my-progress.zip my_progress_function.py

awslocal lambda create-function \
    --function-name my-progress-tracker \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler my_progress_function.lambda_handler \
    --zip-file fileb://my-progress.zip

aws --endpoint-url=http://localhost:4566 lambda create-function \
    --function-name my-progress-tracker \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler my_progress_function.lambda_handler \
    --zip-file fileb://my-progress.zip

# Probar función
awslocal lambda invoke \
    --function-name my-progress-tracker \
    --payload '{"student_id": "TU_NOMBRE_AQUI"}' \
    my-progress-output.json

aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name my-progress-tracker \
    --payload '{"student_id": "fernando"}' \
    --cli-binary-format raw-in-base64-out \
    my-progress-output.json

cat my-progress-output.json
