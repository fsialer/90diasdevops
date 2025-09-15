
kubectl apply -f ./tarea/mysql.yml
kubectl apply -f ./tarea/wordpress.yml

#kubectl port-forward service/wordpress-service 30080:80