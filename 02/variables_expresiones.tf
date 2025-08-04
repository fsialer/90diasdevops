# Cálculos dinámicos basados en variables
resource "local_file" "calculated_config" {
  filename = "calculated-resources.json"
  content = jsonencode({
    # Cálculo de recursos totales
    total_cpu_cores = sum([
      for config in values(var.environment_configs) : 
      config.min_size * lookup({
        "t3.micro"  = 1,
        "t3.small"  = 1,
        "t3.medium" = 2,
        "t3.large"  = 2
      }, config.instance_type, 1)
    ])
    
    # Cálculo de memoria total
    total_memory_gb = sum([
      for config in values(var.environment_configs) :
      config.min_size * lookup({
        "t3.micro"  = 1,
        "t3.small"  = 2,
        "t3.medium" = 4,
        "t3.large"  = 8
      }, config.instance_type, 1)
    ])
    
    # Cálculo de costos estimados
    monthly_cost_estimate = sum([
      for env, config in var.environment_configs :
      config.min_size * lookup({
        "t3.micro"  = 8.5,
        "t3.small"  = 17.0,
        "t3.medium" = 34.0,
        "t3.large"  = 67.0
      }, config.instance_type, 25.0)
    ])
    
    # Configuración optimizada por entorno
    optimized_configs = {
      for env, config in var.environment_configs :
      env => merge(config, {
        # Auto-scaling inteligente
        desired_capacity = max(config.min_size, 
          env == "prod" ? 3 : 1
        )
        
        # Features automáticas por entorno
        features_enabled = {
          monitoring = env == "prod" ? true : var.enable_monitoring
          backup     = env == "prod" ? true : false
          encryption = env == "prod" ? true : false
          cdn        = env == "prod" ? true : false
        }
      })
    }
  })
}