#!/bin/bash
# docker-chaos.sh - Chaos testing para stack completo

echo "🐳 DOCKER STACK CHAOS TEST"
echo "=========================="

# Crear stack de prueba si no existe
if [ ! -f "docker-compose.yml" ]; then
    cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3001:3000"
    depends_on:
      - db
    restart: unless-stopped
  
  db:
    image: postgres:13
    environment:
      POSTGRES_DB: testdb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - db_data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  db_data:
EOF

    echo "📄 docker-compose.yml creado"
fi

# Test 1: Random container killing
echo ""
echo "🎲 1. Random container killing test..."

SERVICES=("app" "db")
for i in {1..3}; do
    # Seleccionar servicio random
    SERVICE=${SERVICES[$RANDOM % ${#SERVICES[@]}]}
    
    echo "   Round $i: Matando servicio '$SERVICE'..."
    docker-compose kill $SERVICE
    
    echo "   ⏰ Esperando 5 segundos..."
    sleep 5
    
    echo "   🔄 Reiniciando servicio..."
    docker-compose up -d $SERVICE
    
    echo "   ⏰ Esperando que se estabilice..."
    sleep 10
    
    # Verificar estado
    if docker-compose ps | grep -q "Up"; then
        echo "   ✅ Stack se recuperó"
    else
        echo "   ❌ Stack no se recuperó completamente"
    fi
    
    echo ""
done

# Test 2: Resource exhaustion
echo "💾 2. Resource exhaustion test..."

# Crear container que consume memoria
docker run --rm -d --name memory-eater \
    --memory="1g" \
    --memory-swap="1g" \
    alpine sh -c 'dd if=/dev/zero of=/tmp/memory.tmp bs=1M count=800; sleep 60' 2>/dev/null

echo "   🐏 Container consumiendo 800MB de RAM por 60s..."

# Monitorear el stack durante el consumo
for i in {1..12}; do
    if curl -s http://localhost:3001/health > /dev/null; then
        echo "   Check $i/12: App respondiendo ✅"
    else
        echo "   Check $i/12: App no responde ❌"
    fi
    sleep 5
done

# Limpiar
docker kill memory-eater 2>/dev/null || true
echo "   🧹 Limpieza completada"

echo ""
echo "🎉 Docker chaos tests completados!"