# Challenge: Generar configuraciones para múltiples servicios
variable "microservices" {
  type = map(object({
    port         = number
    language     = string
    memory_mb    = number
    replicas     = number
    dependencies = list(string)
  }))
}
variable "app_name" {
  type        = string
  description = "nombre de la aplicacion"
  default     = "app"
}

variable "environment" {
  type        = string
  description = "entorno a crear"
  default     = "prod"
}

locals {
  # Generar configuración para cada microservicio
  service_configs = {
    for service_name, config in var.microservices :
    service_name => {
      # Configuración base
      name = service_name

      # Configuración de red
      internal_url = "http://${service_name}:${config.port}"

      # Configuración de recursos basada en lenguaje
      resources = {
        cpu    = config.language == "java" ? "500m" : (config.language == "python" ? "200m" : "100m")
        memory = "${config.memory_mb}Mi"
      }

      # Health checks específicos por lenguaje
      health_check = {
        path = config.language == "java" ? "/actuator/health" : (config.language == "nodejs" ? "/health" : "/healthz")

        port = config.port
      }

      # Variables de entorno automáticas
      environment_vars = merge(
        {
          SERVICE_NAME = service_name
          SERVICE_PORT = tostring(config.port)
          ENVIRONMENT  = var.environment
        },
        # URLs de dependencias
        {
          for dep in config.dependencies :
          "${upper(dep)}_URL" => "http://${dep}:${var.microservices[dep].port}"
          if contains(keys(var.microservices), dep)
        }
      )
    }
  }
  common_tags = {
    Environment = var.environment
  }
}

# Generar archivos de configuración para cada servicio
resource "local_file" "service_configs" {
  for_each = local.service_configs

  filename = "services/${each.key}-config.yaml"
  content = templatefile("${path.module}/templates/service.yaml.tpl", {
    service = each.value
    global_config = {
      app_name    = var.app_name
      environment = var.environment
      tags        = local.common_tags
    }
  })
}
