/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
*/

variable "region" {
  default = "us-west-1"
}

// update with your default VPC ID
variable "vpc_id" {
  default = "vpc-0c347a3a6523cbb3e"
}

// update with a public subnet id from your default VPC
variable "subnet_id" {
  default = "subnet-0a521e183660d2e53"
}

// update with your Docker image URI
variable "docker_image_uri" {
  default = "954476870391.dkr.ecr.us-west-1.amazonaws.com/dsml3850:act13-v3"
} 

variable "postgres_arn" {
  default = "arn:aws:rds:us-west-1:954476870391:db:act13db"
}

