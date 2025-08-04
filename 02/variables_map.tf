# Map simple
variable "tags" {
  description = "Tags comunes para recursos"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "devops-challenge"
    Owner       = "roxs"
    Team        = "devops"
  }
}

# Map con validación
variable "environment_configs" {
  description = "Configuraciones específicas por entorno"
  type = map(object({
    instance_type = string
    min_size      = number
    max_size      = number
  }))
  
  default = {
    dev = {
      instance_type = "t3.micro"
      min_size      = 1
      max_size      = 2
    }
    staging = {
      instance_type = "t3.small"
      min_size      = 2
      max_size      = 4
    }
    prod = {
      instance_type = "t3.medium"
      min_size      = 3
      max_size      = 10
    }
  }
  
  validation {
    condition = alltrue([
      for env, config in var.environment_configs :
      config.min_size <= config.max_size
    ])
    error_message = "min_size debe ser menor o igual que max_size para todos los entornos."
  }
}

# Map anidado complejo
variable "network_config" {
  description = "Configuración de red por región"
  type = map(object({
    vpc_cidr = string
    subnets = map(object({
      cidr = string
      type = string
    }))
  }))
  
  default = {
    "us-west-2" = {
      vpc_cidr = "10.0.0.0/16"
      subnets = {
        public_1 = {
          cidr = "10.0.1.0/24"
          type = "public"
        }
        private_1 = {
          cidr = "10.0.2.0/24" 
          type = "private"
        }
      }
    }
  }
}