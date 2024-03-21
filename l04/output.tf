output "s3_bucket_name" {
  value = local.s3_bucket_name
}

output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.skrao-website-config.website_endpoint}/"
}