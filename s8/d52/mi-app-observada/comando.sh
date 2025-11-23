# Construir y levantar todo
docker-compose up --build -d

# Verificar que todo esté corriendo
docker ps

# Verificar que la app responde
curl http://localhost:5000/
curl http://localhost:5000/api/users
curl -X POST http://localhost:5000/api/login

# Ver métricas crudas de tu app
curl http://localhost:5000/metrics

chmod +x load_test.sh
./load_test.sh

# Con Apache Bench (si lo tenés instalado)
ab -n 1000 -c 10 http://localhost:5000/

# Con curl en loop simple
for i in {1..100}; do
  curl -s http://localhost:5000/api/users > /dev/null &
done

# SOBRECARGA
# Stress test que genera muchos errores
for i in {1..200}; do
  curl -s http://localhost:5000/api/users > /dev/null &
  curl -s -X POST http://localhost:5000/api/login > /dev/null &
done

# CAIDA
# "Romper" la app
docker stop mi-app

# Esperar 1 minuto, ver métricas en Grafana
# Después "arreglar":
docker start mi-app

# BASE DE DATOS LENTA
# Hacer muchos requests al endpoint que simula timeouts
for i in {1..50}; do
  curl -s http://localhost:5000/api/users > /dev/null &
done