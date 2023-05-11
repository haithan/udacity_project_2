# TODO: Define the variable for aws_region
variable "aws_region" {
  default = "us-east-1"
}
variable "lambda_function_name" {
  default = "GreetLambda"
}
variable "lambda_output_path" {
  default = "output.zip"
}
variable "lambda_filename" {
  default = "greet_lambda.py"
}
variable "lambda_handler" {
  default = "greet_lambda.lambda_handler"
}
variable "aws_profile" {
  default = "udacity"
}