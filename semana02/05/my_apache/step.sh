docker run -d --name httpd -p 80:80 httpd:alpine
docker run -d --name my_mysql \
  -e MYSQL_ROOT_PASSWORD=password \
  -v /data/mysql-data:/var/lib/mysql \
  -p 3306:33060 mysql

docker rm -f my_apache
docker run -d --name my_apache --link my_mysql:mysql -p 80:80 httpd
docker run -it --rm --link my_mysql:mysql mysql sh # para pobar
docker run -d --name my_app --link my_mysql:mysql -p 8081:80 my-app
mysql -h mysql -u root -p
docker network create my_network
docker run -d --name my_app --network my_network -p 8081:80 my-app
docker run -d --name my_mysql --network my_network \
  -e MYSQL_ROOT_PASSWORD=password \
  -v /data/mysql-data:/var/lib/mysql \
  -p 3306:33060 mysql