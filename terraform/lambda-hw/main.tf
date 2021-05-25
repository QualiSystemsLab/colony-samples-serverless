resource "aws_lambda_function" "hello_world" {
  s3_bucket     = var.bucket_name
  s3_key        = var.bucket_path_to_file
  function_name = "hello_world_${var.sandbox_id}"
  description   = "Hello world example"
  role          = var.lambda_role_arn
  handler       = "hello_world.handler"
  runtime       = "nodejs12.x"
  timeout       = "120"
  depends_on    = [aws_cloudwatch_log_group.hello_world_log_group]
  environment {
    variables = {
      TABLE_NAME = var.dynamodb_table_name
      SANDBOX_ID = var.sandbox_id
    }
  }
}

resource "aws_cloudwatch_log_group" "hello_world_log_group" {
  name              = "/aws/lambda/hello_world_${var.sandbox_id}"
  retention_in_days = 3
}
