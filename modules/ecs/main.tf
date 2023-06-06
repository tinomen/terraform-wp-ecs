data "aws_region" "current" {}

resource "aws_ecs_cluster" "wordpress" {
  name = "${var.environment}-wordpress-cluster"
}

resource "aws_ecs_service" "wordpress" {
  name             = "${var.environment}-wordpress-ecs-service"
  cluster          = aws_ecs_cluster.wordpress.arn
  task_definition   = aws_ecs_task_definition.wp.arn
  desired_count    = 2
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  propagate_tags   = "SERVICE"
  network_configuration {
    subnets          = var.ecs_subnet_ids
    security_groups  = var.ecs_security_group_ids
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = var.http_target_group_arn
    container_name   = "${var.environment}-wordpress"
    container_port   = "8080"
  }
  tags               = {
    Name = "${var.environment}-wordpress-ecs-service"
  }
}

resource "aws_ecs_task_definition" "wp" {
  family                   = "${var.environment}-wordpress"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 3072
  execution_role_arn       = var.ecs_task_execution_role_arn
  # should move to a template json file
  container_definitions = jsonencode([
  {
    "image": "bitnami/wordpress",
    "name": "${var.environment}-wordpress",
    "networkMode": "awsvpc",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "${var.environment}-wordpress",
        "containerPath": "/bitnami/wordpress"
      }
    ],
    "logConfiguration": { 
      "logDriver": "awslogs",
      "options": { 
        "awslogs-group" : "${var.cloudwatch_log_name}",
        "awslogs-region": "${data.aws_region.current.name}",
        "awslogs-stream-prefix": "ecs"
      }
    }, 
    "environment": [
      {
        "name": "WORDPRESS_DATABASE_HOST",
        "value": "${var.db_url}"
      },
      {
        "name": "MARIADB_HOST",
        "value": "${var.db_url}"
      },
      {   
        "name": "WORDPRESS_DATABASE_USER",
        "value": "${var.db_username}"
      },
      {   
        "name": "WORDPRESS_DATABASE_PASSWORD",
        "value": "${var.db_password}"
      },
      {   
        "name": "WORDPRESS_DATABASE_NAME",
        "value": "wordpress"
      },
      {   
          "name": "PHP_MEMORY_LIMIT",
          "value": "512M"
      },
      {
        "name": "PHP_UPLOAD_MAX_FILESIZE",
        "value": "15M"
      },
      {   
          "name": "enabled",
          "value": "false"
      },
      {   
          "name": "ALLOW_EMPTY_PASSWORD",
          "value": "yes"
      }
    ]
  }
  ])
  volume                   {
    name = "${var.environment}-wordpress"
    efs_volume_configuration {
      file_system_id = var.efs_file_system_id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = var.efs_access_point_id
        iam = "DISABLED"
      }
    }
  }
}
