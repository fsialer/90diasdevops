# README.md del proyecto
## Ambientes Disponibles

- **dev**: Desarrollo local (puerto 8080)
- **staging**: Testing (puerto 8081) 
- **prod**: Producción (puerto 80)

## Comandos Rápidos

```bash
# Desplegar a dev
./scripts/deploy-dev.sh

# Ver estado
./scripts/status.sh

# Cambiar ambiente
terraform workspace select [dev|staging|prod]