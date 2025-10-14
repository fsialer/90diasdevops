#!/bin/bash

# COMANDOS BASICOS
## Ver charts instalados
helm list

## Buscar charts pubicos
heml search hub nginx

## Agregar repositorio de charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

## Ver charts disponibles
helm search repo bitnami/nginx

# Crear tu primer chart

## Crear estructura de chart

### Crear chart desde cero
helm create mi-primera-app

# Templates con variables
## Verificar templates
### Ver YAML que se generará
helm template mi-primera-app ./mi-primer-app
### Verificar sintaxis
helm lint ./mi-primera-app

# Personaliazr Values

## Usar values especificos
### Deploy en desarrollo
helm install mi-app-dev ./mi-primera-app --values ./mi-primera-app/values-dev.yml --namespace dev
### Deploy en producción
helm install mi-app-prod ./mi-primera-app --values ./mi-primera-app/values-prod.yml --namespace prod

# Instalar y gestionar releases

## Instalar aplicacion
### Instalar en namespace dev
kubectl create namespace dev
helm install mi-app ./mi-primera-app \
  --namespace dev \
  --set replicaCount=2 \
  --set image.tag=alpine
### Ver release instalado
helm list -n dev
## Actualizar aplicación
### Cambiar número de réplicas
helm upgrade mi-app ./mi-primera-app \
  --namespace dev \
  --set replicaCount=3

### Ver historial de releases
helm history mi-app -n dev

## Rollback si algo sale mal
### Volver a la versión anterior
helm rollback mi-app 1 -n dev
### Ver status del release
helm status mi-app -n dev

## Comandos útiles de gestión
### Ver valores actuales del release
helm get values mi-app -n dev

### Ver manifests generados
helm get manifest mi-app -n dev

### Desinstalar completamente
helm uninstall mi-app -n dev

# Ejercicio Practico
## Crear chart personalizado
### Crear chart para nuestra app
helm create devops-app

### Personalizar values.yaml
cat > devops-app/values.yaml << EOF
replicaCount: 2

image:
  repository: nginxdemos/hello
  pullPolicy: IfNotPresent
  tag: "latest"

service:
  type: NodePort
  port: 80
  nodePort: 30080

ingress:
  enabled: false

resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 50m
    memory: 64Mi

### Variables de ambiente personalizadas
env:
  APP_NAME: "DevOps Challenge App"
  ENVIRONMENT: "development"
EOF
kubectl get pods -n dev
kubectl port-forward -n dev service/devops-app 8080:80