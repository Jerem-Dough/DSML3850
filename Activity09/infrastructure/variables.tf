/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Description: configuration code for a virtual machine 
*/

variable "region" {
  default = "us-west-1"
}

variable "vpc_cidr" {
  default = "192.168.0.0/16"
}

variable "cidr_block" {
    default = "192.168.10.0/24"
}

variable "availability_zone" {
  default = "us-west-1a"
}

variable "key_name" {
  default = "key-hwk-05-us-west-1-ssh"
}

variable "ami" {
  default = "ami-0fca1aacaa1ed9168"
}

variable "instance_type" {
  default = "t2.micro"
}

