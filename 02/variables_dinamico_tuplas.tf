# Tipo any para flexibilidad
variable "custom_config" {
  description = "Configuración personalizada flexible"
  type        = any
  default     = {}
}

# Tupla con tipos específicos
variable "server_specs" {
  description = "Especificaciones del servidor [tipo, vcpu, memoria, storage]"
  type        = tuple([string, number, number, number])
  default     = ["t3.medium", 2, 4096, 20]
  
  validation {
    condition = var.server_specs[1] >= 1 && var.server_specs[1] <= 96  # vCPU
    error_message = "vCPU debe estar entre 1 y 96."
  }
  
  validation {
    condition = var.server_specs[2] >= 512 && var.server_specs[2] <= 768000  # Memory MB
    error_message = "Memoria debe estar entre 512MB y 768GB."
  }
}