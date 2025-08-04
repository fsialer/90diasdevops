# variables.tf - Organizado por categorías

# ======================
# CONFIGURACIÓN BÁSICA
# ======================
variable "app_name" {
  description = "Nombre de la aplicación"
  type        = string
  # ... configuración
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  # ... configuración
}

# ======================
# CONFIGURACIÓN DE RED
# ======================
variable "vpc_cidr" {
  description = "CIDR block para VPC"
  type        = string
  # ... configuración
}

variable "availability_zones" {
  description = "Zonas de disponibilidad"
  type        = list(string)
  # ... configuración
}

# ======================
# CONFIGURACIÓN DE APLICACIÓN
# ======================
variable "application_config" {
  description = "Configuración completa de la aplicación"
  type = object({
    runtime = object({
      language = string
      version  = string
      memory   = number
      cpu      = number
    })
    # ... más configuración
  })
}

# ======================
# CONFIGURACIÓN SENSIBLE
# ======================
variable "database_password" {
  description = "Password de la base de datos"
  type        = string
  sensitive   = true
  # ... configuración
}