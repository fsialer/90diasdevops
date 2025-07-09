#!/bin/bash

# Linea shebang, indica que el script debe ejecutarse con bash

#Variables
username="Jay"  # Variable con un valor por defecto
filename=$3     # El tercer

#Entrada de usuario

read -p "Ingresa tu nombre de usuario: " user
echo "Usuario ingresado: $user"

#Condicional if

if ["$EUID" -ne 0]; then
    echo "No estas ejecutando este script como root"
else
    echo "Estas ejecutando este script como root"
fi

#Bucle for
echo "Contando hasta 5:"
for i in {1..5}; do
    echo "$i"
done

#Funciones
function saludar(){
    echo "Hola, $1"
}

saludar "Alice" #Llamada a la funcion

#Condicional case
echo "Ingresa un numero entre 1 y 2:"
read num
case $num in
    1) echo "Eligiste uno.";;
    2) echo "Eligiste dos.";;
    *) echo "Opcion invalida";;
esac

#Operaciones con archivos
if [ -e "$filename"] && [ -d "$filename" ]; then
    echo "El archivo existe y es un directorio"
else
    echo "El archivo no existe o no es un directorio"
fi

#Argumentos desde la linea de comandos
echo "Primer argumento: $1"
echo "Segundo argumento: $2"

#Codigos de salida
cat nonexistent-file.txt 2> /dev/null/ # Redirige errores a null
echo "Codigo de salida del comando anterior: $?"

#Array indexados
frutas=("Manzana","Naranja","Banana")
echo "Primera frutas: ${frutas[0]}"

# Arrays asociativos
declare -A capitales
capitales[USA]="Washington D.C."
capitales[Francia]="Paris"
echo "Capital de Francia: ${capitales[Francia]}"


#Susttitucion de comandos
fecha_actua=$(date)
echo "La fecha actual es: $fecha_actual"

#Redireccion de comandos
echo "Texto de ejemplo." > ejemplo.txt #Sobreescribe archio

#Operaciones aritmeticas
resultado=$((15/2))
echo "Resultado: $resultado"

# Expansion de parametros
SRC="/ruta/a/foo.cpp"
BASE=${SRC%/*} #Extrae el directorio base
echo "Directorio base: $BASE"

#Manejo de señales del sistema
trap 'echo "Recibido SIGTERM. Cerrando de forma limpia..."; exit' SIGTERM

#Comentarios
# Esto es un comentario de una sola linea

: '
Esto es un comentario 
de multiples linea
'
