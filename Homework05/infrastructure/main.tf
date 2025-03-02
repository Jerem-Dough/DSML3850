/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Description: Configuration code for a virtual machine with an external hard drive mounted
*/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

/* ------------------------ *
 * Networking Configuration *
 * ------------------------ */

// VPC creation
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}

// Internet gateway creation
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

// Route table creation
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

// Subnet creation
resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone
}

// Route table association to subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}

/* ---------------------- *
 * Security Configuration *
 * ---------------------- */

// Security group creation
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
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

// SSH key pair creation
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "local_file" "private_key" {
  filename        = "${path.module}/key-test-us-west-1-web-ssh.pem"
  content         = tls_private_key.key_pair.private_key_pem
  file_permission = "0400"
}

/* ---------------------- *
 * Services Configuration *
 * ---------------------- */

// EBS volume creation
resource "aws_ebs_volume" "my_data" {
  availability_zone = var.availability_zone
  size             = 1
  type             = "gp3"  

  tags = {
    Name = "my-data"
  }
}

// EC2 instance creation
resource "aws_instance" "my_vm" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = aws_key_pair.key_pair.key_name
  subnet_id            = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id] 

  associate_public_ip_address = true

  user_data = file("${path.module}/setup.sh")

  tags = {
    Name = "my-vm"
  }
}

// Attach the EBS volume to the EC2 instance
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.my_data.id
  instance_id = aws_instance.my_vm.id
}
