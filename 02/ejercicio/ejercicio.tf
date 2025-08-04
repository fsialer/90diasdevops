locals {
  # Generar configuración automática para cada ambiente
  environment_configs = {
    for env, config in var.environments :
    env => merge(config, {
      # Auto-sizing basado en environment
      storage_size = env == "prod" ? 100 : env == "staging" ? 50 : 20
      
      # Features automáticas
      cdn_enabled = env == "prod"
      waf_enabled = env == "prod"
      
      # Naming convention
      resource_prefix = "${var.app_name}-${env}"
      
      # Costos estimados
      monthly_cost = config.min_replicas * lookup({
        "t3.micro"  = 8.5
        "t3.small"  = 17.0
        "t3.medium" = 34.0
      }, config.instance_type, 25.0)
    })
  }
}

# Simulación de recurso (puedes reemplazar por aws_instance, aws_db_instance, etc.)
resource "local_file" "multi_env_configs" {
  for_each = local.environment_configs
  
  filename = "${each.value.resource_prefix}.json"
  content = jsonencode({
    environment   = each.key
    instance_type = each.value.instance_type
    waf_enabled = each.value.waf_enabled
    cdn_enabled = each.value.cdn_enabled
    monthly_cost = each.value.monthly_cost
    scaling = {
      min = each.value.min_replicas
      max = each.value.max_replicas
    }
    features = {
      monitoring = each.key == "prod" ? true :  each.value.enable_monitoring
      ssl        = each.key == "prod" ? true : false
      storage_size = each.value.storage_size
    }
  })
}