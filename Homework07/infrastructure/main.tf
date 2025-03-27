/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
*/

provider "aws" {
  region = var.region
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

/* ---------------------- *
 * Security Configuration *
 * ---------------------- */

resource "aws_security_group" "hwk_07_http_sg" {
  name        = "hwk_07_http_sg"
  description = "Homework 07 HTTP security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "hwk_07_http_sg_sg" {
  name        = "hwk_07_http_sg_sg"
  description = "Homework 07 HTTP SG-SG security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.hwk_07_http_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/* ---------------------- *
 * Services Configuration *
 * ---------------------- */

resource "aws_ecs_cluster" "cluster" {
  name = "hwk_07_cluster"
}

resource "aws_ecs_task_definition" "task_def" {
  family                   = "hwk_07"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn


  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "container",
      image     = "235494821254.dkr.ecr.us-west-1.amazonaws.com/dsml3850:hwk-07",
      essential = true,
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_lb" "hwk_07_lb" {
  name               = "hwk-07-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.hwk_07_http_sg.id]
  subnets            = [var.subnet_id_1, var.subnet_id_2]
}

resource "aws_lb_target_group" "hwk_07_lb_tg_a" {
  name        = "hwk-07-lb-tg-a"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path = "/a"
  }
}

resource "aws_lb_target_group" "hwk_07_lb_tg_b" {
  name        = "hwk-07-lb-tg-b"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path = "/b"
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.hwk_07_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404 Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "rule_a" {
  listener_arn = aws_lb_listener.lb_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hwk_07_lb_tg_a.arn
  }

  condition {
    path_pattern {
      values = ["/a"]
    }
  }
}

resource "aws_lb_listener_rule" "rule_b" {
  listener_arn = aws_lb_listener.lb_listener.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hwk_07_lb_tg_b.arn
  }

  condition {
    path_pattern {
      values = ["/b"]
    }
  }
}

resource "aws_ecs_service" "hwk_07_srv_a" {
  name            = "hwk-07-srv-a"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_def.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = [var.subnet_id_1, var.subnet_id_2]
    security_groups = [aws_security_group.hwk_07_http_sg_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.hwk_07_lb_tg_a.arn
    container_name   = "container"
    container_port   = 80
  }
}

resource "aws_ecs_service" "hwk_07_srv_b" {
  name            = "hwk-07-srv-b"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_def.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = [var.subnet_id_1, var.subnet_id_2]
    security_groups = [aws_security_group.hwk_07_http_sg_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.hwk_07_lb_tg_b.arn
    container_name   = "container"
    container_port   = 80
  }
}

output "hwk_07_lb_dns_name" {
  value = aws_lb.hwk_07_lb.dns_name
}
