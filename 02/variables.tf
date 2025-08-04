# Variable con múltiples validaciones
variable "app_name" {
  description = "Nombre de la aplicación (debe seguir convenciones)"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.app_name))
    error_message = "app_name debe empezar con letra, solo contener minúsculas, números y guiones."
  }
  
  validation {
    condition     = length(var.app_name) >= 3 && length(var.app_name) <= 32
    error_message = "app_name debe tener entre 3 y 32 caracteres."
  }
}

# Variable de entorno con validación estricta
variable "environment" {
  description = "Entorno de despliegue (dev/staging/prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment debe ser exactamente: dev, staging, o prod."
  }
}

# Variable numérica con rangos
variable "instance_count" {
  description = "Número de instancias (1-10)"
  type        = number
  
  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "instance_count debe estar entre 1 y 10."
  }
}

# Variable con validación de formato de email
variable "admin_email" {
  description = "Email del administrador"
  type        = string
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.admin_email))
    error_message = "admin_email debe ser un email válido."
  }
}

# Variable con validación de CIDR
variable "vpc_cidr" {
  description = "CIDR block para VPC"
  type        = string
  default     = "10.0.0.0/16"
  
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr debe ser un bloque CIDR válido."
  }
  
  validation {
    condition     = split("/", var.vpc_cidr)[1] >= 16 && split("/", var.vpc_cidr)[1] <= 24
    error_message = "vpc_cidr debe tener subnet mask entre /16 y /24."
  }
}

# Variable booleana con valor inteligente
variable "enable_monitoring" {
  description = "Habilitar monitoreo (recomendado para prod)"
  type        = bool
  default     = true
}

# Variable sensitive para secrets
variable "database_password" {
  description = "Password de la base de datos"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.database_password) >= 8
    error_message = "Password debe tener al menos 8 caracteres."
  }
}