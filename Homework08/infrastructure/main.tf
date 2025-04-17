/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student(s): Jeremy Dougherty
Description: S3 Bucket Creation and Access Configuration + Lambda Deployment
*/

provider "aws" {
  region = var.region
}

/* ---------------------- *
 * Security Configuration *
 * ---------------------- */

resource "aws_iam_role" "hwk_08_lambda_role" {
  name = "hwk_08_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "hwk_08_lambda_policy_attachment" {
  role       = aws_iam_role.hwk_08_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "hwk_08_bucket_policy" {
  name = var.bucket_policy_name
  role = aws_iam_role.hwk_08_lambda_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource": [
          "arn:aws:s3:::${var.bucket_in}",
          "arn:aws:s3:::${var.bucket_in}/*",
          "arn:aws:s3:::${var.bucket_out}",
          "arn:aws:s3:::${var.bucket_out}/*"
        ]
      }
    ]
  })
}

/* ---------------------- *
 * Services Configuration *
 * ---------------------- */

// Bucket for input files
resource "aws_s3_bucket" "bucket_in" {
  bucket        = var.bucket_in
  force_destroy = true
}

// Bucket for summarized output files
resource "aws_s3_bucket" "bucket_out" {
  bucket        = var.bucket_out
  force_destroy = true
}

// Lambda function that processes CSV uploads
resource "aws_lambda_function" "hwk_08_lambda" {
  function_name = "hwk_08_lambda"
  role          = aws_iam_role.hwk_08_lambda_role.arn
  handler       = "hwk_08_lambda.lambda_handler"
  runtime       = "python3.11"
  filename      = "${path.module}/hwk_08_lambda.zip"

  source_code_hash = filebase64sha256("${path.module}/hwk_08_lambda.zip")

  environment {
    variables = {
      BUCKET_OUT = var.bucket_out
    }
  }
}

// Allow S3 bucket to trigger the Lambda function
resource "aws_lambda_permission" "allow_s3_to_call_lambda" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hwk_08_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket_in.arn
}

// Configure S3 trigger on file upload
resource "aws_s3_bucket_notification" "hwk_08_bucket_notification" {
  bucket = aws_s3_bucket.bucket_in.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.hwk_08_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".csv"
  }

  depends_on = [aws_lambda_permission.allow_s3_to_call_lambda]
}
