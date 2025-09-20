#!/bin/bash
kubectl apply -f 01-namespace.yml
kubectl config set-context --current --namespace=voting-app
kubectl apply -f 02-storage.yml 
kubectl apply -f 03-config-secrets.yml 
kubectl apply -f 04-postgres.yml 
kubectl apply -f 05-redis.yml 
kubectl apply -f 06-vote.yml 
kubectl apply -f 07-worker.yml 
kubectl apply -f 08-result.yml 

#kubectl port-forward service/vote-service -n voting-app 30080:5000
#kubectl port-forward service/result-service -n voting-app 30081:3000