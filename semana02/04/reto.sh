#!/bin/bash

docker network create miapp-net
docker volume create vol-db
docker run -d --network miapp-net --name api alpine sh -c "while true; do date >> /datos/fechas.log; sleep 5; done"
docker run -d --network miapp-net --name  db --volume vol-db:/datos alpine sh -c "while true; do date >> /datos/fechas.log; sleep 5; done"
docker exec api sh -c "ping db"
docker exec db sh -c "ping api"
docker exec db sh -c "echo 'hola desde el contenedor db' >> /datos/info.txt"
docker rm -f db
docker run -d --network miapp-net --name  db --volume vol-db:/datos alpine sh -c "while true; do date >> /datos/fechas.log; sleep 5; done"

# Reto adicional
docker run -d --name mongo \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=secret \
  --network miapp-net \
  mongo:4.4

  docker run -d --name mongo-express \
  -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
  -e ME_CONFIG_MONGODB_ADMINPASSWORD=secret \
  -e ME_CONFIG_MONGODB_SERVER=mongo \
  -e ME_CONFIG_BASICAUTH_USERNAME=admin \
  -e ME_CONFIG_BASICAUTH_PASSWORD=secret \
  -p 8081:8081 \
  --network miapp-net \
  mongo-express



