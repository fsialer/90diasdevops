#/bin/bash
docker run -d --name contenedor2 ubuntu bash -c "while true; do echo hello world; sleep 1; done"
docker ps
docker logs contenedor2
docker stop contenedor2
docker rm contenedor2
docker rm -f contenedor2
docker run -d --name hora-container ubuntu bash -c 'while true; do echo $(date +"%T"); sleep 1; done'
docker logs -f hora-container
docker exec hora-container date
docker run -d --name hora-container2 ubuntu bash -c 'while true; do date +"%T" >> hora.txt; sleep 1; done'
docker exec hora-container2 ls
docker exec hora-container2 cat hora.txt

#  Copiar archivos entre host y contenedor
echo "Curso Docker" > docker.txt
docker cp docker.txt hora-container2:/tmp # copiar desde host anfitrion al contenedor
docker exec hora-container2 cat /tmp/docker.txt 
docker cp hora-container2:hora.txt . # copiar desde el contenedor al host anfitrion

# =======================
docker top hora-container2 # Ver procesos en ejecución
docker inspect hora-container2 # Inspeccionar contenedor (JSON detallado):

#=================
# filtros con  --format
docker inspect --format='{{.Id}}' hora-container2 #ID del contenedor
docker inspect --format='{{.Config.Image}}' hora-container2 # Imagen usada:
docker container inspect -f '{{range .Config.Env}}{{println .}}{{end}}' hora-container2 # Variables de entorno:
docker inspect --format='{{range .Config.Cmd}}{{println .}}{{end}}' hora-container2 # Comando ejecutado
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' hora-container2 # IP asignada

# Configuración de contenedores con variables de entorno
docker run -it --name prueba -e USUARIO=prueba ubuntu bash # Para configurar valores dentro del contenedor, usamos el flag -e:

#Configuración de un contenedor con la imagen mariadb
docker run -d --name some-mariadb -e MARIADB_ROOT_PASSWORD=my-secret-pw mariadb
docker exec -it some-mariadb env #Verificamos la variable dentro del contenedor:
docker exec -it some-mariadb env # docker exec -it some-mariadb env
docker exec -it some-mariadb mariadb -u root -p # Accedemos a MariaDB desde el contenedor:
docker rm -f some-mariadb #Eliminamos el contenedor anterior:
docker run -d -p 3306:3306 --name some-mariadb -e MARIADB_ROOT_PASSWORD=my-secret-pw mariadb # Creamos uno nuevo exponiendo el puerto:
mysql -u root -p -h 127.0.0.1

