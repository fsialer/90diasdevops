# Imagen base desde Docker Hub
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false  # Eliminar imagen al hacer destroy
}

# Imagen específica con tag
resource "docker_image" "postgres" {
  name         = "postgres:15-alpine"
  keep_locally = true   # Mantener imagen localmente
}

# Imagen con digest específico (inmutable)
resource "docker_image" "redis" {
  name = "redis@sha256:..."
}