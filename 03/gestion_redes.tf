resource "docker_network" "app_network" {
  name   = "roxs-app-network"
  driver = "bridge"
  
  # Configuración IPAM
  ipam_config {
    subnet   = "172.20.0.0/16"
    gateway  = "172.20.0.1"
    ip_range = "172.20.240.0/20"
  }
  
  # Opciones adicionales
  options = {
    "com.docker.network.bridge.name" = "roxs-bridge"
  }
  
  # Labels
  labels {
    label = "project"
    value = "devops-challenge"
  }
}

# Conectar contenedores a la red
resource "docker_container" "app_with_network" {
  name  = "app-networked"
  image = docker_image.custom_app.image_id
  
  # Conectar a red personalizada
  networks_advanced {
    name = docker_network.app_network.name
    ipv4_address = "172.20.0.10"
    aliases = ["app", "webapp"]
  }
  
  # También puede estar en la red por defecto
  networks_advanced {
    name = "bridge"
  }
}