provider "aws" {
  region = "${config.region}"
}

resource "aws_instance" "${env_name}_instance" {
  count         = ${config.instance_count}
  instance_type = "${config.instance_type}"
  ami           = "ami-12345678" # reemplaza con un AMI válido

  tags = {
    Environment = "${env_name}"
  }
}

resource "aws_db_instance" "${env_name}_db" {
  instance_class = "db.t3.${config.database_size}"
  allocated_storage = lookup({
    small  = 20,
    medium = 50,
    large  = 100
  }, config.database_size, 20)

  engine         = "mysql"
  username       = "admin"
  password       = "password123"
  skip_final_snapshot = true

  backup_retention_period = ${config.backup_enabled ? 7 : 0}

  tags = {
    Environment = "${env_name}"
  }
}