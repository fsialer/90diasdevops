# ✅ Hacer backups regularmente
cp terraform.tfstate terraform.tfstate.backup-$(date +%Y%m%d)

# ✅ No versionar archivos .tfstate
echo "*.tfstate*" >> .gitignore
echo ".terraform/" >> .gitignore

# ✅ Usar workspaces para separar ambientes
terraform workspace select prod  # Solo para prod

# Ver workspace actual
terraform workspace show

# Listar workspaces
terraform workspace list

# Crear workspace
terraform workspace new nombre

# Cambiar workspace
terraform workspace select nombre

# Eliminar workspace (debe estar vacío)
terraform workspace delete nombre

# Ver recursos en el workspace actual
terraform state list

# Ver detalles de un recurso
terraform state show docker_container.app[0]

# Ver toda la configuración aplicada
terraform show

# Ver outputs
terraform output
terraform output app_info

# Verificar qué workspace estás usando
echo "Workspace actual: $(terraform workspace show)"

# Ver el plan antes de aplicar
terraform plan

# Aplicar solo recursos específicos
terraform apply -target=docker_container.app

# Ver logs detallados
TF_LOG=INFO terraform apply