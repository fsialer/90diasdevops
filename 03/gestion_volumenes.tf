# Crear volumen
resource "docker_volume" "app_data" {
  name = "roxs-app-data"
  
  # Driver específico
  driver = "local"
  
  # Opciones del driver
  driver_opts = {
    type   = "none"
    o      = "bind"
    device = "/host/path/data"
  }
  
  # Labels
  labels {
    label = "backup"
    value = "daily"
  }
}

# Usar volumen en contenedor
resource "docker_container" "app_with_volume" {
  name  = "app-persistent"
  image = docker_image.custom_app.image_id
  
  # Montar volumen nombrado
  volumes {
    volume_name    = docker_volume.app_data.name
    container_path = "/app/data"
    read_only      = false
  }
  
  # Bind mount
  volumes {
    host_path      = "/host/config"
    container_path = "/app/config"
    read_only      = true
  }
  
  # Volumen temporal
  volumes {
    container_path = "/tmp"
    from_container = "temp-container"
  }
}