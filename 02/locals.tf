locals {
  # 🏷️ Naming conventions automatizadas
  resource_prefix = "${var.app_name}-${var.environment}"
  dns_name        = "${var.app_name}.${var.environment}.company.com"
  
  # 📅 Timestamps inteligentes
  creation_timestamp = timestamp()
  readable_date      = formatdate("YYYY-MM-DD", timestamp())
  unique_suffix      = formatdate("YYYYMMDD-hhmm", timestamp())
  
  # 🏷️ Tags estandarizados
  common_tags = merge(var.tags, {
    Terraform     = "true"
    Environment   = var.environment
    Application   = var.app_name
    CreatedDate   = local.readable_date
    ResourceGroup = local.resource_prefix
  })
  
  # 🔄 Transformaciones de datos
  uppercase_tags = {
    for key, value in local.common_tags : 
    upper(key) => upper(value)
  }
  
  # 📊 Configuraciones por entorno
  env_settings = {
    dev = {
      instance_type    = "t3.micro"
      min_replicas     = 1
      max_replicas     = 2
      enable_logging   = true
      enable_monitoring = false
      backup_retention = 7
    }
    staging = {
      instance_type    = "t3.small"
      min_replicas     = 2
      max_replicas     = 4
      enable_logging   = true
      enable_monitoring = true
      backup_retention = 14
    }
    prod = {
      instance_type    = "t3.medium"
      min_replicas     = 3
      max_replicas     = 10
      enable_logging   = true
      enable_monitoring = true
      backup_retention = 30
    }
  }
  
  # 🎯 Configuración actual automática
  current_env = local.env_settings[var.environment]
}