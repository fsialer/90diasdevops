#!/bin/bash
echo "🚀 Roxs Voting App - Quick Start"
echo "1. Crear workspace dev"
terraform workspace new dev 2>/dev/null || terraform workspace select dev

echo "2. Aplicar configuración"
terraform init
terraform apply -var-file="./environments/dev.tfvars"

echo "3. Verificar despliegue"
sleep 10
./verify-deployment.sh