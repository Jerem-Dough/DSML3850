/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
*/

variable "region" {
  default = "us-west-1"
}

// TODO: add your initials suffix for uniqueness 
variable "bucket_in" {
  default = "hwk-08-bucket-in-jd"
}

// TODO: add your initials suffix for uniqueness 
variable "bucket_out" {
  default = "hwk-08-bucket-out-jd"
}

variable "bucket_policy_name" {
  default = "hwk-08-bucket-policy"
}