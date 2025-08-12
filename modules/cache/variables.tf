variable "app_name" {
  description = "Application name prefix"
  type        = string
}

variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "image_name" {
  description = "Docker image name"
  type        = string
}

variable "replica_count" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

variable "environment_vars" {
  description = "Environment variables"
  type        = map(string)
  default     = {}
}

variable "external_port" {
  description = "External port (null for internal only)"
  type        = number
  default     = null
}

variable "memory_limit" {
  description = "Memory limit in MB"
  type        = number
  default     = 256
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "service_name" {
  description = "Service name"
  type = string
}