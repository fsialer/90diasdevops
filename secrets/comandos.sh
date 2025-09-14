#!/bin/bash
kubectl create secret generic db-credentials \
  --from-literal=username=admin \
  --from-literal=password=supersecreta123

# Desde archivo
echo -n 'admin' > username.txt
echo -n 'mi-password-secreto' > password.txt
kubectl create secret generic app-secrets --from-file=username.txt --from-file=password.txt

# Secret para Docker Registry
kubectl create secret docker-registry regcred \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=miusuario \
  --docker-password=mipassword \
  --docker-email=mi@email.com


echo -n 'mi-password' | base64
# Para decodificar:
echo 'bWktcGFzc3dvcmQ=' | base64 -d