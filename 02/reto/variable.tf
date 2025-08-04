variable "environment" {
   type = string
   description = "Nombre del ambiente."
   validation {
     condition = contains(["dev","staging", "prod"],var.environment)
     error_message = "El valor de environment debe ser uno de los siguientes: dev, staging, prod."
   }
}

variable "region" {
   type = string
   description = "Nombre del region."
   validation {
     condition = contains(["us-east-1","us-east-2", "us-east-3"],var.region)
     error_message = "El valor de region debe ser uno de los siguientes: us-east-1, us-east-2, us-east-3."
   }
}

variable "list_recurses"{
    type = list(object({
        name = string,
        price = number
    }))
    description = "Lista de recursos tanto nombre con precio."
    validation {
        condition = alltrue([for item in var.list_recurses : can(regex("^[a-zA-Z0-9_-]+$", item.name)) && item.price > 0])
        error_message = "Cada recurso debe tener un nombre valido y precio mayor a 0."
    }   
}