# Conectarse a MySQL y crear datos
kubectl exec -it <mysql-pod-name> -- mysql -u root -p
# Introducir la contraseña: rootpassword123

# En MySQL, crear algunos datos:
CREATE DATABASE testdb;
USE testdb;
CREATE TABLE usuarios (id INT, nombre VARCHAR(50));
INSERT INTO usuarios VALUES (1, 'Juan'), (2, 'Maria');
SELECT * FROM usuarios;
exit;

# Eliminar el pod para probar persistencia
kubectl delete pod <mysql-pod-name>

# Esperar a que se cree un nuevo pod
kubectl get pods -w

# Conectarse de nuevo y verificar que los datos persisten
kubectl exec -it <nuevo-mysql-pod-name> -- mysql -u root -p
USE testdb;
SELECT * FROM usuarios;  # Los datos deberían estar ahí!