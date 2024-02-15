resource "random_pet" "plr_subnet_group_name" {
  prefix = "plr-subnet-group"
  length = 2
}

resource "random_password" "plr_master_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Postgres RDS if env is Postgres
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

# Postgres RDS if env is Postgres
module "postgres_rds" {
  count                = var.target_env == "postgres" ? 1 : 0
  source               = "terraform-aws-modules/rds/aws"
  identifier           = "${var.application}-${var.target_env}"
  major_engine_version = "13"
  family               = "postgres13"
  engine               = "postgres"
  engine_version       = "13.9"
  instance_class       = "db.t3.micro"
  allocated_storage    = 5

  db_name  = var.application
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
  create_monitoring_role = false

  tags = {
    CreatedBy = "terraform"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.data.ids


  # Database Deletion Protection
  #deletion_protection = true
}

# Oracle RDS if env is not Postgres
module "oracle_rds" {
  count  = var.target_env != "postgres" ? 1 : 0
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.application}-${var.target_env}"

  engine               = "oracle-se2"
  engine_version       = "19"
  family               = "oracle-se2-19" # DB parameter group
  major_engine_version = "19"            # DB option group
  instance_class       = "db.t3.large"
  license_model        = "license-included"

  allocated_storage     = 20
  max_allocated_storage = 100

  # Make sure that database name is capitalized, otherwise RDS will try to recreate RDS instance every time
  # Oracle database name cannot be longer than 8 characters
  db_name  = "ORACLE"
  username = "oracle"
  port     = 1521

  multi_az = false
  #db_subnet_group_name   = module.vpc.database_subnet_group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.data.ids
  vpc_security_group_ids = [data.aws_security_group.data.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  #enabled_cloudwatch_logs_exports = ["alert", "audit"]
  #create_cloudwatch_log_group     = false

  #backup_retention_period = 1
  #skip_final_snapshot     = true
  #deletion_protection     = false

  #performance_insights_enabled          = true
  #performance_insights_retention_period = 7
  #create_monitoring_role                = true

  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = false

  # See here for support character sets https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.OracleCharacterSets.html
  character_set_name       = "AL32UTF8"
  nchar_character_set_name = "AL16UTF16"
}

resource "aws_db_parameter_group" "plr_postgresql13" {
  count       = var.target_env == "postgres" ? 1 : 0
  name        = "${var.plr_cluster_name}-parameter-group"
  family      = "postgres13"
  description = "${var.plr_cluster_name}-parameter-group"
  tags = {
    managed-by = "terraform"
  }
}

resource "aws_rds_cluster_parameter_group" "plr_postgresql13" {
  count       = var.target_env == "postgres" ? 1 : 0
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