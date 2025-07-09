#!/bin/bash
echo "Ingrese el nombre a buscar:"
read search
if [grep -q "$search texto.txt"]; then
    echo "encontrado"
else
    echo "no encontrado"
fi