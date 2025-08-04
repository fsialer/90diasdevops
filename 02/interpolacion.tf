# Template con lógica condicional compleja
resource "local_file" "advanced_config" {
  filename = "app-${var.environment}.conf"
  content = <<-EOF
    # Configuración generada para ${upper(var.app_name)}
    # Entorno: ${title(var.environment)}
    # Generado: ${timestamp()}
    
    [APPLICATION]
    name = ${var.app_name}
    environment = ${var.environment}
    version = ${lookup(var.application_config, "version", "1.0.0")}
    
    [RUNTIME]
    language = ${var.application_config.runtime.language}
    memory = ${var.application_config.runtime.memory}MB
    cpu = ${var.application_config.runtime.cpu}
    
    [DATABASE]
    engine = ${var.application_config.database.engine}
    host = ${var.environment == "prod" ? "prod-db.internal" : "dev-db.local"}
    port = ${var.database_config.port}
    ssl = ${var.database_config.ssl ? "enabled" : "disabled"}
    backups = ${var.application_config.database.backups ? "enabled" : "disabled"}
    
    [FEATURES]
    %{ if var.application_config.features.monitoring ~}
    monitoring_enabled = true
    monitoring_endpoint = /metrics
    %{ endif ~}
    
    %{ if var.application_config.features.logging ~}
    logging_enabled = true
    log_level = ${var.environment == "prod" ? "info" : "debug"}
    %{ endif ~}
    
    %{ if var.application_config.features.caching ~}
    cache_enabled = true
    cache_ttl = ${var.environment == "prod" ? "3600" : "300"}
    %{ endif ~}
    
    [NETWORKING]
    %{ for zone in var.availability_zones ~}
    availability_zone = ${zone}
    %{ endfor ~}
    
    vpc_cidr = ${var.application_config.networking.vpc_cidr}
    subnet_count = ${var.application_config.networking.subnet_count}
    
    [SECURITY]
    %{ for sg in var.security_groups ~}
    security_group = ${sg}
    %{ endfor ~}
    
    %{ for cidr in var.allowed_cidrs ~}
    # ${cidr.description}
    allowed_cidr = ${cidr.cidr}
    %{ endfor ~}
    
    [PORTS]
    %{ for port in var.allowed_ports ~}
    allowed_port = ${port}
    %{ endfor ~}
  EOF
}

# Generación dinámica de archivos de configuración por componente
resource "local_file" "component_configs" {
  for_each = toset(["frontend", "backend", "database", "cache"])
  
  filename = "components/${each.key}-${var.environment}.yaml"
  content = templatefile("${path.module}/templates/${each.key}.yaml.tpl", {
    component   = each.key
    environment = var.environment
    app_name    = var.app_name
    config      = var.application_config
    
    # Configuración específica por componente
    replicas = {
      frontend = var.environment == "prod" ? 3 : 1
      backend  = var.environment == "prod" ? 2 : 1
      database = 1
      cache    = var.environment == "prod" ? 2 : 1
    }[each.key]
    
    resources = {
      frontend = { cpu = "100m", memory = "128Mi" }
      backend  = { cpu = "200m", memory = "256Mi" }
      database = { cpu = "500m", memory = "1Gi" }
      cache    = { cpu = "100m", memory = "64Mi" }
    }[each.key]
  })
}