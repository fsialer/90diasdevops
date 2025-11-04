docker ps -a                # Ver contenedores (incluidos los que fallaron)
docker logs <nombre>        # Logs del contenedor
docker inspect <nombre>     # Configuración y metadata
docker exec -it <nombre> sh # Acceder al contenedor
# Simular un contenedor que falla
docker run --name crash-app alpine sh -c "exit 1"

# Ver estado del contenedor
docker inspect crash-app --format='{{.State.ExitCode}}'

# Ver los logs
docker logs nombre-contenedor
#Inspeccionar
docker inspect nombre-contenedor
# troubleshooting en Kubernetes (básico)
kubectl get pods
kubectl describe pod <nombre>
kubectl logs <nombre>
kubectl exec -it <nombre> -- sh