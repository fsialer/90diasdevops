# Desarrollo - Recursos mínimos
database_password = "dev_password_123"
replica_count     = 2
memory_limit      = 256
external_ports = {
  vote   = 8080
  result = 3000
  postgres = 5432  # Expuesto para debugging
  redis    = 6379  # Expuesto para debugging
}