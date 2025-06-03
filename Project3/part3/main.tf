/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student(s): Jeremy Dougherty
*/

provider "aws" {
  region = var.region
}

/* ---------------------- *
 * Security Configuration *
 * ---------------------- */

resource "aws_iam_role" "prj_03_task_execution_role" {
  name = "prj_03_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.prj_03_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_security_group" "prj_03_sg" {
  filter {
    name   = "group-name"
    values = ["prj_03_sg"]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

/* ---------------------- *
 * Services Configuration *
 * ---------------------- */

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/prj-03"
  retention_in_days = 7
}

resource "aws_ecs_cluster" "cluster" {
  name = "prj-03-cluster"
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "prj-03-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.prj_03_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "prj-03-container",
    image     = var.docker_image_uri,
    essential = true,
    portMappings = [{
      containerPort = 5000,
      hostPort      = 5000
    }],
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name,
        awslogs-region        = var.region,
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

resource "aws_ecs_service" "service" {
  name            = "prj-03-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.subnet_id]
    assign_public_ip = true
    security_groups  = [data.aws_security_group.prj_03_sg.id]
  }
}
