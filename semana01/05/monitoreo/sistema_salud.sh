#!/bin/bash

TIEMPO=$(date "+%Y-%m-%d %H:%M:%S")
echo -e "Hora\t\t\tMemoria\t\tDisco (root)\tCPU"
segundos="3600"
fin=$((SECONDS+segundos))
contador_cpu_alta=0
UMBRAL_CPU=85
MAX_INTENTOS=3
LOG_ALERTAS="alertas_cpu.log"

while [ $SECONDS -lt $fin ]; do
    TIEMPO_ACTUAL=$(date "+%Y-%m-%d %H:%M:%S")
    MEMORIA=$(free -m | awk 'NR==2{printf "%.f%%\t\t", $3*100/$2 }')
    DISCO=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')
    CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf("%.f\n", 100 - $1)}')
    
    echo -e "$TIEMPO_ACTUAL\t$MEMORIA$DISCO$CPU%"

    if [ "$CPU" -gt "$UMBRAL_CPU" ]; then
        ((contador_cpu_alta++))
        echo "[$TIEMPO_ACTUAL] Advertencia: uso de CPU alto ($CPU%) - intento $contador_cpu_alta" >> "$LOG_ALERTAS"
    else
        contador_cpu_alta=0
    fi

    if [ "$contador_cpu_alta" -ge "$MAX_INTENTOS" ]; then
        echo "[$TIEMPO_ACTUAL] CPU superó el $UMBRAL_CPU% en $MAX_INTENTOS intentos seguidos." >> "$LOG_ALERTAS"
        
        # OPCIÓN 1: CORTAR monitoreo
        # echo "Cortando monitoreo por alto uso de CPU."
        # break

        # OPCIÓN 2: CONTINUAR monitoreo pero registrar alerta
        echo "Alerta registrada, pero monitoreo continúa."
        contador_cpu_alta=0
    fi

    sleep 3
done