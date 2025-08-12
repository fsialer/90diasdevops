# main.tf estructura recomendada
locals {
  # configuración dinámica por workspace
  env_config = {
    dev = {
      database_password = var.database_password
      replica_count     = var.replica_count
      memory_limit      = var.memory_limit
      external_ports    = var.external_ports
    }
    staging = {
      database_password = var.database_password
      replica_count     = var.replica_count
      memory_limit      = var.memory_limit
      external_ports    = var.external_ports
    }
    prod = {
      database_password = var.database_password
      replica_count     = var.replica_count
      memory_limit      = var.memory_limit
      external_ports    = var.external_ports
    }
  }
  current_config = local.env_config[terraform.workspace]
}

# Network
module "network" {
  source = "./modules/network"
}

# Database
module "database" {
  source        = "./modules/database"
  app_name      = "postgres"
  network_name  = module.network.network_name
  image_name    = "postgres:latest"
  replica_count = local.env_config[terraform.workspace].replica_count
  environment_vars = {
    POSTGRES_DB       = "db"
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = local.env_config[terraform.workspace].database_password
    ENVIRONMENT       = terraform.workspace,
    ##REPLICA_ID        = replica_count.index,
    TOTAL_REPLICAS = local.env_config[terraform.workspace].replica_count
  }
  external_port = local.env_config[terraform.workspace].external_ports.postgres
  memory_limit  = local.env_config[terraform.workspace].memory_limit
  environment   = terraform.workspace
  service_name  = "postgres-service"
  depends_on    = [module.network]
}

# Cache
module "cache" {
  source        = "./modules/cache"
  app_name      = "redis"
  network_name  = module.network.network_name
  image_name    = "redis:latest"
  replica_count = local.env_config[terraform.workspace].replica_count
  environment_vars = {
    ENVIRONMENT = terraform.workspace,
    # REPLICA_ID        = replica_count.index,
    TOTAL_REPLICAS = local.env_config[terraform.workspace].replica_count
  }
  external_port = local.env_config[terraform.workspace].external_ports.redis
  memory_limit  = local.env_config[terraform.workspace].memory_limit
  environment   = terraform.workspace
  service_name  = "redis-service"
  depends_on    = [module.network]
}

# Applications
module "vote_service" {
  source        = "./modules/vote-service"
  app_name      = "voteapp"
  network_name  = module.network.network_name
  image_name    = "desafiodevops-vote:latest"
  replica_count = local.env_config[terraform.workspace].replica_count
  environment_vars = {
    ENVIRONMENT = terraform.workspace
    # REPLICA_ID        = replica_count.index
    TOTAL_REPLICAS    = local.env_config[terraform.workspace].replica_count
    ENV               = terraform.workspace
    REDIS_HOST        = "redis"
    DATABASE_HOST     = "postgres"
    DATABASE_USER     = "postgres"
    DATABASE_PASSWORD = local.env_config[terraform.workspace].database_password
    DATABASE_NAME     = "db"
  }
  external_port = local.env_config[terraform.workspace].external_ports.vote
  memory_limit  = local.env_config[terraform.workspace].memory_limit
  environment   = terraform.workspace
  service_name  = "vote-service"
  depends_on    = [module.cache]
}

# Worker
module "worker" {
  source        = "./modules/worker-service"
  app_name      = "workerapp"
  network_name  = module.network.network_name
  image_name    = "desafiodevops-worker:latest"
  replica_count = local.env_config[terraform.workspace].replica_count
  environment_vars = {
    ENV               = terraform.workspace
    REDIS_HOST        = "redis"
    DATABASE_HOST     = "postgres"
    DATABASE_USER     = "postgres"
    DATABASE_PASSWORD = local.env_config[terraform.workspace].database_password
    DATABASE_NAME     = "db"
  }
  external_port = null
  memory_limit  = local.env_config[terraform.workspace].memory_limit
  environment   = terraform.workspace
  service_name  = "worker-service"
  depends_on    = [module.database, module.cache]
}

# Result
module "result_service" {
  source        = "./modules/result-service"
  app_name      = "resultapp"
  network_name  = module.network.network_name
  image_name    = "desafiodevops-result:latest"
  replica_count = local.env_config[terraform.workspace].replica_count
  environment_vars = {
    ENV               = terraform.workspace
    APP_PORT          = local.env_config[terraform.workspace].external_ports.result
    DATABASE_HOST     = "postgres"
    DATABASE_USER     = "postgres"
    DATABASE_PASSWORD = local.env_config[terraform.workspace].database_password
    DATABASE_NAME     = "db"
  }
  external_port = local.env_config[terraform.workspace].external_ports.result
  memory_limit  = local.env_config[terraform.workspace].memory_limit
  environment   = terraform.workspace
  service_name  = "result-service"
  depends_on    = [module.database]

}
