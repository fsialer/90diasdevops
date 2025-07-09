#!/bin/bash

# Nombre del archivo de respaldo con fecha y hora
FILE_ZIP="backup_$(date +%Y%m%d_%H%M%S)"
zip -r "$FILE_ZIP.zip" /var/log

# Crear el directorio si no existe
mkdir -p ~/backups

# Mover el backup al directorio
mv "$FILE_ZIP.zip" ~/backups

# Eliminar todos los archivos zip con más de 7 días
find ~/backups -name "*.zip" -type f -mtime +7 -exec rm {} \;
