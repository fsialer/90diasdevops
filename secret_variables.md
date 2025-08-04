# Passwords de base de datos por ambiente
DEV_DB_PASSWORD=dev_password_123
STAGING_DB_PASSWORD=staging_password_456
PROD_DB_PASSWORD=super_secure_prod_password_789

# Credenciales LocalStack (opcionales, ya que usa 'test')
LOCALSTACK_ACCESS_KEY=test
LOCALSTACK_SECRET_KEY=test

# Si usas Docker Registry privado
DOCKER_USERNAME=tu_usuario
DOCKER_PASSWORD=tu_password

# Para notificaciones (opcional)
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...

# Variables específicas de LocalStack
LOCALSTACK_ENDPOINT=http://localhost:4566
AWS_DEFAULT_REGION=us-east-1