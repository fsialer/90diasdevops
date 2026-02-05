# scripts/daily-report.py - Reporte súper simple por email
import smtplib
import psutil
import requests
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from datetime import datetime, timedelta
import json

# Configuración de email
SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587
EMAIL_USER = "example@gmail.com"
EMAIL_PASS = ""  # App password de Gmail
TO_EMAILS = ["example@hotmail.com", "example@gmail.com"]

def get_system_stats():
    """Obtener estadísticas básicas del sistema"""
    return {
        "cpu_percent": psutil.cpu_percent(interval=1),
        "memory_percent": psutil.virtual_memory().percent,
        "disk_percent": round((psutil.disk_usage('/').used / psutil.disk_usage('/').total) * 100, 1),
        "load_avg": psutil.getloadavg()[0] if hasattr(psutil, 'getloadavg') else 0,
        "uptime": datetime.now() - datetime.fromtimestamp(psutil.boot_time())
    }

def check_services():
    """Verificar servicios básicos"""
    services = {}
    
    # Web server
    try:
        response = requests.get("http://localhost:80", timeout=5)
        services["web"] = "✅ OK" if response.status_code == 200 else f"❌ HTTP {response.status_code}"
    except:
        services["web"] = "❌ DOWN"
    
    # Database (ejemplo)
    try:
        import socket
        sock = socket.create_connection(('localhost', 5432), timeout=3)
        sock.close()
        services["database"] = "✅ OK"
    except:
        services["database"] = "❌ DOWN"
    
    return services

def generate_html_report():
    """Generar reporte HTML bonito"""
    stats = get_system_stats()
    services = check_services()
    now = datetime.now()
    
    html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <style>
            body {{ font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }}
            .container {{ max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
            .header {{ background: #4CAF50; color: white; padding: 20px; text-align: center; border-radius: 10px; margin: -20px -20px 20px -20px; }}
            .metric {{ display: inline-block; margin: 10px; padding: 15px; border-radius: 8px; min-width: 120px; text-align: center; }}
            .metric.good {{ background: #e8f5e8; border-left: 4px solid #4CAF50; }}
            .metric.warning {{ background: #fff3e0; border-left: 4px solid #ff9800; }}
            .metric.critical {{ background: #ffebee; border-left: 4px solid #f44336; }}
            .services {{ margin-top: 20px; }}
            .service {{ padding: 10px; margin: 5px 0; border-radius: 5px; background: #f9f9f9; }}
            .footer {{ margin-top: 20px; text-align: center; color: #666; font-size: 12px; }}
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h2>🚀 Reporte Diario DevOps</h2>
                <p>{now.strftime('%d de %B, %Y - %H:%M')}</p>
            </div>
            
            <h3>📊 Métricas del Sistema</h3>
            <div class="metric {'good' if stats['cpu_percent'] < 70 else 'warning' if stats['cpu_percent'] < 85 else 'critical'}">
                <strong>💻 CPU</strong><br>
                {stats['cpu_percent']:.1f}%
            </div>
            
            <div class="metric {'good' if stats['memory_percent'] < 75 else 'warning' if stats['memory_percent'] < 90 else 'critical'}">
                <strong>🧠 Memoria</strong><br>
                {stats['memory_percent']:.1f}%
            </div>
            
            <div class="metric {'good' if stats['disk_percent'] < 80 else 'warning' if stats['disk_percent'] < 95 else 'critical'}">
                <strong>💾 Disco</strong><br>
                {stats['disk_percent']}%
            </div>
            
            <div class="services">
                <h3>🔧 Estado de Servicios</h3>
    """
    
    for service, status in services.items():
        html += f'<div class="service">{service.title()}: {status}</div>'
    
    html += f"""
            </div>
            
            <div class="footer">
                <p>⏰ Sistema activo por: {str(stats['uptime']).split('.')[0]}</p>
                <p>Reporte generado automáticamente por DevOps Challenge Bot</p>
            </div>
        </div>
    </body>
    </html>
    """
    
    return html

def send_email_report():
    """Enviar reporte por email"""
    try:
        # Crear mensaje
        msg = MIMEMultipart()
        msg['From'] = EMAIL_USER
        msg['To'] = ", ".join(TO_EMAILS)
        msg['Subject'] = f"📊 Reporte DevOps - {datetime.now().strftime('%d/%m/%Y')}"
        
        # Generar contenido
        html_content = generate_html_report()
        msg.attach(MIMEText(html_content, 'html'))
        
        # Enviar
        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()
        server.login(EMAIL_USER, EMAIL_PASS)
        server.send_message(msg)
        server.quit()
        
        print("✅ Reporte enviado por email")
        
    except Exception as e:
        print(f"❌ Error enviando email: {e}")

if __name__ == "__main__":
    send_email_report()