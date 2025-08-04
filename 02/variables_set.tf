# Set de strings (sin duplicados)
variable "security_groups" {
  description = "IDs de grupos de seguridad únicos"
  type        = set(string)
  default     = ["sg-123", "sg-456", "sg-789"]
  
  validation {
    condition = alltrue([
      for sg in var.security_groups :
      can(regex("^sg-[a-z0-9]{8,17}$", sg))
    ])
    error_message = "Todos los security groups deben tener formato válido."
  }
}

# Set de objetos
variable "allowed_cidrs" {
  description = "CIDRs permitidos para acceso"
  type = set(object({
    cidr        = string
    description = string
  }))
  
  default = [
    {
      cidr        = "10.0.0.0/8"
      description = "Red interna"
    },
    {
      cidr        = "172.16.0.0/12"
      description = "Red privada"
    }
  ]
}