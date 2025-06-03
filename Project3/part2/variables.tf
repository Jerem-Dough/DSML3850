variable "region" {
  default = "us-east-2"  # use same region as Part 1
}

variable "vpc_id" {
  default = "vpc-0021fcd03d261c115"
}

variable "subnet_ids" {
  type    = list(string)
  default = [
    "subnet-083396cfd285131a5",  # us-east-2b
    "subnet-0e846ace233990327"   # us-east-2a
  ]
}

