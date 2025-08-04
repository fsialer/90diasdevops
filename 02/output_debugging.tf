# Outputs para debugging
output "debug_info" {
  value = {
    variables = {
      app_name    = var.app_name
      environment = var.environment
      zones       = var.availability_zones
    }
    locals = {
      resource_prefix = local.resource_prefix
      common_tags     = local.common_tags
      current_env     = local.current_env
    }
    computed = {
      validation_results = local.validation_results
      all_validations    = local.all_validations_pass
    }
  }
}

# Output para ver transformaciones
output "transformations" {
  value = {
    original_tags = var.tags
    processed_tags = local.common_tags
    uppercase_tags = local.uppercase_tags
  }
}


# Archivo de debug con toda la información
resource "local_file" "debug_output" {
  filename = "debug-${var.environment}.json"
  content = jsonencode({
    timestamp = timestamp()
    variables = {
      app_name           = var.app_name
      environment        = var.environment
      application_config = var.application_config
    }
    locals = {
      resource_prefix    = local.resource_prefix
      current_env        = local.current_env
      infrastructure     = local.infrastructure_config
      validation_results = local.validation_results
    }
    terraform_info = {
      workspace = terraform.workspace
      version   = "1.6+"
    }
  })
}