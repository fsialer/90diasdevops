#!/bin/bash
# validate-docs.sh - Validar que la documentación sirve

echo "📚 VALIDANDO DOCUMENTACIÓN"
echo "========================="

validation_errors=0

# 1. Verificar archivos principales
echo "📁 Verificando archivos de documentación..."

required_files=(
    "README.md"
    "docs/index.html"
    "docs/deployment.md"
    "docs/troubleshooting.md"
    "docs/troubleshooting-auto.md"
    "docs/project-overview.json"
    "knowledge-base.json"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✅ $file"
    else
        echo "   ❌ $file (faltante)"
        ((validation_errors++))
    fi
done

# 2. Verificar que README tenga contenido esencial
echo "📝 Verificando contenido del README..."

if grep -q "Inicio Rápido" README.md; then
    echo "   ✅ Sección Inicio Rápido"
else
    echo "   ❌ Falta sección Inicio Rápido"
    ((validation_errors++))
fi

if grep -q "docker-compose up" README.md; then
    echo "   ✅ Comandos Docker"
else
    echo "   ❌ Faltan comandos Docker"
    ((validation_errors++))
fi

if grep -q "Problemas Comunes" README.md; then
    echo "   ✅ Sección Problemas Comunes"
else
    echo "   ❌ Falta sección Problemas Comunes"
    ((validation_errors++))
fi

# 3. Verificar que dashboard HTML funcione
echo "🌐 Verificando dashboard HTML..."

if grep -q "Documentation" docs/index.html; then
    echo "   ✅ Dashboard tiene título correcto"
else
    echo "   ❌ Dashboard mal formateado"
    ((validation_errors++))
fi

# 4. Verificar scripts de documentación
echo "🐍 Verificando scripts de documentación..."

if python3 -c "import generate-docs; print('OK')" 2>/dev/null; then
    echo "   ✅ generate-docs.py ejecutable"
else
    echo "   ❌ generate-docs.py tiene errores"
    ((validation_errors++))
fi

if python3 -c "import knowledge-base; print('OK')" 2>/dev/null; then
    echo "   ✅ knowledge-base.py ejecutable"
else
    echo "   ❌ knowledge-base.py tiene errores"  
    ((validation_errors++))
fi

# 5. Test de troubleshooting interactivo
echo "🔧 Testing troubleshooting interactivo..."

if echo "container not starting" | python3 knowledge-base.py > /dev/null 2>&1; then
    echo "   ✅ Troubleshooting interactivo funciona"
else
    echo "   ❌ Troubleshooting interactivo falla"
    ((validation_errors++))
fi

# Resumen
echo
echo "📊 RESUMEN DE VALIDACIÓN:"
echo "========================"

if [ "$validation_errors" -eq 0 ]; then
    echo "🎉 ¡TODA LA DOCUMENTACIÓN ESTÁ LISTA!"
    echo "✅ El equipo puede usar la documentación sin problemas"
    
    echo
    echo "🔗 Links importantes:"
    echo "   • Dashboard: file://$(pwd)/docs/index.html"
    echo "   • Troubleshooting: python3 knowledge-base.py"
    echo "   • Deploy: bash deploy.sh"
else
    echo "⚠️  $validation_errors problemas encontrados"
    echo "📋 Corrige los errores antes de compartir con el equipo"
fi

echo
echo "💡 PRÓXIMOS PASOS:"
echo "   1. Comparte dashboard con el equipo"
echo "   2. Entrena al equipo en troubleshooting interactivo"
echo "   3. Actualiza docs regularmente: python3 generate-docs.py"
echo "   4. Recopila feedback y mejora la documentación"

# Generar checklist para el equipo
cat << 'EOF' > team-documentation-checklist.md
# 📚 Checklist de Documentación para el Equipo

## Para Nuevos Desarrolladores
- [ ] Leer README.md completo
- [ ] Ejecutar `bash deploy.sh` para setup inicial
- [ ] Verificar que todos los servicios funcionan
- [ ] Probar troubleshooting interactivo: `python3 knowledge-base.py`
- [ ] Bookmarkear dashboard: `docs/index.html`

## Para Uso Diario
- [ ] Usar `docs/troubleshooting.md` para problemas comunes
- [ ] Actualizar knowledge base con nuevos problemas encontrados
- [ ] Ejecutar `python3 generate-docs.py` después de cambios importantes

## Para DevOps/SRE
- [ ] Revisar métricas en dashboard
- [ ] Mantener guías de deploy actualizadas
- [ ] Agregar nuevos problemas a knowledge-base.py
- [ ] Validar documentación mensualmente: `bash validate-docs.sh`

## Feedback
- 📝 Problemas con docs: crear issue con tag 'documentation'
- 💡 Mejoras: sugerir en #devops-team
- 🔧 Nuevos problemas: ejecutar troubleshooting y agregar solución
EOF

echo "📋 Checklist para equipo creado: team-documentation-checklist.md"