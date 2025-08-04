provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "staging_instance" {
  count         = 2
  instance_type = "t3.small"
  ami           = "ami-12345678" # reemplaza con un AMI válido

  tags = {
    Environment = "staging"
  }
}

resource "aws_db_instance" "staging_db" {
  instance_class = "db.t3.medium"
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
    Environment = "staging"
  }
}