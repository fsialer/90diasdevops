resource "docker_container" "webapp" {
  name  = "roxs-webapp"
  image = docker_image.custom_app.image_id
  
  # Configuración de restart
  restart = "always"
  
  # Múltiples puertos
  ports {
    internal = 3000
    external = 3000
  }
  
  ports {
    internal = 3001
    external = 3001
  }
  
  # Variables de entorno desde archivo
  env = [
    "NODE_ENV=production",
    "PORT=3000",
    "DATABASE_URL=${var.database_url}",
    "REDIS_URL=${var.redis_url}"
  ]
  
  # Health check
  healthcheck {
    test         = ["CMD", "curl", "-f", "http://localhost:3000/health"]
    interval     = "30s"
    timeout      = "10s"
    retries      = 3
    start_period = "40s"
  }
  
  # Límites de recursos
  memory    = 512   # MB
  memory_swap = 1024  # MB
  cpu_shares = 512
  
  # Configuración de logs
  log_driver = "json-file"
  log_opts = {
    "max-size" = "10m"
    "max-file" = "3"
  }
  
  # Comando personalizado
  command = ["npm", "start"]
  
  # Working directory
  working_dir = "/app"
  
  # Usuario
  user = "1000:1000"
  
  # Capabilities
  capabilities {
    add  = ["NET_ADMIN"]
    drop = ["ALL"]
  }
}