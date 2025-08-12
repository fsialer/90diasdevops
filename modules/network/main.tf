# modules/network/main.tf - Segundo paso
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

locals {
  name = "vote_net"
}

resource "docker_network" "voting_network" {
  name = "${local.name}-${terraform.workspace}"
  # ... configuración
}