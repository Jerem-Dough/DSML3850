/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
*/

variable "region" {
  default = "us-west-1"
}

// TODO: update with your default VPC ID
variable "vpc_id" {
  default = "vpc-0c347a3a6523cbb3e"
}

// TODO: update with a public subnet id from your default VPC
variable "subnet_id" {
  default = "subnet-0a521e183660d2e53"
}
