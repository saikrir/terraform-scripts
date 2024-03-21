
# aws s3 bucket
resource "aws_s3_bucket" "skrao-s3-bucket" {
  bucket        = local.s3_bucket_name
  force_destroy = true
  tags          = var.my_tags
}


resource "aws_s3_bucket_public_access_block" "skrao_bucket_block_policy" {
  bucket = aws_s3_bucket.skrao-s3-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# aws s3 bucket policy
resource "aws_s3_bucket_policy" "skrao-s3-bucket-policy" {
  bucket = aws_s3_bucket.skrao-s3-bucket.id
  
  policy = <<POLICY
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "PublicReadGetObject",
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : ["s3:GetObject"],
          "Resource" :  "arn:aws:s3:::${local.s3_bucket_name}/*"
        }
      ]
  }
  POLICY
  depends_on = [ aws_s3_bucket_public_access_block.skrao_bucket_block_policy ]
}

resource "aws_s3_bucket_website_configuration" "skrao-website-config" {
  bucket = aws_s3_bucket.skrao-s3-bucket.id
  index_document {
    suffix = "index.html"
  }
}

module "template_files" {
  source   = "hashicorp/dir/template"
  base_dir = "${path.module}/website"
}

resource "aws_s3_object" "skrao-website-files" {
  bucket   = aws_s3_bucket.skrao-s3-bucket.id
  for_each = module.template_files.files

  key          = each.key
  content_type = each.value.content_type
  source       = each.value.source_path
  content      = each.value.content
  etag         = each.value.digests.md5
}