variable "instance_config" {
  description = "Configuración de instancias"
  type = object({
    type  = optional(string, "t3.micro")      # ✅ Valor por defecto
    count = optional(number)                  # ✅ Sin valor por defecto (requerido cuando se usa)
  })
  default = {}  # ✅ Objeto vacío permite usar solo valores por defecto
}

variable "features" {
  description = "Features de la aplicación"
  type = object({
    monitoring = optional(bool, true)         # ✅ Habilitado por defecto
    backup     = optional(bool, false)       # ✅ Deshabilitado por defecto
    ssl        = optional(bool, true)        # ✅ Habilitado por defecto
  })
  default = {}
}

# Uso con coalesce para fallbacks múltiples
locals {
  final_instance_type = coalesce(
    var.instance_config.type,
    var.environment == "prod" ? "t3.medium" : "t3.micro",
    "t3.micro"  # último fallback
  )
}