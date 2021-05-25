output "base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}

output "apigw_rr_id" {
  value = aws_api_gateway_rest_api.example.root_resource_id
}

output "apigw_id" {
  value = aws_api_gateway_rest_api.example.id
}

output "apigw_exec_arn" {
  value = aws_api_gateway_rest_api.example.execution_arn
}
