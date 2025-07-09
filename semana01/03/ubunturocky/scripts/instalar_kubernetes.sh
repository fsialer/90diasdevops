#!/bin/bash
set -e  # Detiene el script si algo falla

# Descarga la última versión estable
KUBECTL_VERSION=$(curl -Ls https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

# Mueve el binario con permisos root
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Limpieza
rm -f kubectl

# Verificación
echo "✅ kubectl instalado:"
kubectl version --client