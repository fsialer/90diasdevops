#!/bin/bash
docker network ls # ver redes disponibles
# Crear y usar una red
docker network create mi-red
docker run -d --name backend --network mi-red alpine sleep 3600
docker run -it --rm --network mi-red alpine ping backend

# inspeccionar y eliminar redes
docker network inspect mi-red
docker network rm mi-red

# crear y ysar un volumen
docker volume create datos-app
docker run -d --name contenedor-volumen -v datos-app:/datos alpine sh -c "while true; do date >> /datos/fechas.log; sleep 5; done"
docker exec contenedor-volumen cat /datos/fechas.log

# Ver volúmenes disponibles:
docker volume ls
# Eliminar un volumen (si no está en uso):
docker volume rm datos-app
# mkdir datos-local
docker run -it --name con-mount -v $(pwd)/datos-local:/datos alpine sh
# Todo lo que guardes en /datos del contenedor aparece en tu carpeta local datos-local.

# Redes
docker network create <nombre>
docker network ls
docker network inspect <nombre>
docker network rm <nombre>
docker network connect <red> <contenedor>
docker network disconnect <red> <contenedor>

# Redes
docker volume create <nombre>
docker volume ls
docker volume inspect <nombre>
docker volume rm <nombre>

# Crear el contenedor con volumen persistente
docker run -d --name mysql-container \
  -e MYSQL_ROOT_PASSWORD=my-data-pass \
  -v /data/mysql-data:/var/lib/mysql \
  mysql

# Acceder al contenedor
docker exec -it mysql-container bash
mysql -u root -p

# Ejecutar un script SQL 
USE base_de_datos;
SOURCE /ruta/al/archivo/data.sql;

# Detener y eliminar el contenedor:
docker stop mysql-container
docker rm mysql-container

# Reiniciarlo y verificar que los datos persisten
docker run -d --name mysql-container \
  -e MYSQL_ROOT_PASSWORD=my-data-pass \
  -v /data/mysql-data:/var/lib/mysql \
  mysql

docker exec -it mysql-container bash
mysql -u root -p
USE base_de_datos;
SELECT * FROM usuarios;