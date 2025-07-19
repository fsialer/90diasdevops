#!/bin/bash
echo "Actualizando paquetes"
apt update && apt upgrade -y

echo "Instalar git"
apt install git

echo "Verificar version git"
git --version

echo "Instalar npm"
apt install -y npm && apt install -y nodejs