/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student(s): Jeremy Dougherty
Description: S3 Bucket Creation and Access Configuration 
*/

variable "region" {
  default = "us-west-1"
}

variable "user_name" {
  default = "prj-01-user"
}

variable "bucket_name" {
  default = "prj-01-bucket-jd"
}

variable "bucket_policy_name" {
  default = "prj-01-bucket-policy"
}
