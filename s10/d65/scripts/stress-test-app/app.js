const express = require('express');
const app = express();
const port = 3001;

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
  console.log(`��� App corriendo en http://localhost:${port}`);
});
