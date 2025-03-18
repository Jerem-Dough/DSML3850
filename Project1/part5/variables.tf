/* DSML3850: Cloud Computing
   Instructor: Thyago Mota
   Student(s): Jeremy Dougherty
*/

variable "region" {
  default = "us-west-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_az1_cidr" {
  default = "10.0.1.0/24"
}

variable "subnet_az2_cidr" {
  default = "10.0.2.0/24"
}

variable "ecs_cluster_name" {
  default = "prj-01-cluster"
}

variable "ecs_service_name" {
  default = "prj-01-service"
}

variable "ecs_task_name" {
  default = "prj-01-task"
}

variable "container_port" {
  default = 5000
}

variable "alb_name" {
  default = "prj-01-alb"
}

variable "target_group_name" {
  default = "prj-01-tg"
}

variable "s3_bucket_name" {
  default = "prj-01-bucket-jd"
}

variable "task_execution_role_name" {
  default = "prj-01-task-execution-role"
}

variable "task_role_name" {
  default = "prj-01-task-role"
}

variable "security_group_name" {
  default = "prj-01-ecs-sg"
}

variable "bucket_name" {
  description = "S3 bucket for storing application data"
  type        = string
  default     = "prj-01-bucket-jd"  # Hardcoded value
}

variable "docker_image_uri" {
  description = "URI of the Docker image in ECR"
  type        = string
  default     = "235494821254.dkr.ecr.us-west-1.amazonaws.com/dsml3850:prj-01-v3"  # Hardcoded value
}
