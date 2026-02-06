#!/bin/bash
# setup-firewall.sh - Configurar firewall básico

echo "🛡️  CONFIGURANDO FIREWALL BÁSICO"
echo "==============================="

# Verificar si ufw está disponible
if ! command -v ufw >/dev/null 2>&1; then
    echo "📦 Instalando UFW (firewall)..."
    if command -v apt >/dev/null 2>&1; then
        sudo apt update && sudo apt install -y ufw
    elif command -v yum >/dev/null 2>&1; then
        sudo yum install -y ufw
    else
        echo "❌ No se puede instalar UFW automáticamente"
        echo "💡 Instala manualmente: apt install ufw"
        exit 1
    fi
fi

echo "🔧 Configurando reglas básicas..."

# Reset completo (cuidado en producción!)
sudo ufw --force reset

# Políticas por defecto
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Puertos esenciales
echo "✅ Permitiendo SSH (22)..."
sudo ufw allow 22/tcp comment 'SSH'

echo "✅ Permitiendo HTTP (80)..."
sudo ufw allow 80/tcp comment 'HTTP'

echo "✅ Permitiendo HTTPS (443)..."
sudo ufw allow 443/tcp comment 'HTTPS'

# Activar firewall
echo "🚀 Activando firewall..."
sudo ufw --force enable

# Mostrar estado
echo
echo "📊 ESTADO DEL FIREWALL:"
echo "======================"
sudo ufw status numbered

echo
echo "✅ Firewall configurado correctamente!"