terraform {
  required_providers {
    docker = {
      source  = "calxus/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Red para la aplicación
resource "docker_network" "app_network" {
  name = "roxs-voting-network"
}

# Volúmenes
resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}

resource "docker_volume" "redis_data" {
  name = "redis_data"
}

# Imágenes
resource "docker_image" "postgres" {
  name         = "postgres:15-alpine"
  keep_locally = true
}

resource "docker_image" "redis" {
  name         = "redis:7-alpine"
  keep_locally = true
}

resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = true
}

# Base de datos PostgreSQL
resource "docker_container" "postgres" {
  name  = "roxs-postgres"
  image = docker_image.postgres.image_id
  
  restart = "unless-stopped"
  
  env = [
    "POSTGRES_DB=${var.database_name}",
    "POSTGRES_USER=${var.database_user}",
    "POSTGRES_PASSWORD=${var.database_password}"
  ]
  
  ports {
    internal = 5432
    external = var.postgres_external_port
  }
  
  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }
  
  networks_advanced {
    name = docker_network.app_network.name
    aliases = ["database", "postgres"]
  }
  
  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U ${var.database_user}"]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
  }
}

# Cache Redis
resource "docker_container" "redis" {
  name  = "roxs-redis"
  image = docker_image.redis.image_id
  
  restart = "unless-stopped"
  
  command = [
    "redis-server",
    "--appendonly", "yes",
    "--appendfsync", "everysec"
  ]
  
  ports {
    internal = 6379
    external = var.redis_external_port
  }
  
  volumes {
    volume_name    = docker_volume.redis_data.name
    container_path = "/data"
  }
  
  networks_advanced {
    name = docker_network.app_network.name
    aliases = ["cache", "redis"]
  }
  
  healthcheck {
    test     = ["CMD", "redis-cli", "ping"]
    interval = "10s"
    timeout  = "3s"
    retries  = 3
  }
}

# Nginx como reverse proxy
resource "docker_container" "nginx" {
  name  = "roxs-nginx"
  image = docker_image.nginx.image_id
  
  restart = "unless-stopped"
  
  ports {
    internal = 80
    external = var.nginx_external_port
  }
  
  # Configuración personalizada de nginx
  upload {
    content = templatefile("${path.module}/nginx.conf", {
      app_upstream = "app:3000"
    })
    file = "/etc/nginx/nginx.conf"
  }
  
  networks_advanced {
    name = docker_network.app_network.name
    aliases = ["proxy", "nginx"]
  }
  
  # Depende de que los otros servicios estén running
  depends_on = [
    docker_container.postgres,
    docker_container.redis
  ]
}