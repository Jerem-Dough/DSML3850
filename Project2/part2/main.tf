/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student(s): 
*/

provider "aws" {
  region = var.region
}

/* ---------------------- *
 * Security Configuration *
 * ---------------------- */

// creates a role to allow the lambda function to interact with AWS services
resource "aws_iam_role" "prj_02_lambda_role" {
  name = "prj_02_lambda_role"
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
resource "aws_iam_role_policy_attachment" "prj_02_lambda_policy_attachment" {
  role       = aws_iam_role.prj_02_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// allows API gateway to invoke the Lambda function
resource "aws_lambda_permission" "prj_02_api_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.prj_02_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.prj_02_api.execution_arn}/*/*"
}

// retrieve dynamodb table keys
data "aws_dynamodb_table" "prj_02_keys" {
  name = "prj_02_keys"
}

// retrieve dynamodb table keys
data "aws_dynamodb_table" "prj_02_incidents" {
  name = "prj_02_incidents"
}

// allows the lambda function to access the dynamodb table
resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name   = "lambda_dynamodb_policy"
  role   = aws_iam_role.prj_02_lambda_role.id

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
        Resource = [ 
          data.aws_dynamodb_table.prj_02_keys.arn, 
          data.aws_dynamodb_table.prj_02_incidents.arn
        ]
      }
    ]
  })
}

/* ---------------------- *
 * Services Configuration *
 * ---------------------- */

resource "aws_lambda_function" "prj_02_lambda" {
  function_name = "prj_02_lambda"
  role          = aws_iam_role.prj_02_lambda_role.arn
  package_type  = "Image"

  image_uri     = "${aws_ecr_repository.prj_02_lambda.repository_url}:latest"

  timeout       = 15
}

resource "aws_ecr_repository" "prj_02_lambda" {
  name = "prj_02_lambda"
}

resource "aws_api_gateway_rest_api" "prj_02_api" {
  name        = "prj_02_api"
  description = "API Gateway for Cybersecurity Incident Sharing"
}

resource "aws_api_gateway_method" "prj_02_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.prj_02_api.id
  resource_id   = aws_api_gateway_rest_api.prj_02_api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "prj_02_api_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.prj_02_api.id
  resource_id = aws_api_gateway_rest_api.prj_02_api.root_resource_id
  http_method = aws_api_gateway_method.prj_02_api_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.prj_02_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "prj_02_api_deployment" {
  depends_on = [aws_api_gateway_integration.prj_02_api_lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.prj_02_api.id
}

resource "aws_api_gateway_stage" "prj_02_api_stage" {
  deployment_id = aws_api_gateway_deployment.prj_02_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.prj_02_api.id
  stage_name    = "prod"
}
