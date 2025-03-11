/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
*/

provider "aws" {
  region = var.region
}

/* --------------------- *
 * Network Configuration *
 * --------------------- */

// VPC creation
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "hwk_06_vpc"
  }
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

// Subnet 1 creation (Public)
resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_1_cidr_block
  availability_zone       = var.az_1
  map_public_ip_on_launch = true # Ensures EC2 instances get public IPs
  tags = {
    Name = "hwk_06_subnet_1"
  }
}

// Routing association for subnet 1
resource "aws_route_table_association" "subnet_1_routing_association" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.rt.id
}

// Subnet 2 creation (Public)
resource "aws_subnet" "subnet_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_2_cidr_block
  availability_zone       = var.az_2
  map_public_ip_on_launch = true # Ensures EC2 instances get public IPs
  tags = {
    Name = "hwk_06_subnet_2"
  }
}

// Routing association for subnet 2
resource "aws_route_table_association" "subnet_2_routing_association" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.rt.id
}

/* ---------------------- *
 * Security Configuration *
 * ---------------------- */

// Security group for EFS access
resource "aws_security_group" "hwk_06_efs_sg" {
  name        = "hwk_06_efs_sg"
  description = "Homework 06 EFS security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 2049    
    to_port     = 2049
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

// Security group for EC2 instances
resource "aws_security_group" "hwk_06_ec2s_sg" {
  name        = "hwk_06_ec2s_sg"
  description = "Homework 06 EC2s security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict for security if necessary
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// SSH key pair creation (next 3 resources)
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "local_file" "private_key" {
  filename        = "${path.module}/${var.key_name}.pem"
  content         = tls_private_key.key_pair.private_key_pem
  file_permission = "0400"
}

/* ---------------------- *
 * Services Configuration *
 * ---------------------- */

// EFS creation
resource "aws_efs_file_system" "hwk_06_efs" {
  creation_token = "hwk_06_efs"
  tags = {
    Name = "hwk_06_efs"
  }
}

// Mount EFS to subnet 1
resource "aws_efs_mount_target" "efs_mount_subnet_1" {
  file_system_id  = aws_efs_file_system.hwk_06_efs.id
  subnet_id       = aws_subnet.subnet_1.id
  security_groups = [aws_security_group.hwk_06_efs_sg.id]
}

// Mount EFS to subnet 2
resource "aws_efs_mount_target" "efs_mount_subnet_2" {
  file_system_id  = aws_efs_file_system.hwk_06_efs.id
  subnet_id       = aws_subnet.subnet_2.id
  security_groups = [aws_security_group.hwk_06_efs_sg.id]
}

// EC2 Instance #1 creation
resource "aws_instance" "hwk_06_ec2_1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_1.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.hwk_06_ec2s_sg.id]

  # Ensures a public IP for external access
  associate_public_ip_address = true  

  # Run user data script
  user_data = file("${path.module}/setup.sh")

  tags = {
    Name = "hwk_06_ec2_1"
  }
}

// EC2 Instance #2 creation
resource "aws_instance" "hwk_06_ec2_2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_2.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.hwk_06_ec2s_sg.id]

  # Ensures a public IP for external access
  associate_public_ip_address = true  

  # Run user data script
  user_data = file("${path.module}/setup.sh")

  tags = {
    Name = "hwk_06_ec2_2"
  }
}
