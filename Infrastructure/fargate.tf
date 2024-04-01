resource "aws_ecs_cluster" "plr_cluster" {
  name = "${var.application}_cluster"
}

resource "aws_ecs_cluster_capacity_providers" "plr_cluster" {
  cluster_name       = aws_ecs_cluster.plr_cluster.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 100

  }
}

resource "aws_ecs_task_definition" "plresb_td" {
  family                   = "${var.esb_application}-${var.target_env}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.esb_cpu
  memory                   = var.esb_memory
  tags                     = local.common_tags
  container_definitions = jsonencode([
    {
      essential = true
      name      = "${var.esb_application}-${var.target_env}-definition"
      #change to variable to env. for GH Actions
      image       = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ca-central-1.amazonaws.com/plresb:latest"
      cpu         = var.esb_cpu
      memory      = var.esb_memory
      networkMode = "awsvpc"
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = var.esb_port
          hostPort      = var.esb_port
        }
      ]
      secrets = [
        { name = "PG_USER",
        valueFrom = "${aws_secretsmanager_secret_version.rds_credentials.arn}:username::" },
        { name = "KEYCLOAK_CLIENT_SECRET",
        valueFrom = aws_secretsmanager_secret_version.plresb_keycloak_client_secret.arn },
        { name = "PROVIDER_URI",
        valueFrom = aws_secretsmanager_secret_version.plresb_provider_uri.arn },
        { name = "REDIRECT_URI",
        valueFrom = aws_secretsmanager_secret_version.plresb_redirect_uri.arn },
        { name = "SITEMINDER_LOGOUT_URI",
        valueFrom = aws_secretsmanager_secret_version.plresb_siteminder_logout_uri.arn },
        { name = "PHSA_LOGOUT_URI",
        valueFrom = aws_secretsmanager_secret_version.plresb_phsa_logout_uri.arn }
      ]
      environment = [
        { name = "JVM_XMX",
        value = "\\-Xmx1024m" },
        { name = "JVM_XMS",
        value = "\\-Xms512m" },
        { name = "TZ",
        value = var.timezone },
      ]
      #change awslog group
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/${var.esb_application}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "plrweb_td" {
  family                   = "${var.web_application}-${var.target_env}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.web_cpu
  memory                   = var.web_memory
  tags                     = local.common_tags
  container_definitions = jsonencode([
    {
      essential = true
      name      = "${var.web_application}-${var.target_env}-definition"
      #change to variable to env. for GH Actions
      image       = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ca-central-1.amazonaws.com/plrweb:latest"
      cpu         = var.web_cpu
      memory      = var.web_memory
      networkMode = "awsvpc"
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = var.web_port
          hostPort      = var.web_port
        }
      ]
      secrets = [
        { name = "DB_USER",
        valueFrom = "${aws_secretsmanager_secret_version.rds_credentials.arn}:username::" },
        { name = "DB_PASS",
        valueFrom = "${aws_secretsmanager_secret_version.rds_credentials.arn}:password::" },
        { name = "PLR_KEYCLOAK_CLIENT_SECRET",
        valueFrom = aws_secretsmanager_secret_version.plrweb_keycloak_client_secret.arn },
        { name = "CLIENT_ID",
        valueFrom = aws_secretsmanager_secret_version.plrweb_keycloak_client_id.arn },
        { name = "DB_NAME",
        valueFrom = aws_secretsmanager_secret_version.plrweb_db_name.arn },
        { name = "ENV_NAME",
        valueFrom = aws_secretsmanager_secret_version.plrweb_env_name.arn },
        { name = "ESB_DISTRIBUTION_SERVICE_URI",
        valueFrom = aws_secretsmanager_secret_version.plrweb_esb_dist_service.arn },
        { name = "ESB_BATCH_SERVICE_URI",
        valueFrom = aws_secretsmanager_secret_version.plrweb_esb_batch_service_uri.arn },
        { name = "ESB_ADDRESS_VALIDATION_SERVICE_URI",
        valueFrom = aws_secretsmanager_secret_version.plrweb_esb_address_validation_service_uri.arn },
        { name = "ESB_KEYSTORE_PASSWORD",
        valueFrom = aws_secretsmanager_secret_version.plrweb_esb_keystore_password.arn },
        { name = "ESB_KEY_PASSWORD",
        valueFrom = aws_secretsmanager_secret_version.plrweb_esb_key_password.arn },
        { name = "ESB_TRUSTSTORE_PASSWORD",
        valueFrom = aws_secretsmanager_secret_version.plrweb_esb_truststore_password.arn },
        { name = "KEYCLOAK_PROVIDER_URI",
        valueFrom = aws_secretsmanager_secret_version.plrweb_provider_uri.arn },
        { name = "REDIRECT_URI",
        valueFrom = aws_secretsmanager_secret_version.plrweb_redirect_uri.arn },
        { name = "UMS_URL",
        valueFrom = aws_secretsmanager_secret_version.plrweb_ums_url.arn },
        { name = "SITEMINDER_LOGOUT_URI",
        valueFrom = aws_secretsmanager_secret_version.plrweb_siteminder_logout_uri.arn },
        { name = "PHSA_LOGOUT_URI",
        valueFrom = aws_secretsmanager_secret_version.plrweb_phsa_logout_uri.arn }
      ]
      environment = [
        { name = "JVM_XMX",
        value = "\\-Xmx1024m" },
        { name = "JVM_XMS",
        value = "\\-Xms512m" },
        { name = "TZ",
        value = var.timezone },
      ]
      #change awslog group
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/${var.web_application}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "plrweb" {
  name                              = "${var.web_application}-${var.target_env}-service"
  cluster                           = aws_ecs_cluster.plr_cluster.arn
  task_definition                   = aws_ecs_task_definition.plrweb_td.arn
  desired_count                     = var.web_count
  health_check_grace_period_seconds = 60
  wait_for_steady_state             = false
  force_new_deployment              = true

  triggers = {
    redeployment = var.timestamp
  }

  network_configuration {
    security_groups  = [data.aws_security_group.app.id]
    subnets          = data.aws_subnets.app.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.web.id
    container_name   = "${var.web_application}-${var.target_env}-definition"
    container_port   = var.web_port
  }

  depends_on = [data.aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]

  lifecycle {
    ignore_changes = [capacity_provider_strategy]
  }

}

resource "aws_ecs_service" "plresb" {
  name                              = "${var.esb_application}-${var.target_env}-service"
  cluster                           = aws_ecs_cluster.plr_cluster.arn
  task_definition                   = aws_ecs_task_definition.plresb_td.arn
  desired_count                     = var.esb_count
  health_check_grace_period_seconds = 60
  wait_for_steady_state             = false
  force_new_deployment              = true

  triggers = {
    redeployment = var.timestamp
  }

  network_configuration {
    security_groups  = [data.aws_security_group.app.id]
    subnets          = data.aws_subnets.app.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.esb.id
    container_name   = "${var.esb_application}-${var.target_env}-definition"
    container_port   = var.esb_port
  }

  depends_on = [data.aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]

  lifecycle {
    ignore_changes = [capacity_provider_strategy]
  }

}