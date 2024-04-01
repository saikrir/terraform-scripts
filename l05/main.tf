provider "aws" {
  region = "us-east-1"
}


resource "aws_lambda_function" "skrao-first-lambda" {
  function_name    = "skrao-first-lambda"
  handler          = "app"
  runtime          = "provided.al2"
  role             = aws_iam_role.skrao-lambda-role.arn
  filename         = "./lambda-src/build/bootstrap.zip"
  source_code_hash = sha256(filebase64("./lambda-src/build/bootstrap.zip"))
  memory_size      = 128
  timeout          = 10
}
