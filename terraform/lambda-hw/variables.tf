
variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "sandbox_id" {
  type    = string
  default = "test"
}

variable "lambda_role_arn" {
  type    = string
}

variable "apigw_rr_id" {
  type    = string
}

variable "apigw_id" {
  type    = string
}

variable "apigw_exec_arn" {
  type    = string
}

variable "dynamodb_table_name" {
  type    = string
}

variable "bucket_name" {
  type    = string
}


variable "bucket_path_to_file" {
  type    = string
}
