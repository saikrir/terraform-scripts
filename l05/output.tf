output "invoke-arn" {
  value = aws_api_gateway_deployment.skrao-deployment.invoke_url
}
output "stage" {
  value = aws_api_gateway_stage.skrao-api-stage.stage_name
}

output "path" {
  value = aws_api_gateway_resource.hello-world.path_part
}


output "invoke-url" {
  value = "${aws_api_gateway_deployment.skrao-deployment.invoke_url}${aws_api_gateway_stage.skrao-api-stage.stage_name}/${aws_api_gateway_resource.hello-world.path_part}"
}
