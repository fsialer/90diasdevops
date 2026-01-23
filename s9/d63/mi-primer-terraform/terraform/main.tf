# Configuración de Terraform y el provider de AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configuración para conectar con LocalStack
provider "aws" {
  region                      = "us-east-1"
  access_key                 = "test"
  secret_key                 = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true


  # Endpoints para LocalStack
  endpoints {
    s3         = "http://localhost:4566"
    lambda     = "http://localhost:4566"
    dynamodb   = "http://localhost:4566"
    apigateway = "http://localhost:4566"
    iam        = "http://localhost:4566"
  }
}

# Variable para personalizar nombres
variable "student_name" {
  description = "Tu nombre para personalizar los recursos"
  type        = string
  default     = "estudiante-roxs"
}

# ==========================================
# 1. BUCKETS S3
# ==========================================

# Bucket para archivos
resource "aws_s3_bucket" "mi_bucket_archivos" {
  bucket = "mi-bucket-archivos-${var.student_name}"

  tags = {
    Name        = "Bucket de Archivos"
    Environment = "LocalStack"
    CreatedBy   = "Terraform"
    Student     = var.student_name
  }
}

# Bucket para logs
resource "aws_s3_bucket" "mi_bucket_logs" {
  bucket = "mi-bucket-logs-${var.student_name}"

  tags = {
    Name        = "Bucket de Logs"
    Environment = "LocalStack"
    CreatedBy   = "Terraform"
    Student     = var.student_name
  }
}

# ==========================================
# 2. TABLAS DYNAMODB
# ==========================================

# Tabla de usuarios
resource "aws_dynamodb_table" "mi_tabla_usuarios" {
  name           = "mi-tabla-usuarios-${var.student_name}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  tags = {
    Name        = "Tabla de Usuarios"
    Environment = "LocalStack"
    CreatedBy   = "Terraform"
    Student     = var.student_name
  }
}

# Tabla de posts
resource "aws_dynamodb_table" "mi_tabla_posts" {
  name           = "mi-tabla-posts-${var.student_name}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "post_id"

  attribute {
    name = "post_id"
    type = "S"
  }

  tags = {
    Name        = "Tabla de Posts"
    Environment = "LocalStack"
    CreatedBy   = "Terraform"
    Student     = var.student_name
  }
}

# ==========================================
# 3. ROL IAM PARA LAMBDA
# ==========================================

# Rol para las funciones Lambda
resource "aws_iam_role" "mi_lambda_role" {
  name = "mi-lambda-role-${var.student_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "Lambda Role"
    Environment = "LocalStack"
    CreatedBy   = "Terraform"
    Student     = var.student_name
  }
}

# Política para el rol Lambda
resource "aws_iam_role_policy" "mi_lambda_policy" {
  name = "mi-lambda-policy-${var.student_name}"
  role = aws_iam_role.mi_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          aws_dynamodb_table.mi_tabla_usuarios.arn,
          aws_dynamodb_table.mi_tabla_posts.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${aws_s3_bucket.mi_bucket_archivos.arn}/*",
          "${aws_s3_bucket.mi_bucket_logs.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# ==========================================
# 4. FUNCIÓN LAMBDA SIMPLE
# ==========================================

# Crear el archivo ZIP para Lambda
data "archive_file" "mi_lambda_zip" {
  type        = "zip"
  output_path = "mi_lambda.zip"
  source {
    content = <<EOF
import json
import boto3
from datetime import datetime

def lambda_handler(event, context):
    """
    Función Lambda simple creada con Terraform
    """
    print(f"Evento recibido: {json.dumps(event)}")
    
    # Información de la infraestructura
    response = {
        'statusCode': 200,
        'body': json.dumps({
            'message': '¡Hola desde Lambda creada con Terraform!',
            'student': '${var.student_name}',
            'timestamp': datetime.now().isoformat(),
            'event_received': event,
            'infrastructure': {
                'created_with': 'Terraform',
                'environment': 'LocalStack',
                'tables': ['mi-tabla-usuarios', 'mi-tabla-posts'],
                'buckets': ['mi-bucket-archivos', 'mi-bucket-logs']
            }
        })
    }
    
    print(f"Respuesta: {json.dumps(response)}")
    return response
EOF
    filename = "lambda_function.py"
  }
}

# Función Lambda
resource "aws_lambda_function" "mi_lambda" {
  filename         = data.archive_file.mi_lambda_zip.output_path
  function_name    = "mi-lambda-${var.student_name}"
  role            = aws_iam_role.mi_lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30

  environment {
    variables = {
      TABLA_USUARIOS = aws_dynamodb_table.mi_tabla_usuarios.name
      TABLA_POSTS    = aws_dynamodb_table.mi_tabla_posts.name
      BUCKET_ARCHIVOS = aws_s3_bucket.mi_bucket_archivos.bucket
      BUCKET_LOGS     = aws_s3_bucket.mi_bucket_logs.bucket
      STUDENT_NAME    = var.student_name
    }
  }

  depends_on = [data.archive_file.mi_lambda_zip]

  tags = {
    Name        = "Mi Lambda Function"
    Environment = "LocalStack"
    CreatedBy   = "Terraform"
    Student     = var.student_name
  }
}