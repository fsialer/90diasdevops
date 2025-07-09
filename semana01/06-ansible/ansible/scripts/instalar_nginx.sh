sudo apt update && sudo apt upgrade -y
apt install -y nginx
echo "<h1>Hola, soy Fernando </h1>" > /var/www/html/index.html
ufw allow 80