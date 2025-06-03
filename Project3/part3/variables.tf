/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student(s): Jeremy Dougherty
*/

variable "region" {
  default = "us-east-2"
}

variable "vpc_id" {
  default = "vpc-0021fcd03d261c115"
}

variable "subnet_id" {
  default = "subnet-083396cfd285131a5"
}

variable "docker_image_uri" {
  default = "235494821254.dkr.ecr.us-east-2.amazonaws.com/dsml3850:prj-03"
}

variable "postgres_arn" {
  default = "arn:aws:rds:us-east-2:235494821254:db:prj03-postgres-db"
}
