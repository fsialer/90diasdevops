#!/bin/bash
# deploy.sh - Deploy en 1 comando

echo "🚀 DEPLOYING APPLICATION..."
echo "========================="

# Verificar prerrequisitos
if ! command -v docker >/dev/null 2>&1; then
    echo "❌ Docker no está instalado"
    exit 1
fi

if ! command -v docker-compose >/dev/null 2>&1; then
    echo "❌ Docker Compose no está instalado"
    exit 1
fi

# Configurar entorno si no existe
if [ ! -f ".env" ]; then
    echo "📝 Creando .env desde template..."
    cp .env.example .env
    echo "⚠️  Edita .env antes de continuar"
    echo "💡 Presiona Enter cuando esté listo..."
    read -r
fi

# Build y deploy
echo "🔨 Building containers..."
docker-compose build

echo "🚀 Starting services..."
docker-compose up -d

echo "⏳ Esperando que servicios inicien..."
sleep 30

echo "🔍 Verificando servicios..."
docker-compose ps

echo "🌐 Testing endpoints..."
if curl -s http://localhost:3000/health > /dev/null; then
    echo "✅ App principal: OK"
else
    echo "❌ App principal: FAIL"
fi

if curl -s http://localhost:9090 > /dev/null; then
    echo "✅ Prometheus: OK"
else
    echo "❌ Prometheus: FAIL"
fi

if curl -s http://localhost:3001 > /dev/null; then
    echo "✅ Grafana: OK"
else
    echo "❌ Grafana: FAIL"
fi

echo
echo "🎉 Deploy completado!"
echo "📊 Dashboard: http://localhost:3001"
echo "📈 Métricas: http://localhost:9090"
echo "🚀 App: http://localhost:3000"
echo
echo "💡 Ver logs: docker-compose logs -f"
echo "🔧 Troubleshooting: cat docs/troubleshooting.md"