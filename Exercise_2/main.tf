provider "aws" {
  region  = var.region
  profile = "miro-udacity"
}

# Policy to lambda to assume role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
# Policy to lambda to log
resource "aws_iam_policy" "logging_policy" {
  name = "logging-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
      }
    ]
  })
}
# Add policy  to role
resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
# Add policy to log to role
resource "aws_iam_role_policy_attachment" "logging_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.id
  policy_arn = aws_iam_policy.logging_policy.arn
}
# Package lambda to be deployed
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "greet_lambda.py"
  output_path = "lambda_function_artifact.zip"
}
# Define lambda itself
resource "aws_lambda_function" "greet_lambda" {
  filename         = "lambda_function_artifact.zip"
  function_name    = "GreetingsUdacity"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "greet_lambda.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = var.runtime
  environment {
    variables = {
      greeting = "Reviewer"
    }
  }
}