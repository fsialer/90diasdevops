# Variables marcadas como sensitive
variable "api_key" {
  description = "API key para servicios externos"
  type        = string
  sensitive   = true  # ✅ No aparece en logs
}

variable "database_credentials" {
  description = "Credenciales de base de datos"
  type = object({
    username = string
    password = string
  })
  sensitive = true  # ✅ Todo el objeto es sensitive
}

# Uso de variables sensibles
resource "local_file" "app_config" {
  content = templatefile("${path.module}/templates/config.tpl", {
    api_key = var.api_key
    # La variable sensible se puede usar normalmente
  })
  
  lifecycle {
    ignore_changes = [content]  # ✅ Evita cambios accidentales
  }
}