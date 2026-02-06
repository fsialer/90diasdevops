#Paso 1: Passwords Seguros Automáticos (35 min)
# 1.1 Generador de passwords automático
#./generate-secure-passwords.sh

#1.2 Rotador automático de passwords
# password_crypt/password-rotation.py

#Paso 2: Escaneo Básico de Vulnerabilidades 
# 2.1 Scanner automático de vulnerabilidades
# ./security-scanner.sh

#Paso 3: Firewall Simple pero Efectivo
#3.1 Configurador de firewall básico
# setup-firewall.sh

#Paso 4: Logs de Seguridad Básicos
#4.1 Script de monitoreo simple
#security-status.sh


#Paso 5: Validar Toda la Seguridad
#5.1 Validador completo de seguridad
#validate-security.sh

#Mantener la Seguridad - Recomendación

# Ejecutar diariamente
./security-status.sh

# Ejecutar semanalmente  
./security-scanner.sh
./setup-firewall.sh

# Revisar mensualmente
sudo tail -f /var/log/auth.log



