#  Método 1: Python + pip (Recomendado)
## Instalar LocalStack CLI
pip install localstack

## Verificar instalación
localstack --version

pip3 install localstack

# Método 2: Solo Docker (Sin instalación)
docker run --rm -it -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack

# Método 3: Docker Compose (Para proyectos)
docker compose up -d