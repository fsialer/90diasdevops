
# Levantar todo el stack
docker compose up -d

# Verificar que todo esté corriendo
docker ps

# Deberías ver 3 contenedores corriendo:
# - grafana (puerto 3000)
# - prometheus (puerto 9090)  
# - node-exporter (puerto 9100)


# 1. Node Exporter (métricas crudas)
curl http://localhost:9100/metrics | head -20

# Deberías ver algo como:
# node_cpu_seconds_total{cpu="0",mode="idle"} 12345.67
# node_memory_MemTotal_bytes 8.394604e+09

# 2. Prometheus (interface web)
# Abrir en browser: http://localhost:9090

# 3. Grafana (dashboard web)
# Abrir en browser: http://localhost:3000
# Usuario: admin
# Password: admin123

# SUBIR CPU
# En una terminal nueva
# Linux/Mac:
stress --cpu 1 --timeout 60s

# Si no tenés stress, usar:
yes > /dev/null &
sleep 10
kill %1

# Windows (PowerShell):
for ($i=0; $i -lt 100000000; $i++) { $x = $i * $i }

# SUBIR MEMORIA
# Crear archivo grande temporal
dd if=/dev/zero of=archivo_grande bs=1M count=500

# Ver gráfico de memoria subir
# Después borrar:
rm archivo_grande

# NETWORK ACTIVITY
# Generar tráfico de red
curl -o archivo_test.zip http://speedtest.ftp.otenet.gr/files/test1Mb.db
rm archivo_test.zip
