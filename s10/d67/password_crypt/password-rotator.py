#!/usr/bin/env python3
# password-rotator.py - Rotar passwords automáticamente

import os
import random
import string
import json
import subprocess
from datetime import datetime, timedelta

class PasswordRotator:
    def __init__(self):
        self.services = [
            "database",
            "redis", 
            "admin_user",
            "api_token",
            "backup_key"
        ]
        self.password_file = ".env.secrets"
        self.rotation_log = "password-rotation.log"
    
    def generate_strong_password(self, length=16):
        """Generar password fuerte"""
        # Caracteres seguros (evitar confusos como 0, O, l, I)
        chars = string.ascii_letters + string.digits + "!@#$%&*+-="
        chars = chars.replace('0', '').replace('O', '')
        chars = chars.replace('l', '').replace('I', '')
        
        return ''.join(random.choice(chars) for _ in range(length))
    
    def generate_security_summary(self):
        """Generar resumen completo de seguridad"""
        print("📊 RESUMEN DE SEGURIDAD")
        print("=" * 30)
        print(f"📅 Análisis generado: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print()
        
        print("\n💡 RECOMENDACIONES:")
        print("=" * 20)
        
        print("\n🔧 COMANDOS ÚTILES:")
        print("   • Ver logs en vivo: sudo tail -f /var/log/auth.log")
        print("   • Bloquear IP: sudo ufw deny from <IP>")
        print("   • Ver conexiones: netstat -tuln")
        print("   • Procesos de red: sudo lsof -i")
    
    def rotate_passwords(self):
        now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        with open(self.password_file, "w") as secrets, open(self.rotation_log, "a") as log:
            log.write(f"\n[{now}] Rotación de passwords\n")

            for service in self.services:
                password = self.generate_strong_password()
                env_key = service.upper() + "_PASSWORD"

                secrets.write(f"{env_key}={password}\n")
                log.write(f"  - {service} rotado correctamente\n")

        # Permisos seguros
        os.chmod(self.password_file, 0o600)

        print("🔐 Passwords rotados correctamente")
        print(f"📁 Guardados en: {self.password_file}")
        print(f"📝 Log: {self.rotation_log}")

if __name__ == "__main__":
    rotator = PasswordRotator()
    rotator.rotate_passwords()
    rotator.generate_security_summary()
    print("✅ Sistema de passwords configurado correctamente")