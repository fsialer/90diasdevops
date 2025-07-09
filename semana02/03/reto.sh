#!/bin/bash
docker run -d --name contenedor-personalizado bash -c 'while true; do date +"%T" >> mensajes.txt; sleep 5; done'
docker cp contenedor-personalizado:mensajes.txt .
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' contenedor-personalizado
docker inspect --format='{{.Config.Image}}' contenedor-personalizado
docker top contenedor-personalizado
docker rm -f contenedor-personalizado
docker run --rm -e APP_ENV=development -e APP_VERSION=1.0.0 alpine sh -c 'echo Entorno: $APP_ENV, Versión: $APP_VERSION'
docker run --rm -e APP_ENV=development -e APP_VERSION=alpine nginx:alpine sh -c 'echo Entorno: $APP_ENV, Versión: $APP_VERSION'
docker run --rm -e MARIADB_ROOT_PASSWORD=secret -e MARIADB_USER=fernando -e MARIADB_DATABASE=dbtest mariadb:latest sh -c 'echo usuario: $MARIADB_USER, password: $MARIADB_ROOT_PASSWORD, db= $MARIADB_DATABASE'
docker run  -d --name mariadb -e MARIADB_ROOT_PASSWORD=secret -e MARIADB_USER=fernando -e MARIADB_DATABASE=dbtest mariadb:latest
docker exec -it mariadb env
docker rm -f mariadb