#!/usr/bin/env python3
# 🚨 Sistema de alertas súper simple que funciona

import requests
import psutil
import time
import json
from datetime import datetime

# Configuración
SLACK_WEBHOOK = "WEBHOOK_SLACK"

def send_slack_alert(message, emoji="🚨", channel="#devops-alerts"):
    """Enviar mensaje a Slack"""
    payload = {
        "text": f"{emoji} {message}",
        "channel": channel,
        "username": "DevOps Bot",
        "icon_emoji": ":robot_face:"
    }
    
    try:
        response = requests.post(SLACK_WEBHOOK, json=payload)
        if response.status_code == 200:
            print(f"✅ Alerta enviada: {message}")
        else:
            print(f"❌ Error enviando alerta: {response.status_code}")
    except Exception as e:
        print(f"❌ Error: {e}")

def check_system_health():
    """Revisar salud del sistema - súper simple"""
    alerts = []
    
    # 1. CPU muy alta
    cpu_percent = psutil.cpu_percent(interval=1)
    if cpu_percent > 80:
        alerts.append(f"CPU alta: {cpu_percent}%")
    
    # 2. Memoria muy alta
    memory = psutil.virtual_memory()
    if memory.percent > 85:
        alerts.append(f"Memoria alta: {memory.percent}%")
    
    # 3. Disco muy lleno
    disk = psutil.disk_usage('/')
    disk_percent = (disk.used / disk.total) * 100
    if disk_percent > 90:
        alerts.append(f"Disco lleno: {disk_percent:.1f}%")
    
    # 4. Muchos procesos
    if len(psutil.pids()) > 300:
        alerts.append(f"Muchos procesos: {len(psutil.pids())}")
    
    return alerts

def check_application_health():
    """Revisar apps - súper básico"""
    alerts = []
    
    # Verificar si la web responde
    try:
        response = requests.get("http://localhost:80", timeout=5)
        if response.status_code != 200:
            alerts.append(f"Web no responde: HTTP {response.status_code}")
    except requests.exceptions.RequestException:
        alerts.append("Web no disponible - No responde")
    
    # Verificar base de datos (ejemplo con ping a puerto)
    import socket
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(3)
        result = sock.connect_ex(('localhost', 5432))  # PostgreSQL
        if result != 0:
            alerts.append("Base de datos no responde")
        sock.close()
    except:
        alerts.append("Error verificando BD")
    
    return alerts

def main():
    print(f"🔍 Verificando sistema - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Revisar sistema
    system_alerts = check_system_health()
    app_alerts = check_application_health()
    
    all_alerts = system_alerts + app_alerts
    
    if all_alerts:
        message = f"PROBLEMAS DETECTADOS:\n" + "\n".join([f"• {alert}" for alert in all_alerts])
        send_slack_alert(message, "🚨")
    else:
        print("✅ Todo bien!")
        # Enviar mensaje cada hora si todo está bien
        current_minute = datetime.now().minute
        if current_minute == 0:  # Solo a las horas en punto
            send_slack_alert("Sistema funcionando normal ✅", "💚")

if __name__ == "__main__":
    main()