# TODO: Define the variable for aws_region
variable "runtime" {
  description = "Lambda Function runtime"
  type        = string
  default     = "python3.9"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}