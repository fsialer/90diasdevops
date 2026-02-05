// Node.js con OpenTelemetry
const { NodeSDK } = require('@opentelemetry/sdk-node');
const { JaegerExporter } = require('@opentelemetry/exporter-jaeger');
const { getNodeAutoInstrumentations } = require('@opentelemetry/auto-instrumentations-node');

const jaegerExporter = new JaegerExporter({
  endpoint: 'http://localhost:14268/api/traces',
});

const sdk = new NodeSDK({
  traceExporter: jaegerExporter,
  instrumentations: [
    getNodeAutoInstrumentations()
  ]
});

sdk.start()
  .then(() => {
    console.log('🚀 OpenTelemetry iniciado correctamente');
  })
  .catch((error) => {
    console.error('❌ Error iniciando OpenTelemetry', error);
  });