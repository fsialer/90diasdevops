
# Correr un contenedor simple
# Ver logs de Dockerdocker run -d --name mi-nginx nginx

# Ver los logs en tiempo real
docker logs -f mi-nginx

# Hacer algunas requests
curl http://localhost:80

# ¡Vas a ver los logs apareciendo!

#Métricas de tu sistema
# CPU y memoria en tiempo real
htop

# Info del sistema
top

# Espacio en disco
df -h

#en windows
# Abrir Task Manager (Ctrl + Shift + Esc)
# O usar PowerShell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10

# Trace
chmod +x mi_trace.sh
./mi_trace.sh