# Dockerfile para Terraform
FROM hashicorp/terraform:1.6

# Instalar herramientas adicionales
RUN apk add --no-cache \
    aws-cli \
    git \
    curl \
    jq

# Copiar configuración
WORKDIR /workspace
COPY . .

# Script de entrada
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]