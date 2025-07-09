#!/bin/bash
declare -A colores
colores[rojo]="#FF0000"
colores[verde]="#00FF00"
for color in "${!colores[@]}"; do
    echo "$color: ${colores[$color]}"
done