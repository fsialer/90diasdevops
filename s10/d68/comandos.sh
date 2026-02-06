# Desarrollo
# Ver logs en tiempo real
docker-compose logs -f

# Reiniciar un servicio
docker-compose restart app

# Ejecutar tests
make test

# Ver métricas
curl http://localhost:9090/metrics

# Produccion
# Deploy a producción
make deploy-prod

# Ver estado de servicios
make status

# Backup de datos
make backup

# Rollback si algo falla
make rollback

# Paso 2: Guías de Despliegue Simples
# 2.1 Ejecutar generador de documentación
# Crear y ejecutar generador
# python3 generador/generate-docs.py

# Ver documentación generada
ls -la docs/

# Abrir dashboard en navegador
open docs/index.html  # macOS
# xdg-open docs/index.html  # Linux

# 2.2 Guía de deploy de 1 comando
# deploy.sh

# Paso 3: Manual de Problemas Comunes
# 3.1 Base de conocimiento automática
# conocimiento/knowledge-base.py

# Paso 4: Dashboard de Documentación
# 4.1 Ejecutar todos los generadores
# Generar toda la documentación
echo "📚 Generando documentación completa..."

# 1. Documentación general
python3 generate-docs.py

# 2. Base de conocimiento
python3 knowledge-base.py

# 3. Verificar archivos generados
echo "📁 Archivos generados:"
ls -la docs/

# 4. Abrir dashboard
if command -v open >/dev/null 2>&1; then
    open docs/index.html
elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open docs/index.html
else
    echo "💡 Abre docs/index.html en tu navegador"
fi

echo "✅ Dashboard de documentación listo!"

# Paso 5: Validar con el Equipo
# 5.1 Checklist de validación
# validate-docs.sh

