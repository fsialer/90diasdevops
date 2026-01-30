// advanced-stress-test.js - Stress test con K6
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

// Métricas personalizadas
const errorRate = new Rate('errors');
const responseTime = new Trend('response_time');

// Configuración del test
export const options = {
  stages: [
    // Calentamiento
    { duration: '2m', target: 10 },   // Empezar suave
    { duration: '2m', target: 20 },   // Aumentar gradualmente
    
    // Carga normal
    { duration: '3m', target: 50 },   // Carga normal esperada
    
    // Stress test
    { duration: '2m', target: 100 },  // Doble de la carga normal
    { duration: '3m', target: 150 },  // Carga alta
    
    // Spike test
    { duration: '1m', target: 300 },  // Pico de tráfico
    { duration: '2m', target: 300 },  // Mantener pico
    
    // Recovery
    { duration: '3m', target: 0 },    // Volver a cero
  ],
  
  thresholds: {
    'http_req_duration': ['p(95)<1000'], // 95% de requests bajo 1s
    'http_req_failed': ['rate<0.05'],    // Menos de 5% de errores
    'errors': ['rate<0.05'],
  },
};

const BASE_URL = 'http://host.docker.internal:3000';

export default function () {
  // Test de endpoint principal
  const response1 = http.get(`${BASE_URL}/`);
  check(response1, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  }) || errorRate.add(1);
  
  responseTime.add(response1.timings.duration);

  // Test de health check
  const response2 = http.get(`${BASE_URL}/health`);
  check(response2, {
    'health check OK': (r) => r.status === 200,
  }) || errorRate.add(1);

  // Ocasionalmente probar endpoint pesado
  if (Math.random() < 0.3) {  // 30% de las veces
    const response3 = http.get(`${BASE_URL}/cpu-intensive`);
    check(response3, {
      'CPU intensive OK': (r) => r.status === 200,
      'CPU response < 2s': (r) => r.timings.duration < 2000,
    }) || errorRate.add(1);
  }

  sleep(1);
}

// Función que se ejecuta al final
export function handleSummary(data) {
  return {
    'stress-test-summary.json': JSON.stringify(data, null, 2),
    'stress-test-report.html': htmlReport(data),
  };
}

function htmlReport(data) {
  return `
<!DOCTYPE html>
<html>
<head>
    <title>🔥 Stress Test Results</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .summary { background: #f5f5f5; padding: 20px; border-radius: 8px; }
        .pass { color: green; }
        .fail { color: red; }
        .metric { margin: 10px 0; }
    </style>
</head>
<body>
    <h1>🔥 Stress Test Results</h1>
    <div class="summary">
        <h2>📊 Summary</h2>
        <div class="metric">Total Requests: ${data.metrics.http_reqs.count}</div>
        <div class="metric">Failed Requests: ${data.metrics.http_req_failed.count}</div>
        <div class="metric">Error Rate: ${(data.metrics.http_req_failed.rate * 100).toFixed(2)}%</div>
        <div class="metric">Average Response Time: ${data.metrics.http_req_duration.med.toFixed(2)}ms</div>
        <div class="metric">95th Percentile: ${data.metrics['http_req_duration'].p95.toFixed(2)}ms</div>
        <div class="metric">Max Response Time: ${data.metrics.http_req_duration.max.toFixed(2)}ms</div>
    </div>
    
    <h2>🎯 Thresholds</h2>
    ${Object.entries(data.thresholds || {}).map(([key, threshold]) => 
      `<div class="metric ${threshold.ok ? 'pass' : 'fail'}">
        ${threshold.ok ? '✅' : '❌'} ${key}
      </div>`
    ).join('')}
</body>
</html>
  `;
}