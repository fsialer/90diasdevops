#!/bin/bash
apt update && apt install -y nginx
echo "<h1>Hola, soy Fernando </h1>" > /var/www/html/index.html