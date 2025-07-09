#!/bin/bash

# Servicios a verificar
SERVICIOS=("nginx" "mysql" "docker")
SERVICIOS_CAIDOS=()
EMAIL_DESTINO="asialer05@hotmail.com"

# Revisión de estado
echo "Revisando estado de servicios..."

for SERVICIO in "${SERVICIOS[@]}"; do
    systemctl is-active --quiet "$SERVICIO"
    if [ $? -eq 0 ]; then
        echo "✅ $SERVICIO está activo."
    else
        echo "❌ $SERVICIO está CAÍDO."
        SERVICIOS_CAIDOS+=("$SERVICIO")
    fi
done

# Si hay servicios caídos, enviar email
if [ ${#SERVICIOS_CAIDOS[@]} -gt 0 ]; then
    MENSAJE="Los siguientes servicios están caídos:\n"
    for SERVICIO in "${SERVICIOS_CAIDOS[@]}"; do
        MENSAJE+="$SERVICIO\n"
    done

    echo -e "$MENSAJE" | mail -s "⚠️ Servicios caídos en $(hostname)" "$EMAIL_DESTINO"
    echo "Se envió un correo a $EMAIL_DESTINO."
else
    echo "Todos los servicios están funcionando correctamente."
fi