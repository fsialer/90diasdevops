#!/bin/bash
archivos=("documento1.txt" "documento2.txt" "informe.pdf")
for archivo in "${archivos[@]}"; do
    echo "Procesando $archivo"
done