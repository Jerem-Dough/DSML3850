/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
*/

variable "region" {
  default = "us-west-1"
}

variable "vpc_id" {
  default = "vpc-0dfba14029e8016bb"
}

variable "subnet_id_1" {
  default = "subnet-0bbfc9f48b23f791c"
}

variable "subnet_id_2" {
  default = "subnet-0047467d6b95ba325"
}

variable "docker_image_uri" {
  default = "235494821254.dkr.ecr.us-west-1.amazonaws.com/dsml3850:hwk-07"
} 

variable "service_b_image" {
  description = "Docker image URI for service B"
  type        = string
  default     = "235494821254.dkr.ecr.us-west-1.amazonaws.com/dsml3850:hwk-07"
}

variable "service_a_image" {
  description = "Docker image URI for service A"
  type        = string
  default     = "235494821254.dkr.ecr.us-west-1.amazonaws.com/dsml3850:hwk-07"
}

variable "ecs_cluster_id" {
  description = "The ID or ARN of the ECS cluster"
  type        = string
}