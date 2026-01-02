#!/bin/bash
echo "🔍 Testing distributed tracing..."

# Generar votos para crear traces
for i in {1..10}; do
  echo "Casting vote $i..."
  curl -s http://localhost:30080/vote/cats > /dev/null
  sleep 1
  curl -s http://localhost:30080/vote/dogs > /dev/null
  sleep 1
done

echo "✅ Votes cast! Check Jaeger for traces:"
echo "   http://localhost:16686"
echo "   Service: vote-service"
echo "   Operation: HTTP GET /vote/*"
