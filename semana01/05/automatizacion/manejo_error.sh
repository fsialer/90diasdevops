#!/bin/bash
archivo="datos.csv"
if [[ -f $archivo ]]; then
    echo "Leyendo $archivo"
    cat "$archivo"
else
    echo "Error: ¡$archivo no existe!"
    exit 1
fi