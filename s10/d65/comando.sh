#Paso 1: Stress Test Básico
#Preparar la aplicación de prueba
# Crear aplicación simple para probar
mkdir stress-test-app && cd stress-test-app

# Crear app Node.js básica
cat > app.js << 'EOF'
const express = require('express');
const app = express();
const port = 3000;

// Endpoint básico
app.get('/', (req, res) => {
  res.json({ message: 'App funcionando', timestamp: new Date() });
});

// Endpoint con carga de CPU
app.get('/cpu-intensive', (req, res) => {
  const start = Date.now();
  // Simular trabajo pesado
  let result = 0;
  for (let i = 0; i < 1000000; i++) {
    result += Math.random();
  }
  const duration = Date.now() - start;
  res.json({ result: result, duration: `${duration}ms` });
});

// Endpoint con uso de memoria
app.get('/memory-test', (req, res) => {
  const data = new Array(100000).fill('x'.repeat(1000));
  res.json({ message: 'Memory allocated', size: data.length });
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', uptime: process.uptime() });
});

app.listen(port, () => {
  console.log(`🚀 App corriendo en http://localhost:${port}`);
});
EOF

# package.json
cat > package.json << 'EOF'
{
  "name": "stress-test-app",
  "version": "1.0.0",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF

# Instalar y arrancar
npm install
npm start &
echo "✅ App de prueba iniciada en puerto 3000"

#Ejecutar el stress test básico
chmod +x basic-stress-test.sh
./basic-stress-test.sh

#Paso 2: Stress Test Avanzado con K6
#2.1 Instalar K6
# macOS
brew install k6

# Ubuntu/Debian
curl -s https://packagecloud.io/install/repositories/k6-io/stable/script.deb.sh | sudo bash
sudo apt-get update
sudo apt-get install k6

# O usar Docker
docker run --rm -i grafana/k6:latest run - <script.js
docker run --rm -i --add-host=host.docker.internal:host-gateway grafana/k6 run - < advanced-stress-test.js
docker run --rm -i -v ./results --add-host=host.docker.internal:host-gateway grafana/k6 run - < advanced-stress-test.js


#2.2 Script de stress test profesional
# s10/d65/advanced-stress-test.js

#2.3 Ejecutar stress test avanzado
echo "🚀 Ejecutando stress test avanzado con K6..."
k6 run advanced-stress-test.js

echo "📊 Resultados guardados en:"
echo "   - stress-test-summary.json"
echo "   - stress-test-report.html"

# Ver reporte en navegador
open stress-test-report.html  # macOS
# xdg-open stress-test-report.html  # Linux

# Paso 3: Chaos Engineering Práctico
# 3.1 Chaos Engineering con Docker
# ./scripts/chaos-test.sh

#3.2 Chaos con Docker Compose
# ./scripts/docker-chaos.sh

# Paso 4: Monitoreo Durante Stress
# 4.1 Monitor de sistema en tiempo real
# system-monitor.py

# 4.2 Dashboard en tiempo rea
# install-dependencies.sh
echo "📦 Instalando dependencias para monitoreo..."

# Python dependencies
pip3 install psutil matplotlib requests

# Instalar herramientas de sistema
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    brew install htop iftop
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    sudo apt-get update
    sudo apt-get install -y htop iftop sysstat
fi

echo "✅ Dependencias instaladas"

# Paso 5: Generar Reporte Final
# 5.1 Script de reporte unificado
# reporte/final-stress-report.py

# 5.2 Ejecutar reporte final
# ./scripts/run-complete-stress-test.sh



