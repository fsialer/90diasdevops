terraform {
  required_version = ">= 1.0"
  
  required_providers {
    docker = {
      source  = "calxus/docker"
      version = "~> 3.0"
    }
  }
}

# Configuración del provider Docker
provider "docker" {
}