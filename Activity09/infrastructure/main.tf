/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Description: configuration code for a virtual machine with an external hard drive mounted
*/

provider "aws" {
  region = var.region
}

/* ------------------------ *
 * Networking Configuration *
 * ------------------------ */

// vpc creation
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}

// internet gateway creation
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

// route table creation
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

// subnet creation
resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone
}

// route table assocation to subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}

/* ---------------------- *
 * Security Configuration *
 * ---------------------- */

// security group creation
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5001
    to_port     = 5001
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
  filename = "${path.module}/key-test-us-west-1-web-ssh.pem"
  content  = tls_private_key.key_pair.private_key_pem
  file_permission = "0400"
}

/* ---------------------- *
 * Services Configuration *
 * ---------------------- */

// TODO: create an EC2 instance named "my-vm" using configuration parameters similar to the ones used in activity 08; use user data to upload the setup.sh script that automatically configures a flask app

resource "aws_instance" "my_vm" {
  ami             = var.ami_id           # AMI ID (Amazon Linux, Ubuntu, etc.)
  instance_type   = var.instance_type    # Instance type (e.g., t2.micro)
  key_name        = aws_key_pair.key_pair.key_name
  subnet_id       = aws_subnet.subnet.id
  security_groups = [aws_security_group.sg.name]

  tags = {
    Name = "my-vm"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Updating and installing dependencies..."
              sudo apt update -y
              sudo apt install -y python3-pip python3-venv git

              echo "Cloning Flask application repository..."
              git clone https://github.com/example/flask-app.git /home/ubuntu/flask-app

              echo "Setting up virtual environment and installing dependencies..."
              cd /home/ubuntu/flask-app
              python3 -m venv venv
              source venv/bin/activate
              pip install -r requirements.txt

              echo "Starting Flask application..."
              nohup python3 app.py &

              echo "Setup complete."
              EOF

  // Attach external volume (EBS)
  root_block_device {
    volume_size = var.root_volume_size  # Size in GB
  }

  ebs_block_device {
    device_name = "/dev/xvdf"
    volume_size = var.external_volume_size
    volume_type = "gp2"
  }

}

