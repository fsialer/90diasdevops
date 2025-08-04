provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "prod_instance" {
  count         = 3
  instance_type = "t3.large"
  ami           = "ami-12345678" # reemplaza con un AMI válido

  tags = {
    Environment = "prod"
  }
}

resource "aws_db_instance" "prod_db" {
  instance_class = "db.t3.large"
  allocated_storage = lookup({
    small  = 20,
    medium = 50,
    large  = 100
  }, config.database_size, 20)

  engine         = "mysql"
  username       = "admin"
  password       = "password123"
  skip_final_snapshot = true

  backup_retention_period = 7

  tags = {
    Environment = "prod"
  }
}