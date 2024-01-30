# TODO: Define the output variable for the lambda function.
output "lambda_function_arn" {
  description = "The ARN of lambda function"
  value       = aws_lambda_function.greet_lambda.arn
}