# modules/worker-service/main.tf - Séptimo paso# modules/vote-service/main.tf - Quinto paso
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "worker_app" {
  name = var.image_name
  keep_locally = false
}

resource "docker_container" "service" {
  count =  var.replica_count
  name = "${var.app_name}-${count.index+1}"
  image = docker_image.worker_app.image_id
  # Puerto solo en el primer contenedor
  dynamic "ports" {
    for_each = count.index == 0 ? [1] : []
    content {
      internal = 80
      external = var.external_port
    }
  }

  # Variables de entorno
  env = concat(
    [
      for k, v in var.environment_vars : "${k}=${v}"
    ],
    [
      "REPLICA_ID=${count.index + 1}",
      "TOTAL_REPLICAS=${var.replica_count}"
    ]
  )
  
  # Límites de recursos
  memory = var.memory_limit
  
  # Conectar a la red
  networks_advanced {
    name = var.network_name
    aliases = ["postgres", "database", "db"]  # Múltiples aliases
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