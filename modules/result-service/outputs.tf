output "container_ids" {
  description = "Container IDs"
  value       = docker_container.service[*].id
}

output "container_names" {
  description = "Container names"
  value       = docker_container.service[*].name
}

output "service_url" {
  description = "Service URL"
  value       = var.external_port != null ? "http://localhost:${var.external_port}" : "internal"
}

output "internal_host" {
  description = "Internal hostname"
  value       = "${var.app_name}-${replace(var.service_name, "_", "-")}"
}
