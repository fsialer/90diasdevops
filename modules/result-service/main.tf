# modules/result-service/main.tf - Sexto paso# modules/worker-service/main.tf - Séptimo paso# modules/vote-service/main.tf - Quinto paso
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "result_app" {
  name = var.image_name
  keep_locally = false
}

resource "docker_container" "service" {
  count = var.replica_count
  name = var.service_name
  image = docker_image.result_app.image_id
  # Puerto solo en el primer contenedor
  dynamic "ports" {
    for_each = count.index == 0 ? [1] : []
    content {
      internal = 3000
      external = var.external_port
    }
  }

  # Variables de entorno
  env =  [for k, v in var.environment_vars : "${k}=${v}"]
  
  # Límites de recursos
  memory =  var.memory_limit
  
  # Conectar a la red
  networks_advanced {
    name = var.network_name
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