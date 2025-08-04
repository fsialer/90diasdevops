provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "dev_instance" {
  count         = 1
  instance_type = "t3.micro"
  ami           = "ami-12345678" # reemplaza con un AMI válido

  tags = {
    Environment = "dev"
  }
}

resource "aws_db_instance" "dev_db" {
  instance_class = "db.t3.small"
  allocated_storage = lookup({
    small  = 20,
    medium = 50,
    large  = 100
  }, config.database_size, 20)

  engine         = "mysql"
  username       = "admin"
  password       = "password123"
  skip_final_snapshot = true

  backup_retention_period = 0

  tags = {
    Environment = "dev"
  }
}