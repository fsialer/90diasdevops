# Uso básico de variables
resource "local_file" "basic_config" {
  filename = "${var.app_name}-config.txt"
  content  = templatefile("${path.module}/templates/config.tmpl", {
    app_name    = var.app_name
    environment = var.environment
    port        = var.port
    enabled     = var.enable_monitoring
  })
}

# Uso condicional de variables
resource "local_file" "conditional_config" {
  count = var.environment == "prod" ? 1 : 0
  
  filename = "${var.app_name}-production.conf"
  content = templatefile("${path.module}/templates/prod-config.tmpl", {
    app_name     = var.app_name
    ssl_enabled  = var.environment == "prod" ? true : var.enable_ssl
    replica_count = var.environment == "prod" ? 3 : 1
  })
}

# Uso dinámico con for_each
resource "local_file" "multi_env_configs" {
  for_each = var.environment_configs
  
  filename = "${var.app_name}-${each.key}.json"
  content = jsonencode({
    environment   = each.key
    instance_type = each.value.instance_type
    scaling = {
      min = each.value.min_size
      max = each.value.max_size
    }
    features = {
      monitoring = each.key == "prod" ? true : var.enable_monitoring
      ssl        = each.key == "prod" ? true : false
    }
  })
}