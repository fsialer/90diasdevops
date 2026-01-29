#!/bin/bash
echo "📊 Analizando pipeline actual..."

# Obtener últimas 10 ejecuciones
gh api repos/:owner/:repo/actions/runs \
  --jq '.workflow_runs[0:10] | .[] | {
    id: .id,
    status: .conclusion,
    duration: ((.updated_at | fromdateiso8601) - (.created_at | fromdateiso8601)),
    started: .created_at
  }'

echo "🎯 Meta: Reducir tiempo en 50%"