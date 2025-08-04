locals {
  # 🏗️ Configuración de infraestructura inteligente
  infrastructure_config = {
    # Auto-dimensionamiento basado en entorno
    compute = {
      instance_type = local.current_env.instance_type
      desired_capacity = local.current_env.min_replicas
      
      # Optimización automática de recursos
      cpu_credits = startswith(local.current_env.instance_type, "t3") ? "unlimited" : null
      
      # Configuración de storage por tipo de instancia
      root_volume_size = lookup({
        "t3.micro"  = 8
        "t3.small"  = 10
        "t3.medium" = 15
        "t3.large"  = 20
      }, local.current_env.instance_type, 10)
    }
    
    # Red inteligente basada en número de AZs
    networking = {
      vpc_cidr = "10.${var.environment == "prod" ? 0 : var.environment == "staging" ? 1 : 2}.0.0/16"
      
      # Subnets automáticas
      public_subnets = [
        for i, az in var.availability_zones :
        "10.${var.environment == "prod" ? 0 : var.environment == "staging" ? 1 : 2}.${i + 1}.0/24"
      ]
      
      private_subnets = [
        for i, az in var.availability_zones :
        "10.${var.environment == "prod" ? 0 : var.environment == "staging" ? 1 : 2}.${i + 10}.0/24"
      ]
      
      # NAT Gateways inteligentes
      enable_nat_gateway = var.environment == "prod" ? true : false
      single_nat_gateway = var.environment != "prod" ? true : false
    }
    
    # Base de datos optimizada
    database = merge(var.database_config, {
      # Tamaño automático basado en entorno
      allocated_storage = {
        dev     = 20
        staging = 50
        prod    = 100
      }[var.environment]
      
      # Configuración de backup inteligente
      backup_retention_period = local.current_env.backup_retention
      backup_window          = var.environment == "prod" ? "03:00-04:00" : "02:00-03:00"
      maintenance_window     = var.environment == "prod" ? "sun:04:00-sun:05:00" : "sun:03:00-sun:04:00"
      
      # Multi-AZ solo en producción
      multi_az = var.environment == "prod" ? true : false
      
      # Tipo de instancia optimizado
      instance_class = {
        dev     = "db.t3.micro"
        staging = "db.t3.small" 
        prod    = "db.r5.large"
      }[var.environment]
    })
  }
  
  # 🔐 Configuración de seguridad dinámica
  security_config = {
    # Reglas de firewall inteligentes
    ingress_rules = concat(
      # HTTP/HTTPS básico
      [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "HTTP access"
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "HTTPS access"
        }
      ],
      
      # SSH solo para no-producción o con restricciones
      var.environment != "prod" ? [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/8"]
          description = "SSH access from internal network"
        }
      ] : [],
      
      # Puertos de aplicación personalizados
      [
        for port in var.allowed_ports : {
          from_port   = port
          to_port     = port
          protocol    = "tcp"
          cidr_blocks = [local.infrastructure_config.networking.vpc_cidr]
          description = "Application port ${port}"
        }
      ],
      
      # Acceso a base de datos solo desde VPC
      [
        {
          from_port   = var.database_config.port
          to_port     = var.database_config.port
          protocol    = "tcp"
          cidr_blocks = [local.infrastructure_config.networking.vpc_cidr]
          description = "Database access from VPC"
        }
      ]
    )
    
    # Encriptación automática por entorno
    encryption_config = {
      ebs_encrypted          = var.environment == "prod" ? true : false
      s3_sse_algorithm      = var.environment == "prod" ? "aws:kms" : "AES256"
      rds_storage_encrypted = var.environment == "prod" ? true : false
    }
  }
  
  # 📊 Cálculos de costos y recursos
  cost_analysis = {
    # Estimación mensual por servicio
    monthly_costs = {
      compute = local.current_env.min_replicas * lookup({
        "t3.micro"  = 8.5
        "t3.small"  = 17.0
        "t3.medium" = 34.0
        "t3.large"  = 67.0
      }, local.current_env.instance_type, 25.0)
      
      database = lookup({
        "db.t3.micro" = 15.0
        "db.t3.small" = 30.0
        "db.r5.large" = 182.0
      }, local.infrastructure_config.database.instance_class, 50.0)
      
      storage = local.infrastructure_config.database.allocated_storage * 0.115
      
      network = var.environment == "prod" ? 45.0 : 15.0
    }
    
    total_monthly_estimate = sum(values(local.cost_analysis.monthly_costs))
    
    # Recursos totales calculados
    total_resources = {
      vcpus = local.current_env.min_replicas * lookup({
        "t3.micro"  = 1
        "t3.small"  = 1
        "t3.medium" = 2
        "t3.large"  = 2
      }, local.current_env.instance_type, 1)
      
      memory_gb = local.current_env.min_replicas * lookup({
        "t3.micro"  = 1
        "t3.small"  = 2
        "t3.medium" = 4
        "t3.large"  = 8
      }, local.current_env.instance_type, 2)
      
      storage_gb = local.current_env.min_replicas * local.infrastructure_config.compute.root_volume_size
    }
  }
  
  # 🎛️ Features dinámicas habilitadas
  enabled_features = {
    monitoring = local.current_env.enable_monitoring || var.enable_monitoring
    logging    = local.current_env.enable_logging
    backup     = var.environment != "dev"
    cdn        = var.environment == "prod"
    waf        = var.environment == "prod"
    
    # Auto-scaling inteligente
    auto_scaling = {
      enabled     = local.current_env.max_replicas > local.current_env.min_replicas
      min_size    = local.current_env.min_replicas
      max_size    = local.current_env.max_replicas
      target_cpu  = var.environment == "prod" ? 70 : 80
    }
  }
}