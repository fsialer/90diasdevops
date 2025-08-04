
# Obtener información de imagen existente
data "docker_image" "existing_nginx" {
  name = "nginx:latest"
}

# Obtener información de red existente
data "docker_network" "existing_network" {
  name = "bridge"
}

# Usar en recursos
resource "docker_container" "app_existing_network" {
  name  = "app-on-bridge"
  image = data.docker_image.existing_nginx.image_id
  
  networks_advanced {
    name = data.docker_network.existing_network.name
  }
}