variable "student_name" {
  description = "Nombre del estudiante"
  type        = string
  default     = "Devops Student"

  validation {
    condition     = length(var.student_name) > 2
    error_message = "El nombre de tener al menos 3 caracteres."
  }
}

variable "devops_tools" {
  description = "Herramientas Devops que estamos aprendiendo"
  type        = list(string)
  default = [
    "Docker",
    "Docker Compose",
    "Terraform",
    "Github Actions",
    "Kubernetes"
  ]
}

variable "create_backup" {
  description = "Crear archivo de resplado"
  type        = bool
  default     = true
}