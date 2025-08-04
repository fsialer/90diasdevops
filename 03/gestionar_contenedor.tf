resource "docker_container" "nginx_server" {
  name  = "my-nginx"
  image = docker_image.nginx.image_id
  
  # Configuración básica
  restart = "unless-stopped"
  
  # Puertos
  ports {
    internal = 80
    external = 8080
    protocol = "tcp"
  }
  
  # Variables de entorno
  env = [
    "ENV=production",
    "DEBUG=false"
  ]
  
  # Labels
  labels {
    label = "project"
    value = "devops-challenge"
  }
  
  labels {
    label = "managed-by"
    value = "terraform"
  }
}