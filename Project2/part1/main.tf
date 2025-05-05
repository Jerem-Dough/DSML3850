/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student(s): Jeremy Dougherty
*/

provider "aws" {
  region = var.region
}

/* ---------------------- *
 * Services Configuration *
 * ---------------------- */

resource "aws_dynamodb_table" "prj_02_dynamodb_keys_table" {
  name         = "prj_02_keys"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "api_key"

  attribute {
    name = "api_key"
    type = "S"
  }

  tags = {
    Name        = "prj_02_keys"
    Environment = "dev"
  }
}

resource "aws_dynamodb_table" "prj_02_dynamodb_incidents_table" {
  name         = "prj_02_incidents"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "uid"

  attribute {
    name = "uid"
    type = "S"
  }

  tags = {
    Name        = "prj_02_incidents"
    Environment = "dev"
  }
}
