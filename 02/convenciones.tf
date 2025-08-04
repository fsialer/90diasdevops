# ✅ BUENAS PRÁCTICAS
variable "app_name" {              # ✅ snake_case
  description = "Nombre de la aplicación"  # ✅ Descripción clara
  type        = string             # ✅ Tipo explícito
  
  validation {                     # ✅ Validación incluida
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.app_name))
    error_message = "app_name debe seguir convenciones de naming."
  }
}

variable "environment" {
  description = "Entorno de despliegue (dev/staging/prod)"  # ✅ Opciones claras
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment debe ser: dev, staging, o prod."
  }
}

# ❌ MALAS PRÁCTICAS
variable "AppName" { }             # ❌ PascalCase
variable "app-name" { }            # ❌ kebab-case
variable "APPNAME" { }             # ❌ UPPERCASE
variable "a" { }                   # ❌ Nombre no descriptivo