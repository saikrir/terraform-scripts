locals {
  s3_bucket_name = "skrao-bucket-${random_integer.s3_uniq_id.result}"
}