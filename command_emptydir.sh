# Desplegar el pod
kubectl apply -f emptydir-example.yaml

# Ver logs de ambos contenedores
kubectl logs shared-volume-pod -c writer
kubectl logs shared-volume-pod -c reader