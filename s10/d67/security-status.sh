#!/bin/bash
# security-status.sh - Ver estado rápido de seguridad

echo "🔍 ESTADO DE SEGURIDAD - $(date)"
echo "=============================="

echo "🔐 Actividad SSH (hoy):"
ssh_today=$(grep "$(date '+%b %d')" /var/log/auth.log 2>/dev/null | wc -l)
echo "   📊 Total eventos: $ssh_today"

failed_today=$(grep "Failed password" /var/log/auth.log | grep "$(date '+%b %d')" | wc -l)
if [ "$failed_today" -gt 0 ]; then
    echo "   ⚠️  Intentos fallidos: $failed_today"
else
    echo "   ✅ No intentos fallidos"
fi

echo
echo "🛡️  Estado Firewall:"
if command -v ufw >/dev/null 2>&1; then
    ufw_status=$(sudo ufw status | head -1)
    echo "   $ufw_status"
else
    echo "   ℹ️  UFW no instalado"
fi

echo
echo "💡 Ver más detalles:"
echo "   • Logs SSH: sudo tail -f /var/log/auth.log"
echo "   • Logs Firewall: sudo tail -f /var/log/ufw.log"