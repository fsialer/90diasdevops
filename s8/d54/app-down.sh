# Simular app completamente caída
kubectl scale deployment mi-app --replicas=0 -n mi-app

# Esperar 2 minutos para que las alertas se disparen
sleep 120

# Restaurar
kubectl scale deployment mi-app --replicas=3 -n mi-app