# modules/cache/main.tf - Cuarto paso  
# Implementar Redis con configuración optimizada

# modules/database/main.tf - Tercer paso
# Implementar PostgreSQL con volúmenes persistentes
# modules/vote-service/main.tf - Quinto paso

# locals {
#   image = "redis:latest"
#   container_name = "redis"
#   current_config = {
#     replica_count = 1
#     memory_mb = 500
#   }
# }
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

locals {
  volume = "redis_vol"
}

resource "docker_image" "redis" {
  name = var.image_name
  keep_locally = false
}

resource "docker_volume" "redis_data" {
  name = local.volume
}

resource "docker_container" "service" {
  name = "${var.app_name}"
  image = docker_image.redis.image_id
  # Puerto solo en el primer contenedor
  ports{
    internal = 6379
    external = var.external_port
  }

  # Variables de entorno
  env = concat(
    [
      for k, v in var.environment_vars : "${k}=${v}"
    ]
  )
    
  # Límites de recursos
  memory = var.memory_limit
  
  # Conectar a la red
  networks_advanced {
    name = var.network_name
  }
  # volumen
  volumes {
    volume_name    = docker_volume.redis_data.name
    container_path = "/data"
  }
  

  # Labels para identificar
  labels {
    label = "environment"
    value = var.environment
  }
  
  labels {
    label = "managed-by"
    value = "terraform"
  }
}