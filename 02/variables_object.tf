# Object simple
variable "database_config" {
  description = "Configuración de base de datos"
  type = object({
    name     = string
    port     = number
    username = string
    ssl      = bool
  })
  
  default = {
    name     = "app_db"
    port     = 5432
    username = "admin"
    ssl      = true
  }
}

# Object complejo con validaciones
variable "application_config" {
  description = "Configuración completa de la aplicación"
  type = object({
    name    = string
    version = string
    
    # Configuración de runtime
    runtime = object({
      language = string
      version  = string
      memory   = number
      cpu      = number
    })
    
    # Configuración de base de datos
    database = object({
      engine   = string
      version  = string
      storage  = number
      backups  = bool
    })
    
    # Features opcionales
    features = object({
      monitoring    = bool
      logging       = bool
      caching       = bool
      load_balancer = bool
    })
    
    # Configuración de red
    networking = object({
      vpc_cidr     = string
      subnet_count = number
      enable_nat   = bool
    })
  })
  
  # Validaciones del objeto
  validation {
    condition     = contains(["python", "nodejs", "java", "go"], var.application_config.runtime.language)
    error_message = "Runtime language debe ser uno de: python, nodejs, java, go."
  }
  
  validation {
    condition     = var.application_config.runtime.memory >= 512 && var.application_config.runtime.memory <= 8192
    error_message = "Memory debe estar entre 512MB y 8GB."
  }
  
  validation {
    condition     = contains(["postgres", "mysql", "mongodb"], var.application_config.database.engine)
    error_message = "Database engine debe ser: postgres, mysql, o mongodb."
  }
}

# Object con valores opcionales
variable "monitoring_config" {
  description = "Configuración de monitoreo (opcional)"
  type = object({
    enabled          = bool
    retention_days   = optional(number, 30)
    alert_email      = optional(string, "admin@company.com")
    slack_webhook    = optional(string)
    custom_metrics   = optional(list(string), [])
  })
  
  default = {
    enabled = true
  }
}