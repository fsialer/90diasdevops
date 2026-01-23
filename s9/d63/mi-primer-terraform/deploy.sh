#!/bin/bash
# deploy.sh - Script simple para desplegar con Terraform

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Script de despliegue con Terraform${NC}"
echo "======================================"

# Verificar que se proporcionó el nombre
if [ -z "$1" ]; then
    echo -e "${RED}❌ Error: Debes proporcionar tu nombre${NC}"
    echo -e "${YELLOW}Uso: $0 TU_NOMBRE${NC}"
    echo -e "${YELLOW}Ejemplo: $0 maria-rodriguez${NC}"
    exit 1
fi

STUDENT_NAME=$1
echo -e "${BLUE}👤 Estudiante: $STUDENT_NAME${NC}"

# Verificar LocalStack
echo -e "${BLUE}🔍 Verificando LocalStack...${NC}"
if ! curl -s http://localhost:4566/health > /dev/null; then
    echo -e "${RED}❌ LocalStack no está corriendo${NC}"
    echo -e "${YELLOW}Inicia LocalStack con: localstack start${NC}"
    exit 1
fi
echo -e "${GREEN}✅ LocalStack está funcionando${NC}"

# Verificar Terraform
echo -e "${BLUE}🔍 Verificando Terraform...${NC}"
if ! command -v terraform &> /dev/null; then
    echo -e "${RED}❌ Terraform no está instalado${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Terraform está instalado${NC}"

# Ir al directorio de terraform
cd terraform

# Inicializar si es necesario
if [ ! -f ".terraform.lock.hcl" ]; then
    echo -e "${BLUE}🏗️ Inicializando Terraform...${NC}"
    terraform init
fi

# Validar configuración
echo -e "${BLUE}🔍 Validando configuración...${NC}"
if ! terraform validate; then
    echo -e "${RED}❌ Error en la configuración de Terraform${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Configuración válida${NC}"

# Mostrar plan
echo -e "${BLUE}📋 Mostrando plan de ejecución...${NC}"
terraform plan -var="student_name=$STUDENT_NAME"

# Preguntar si continuar
echo -e "${YELLOW}¿Quieres aplicar estos cambios? (y/N)${NC}"
read -r response
if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}ℹ️ Operación cancelada${NC}"
    exit 0
fi

# Aplicar configuración
echo -e "${BLUE}🚀 Desplegando infraestructura...${NC}"
if terraform apply -var="student_name=$STUDENT_NAME" -auto-approve; then
    echo -e "${GREEN}✅ ¡Despliegue exitoso!${NC}"
    
    # Mostrar outputs
    echo -e "${BLUE}📊 Información de la infraestructura:${NC}"
    terraform output
    
    echo ""
    echo -e "${GREEN}🎉 ¡Tu infraestructura está lista!${NC}"
    echo -e "${YELLOW}🧪 Prueba los comandos que aparecen en 'comandos_para_probar'${NC}"
    echo -e "${YELLOW}🧹 Para eliminar todo: terraform destroy -var=\"student_name=$STUDENT_NAME\"${NC}"
else
    echo -e "${RED}❌ Error en el despliegue${NC}"
    exit 1
fi