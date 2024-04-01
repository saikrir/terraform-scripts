resource "aws_api_gateway_rest_api" "skrao-rest-api" {
  name = "skrao-rest-api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "hello-world" {
  rest_api_id = aws_api_gateway_rest_api.skrao-rest-api.id
  parent_id   = aws_api_gateway_rest_api.skrao-rest-api.root_resource_id
  path_part   = "hello-world"
}


resource "aws_api_gateway_method" "GET" {
  rest_api_id      = aws_api_gateway_rest_api.skrao-rest-api.id
  resource_id      = aws_api_gateway_resource.hello-world.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "skrao-api-integration" {
  rest_api_id             = aws_api_gateway_rest_api.skrao-rest-api.id
  resource_id             = aws_api_gateway_resource.hello-world.id
  http_method             = aws_api_gateway_method.GET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.skrao-first-lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "skrao-deployment" {
  rest_api_id = aws_api_gateway_rest_api.skrao-rest-api.id

  depends_on = [aws_api_gateway_integration.skrao-api-integration]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "skrao-api-stage" {
  deployment_id = aws_api_gateway_deployment.skrao-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.skrao-rest-api.id
  stage_name    = "skrao-stage"
}

