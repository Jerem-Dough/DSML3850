/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
*/

provider "aws" {
  region = var.region
}

/* ---------------------- *
 * Services Configuration *
 * ---------------------- */

// dynamodb table creation
resource "aws_dynamodb_table" "hwk_09_dynamodb_keys_table" {
  name           = "hwk_09_keys"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "key"
  attribute {
    name = "key"
    type = "S"
  }
}