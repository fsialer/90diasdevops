# Producción - Recursos optimizados
database_password = "super_secure_prod_password"
replica_count     = 3
memory_limit      = 1024
external_ports = {
  vote   = 80
  result = 3000
  postgres = null  # No expuesto
  redis    = null  # No expuesto
}