
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "sandbox_id" {
  type    = string
  default = "none"
}

variable "acm_cert_arn" {
  type    = string
}

variable "base_domain" {
  type    = string
}

