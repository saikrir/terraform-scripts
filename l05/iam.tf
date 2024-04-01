resource "aws_iam_role" "skrao-lambda-role" {
  name               = "skrao-lambda-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow"
  }
}
POLICY
}


# Allow API gateway to invoke the hello Lambda function.
resource "aws_lambda_permission" "skrao-lambda-permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.skrao-first-lambda.function_name
  principal     = "apigateway.amazonaws.com"
}
