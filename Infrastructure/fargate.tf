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
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  tags                     = local.common_tags
  container_definitions = jsonencode([
    {
      essential = true
      name      = "${var.esb_application}-${var.target_env}-definition"
      #change to variable to env. for GH Actions
      image       = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ca-central-1.amazonaws.com/plresb:latest"
      cpu         = var.fargate_cpu
      memory      = var.fargate_memory
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
        { name = "PG_PASSWORD",
        valueFrom = "${aws_secretsmanager_secret_version.rds_credentials.arn}:password::" },
        { name = "JDBC_SETTING",
        valueFrom = aws_secretsmanager_secret_version.gis_jdbc_setting.arn },
        { name = "KEYCLOAK_CLIENT_SECRET",
        valueFrom = aws_secretsmanager_secret_version.gis_keycloak_client_secret.arn },
        { name = "PROVIDER_URI",
        valueFrom = aws_secretsmanager_secret_version.gis_provider_uri.arn },
        { name = "REDIRECT_URI",
        valueFrom = aws_secretsmanager_secret_version.gis_redirect_uri.arn },
        { name = "SITEMINDER_LOGOUT_URI",
        valueFrom = aws_secretsmanager_secret_version.gis_siteminder_logout_uri.arn },
        { name = "PHSA_LOGOUT_URI",
        valueFrom = aws_secretsmanager_secret_version.gis_phsa_logout_uri.arn }
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
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  tags                     = local.common_tags
  container_definitions = jsonencode([
    {
      essential = true
      name      = "${var.web_application}-${var.target_env}-definition"
      #change to variable to env. for GH Actions
      image       = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ca-central-1.amazonaws.com/gis:latest"
      cpu         = var.fargate_cpu
      memory      = var.fargate_memory
      networkMode = "awsvpc"
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = var.web_port
          hostPort      = var.web_port
        }
      ]
      secrets = [
        { name = "PG_USER",
        valueFrom = "${aws_secretsmanager_secret_version.rds_credentials.arn}:username::" },
        { name = "PG_PASSWORD",
        valueFrom = "${aws_secretsmanager_secret_version.rds_credentials.arn}:password::" },
        { name = "JDBC_SETTING",
        valueFrom = aws_secretsmanager_secret_version.gis_jdbc_setting.arn },
        { name = "KEYCLOAK_CLIENT_SECRET",
        valueFrom = aws_secretsmanager_secret_version.gis_keycloak_client_secret.arn },
        { name = "PROVIDER_URI",
        valueFrom = aws_secretsmanager_secret_version.gis_provider_uri.arn },
        { name = "REDIRECT_URI",
        valueFrom = aws_secretsmanager_secret_version.gis_redirect_uri.arn },
        { name = "SITEMINDER_LOGOUT_URI",
        valueFrom = aws_secretsmanager_secret_version.gis_siteminder_logout_uri.arn },
        { name = "PHSA_LOGOUT_URI",
        valueFrom = aws_secretsmanager_secret_version.gis_phsa_logout_uri.arn }
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

resource "aws_ecs_service" "main" {
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
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "${var.web_application}-${var.target_env}-definition"
    container_port   = var.web_port
  }

  depends_on = [data.aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]

  lifecycle {
    ignore_changes = [capacity_provider_strategy]
  }

}

resource "aws_ecs_service" "main" {
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
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "${var.esb_application}-${var.target_env}-definition"
    container_port   = var.esb_port
  }

  depends_on = [data.aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]

  lifecycle {
    ignore_changes = [capacity_provider_strategy]
  }

}