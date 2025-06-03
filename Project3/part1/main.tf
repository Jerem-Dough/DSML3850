provider "aws" {
  region = var.region
}

/* ---------------------- *
 * Security Configuration *
 * ---------------------- */

// IAM role for SageMaker
resource "aws_iam_role" "sagemaker_execution_role" {
  name = "SageMakerExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "sagemaker.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "sagemaker_policy_attachment" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "sagemakercanvas_policy_attachment" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerCanvasFullAccess"
}

resource "aws_iam_role_policy" "sagemaker_policy" {
  name = "SageMakerPolicy"
  role = aws_iam_role.sagemaker_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      Resource = [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    }]
  })
}

/* ---------------------- *
 * Services Configuration *
 * ---------------------- */

resource "aws_s3_bucket" "prj_03_bucket" {
  bucket         = var.bucket_name
  force_destroy  = true
}

resource "aws_s3_bucket_public_access_block" "bucket_block" {
  bucket = aws_s3_bucket.prj_03_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "heart_attack_file" {
  bucket       = aws_s3_bucket.prj_03_bucket.bucket
  key          = "heart_attack.csv"
  source       = "${path.module}/../data/heart_attack.csv"
  etag         = filemd5("${path.module}/../data/heart_attack.csv")
  content_type = "text/csv"
}

resource "aws_sagemaker_domain" "dsml3850" {
  domain_name = var.domain_name
  auth_mode   = "IAM"
  vpc_id      = var.vpc_id
  subnet_ids  = [var.subnet_id]
  default_user_settings {
    execution_role = aws_iam_role.sagemaker_execution_role.arn
  }
}

resource "aws_sagemaker_user_profile" "dsml3850_user" {
  domain_id         = aws_sagemaker_domain.dsml3850.id
  user_profile_name = var.user_profile_name
  user_settings {
    execution_role = aws_iam_role.sagemaker_execution_role.arn
  }
}
