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

// creates a role to allow the lambda function to interact with AWS services
resource "aws_iam_role" "hwk_09_lambda_role" {
  name = "hwk_09_lambda_role"
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

// attaches the AWSLambdaBasicExecutionRole to the role created above
resource "aws_iam_role_policy_attachment" "hwk_09_lambda_policy_attachment" {
  role       = aws_iam_role.hwk_09_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// allows API gateway to invoke the Lambda function
resource "aws_lambda_permission" "hwk_09_api_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hwk_09_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hwk_09_api.execution_arn}/*/*"
}

// retrieve dynamodb table keys
data "aws_dynamodb_table" "hwk_09_keys" {
  name = "hwk_09_keys"
}

// allows the lambda function to access the dynamodb table
resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name   = "lambda_dynamodb_policy"
  role   = aws_iam_role.hwk_09_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchWriteItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Resource = data.aws_dynamodb_table.hwk_09_keys.arn
      }
    ]
  })
}

/* ---------------------- *
 * Services Configuration *
 * ---------------------- */

// API gateway creation
resource "aws_api_gateway_rest_api" "hwk_09_api" {
  name        = "Hwk09API"
  description = "API Gateway for Homework 09"
}

// creates the API's root endpoint
// Not needed for root endpoint!
# resource "aws_api_gateway_resource" "hwk_09_api_root_endpoint" {
#   rest_api_id = aws_api_gateway_rest_api.hwk_09_api.id
#   parent_id   = aws_api_gateway_rest_api.hwk_09_api.root_resource_id
#   path_part   = "/"
# }

// TODO: create the API's root endpoint method
resource "aws_api_gateway_method" "hwk_09_api_root_endpoint_method" {
  rest_api_id   = aws_api_gateway_rest_api.hwk_09_api.id
  resource_id   = aws_api_gateway_rest_api.hwk_09_api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}


// TODO: integrate the API's root endpoint with the Lambda function
resource "aws_api_gateway_integration" "hwk_09_api_root_endpoint_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.hwk_09_api.id
  resource_id             = aws_api_gateway_rest_api.hwk_09_api.root_resource_id
  http_method             = aws_api_gateway_method.hwk_09_api_root_endpoint_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hwk_09_lambda.invoke_arn
}


// TODO: create the lambda function service
resource "aws_lambda_function" "hwk_09_lambda" {
  function_name = "hwk_09_lambda"
  handler       = "hwk_09_lambda.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.hwk_09_lambda_role.arn

  filename         = "${path.module}/../hwk_09_lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/../hwk_09_lambda.zip")

  environment {
    variables = {
      TABLE_NAME = data.aws_dynamodb_table.hwk_09_keys.name
    }
  }
}


// TODO: deploy the API
resource "aws_api_gateway_deployment" "hwk_09_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.hwk_09_api_root_endpoint_lambda_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.hwk_09_api.id
}


// TODO: stage the API
resource "aws_api_gateway_stage" "hwk_09_api_stage" {
  rest_api_id   = aws_api_gateway_rest_api.hwk_09_api.id
  stage_name    = "prod"
  deployment_id = aws_api_gateway_deployment.hwk_09_api_deployment.id
}

