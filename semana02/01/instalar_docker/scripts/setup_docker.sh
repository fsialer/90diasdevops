#!/bin/bash

echo "Actualizando paquetes"
apt update && apt upgrade -y

echo "Instalando certificado y herramientas necesarias"
apt install -y ca-certificates curl gnupg lsb-release

echo "Instalando keyrings"
install -m 0755 -d /etc/apt/keyrings

echo "Descargando gpg de Docker"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "Dando permisos a docker.gpg"
chmod a+r /etc/apt/keyrings/docker.gpg

echo "Agregando repositorio de Docker para Ubuntu"
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Actualizando lista de paquetes"
apt update

echo "Instalando Docker"
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Agregando usuario vagrant al grupo docker"
groupadd docker 2>/dev/null # por si no existe
usermod -aG docker vagrant

echo "Recuerda cerrar sesión o ejecutar 'newgrp docker' para aplicar los cambios de grupo"
docker --version

echo "Instalar git"
apt install git

echo "Verificar version git"
git --version

echo "Instalar npm"
apt install -y npm && apt install -y nodejs

apt install -y mysql-client-core-8.0
apt install -y mariadb-client-core-10.6