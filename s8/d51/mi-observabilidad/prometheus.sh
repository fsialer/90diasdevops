# Ver todas las métricas disponibles
{__name__=~"node_.*"}

# CPU por core
node_cpu_seconds_total

# Memoria total en GB
node_memory_MemTotal_bytes / 1024 / 1024 / 1024

# Uptime del sistema
node_time_seconds - node_boot_time_seconds