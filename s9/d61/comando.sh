# Crear tabla de usuarios con solo Partition Key
awslocal dynamodb create-table \
    --table-name RoxsUsers \
    --attribute-definitions \
        AttributeName=UserId,AttributeType=S \
    --key-schema \
        AttributeName=UserId,KeyType=HASH \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

aws --endpoint-url=http://localhost:4566 dynamodb create-table \
    --table-name RoxsUsers \
    --attribute-definitions \
        AttributeName=UserId,AttributeType=S \
    --key-schema \
        AttributeName=UserId,KeyType=HASH \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

# Crear tabla de posts con Partition Key + Sort Key
awslocal dynamodb create-table \
    --table-name RoxsPosts \
    --attribute-definitions \
        AttributeName=UserId,AttributeType=S \
        AttributeName=PostId,AttributeType=S \
    --key-schema \
        AttributeName=UserId,KeyType=HASH \
        AttributeName=PostId,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

aws --endpoint-url=http://localhost:4566 dynamodb create-table \
    --table-name RoxsPosts \
    --attribute-definitions \
        AttributeName=UserId,AttributeType=S \
        AttributeName=PostId,AttributeType=S \
    --key-schema \
        AttributeName=UserId,KeyType=HASH \
        AttributeName=PostId,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

# Crear tabla de eventos con timestamp como Sort Key
awslocal dynamodb create-table \
    --table-name RoxsEvents \
    --attribute-definitions \
        AttributeName=EventType,AttributeType=S \
        AttributeName=Timestamp,AttributeType=N \
    --key-schema \
        AttributeName=EventType,KeyType=HASH \
        AttributeName=Timestamp,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

aws --endpoint-url=http://localhost:4566 dynamodb create-table \
    --table-name RoxsEvents \
    --attribute-definitions \
        AttributeName=EventType,AttributeType=S \
        AttributeName=Timestamp,AttributeType=N \
    --key-schema \
        AttributeName=EventType,KeyType=HASH \
        AttributeName=Timestamp,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5

# Listar todas las tablas
awslocal dynamodb list-tables
aws --endpoint-url=http://localhost:4566 dynamodb list-tables

# Ver detalles de una tabla específica
awslocal dynamodb describe-table --table-name RoxsUsers
aws --endpoint-url=http://localhost:4566 dynamodb describe-table --table-name RoxsUsers

# Ver schema de la tabla
awslocal dynamodb describe-table --table-name RoxsUsers \
    --query 'Table.[TableName,KeySchema,AttributeDefinitions]'

aws --endpoint-url=http://localhost:4566 dynamodb describe-table --table-name RoxsUsers \
    --query 'Table.[TableName,KeySchema,AttributeDefinitions]'

# Usuario 1 - Estructura básica
awslocal dynamodb put-item \
    --table-name RoxsUsers \
    --item '{
        "UserId": {"S": "user001"},
        "Name": {"S": "Ana García"},
        "Email": {"S": "ana@roxs.com"},
        "Age": {"N": "28"},
        "Skills": {"SS": ["Python", "AWS", "DevOps"]},
        "IsActive": {"BOOL": true},
        "JoinDate": {"S": "2024-06-01"}
    }'

aws --endpoint-url=http://localhost:4566  dynamodb put-item \
    --table-name RoxsUsers \
    --item '{
        "UserId": {"S": "user001"},
        "Name": {"S": "Ana García"},
        "Email": {"S": "ana@roxs.com"},
        "Age": {"N": "28"},
        "Skills": {"SS": ["Python", "AWS", "DevOps"]},
        "IsActive": {"BOOL": true},
        "JoinDate": {"S": "2024-06-01"}
    }'

# Usuario 2 - Con más atributos
awslocal dynamodb put-item \
    --table-name RoxsUsers \
    --item '{
        "UserId": {"S": "user002"},
        "Name": {"S": "Carlos López"},
        "Email": {"S": "carlos@roxs.com"},
        "Age": {"N": "32"},
        "Skills": {"SS": ["JavaScript", "Docker", "Kubernetes"]},
        "IsActive": {"BOOL": true},
        "JoinDate": {"S": "2024-05-15"},
        "Department": {"S": "Engineering"},
        "Salary": {"N": "75000"}
    }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name RoxsUsers \
    --item '{
        "UserId": {"S": "user002"},
        "Name": {"S": "Carlos López"},
        "Email": {"S": "carlos@roxs.com"},
        "Age": {"N": "32"},
        "Skills": {"SS": ["JavaScript", "Docker", "Kubernetes"]},
        "IsActive": {"BOOL": true},
        "JoinDate": {"S": "2024-05-15"},
        "Department": {"S": "Engineering"},
        "Salary": {"N": "75000"}
    }'

# Usuario 3 - Estructura diferente (NoSQL flexibility!)
awslocal dynamodb put-item \
    --table-name RoxsUsers \
    --item '{
        "UserId": {"S": "user003"},
        "Name": {"S": "María Rodríguez"},
        "Email": {"S": "maria@roxs.com"},
        "Age": {"N": "25"},
        "Skills": {"SS": ["Java", "Spring", "Microservices"]},
        "IsActive": {"BOOL": false},
        "JoinDate": {"S": "2024-04-20"},
        "Projects": {"L": [
            {"S": "Project Alpha"},
            {"S": "Project Beta"}
        ]},
        "Preferences": {"M": {
            "Theme": {"S": "dark"},
            "Language": {"S": "es"},
            "Notifications": {"BOOL": true}
        }}
    }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name RoxsUsers \
    --item '{
        "UserId": {"S": "user003"},
        "Name": {"S": "María Rodríguez"},
        "Email": {"S": "maria@roxs.com"},
        "Age": {"N": "25"},
        "Skills": {"SS": ["Java", "Spring", "Microservices"]},
        "IsActive": {"BOOL": false},
        "JoinDate": {"S": "2024-04-20"},
        "Projects": {"L": [
            {"S": "Project Alpha"},
            {"S": "Project Beta"}
        ]},
        "Preferences": {"M": {
            "Theme": {"S": "dark"},
            "Language": {"S": "es"},
            "Notifications": {"BOOL": true}
        }}
    }'

# Post 1
awslocal dynamodb put-item \
    --table-name RoxsPosts \
    --item '{
        "UserId": {"S": "user001"},
        "PostId": {"S": "post001"},
        "Title": {"S": "Mi experiencia con LocalStack"},
        "Content": {"S": "LocalStack es increíble para desarrollo local..."},
        "CreatedAt": {"S": "2024-06-03T10:00:00Z"},
        "Tags": {"SS": ["localstack", "aws", "development"]},
        "Likes": {"N": "15"},
        "Views": {"N": "120"}
    }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name RoxsPosts \
    --item '{
        "UserId": {"S": "user001"},
        "PostId": {"S": "post001"},
        "Title": {"S": "Mi experiencia con LocalStack"},
        "Content": {"S": "LocalStack es increíble para desarrollo local..."},
        "CreatedAt": {"S": "2024-06-03T10:00:00Z"},
        "Tags": {"SS": ["localstack", "aws", "development"]},
        "Likes": {"N": "15"},
        "Views": {"N": "120"}
    }'

# Post 2
awslocal dynamodb put-item \
    --table-name RoxsPosts \
    --item '{
        "UserId": {"S": "user001"},
        "PostId": {"S": "post002"},
        "Title": {"S": "DynamoDB vs SQL: ¿Cuándo usar cada uno?"},
        "Content": {"S": "La elección entre NoSQL y SQL depende de varios factores..."},
        "CreatedAt": {"S": "2024-06-02T14:30:00Z"},
        "Tags": {"SS": ["database", "nosql", "sql"]},
        "Likes": {"N": "8"},
        "Views": {"N": "95"}
    }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name RoxsPosts \
    --item '{
        "UserId": {"S": "user001"},
        "PostId": {"S": "post002"},
        "Title": {"S": "DynamoDB vs SQL: ¿Cuándo usar cada uno?"},
        "Content": {"S": "La elección entre NoSQL y SQL depende de varios factores..."},
        "CreatedAt": {"S": "2024-06-02T14:30:00Z"},
        "Tags": {"SS": ["database", "nosql", "sql"]},
        "Likes": {"N": "8"},
        "Views": {"N": "95"}
    }'
# Post de otro usuario
awslocal dynamodb put-item \
    --table-name RoxsPosts \
    --item '{
        "UserId": {"S": "user002"},
        "PostId": {"S": "post001"},
        "Title": {"S": "Kubernetes en producción"},
        "Content": {"S": "Lecciones aprendidas después de 2 años con K8s..."},
        "CreatedAt": {"S": "2024-06-01T09:15:00Z"},
        "Tags": {"SS": ["kubernetes", "devops", "production"]},
        "Likes": {"N": "23"},
        "Views": {"N": "189"}
    }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name RoxsPosts \
    --item '{
        "UserId": {"S": "user002"},
        "PostId": {"S": "post001"},
        "Title": {"S": "Kubernetes en producción"},
        "Content": {"S": "Lecciones aprendidas después de 2 años con K8s..."},
        "CreatedAt": {"S": "2024-06-01T09:15:00Z"},
        "Tags": {"SS": ["kubernetes", "devops", "production"]},
        "Likes": {"N": "23"},
        "Views": {"N": "189"}
    }'

# Eventos de login
awslocal dynamodb put-item \
    --table-name RoxsEvents \
    --item '{
        "EventType": {"S": "login"},
        "Timestamp": {"N": "1717401600"},
        "UserId": {"S": "user001"},
        "IP": {"S": "192.168.1.100"},
        "UserAgent": {"S": "Chrome/124.0"},
        "Success": {"BOOL": true}
    }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name RoxsEvents \
    --item '{
        "EventType": {"S": "login"},
        "Timestamp": {"N": "1717401600"},
        "UserId": {"S": "user001"},
        "IP": {"S": "192.168.1.100"},
        "UserAgent": {"S": "Chrome/124.0"},
        "Success": {"BOOL": true}
    }'
# Evento de error
awslocal dynamodb put-item \
    --table-name RoxsEvents \
    --item '{
        "EventType": {"S": "error"},
        "Timestamp": {"N": "1717401700"},
        "ErrorCode": {"S": "500"},
        "Message": {"S": "Database connection timeout"},
        "Service": {"S": "api-gateway"},
        "Severity": {"S": "high"}
    }'

aws --endpoint-url=http://localhost:4566 dynamodb put-item \
    --table-name RoxsEvents \
    --item '{
        "EventType": {"S": "error"},
        "Timestamp": {"N": "1717401700"},
        "ErrorCode": {"S": "500"},
        "Message": {"S": "Database connection timeout"},
        "Service": {"S": "api-gateway"},
        "Severity": {"S": "high"}
    }'

# Obtener usuario específico
awslocal dynamodb get-item \
    --table-name RoxsUsers \
    --key '{"UserId": {"S": "user001"}}'

aws --endpoint-url=http://localhost:4566 dynamodb get-item \
    --table-name RoxsUsers \
    --key '{"UserId": {"S": "user001"}}'

# Obtener post específico (requiere Partition + Sort Key)
awslocal dynamodb get-item \
    --table-name RoxsPosts \
    --key '{
        "UserId": {"S": "user001"},
        "PostId": {"S": "post001"}
    }'
aws --endpoint-url=http://localhost:4566 dynamodb get-item \
    --table-name RoxsPosts \
    --key '{
        "UserId": {"S": "user001"},
        "PostId": {"S": "post001"}
    }'
# Obtener solo ciertos atributos
awslocal dynamodb get-item \
    --table-name RoxsUsers \
    --key '{"UserId": {"S": "user002"}}' \
    --projection-expression "Name,Email,Skills"

# Crear placeholder y mapper lo atributos
aws --endpoint-url=http://localhost:4566 dynamodb get-item \
    --table-name RoxsUsers \
    --key '{"UserId": {"S": "user002"}}' \
    --projection-expression "#n,#e,#s" \
    --expression-attribute-names '{"#n":"Name","#e":"Email","#s":"Skills"}'

# Obtener todos los posts de un usuario
awslocal dynamodb query \
    --table-name RoxsPosts \
    --key-condition-expression "UserId = :userId" \
    --expression-attribute-values '{":userId": {"S": "user001"}}'

aws --endpoint-url=http://localhost:4566 dynamodb query \
    --table-name RoxsPosts \
    --key-condition-expression "UserId = :userId" \
    --expression-attribute-values '{":userId": {"S": "user001"}}'

# Consultar eventos por tipo en un rango de tiempo
awslocal dynamodb query \
    --table-name RoxsEvents \
    --key-condition-expression "EventType = :type AND #ts BETWEEN :start AND :end" \
    --expression-attribute-names '{"#ts": "Timestamp"}' \
    --expression-attribute-values '{
        ":type": {"S": "login"},
        ":start": {"N": "1717401000"},
        ":end": {"N": "1717401800"}
    }'

aws --endpoint-url=http://localhost:4566  dynamodb query \
    --table-name RoxsEvents \
    --key-condition-expression "EventType = :type AND #ts BETWEEN :start AND :end" \
    --expression-attribute-names '{"#ts": "Timestamp"}' \
    --expression-attribute-values '{
        ":type": {"S": "login"},
        ":start": {"N": "1717401000"},
        ":end": {"N": "1717401800"}
    }'

# Actualizar edad y agregar nuevo skill
awslocal dynamodb update-item \
    --table-name RoxsUsers \
    --key '{"UserId": {"S": "user001"}}' \
    --update-expression "SET Age = :newAge, Skills = list_append(Skills, :newSkill)" \
    --expression-attribute-values '{
        ":newAge": {"N": "29"},
        ":newSkill": {"SS": ["LocalStack"]}
    }'

aws --endpoint-url=http://localhost:4566 dynamodb update-item \
  --table-name RoxsUsers \
  --key '{"UserId": {"S": "user001"}}' \
  --update-expression "SET Age = :newAge ADD Skills :newSkill" \
  --expression-attribute-values '{":newAge": {"N": "29"}, ":newSkill": {"SS": ["LocalStack"]}}'



# Incrementar contador de likes
awslocal dynamodb update-item \
    --table-name RoxsPosts \
    --key '{
        "UserId": {"S": "user001"},
        "PostId": {"S": "post001"}
    }' \
    --update-expression "ADD Likes :inc" \
    --expression-attribute-values '{":inc": {"N": "1"}}'

aws --endpoint-url=http://localhost:4566 dynamodb update-item \
    --table-name RoxsPosts \
    --key '{
        "UserId": {"S": "user001"},
        "PostId": {"S": "post001"}
    }' \
    --update-expression "ADD Likes :inc" \
    --expression-attribute-values '{":inc": {"N": "1"}}'

# Agregar nuevo atributo
awslocal dynamodb update-item \
    --table-name RoxsUsers \
    --key '{"UserId": {"S": "user003"}}' \
    --update-expression "SET LastLogin = :login" \
    --expression-attribute-values '{":login": {"S": "2024-06-03T15:30:00Z"}}'

aws --endpoint-url=http://localhost:4566 dynamodb update-item \
    --table-name RoxsUsers \
    --key '{"UserId": {"S": "user003"}}' \
    --update-expression "SET LastLogin = :login" \
    --expression-attribute-values '{":login": {"S": "2024-06-03T15:30:00Z"}}'

# Actualizar solo si el usuario está activo
awslocal dynamodb update-item \
    --table-name RoxsUsers \
    --key '{"UserId": {"S": "user002"}}' \
    --update-expression "SET LastSeen = :now" \
    --condition-expression "IsActive = :active" \
    --expression-attribute-values '{
        ":now": {"S": "2024-06-03T16:00:00Z"},
        ":active": {"BOOL": true}
    }'

aws --endpoint-url=http://localhost:4566 dynamodb update-item \
    --table-name RoxsUsers \
    --key '{"UserId": {"S": "user002"}}' \
    --update-expression "SET LastSeen = :now" \
    --condition-expression "IsActive = :active" \
    --expression-attribute-values '{
        ":now": {"S": "2024-06-03T16:00:00Z"},
        ":active": {"BOOL": true}
    }'

# Eliminar usuario
awslocal dynamodb delete-item \
    --table-name RoxsUsers \
    --key '{"UserId": {"S": "user003"}}'

aws --endpoint-url=http://localhost:4566 dynamodb delete-item \
    --table-name RoxsUsers \
    --key '{"UserId": {"S": "user003"}}'

# Eliminar post específico
awslocal dynamodb delete-item \
    --table-name RoxsPosts \
    --key '{
        "UserId": {"S": "user002"},
        "PostId": {"S": "post001"}
    }'

aws --endpoint-url=http://localhost:4566 dynamodb delete-item \
    --table-name RoxsPosts \
    --key '{
        "UserId": {"S": "user002"},
        "PostId": {"S": "post001"}
    }'

# Eliminar solo si existe
awslocal dynamodb delete-item \
    --table-name RoxsUsers \
    --key '{"UserId": {"S": "user999"}}' \
    --condition-expression "attribute_exists(UserId)"

aws --endpoint-url=http://localhost:4566 dynamodb delete-item \
    --table-name RoxsUsers \
    --key '{"UserId": {"S": "user999"}}' \
    --condition-expression "attribute_exists(UserId)"

# Crear archivo JSON para batch operations
cat > batch-operations.json << 'EOF'
{
    "RoxsUsers": [
        {
            "PutRequest": {
                "Item": {
                    "UserId": {"S": "batch001"},
                    "Name": {"S": "Usuario Batch 1"},
                    "Email": {"S": "batch1@roxs.com"},
                    "Age": {"N": "30"}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "UserId": {"S": "batch002"},
                    "Name": {"S": "Usuario Batch 2"},
                    "Email": {"S": "batch2@roxs.com"},
                    "Age": {"N": "25"}
                }
            }
        }
    ]
}
EOF

# Ejecutar batch write
awslocal dynamodb batch-write-item --request-items file://batch-operations.json
aws --endpoint-url=http://localhost:4566  dynamodb batch-write-item --request-items file://batch-operations.json

# Crear archivo para batch get
cat > batch-get.json << 'EOF'
{
    "RoxsUsers": {
        "Keys": [
            {"UserId": {"S": "user001"}},
            {"UserId": {"S": "batch001"}},
            {"UserId": {"S": "batch002"}}
        ],
        "ProjectionExpression": "UserId,Name,Email"
    }
}
EOF

# Ejecutar batch get
awslocal dynamodb batch-get-item --request-items file://batch-get.json
aws --endpoint-url=http://localhost:4566  dynamodb batch-get-item --request-items file://batch-get.json

# Empaquetar función
zip lambda-dynamodb.zip lambda_dynamodb.py

# Crear función
awslocal lambda create-function \
    --function-name roxs-dynamodb-function \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler lambda_dynamodb.lambda_handler \
    --zip-file fileb://lambda-dynamodb.zip \
    --timeout 30 \
    --description "Función Lambda que interactúa con DynamoDB"

aws --endpoint-url=http://localhost:4566 lambda create-function \
    --function-name roxs-dynamodb-function \
    --runtime python3.9 \
    --role arn:aws:iam::000000000000:role/lambda-role \
    --handler lambda_dynamodb.lambda_handler \
    --zip-file fileb://lambda-dynamodb.zip \
    --timeout 30 \
    --description "Función Lambda que interactúa con DynamoDB"

# Crear usuario
awslocal lambda invoke \
    --function-name roxs-dynamodb-function \
    --payload '{
        "action": "create_user",
        "user_data": {
            "name": "Lambda User",
            "email": "lambda@roxs.com"
        }
    }' \
    lambda-create-output.json

aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name roxs-dynamodb-function \
    --payload '{
        "action": "create_user",
        "user_data": {
            "name": "Lambda User",
            "email": "lambda@roxs.com"
        }
    }' \
    --cli-binary-format raw-in-base64-out \
    lambda-create-output.json

cat lambda-create-output.json

# Listar usuarios
awslocal lambda invoke \
    --function-name roxs-dynamodb-function \
    --payload '{"action": "list_users"}' \
    lambda-list-output.json

aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name roxs-dynamodb-function \
    --payload '{"action": "list_users"}' \
    --cli-binary-format raw-in-base64-out \
    lambda-list-output.json

cat lambda-list-output.json

# Obtener usuario específico
awslocal lambda invoke \
    --function-name roxs-dynamodb-function \
    --payload '{
        "action": "get_user",
        "user_id": "user001"
    }' \
    lambda-get-output.json

aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name roxs-dynamodb-function \
    --payload '{
        "action": "get_user",
        "user_id": "user001"
    }' \
    --cli-binary-format raw-in-base64-out \
    lambda-get-output.json

# Tips Pro del día
# Performance en DynamoDB
# Usar Query en lugar de Scan siempre que sea posible
# Query es O(log n), Scan es O(n)

# ✅ Bueno: Query con Partition Key
awslocal dynamodb query --table-name RoxsPosts \
    --key-condition-expression "UserId = :uid"

# ❌ Malo: Scan con filtro
awslocal dynamodb scan --table-name RoxsPosts \
    --filter-expression "UserId = :uid"

# Diseño de Primary Keys
# Para datos jerárquicos, usa Composite Keys:
# PK: EntityType (USER, POST, COMMENT)
# SK: EntityID o Timestamp

# Ejemplo:
# USER#user123 | PROFILE
# USER#user123 | POST#post456
# USER#user123 | POST#post789

# Agregaciones simples
# Contar items
awslocal dynamodb scan --table-name RoxsUsers --select COUNT

# Obtener solo atributos específicos
awslocal dynamodb scan --table-name RoxsUsers \
    --projection-expression "UserId,Name,Email"

# Backup y restore
# "Backup" usando scan
awslocal dynamodb scan --table-name RoxsUsers > backup-users.json

# Nota: En LocalStack real necesitarías scripts más sofisticados
# para restore, pero este enfoque funciona para development

# Comandos útiles para desarrollo
# Ver schema rápido
awslocal dynamodb describe-table --table-name TABLE_NAME \
    --query 'Table.[KeySchema,AttributeDefinitions]'

# Limpiar tabla (eliminar todos los items)
# Nota: No hay comando directo, necesitas scan + batch-delete

# Eliminar tabla completa
awslocal dynamodb delete-table --table-name TABLE_NAME

# Patrones de acceso comunes
#1:1: get-item con Primary Key
#1:N: query con Partition Key
#N:M: GSI (Global Secondary Index) - disponible en LocalStack Pro
#Búsqueda de texto: Scan con FilterExpression (no recomendado para prod)