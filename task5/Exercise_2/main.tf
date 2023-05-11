terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

data "archive_file" "app_greet_lambda" {
  type        = "zip"
  source_file = var.lambda_filename
  output_path = var.lambda_output_path
}

resource "aws_lambda_function" "greet_lambda" {
  function_name = var.lambda_function_name
  filename      = data.archive_file.app_greet_lambda.output_path
  handler       = var.lambda_handler
  runtime       = "python3.8"

  environment {
    variables = {
      greeting = "Hello World!"
    }
  }

  source_code_hash = data.archive_file.app_greet_lambda.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "greet_lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.greet_lambda.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "greet_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
