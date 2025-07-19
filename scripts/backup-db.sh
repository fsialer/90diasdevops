#!/bin/bash

# Configuración
CONTAINER_NAME="postgres"
DB_USER="postgres"
DB_NAME="votes_staging"
PGPASSWORD="password123"   # ¡O mejor usar una variable de entorno!
DATE=$(date +%Y-%m-%d_%H-%M)
BACKUP_FILE="/tmp/${DB_NAME}_backup_${DATE}.sql.gz"

# Dump comprimido desde dentro del contenedor
echo "📦 Generando backup de $DB_NAME..."
docker exec -e PGPASSWORD=$PGPASSWORD $CONTAINER_NAME pg_dump -U $DB_USER $DB_NAME | gzip > $BACKUP_FILE

if [ $? -eq 0 ]; then
  echo "✅ Backup generado en $BACKUP_FILE"
else
  echo "❌ Error al generar backup"
  exit 1
fi
