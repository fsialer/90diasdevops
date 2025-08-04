# ✅ Usar tags específicos en producción
resource "docker_image" "app_prod" {
  name = "myapp:v1.2.3"  # No usar 'latest'
}

# ✅ Usar keep_locally apropiadamente
resource "docker_image" "base_image" {
  name         = "postgres:15-alpine"
  keep_locally = true  # Para imágenes base
}

# Configuracion de contenedores
# ✅ Usar health checks
resource "docker_container" "app" {
  # ... configuración ...
  
  healthcheck {
    test     = ["CMD", "curl", "-f", "http://localhost/health"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
  }
}

# ✅ Configurar límites de recursos
resource "docker_container" "app" {
  # ... configuración ...
  
  memory      = 512
  memory_swap = 1024
  cpu_shares  = 512
}

# rede y seguridad
# ✅ Usar redes personalizadas
resource "docker_network" "app_network" {
  name   = "app-network"
  driver = "bridge"
  
  # Configuración específica
  ipam_config {
    subnet = "172.20.0.0/16"
  }
}

# ✅ Exponer solo puertos necesarios
resource "docker_container" "database" {
  # ... configuración ...
  
  # NO exponer puerto si no es necesario
  # ports {
  #   internal = 5432
  #   external = 5432
  # }
}

# variables sensibles
# ✅ Marcar passwords como sensitive
variable "database_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}