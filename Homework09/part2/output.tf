/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
*/

output "api_gateway_url" {
  description = "The URL of the API Gateway"
  value       = aws_api_gateway_stage.hwk_09_api_stage.invoke_url
}