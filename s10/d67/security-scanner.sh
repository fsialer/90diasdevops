#!/bin/bash
# security-scanner.sh - Escanear vulnerabilidades básicas

echo "🔍 SCANNER DE SEGURIDAD BÁSICO"
echo "=============================="

# Crear directorio de reportes
mkdir -p security-reports
report_file="security-reports/scan-$(date +%Y%m%d-%H%M%S).txt"

{
    echo "REPORTE DE SEGURIDAD - $(date)"
    echo "================================"
    echo

    # 1. Verificar actualizaciones del sistema
    echo "📦 ACTUALIZACIONES PENDIENTES:"
    if command -v apt >/dev/null 2>&1; then
        apt list --upgradable 2>/dev/null | grep -v "WARNING" | wc -l | xargs echo "Paquetes a actualizar:"
    elif command -v yum >/dev/null 2>&1; then
        yum check-update 2>/dev/null | grep -v "Loaded plugins" | wc -l | xargs echo "Paquetes a actualizar:"
    else
        echo "Sistema no soportado para verificar actualizaciones"
    fi
    echo

    # 2. Puertos abiertos
    echo "🌐 PUERTOS ABIERTOS:"
    netstat -tuln 2>/dev/null | grep LISTEN || ss -tuln | grep LISTEN
    echo

    # 3. Usuarios con shell
    echo "👥 USUARIOS CON SHELL:"
    grep -E "/(bash|zsh|sh)$" /etc/passwd
    echo

    # 4. Archivos con permisos peligrosos
    echo "⚠️  ARCHIVOS CON PERMISOS 777:"
    find /home -type f -perm 0777 2>/dev/null | head -10
    echo

} > "$report_file"

# Mostrar resumen en pantalla
echo "✅ Escaneo completado - Reporte: $report_file"
echo
echo "📊 RESUMEN:"
echo "==========="

echo "💡 Ejecuta este script semanalmente para monitorear seguridad"