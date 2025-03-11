/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
*/

/* ---------------------- *
 * Security Configuration *
 * ---------------------- */

// create the activity's task execution role
resource "aws_iam_role" "act_13_task_execution_role" {
  name = "act_13_task_execution_role"

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

// attach the task execution policy to the role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.act_13_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

// create the activity's task role
resource "aws_iam_role" "act_13_task_role" {
  name = "act_13_task_role"

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

// create the activity's RDS access policy
resource "aws_iam_policy" "act_13_rds_access_policy" {
  name = "act_13_rds_access_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "rds:CreateDBInstance",
          "rds:DescribeDBInstances",
          "rds:ModifyDBInstance",
          "rds:DeleteDBInstance",
          "rds:CreateDBCluster",
          "rds:DescribeDBClusters",
          "rds:ModifyDBCluster",
          "rds:DeleteDBCluster",
          "rds-db:connect"
        ],
        Resource = var.postgres_arn
      }
    ]
  })
}

// attach the rds access policy to the role
resource "aws_iam_role_policy_attachment" "act_13_task_role_policy_attachment" {
  role       = aws_iam_role.act_13_task_role.name
  policy_arn = aws_iam_policy.act_13_rds_access_policy.arn
}

data "aws_security_group" "act_13_sg" {
  name = "act_13_sg"
}

/* ---------------------- *
 * Services Configuration *
 * ---------------------- */

// create the activity's task definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = "act_13"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.act_13_task_execution_role.arn
  task_role_arn            = aws_iam_role.act_13_task_role.arn

  // make sure that the runtime platform is compatible with the docker image
  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "act_13",
      image     = var.docker_image_uri,
      essential = true,
      portMappings = [
        {
          containerPort = 5000,
          hostPort      = 5000
        }
      ]
    }
  ])
}

// create an ECS cluster
resource "aws_ecs_cluster" "cluster" {
  name = "act_13_cluster"
}

// create a service to run a single task from the task definition
resource "aws_ecs_service" "service" {
  name            = "act_13"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [var.subnet_id] 
    security_groups = [data.aws_security_group.act_13_sg.id]
    assign_public_ip = true
  }
}