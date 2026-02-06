# Guía de Despliegue

## Despliegue Local
1. git clone <repository-url>
2. docker-compose up -d
3. curl http://localhost:3000/health

## Despliegue en Producción
1. Conectar SSH a servidor
2. Instalar Docker y Docker Compose
3. Clonar repo y configurar .env
4. docker-compose -f docker-compose.prod.yml up -d
