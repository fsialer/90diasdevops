# modules/database/main.tf - Tercer paso
# Implementar PostgreSQL con volúmenes persistentes
# modules/vote-service/main.tf - Quinto paso

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

locals {
  volume = "redis_vol-${var.environment}"
}

resource "docker_image" "postgres" {
  name = var.image_name
  keep_locally = false
}

resource "docker_volume" "postgres_data" {
  name = local.volume
}

resource "docker_container" "service" {
  name = "${var.app_name}"
  image = docker_image.postgres.image_id
  # Puerto solo en el primer contenedor
  ports {
    internal = 5432
    external = var.external_port
  }

  # Variables de entorno
  env = concat(
    [
      for k, v in var.environment_vars : "${k}=${v}"
    ]
  )
  
  # Límites de recursos
  memory =  var.memory_limit
  
  # Conectar a la red
  networks_advanced {
    name = var.network_name
  }
  # volumen

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  # Labels para identificar
  labels {
    label = "environment"
    value = terraform.workspace
  }
  
  labels {
    label = "managed-by"
    value = "terraform"
  }
}