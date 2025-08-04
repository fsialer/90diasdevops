#!/bin/bash
echo "🚀 Desplegando a desarrollo..."

# Cambiar al workspace correcto
terraform workspace select dev || terraform workspace new dev

# Aplicar con variables específicas
terraform apply -var-file="environments/dev.tfvars"

echo "✅ Desarrollo desplegado!"
echo "🌐 URL: http://localhost:8080"