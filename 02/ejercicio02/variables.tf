variable "environment" {
  type    = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment debe ser: dev, staging, o prod"
  }
}

variable "app_name" {
  description = "nombre de aplicacion"
  type = string
}

variable "application_config" {
  description = "se configura de la aplicacion"
  type = object({
    name = string
    features = object({
      monitoring = bool
      backup     = bool
      
    })
    runtime = object({
        memory = number
        cpu    = number
      })
  })
}
