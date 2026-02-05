import requests

webhook = "WEBHHOK_SLACK"
mensaje = {
    "text": "🧪 Prueba de alerta desde DevOps Challenge!",
    "channel": "#devops-alerts"
}

response = requests.post(webhook, json=mensaje)
print(f"Estado: {response.status_code}")