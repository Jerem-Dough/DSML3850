/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student(s): Jeremy Dougherty
*/

provider "aws" {
  region = var.region
}

/* ---------------------- *
 * Security Configuration *
 * ---------------------- */

resource "aws_security_group" "prj_03_sg" {
  name        = "prj_03_sg"
  description = "Allow TCP port 5000"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5000
    to_port     = 5000
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

resource "aws_security_group" "postgres_sg" {
  name        = "postgres_sg"
  description = "Allow PostgreSQL access from prj_03_sg"
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
  source_security_group_id = aws_security_group.prj_03_sg.id
}

resource "aws_db_instance" "postgres" {
  identifier              = "prj03-postgres-db"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "heartdb"
  username                = "postgresadmin"
  password                = "HeartAttack123!"
  publicly_accessible     = true
  vpc_security_group_ids  = [aws_security_group.postgres_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.default.name
  skip_final_snapshot     = true
}

resource "aws_db_subnet_group" "default" {
  name       = "default-subnet-group"
  subnet_ids = var.subnet_ids
}


# I left this here as a less secure alternative option in case you need to troubleshoot the app running it locally
# resource "aws_security_group" "postgres_sg" {
#   name        = "postgres_sg"
#   description = "Allow PostgreSQL access"
#   vpc_id      = var.vpc_id  

#   ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Allow access from anywhere (use with caution)
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# } 

/* --------------------- *
 * Service Configuration *
 * --------------------- */

// TODO: create an RDS instance
# resource "aws_db_instance" "postgres" {
# }