resource "aws_dynamodb_table" "example_table" {
  name        = "hello_world_table_${var.sandbox_id}"
  hash_key    = "requestId"
  read_capacity  = 5
  write_capacity = 5
  attribute {
    name = "requestId"
    type = "S"
  }
}
