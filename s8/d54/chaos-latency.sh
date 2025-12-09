#!/bin/bash
echo "⏰ Generando latencia alta..."

# Bombardear con requests para causar latencia
for round in {1..5}; do
  echo "Round $round/5"
  for i in {1..50}; do
    curl -s http://localhost:30080/api/users > /dev/null &
  done
  sleep 2
done

wait
echo "✅ Latency chaos test completado."
