#!/bin/bash
ADMIN="admin@ejemplo.com"
USO_RAIZ=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
TAMANO_HOME=$(du -sh /home 2>/dev/null | awk '{print $1}' | sed 's/G//g')
FILE_LOG="backup_$(date +%Y%m%d_%H%M%S)"
LOG_DIR=~/logs
LOG_PATH="$LOG_DIR/${FIE_LOG}.log"
mkdir -p "$LOG_DIR"

{
echo "***************************"
echo "********* REPORTE *********"
echo "***************************"
printf "%-15s %s\n" "Admin:" "$ADMIN"
printf "%-15s %s%%\n" "Espacio raiz:" "$USO_RAIZ"
printf "%-15s %sG\n" "Espacio /home:" "$TAMANO_HOME"
printf "%-15s %s\n" "Fecha:" "$(date)"
} > "$LOG_PATH"
echo "Log generado en: $LOG_PATH"
