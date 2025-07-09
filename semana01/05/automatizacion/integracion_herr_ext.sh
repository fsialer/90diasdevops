#!/bin/bash
json='{"nombre": "Pedro", "edad": 28}'
nombre=$(echo "$json" | jq -r '.nombre')
edad=$(echo "$json" | jq -r '.edad')
echo "Nombre: $nombre, Edad: $edad"

#📌 Asegurate de tener jq instalado (sudo apt install jq en Debian/Ubuntu).