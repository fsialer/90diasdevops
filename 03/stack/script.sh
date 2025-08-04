# Inicializar
terraform init

# Planificar
terraform plan

# Aplicar
terraform apply -auto-approve

# Ver estado
terraform show

# Ver outputs
terraform output

# Verificar contenedores
docker ps

# Ver logs
docker logs roxs-postgres
docker logs roxs-redis
docker logs roxs-nginx

# Limpiar todo
terraform destroy -auto-approve

# Inspeccionar red
docker network inspect roxs-voting-network

# Inspeccionar volúmenes
docker volume inspect postgres_data

# Conectar a contenedor
docker exec -it roxs-postgres psql -U postgres -d voting_app

# Verificar conectividad
docker exec roxs-nginx ping postgres
docker exec roxs-nginx ping redis