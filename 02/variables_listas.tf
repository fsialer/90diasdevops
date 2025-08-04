# Lista simple
variable "availability_zones" {
  description = "Zonas de disponibilidad"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
  
  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "Debe especificar al menos 2 zonas de disponibilidad."
  }
}

# Lista de números
variable "allowed_ports" {
  description = "Puertos permitidos en el firewall"
  type        = list(number)
  default     = [22, 80, 443, 8080]
}

# Lista con validación de contenido
variable "supported_instance_types" {
  description = "Tipos de instancia soportados"
  type        = list(string)
  default     = ["t3.micro", "t3.small", "t3.medium"]
  
  validation {
    condition = alltrue([
      for instance_type in var.supported_instance_types :
      can(regex("^(t3|t2|m5|c5)\\.(micro|small|medium|large|xlarge)$", instance_type))
    ])
    error_message = "Todos los tipos de instancia deben ser válidos de AWS."
  }
}