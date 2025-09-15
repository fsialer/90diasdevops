# Ver volúmenes persistentes
kubectl get pv
kubectl describe pv <pv-name>

# Ver claims de volúmenes
kubectl get pvc
kubectl describe pvc <pvc-name>

# Ver StorageClasses
kubectl get storageclass
kubectl describe storageclass <sc-name>

# Ver uso de almacenamiento en pods
kubectl exec -it <pod-name> -- df -h

# Crear PVC dinámicamente
kubectl create pvc <name> --size=1Gi --storageclass=<class>

# Eliminar PVC (cuidado con los datos!)
kubectl delete pvc <pvc-name>


# Políticas de Reclamación
# Cuando eliminas un PVC, ¿qué pasa con los datos?
# En el PV
spec:
  persistentVolumeReclaimPolicy: Retain  # o Delete