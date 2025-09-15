# Aplicar en orden
kubectl apply -f persistent-volume.yaml
kubectl apply -f persistent-volume-claim.yaml
kubectl apply -f pod-with-pvc.yaml

# Verificar el estado
kubectl get pv
kubectl get pvc
kubectl get pods