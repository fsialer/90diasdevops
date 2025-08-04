# String con validación avanzada
variable "region" {
  description = "Región de AWS"
  type        = string
  default     = "us-west-2"
  
  validation {
    condition = can(regex("^(us|eu|ap|sa|ca|me|af)-(north|south|east|west|central)-[1-9]$", var.region))
    error_message = "Debe ser una región válida de AWS."
  }
}

# Number con límites específicos
variable "port" {
  description = "Puerto de la aplicación"
  type        = number
  default     = 8080
  
  validation {
    condition     = var.port >= 1024 && var.port <= 65535
    error_message = "Puerto debe estar entre 1024 y 65535."
  }
}

# Boolean con lógica condicional
variable "enable_ssl" {
  description = "Habilitar SSL (obligatorio en prod)"
  type        = bool
  default     = true
}