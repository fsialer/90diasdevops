kubectl apply -f slos-config.yaml
kubectl apply -f error-budget-alerts.yaml

kubectl apply -f alertmanager-config.yaml
# Reiniciar AlertManager para cargar nueva config
kubectl rollout restart statefulset/alertmanager-kube-prometheus-alertmanager -n monitoring


# Integración con Slack/Discord
## Editar el secret con tu webhook real
kubectl edit secret alertmanager-kube-prometheus-alertmanager -n monitoring
## Cambiar YOUR_SLACK_WEBHOOK_URL por tu URL real
## discord
# En lugar de slack_configs, usar webhook_configs para Discord
webhook_configs:
- url: 'YOUR_DISCORD_WEBHOOK_URL'
  title: '🚨 Alert from Kubernetes'
  send_resolved: true

#Quick Mitigation:

## If recent deployment caused it, rollback immediately
kubectl rollout undo deployment/mi-app -n mi-app

## If traffic spike, scale up
kubectl scale deployment mi-app --replicas=10 -n mi-app

#Investigation (< 15 minutes)
#Check Dependencies: Database, external APIs, network
#Resource Analysis: CPU, Memory, Network saturation
#Log Analysis:
kubectl logs -n mi-app -l app=mi-app --tail=100 | grep ERROR

#Quick Fixes
## Scale application
kubectl scale deployment mi-app --replicas=5 -n mi-app

## Check resource limits
kubectl describe pod -n mi-app -l app=mi-app | grep -A 5 Limits

## Restart if memory leak suspected
kubectl rollout restart deployment/mi-app -n mi-app


#Application Down - Critical Incident
#Emergency Response (< 2 minutes)
## Check Pod Status:

kubectl get pods -n mi-app -o wide
kubectl describe pod -n mi-app -l app=mi-app

## Check Service/Ingress:

kubectl get svc,ingress -n mi-app
curl -I http://localhost:30080/health

## Immediate Recovery:
### Force restart all pods
kubectl rollout restart deployment/mi-app -n mi-app
### If persistent, rollback to last known good
kubectl rollout undo deployment/mi-app -n mi-app