/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student: 
*/

variable "region" {
  default = "us-west-1"
}

variable "vpc_cidr_block" {
  default = "192.168.0.0/16"
}

variable "az_1" {
  default = "us-west-1a"
}

variable "subnet_1_cidr_block" {
    default = "192.168.1.0/24"
}

variable "az_2" {
  default = "us-west-1b"
}

variable "subnet_2_cidr_block" {
    default = "192.168.2.0/24"
}

variable "key_name" {
  default = "hwk_06_ec2s_key"
}

variable "ami" {
  default = "ami-0fca1aacaa1ed9168"
}

variable "instance_type" {
  default = "t2.micro"
}