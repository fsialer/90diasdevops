variable "database_password" {
  type        = string
  description = "Name database"
}

variable "replica_count" {
  type        = number
  description = "Count replica"
}

variable "memory_limit" {
  type        = number
  description = "Memory limit in MB"
}

variable "external_ports" {
  type = object({
    vote     = number
    result   = number
    postgres = number
    redis    = number
  })
}