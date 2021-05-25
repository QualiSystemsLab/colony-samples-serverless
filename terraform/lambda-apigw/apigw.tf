resource "aws_api_gateway_rest_api" "example" {
  name        = "Hello_World_APIGW_${var.sandbox_id}"
  description = "Terraform Serverless Application Example"
}

resource "aws_api_gateway_resource" "defaultcheckup" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "defaultcheckup"
}

resource "aws_api_gateway_method" "defaultcheckup" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.defaultcheckup.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "defaultcheckup" {
  rest_api_id          = aws_api_gateway_rest_api.example.id
  resource_id          = aws_api_gateway_resource.defaultcheckup.id
  http_method          = aws_api_gateway_method.defaultcheckup.http_method
  type                 = "MOCK"
  request_templates = {
    "application/json": "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.defaultcheckup.id
  http_method = aws_api_gateway_method.defaultcheckup.http_method
  status_code = 200
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.defaultcheckup.id
  http_method = aws_api_gateway_method.defaultcheckup.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
}

resource "aws_api_gateway_deployment" "example" {
   depends_on = [
     aws_api_gateway_integration.defaultcheckup,
   ]

   rest_api_id = aws_api_gateway_rest_api.example.id
   stage_name  = var.sandbox_id
}