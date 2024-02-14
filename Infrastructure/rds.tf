resource "random_pet" "plr_subnet_group_name" {
  prefix = "plr-subnet-group"
  length = 2
}


resource "random_password" "plr_master_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

variable "plr_master_username" {
  description = "The username for the DB master user"
  type        = string
  default     = "postgres"
  sensitive   = true
}

variable "plr_database_name" {
  description = "The name of the database"
  type        = string
  default     = "plr"
}

resource "aws_db_subnet_group" "plr_subnet_group" {
  description = "For RDS ${var.plr_db_name}"
  name        = "${var.plr_db_name}-subnet-group"
  subnet_ids  = data.aws_subnets.app.ids
  tags = {
    managed-by = "Terraform"
  }

  tags_all = {
    managed-by = "Terraform"
  }
}

module "postgres_rds" {
  source = "terraform-aws-modules/rds/aws"
  identifier           = "${var.application}-${var.target_env}"
  major_engine_version = "13"
  family               = "postgres13"
  engine               = "postgres"
  engine_version       = "13.9"
  instance_class       = "db.t3.micro"
  allocated_storage    = 5

  db_name  = "${var.application}audit"
  username = var.plr_master_username
  password = random_password.plr_master_password.result
  port     = "5432"

  vpc_security_group_ids = [data.aws_security_group.data.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    CreatedBy = "terraform"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.data.ids


  # Database Deletion Protection
  #deletion_protection = true
}

resource "aws_db_parameter_group" "plr_postgresql13" {
  name        = "${var.plr_cluster_name}-parameter-group"
  family      = "postgres13"
  description = "${var.plr_cluster_name}-parameter-group"
  tags = {
    managed-by = "terraform"
  }
}

resource "aws_rds_cluster_parameter_group" "plr_postgresql13" {
  name        = "${var.plr_cluster_name}-cluster-parameter-group"
  family      = "postgres13"
  description = "${var.plr_cluster_name}-cluster-parameter-group"
  tags = {
    managed-by = "terraform"
  }
}

resource "random_pet" "master_creds_secret_name" {
  prefix = "plr-master-creds"
  length = 2
}

resource "aws_secretsmanager_secret" "plr_mastercreds_secret" {
  name = random_pet.master_creds_secret_name.id

  tags = {
    managed-by = "terraform"
  }
}

resource "aws_secretsmanager_secret_version" "plr_mastercreds_secret_version" {
  secret_id     = aws_secretsmanager_secret.plr_mastercreds_secret.id
  secret_string = <<EOF
   {
    "username": "${var.plr_master_username}",
    "password": "${random_password.plr_master_password.result}"
   }
  EOF
  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "random_password" "plr_api_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

variable "plr_api_username" {
  description = "The username for the DB api user"
  type        = string
  default     = "fam_proxy_api"
  sensitive   = true
}


resource "random_pet" "api_creds_secret_name" {
  prefix = "plr-api-creds"
  length = 2
}

resource "aws_secretsmanager_secret" "plr_apicreds_secret" {
  name = random_pet.api_creds_secret_name.id

  tags = {
    managed-by = "terraform"
  }
}

resource "aws_secretsmanager_secret_version" "plr_apicreds_secret_version" {
  secret_id     = aws_secretsmanager_secret.plr_apicreds_secret.id
  secret_string = <<EOF
   {
    "username": "${var.plr_api_username}",
    "password": "${random_password.plr_api_password.result}"
   }
  EOF
  lifecycle {
    ignore_changes = [secret_string]
  }
}
