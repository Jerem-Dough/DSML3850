/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
*/

provider "aws" {
  region = var.region
}

/* ---------------------- *
 * Security Configuration *
 * ---------------------- */

resource "aws_security_group" "act_13_sg" {
  name        = "act_13_sg"
  description = "Allow ingress on port 5000 from anywhere"
  vpc_id      = var.vpc_id  

  ingress {
    description      = "Allow HTTP traffic on port 5000"
    from_port        = 5000
    to_port          = 5000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "act_13_sg"
  }
}

resource "aws_security_group" "postgres_sg" {
  name        = "postgres_sg"
  description = "Allow PostgreSQL access"
  vpc_id      = var.vpc_id  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
} 

resource "aws_security_group_rule" "postgres_ingress" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.postgres_sg.id
  source_security_group_id = aws_security_group.act_13_sg.id
}

/* --------------------- *
 * Service Configuration *
 * --------------------- */

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "17.2"  
  instance_class       = "db.t3.micro"
  identifier           = "act13db"
  username             = "postgres"
  password             = "dsml3850"  
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]

  lifecycle {
    ignore_changes = [maintenance_window, backup_window]
  }
}