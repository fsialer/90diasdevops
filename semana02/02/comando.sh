docker --version
docker pull hello-world
docker run hello-world
docker pull nginx
docker run -d -p 8080:80 --name web-nginx nginx
# =========================
docker ps
docker ps -a
docker stop web-nginx
docker rm web-nginx
docker container prune
docker run -it --name contenedor1 ubuntu bash
docker start contenedor1
docker attach contenedor1
docker exec contenedor1 ls -al
docker inspect contenedor1

# =====================================
docker history nginx
docker run -d --name bootcamp-web -p 9999:80 nginx
git clone -b devops-simple-web https://github.com/roxsross/devops-static-web.git
docker cp devops-static-web/bootcamp-web/. bootcamp-web:/usr/share/nginx/html/
docker exec bootcamp-web ls /usr/share/nginx/html
