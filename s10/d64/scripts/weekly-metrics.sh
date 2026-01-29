#!/bin/bash
echo "📊 Generando métricas semanales..."

# Obtener runs de la última semana
WEEK_AGO=$(date -d '7 days ago' --iso-8601)
RUNS=$(gh api repos/:owner/:repo/actions/runs \
  --jq ".workflow_runs[] | select(.created_at > \"$WEEK_AGO\")")

SUCCESS_COUNT=$(echo "$RUNS" | jq 'select(.conclusion == "success")' | jq -s length)
TOTAL_COUNT=$(echo "$RUNS" | jq -s length)
SUCCESS_RATE=$((SUCCESS_COUNT * 100 / TOTAL_COUNT ))

echo "✅ Deployments exitosos: $SUCCESS_COUNT"
echo "📊 Total deployments: $TOTAL_COUNT"  
echo "🎯 Tasa de éxito: $SUCCESS_RATE%"

# Exportar para GitHub Actions
echo "SUCCESS_RATE=$SUCCESS_RATE" >> $GITHUB_ENV