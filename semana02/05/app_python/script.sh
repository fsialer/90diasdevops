
docker network create my_network
docker run -d --name my_mysql --network my_network \
  -e MYSQL_ROOT_PASSWORD=password \
  -v /data/mysql-data:/var/lib/mysql \
  -p 3306:33060 mysql
docker build -t app_python .
docker run --name app_python -d --network my_network -p 8082:80 app_python
docker network inspect my_network
docker logs app_python