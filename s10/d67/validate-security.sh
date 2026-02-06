#!/bin/bash
# validate-security.sh - Validar que toda la seguridad funciona

echo "🔍 VALIDANDO CONFIGURACIÓN DE SEGURIDAD"
echo "========================================"

validation_errors=0

# 1. Verificar generador de passwords
echo "🔑 Verificando generador de passwords..."
if [ -f "generate-secure-passwords.sh" ]; then
    chmod +x generate-secure-passwords.sh
    echo "   ✅ Generador de passwords disponible"
else
    echo "   ❌ Script generate-secure-passwords.sh no encontrado"
    ((validation_errors++))
fi

# 2. Verificar scanner de vulnerabilidades
echo "🔍 Verificando scanner de vulnerabilidades..."
if [ -f "security-scanner.sh" ]; then
    chmod +x security-scanner.sh
    echo "   ✅ Scanner disponible"
else
    echo "   ❌ Script security-scanner.sh no encontrado"
    ((validation_errors++))
fi

# 3. Verificar firewall
echo "🛡️  Verificando firewall..."
if command -v ufw >/dev/null 2>&1; then
    ufw_status=$(sudo ufw status | head -1)
    if echo "$ufw_status" | grep -q "active"; then
        echo "   ✅ UFW está activo"
    else
        echo "   ❌ UFW no está activo"
        ((validation_errors++))
    fi
else
    echo "   ❌ UFW no está instalado"
    ((validation_errors++))
fi

# Resumen final
echo
echo "📊 RESUMEN DE VALIDACIÓN:"
echo "========================"

if [ "$validation_errors" -eq 0 ]; then
    echo "🎉 ¡TODAS LAS VALIDACIONES PASARON!"
    echo "✅ Tu sistema tiene seguridad básica funcionando"
else
    echo "⚠️  $validation_errors errores encontrados"
    echo "📋 Revisa los mensajes arriba y corrige los problemas"
fi

echo
echo "💡 PRÓXIMOS PASOS:"
echo "   1. Ejecuta: ./security-status.sh (estado rápido)"
echo "   2. Revisa: tail -f /var/log/auth.log (logs en vivo)" 
echo "   3. Testa: nmap -sT localhost (ver puertos abiertos)"