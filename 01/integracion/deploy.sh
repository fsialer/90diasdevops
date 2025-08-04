#!/bin/bash
# deploy.sh - Script de despliegue automatizado

set -e

# Variables
ENVIRONMENT=${1:-dev}
ACTION=${2:-plan}

echo "🚀 Terraform Deployment Script"
echo "Environment: $ENVIRONMENT"
echo "Action: $ACTION"

# Validar argumentos
if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    echo "❌ Error: Environment debe ser dev, staging o prod"
    exit 1
fi

if [[ ! "$ACTION" =~ ^(plan|apply|destroy)$ ]]; then
    echo "❌ Error: Action debe ser plan, apply o destroy"
    exit 1
fi

# Configurar backend dinámicamente
export TF_VAR_environment=$ENVIRONMENT

# Ejecutar Terraform
echo "📋 Inicializando Terraform..."
terraform init \
    -backend-config="key=environments/${ENVIRONMENT}/terraform.tfstate"

echo "✅ Validando configuración..."
terraform validate

echo "🔍 Ejecutando $ACTION..."
case $ACTION in
    plan)
        terraform plan -var-file="environments/${ENVIRONMENT}.tfvars"
        ;;
    apply)
        terraform apply -var-file="environments/${ENVIRONMENT}.tfvars" -auto-approve
        ;;
    destroy)
        read -p "⚠️  ¿Estás seguro de destruir $ENVIRONMENT? (yes/no): " confirm
        if [[ $confirm == "yes" ]]; then
            terraform destroy -var-file="environments/${ENVIRONMENT}.tfvars" -auto-approve
        else
            echo "❌ Operación cancelada"
            exit 1
        fi
        ;;
esac

echo "✨ ¡Operación completada!"