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

resource "aws_security_group" "postgres_sg" {
  name        = "postgres_sg"
  description = "Allow PostgreSQL access"
  vpc_id      = var.vpc_id  

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow access from anywhere (use with caution)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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