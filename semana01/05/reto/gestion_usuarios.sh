#!/bin/bash
source ./funciones.sh

if [[ $# -ne 1 ]]; then
  echo "Uso: $0 <nombre_usuario>"
  exit 1
fi

crear_usuario "$1" > ~/usuario.txt
if [[ $? -ne 0 ]]; then
  echo "Error: No se pudo crear el usuario o escribir en ~/usuario.txt"
  exit 2
fi