resource "aws_s3_bucket" "wordpress_bucket" {
  bucket = "datacenter-s3-832943507"
}

resource "aws_s3_bucket_acl" "wordpress_bucket_acl" {
  bucket = aws_s3_bucket.wordpress_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket" "kke_bucket" {
  bucket = var.KKE_BUCKET
}

resource "aws_s3_bucket_acl" "kke_bucket_acl" {
  bucket = aws_s3_bucket.kke_bucket.id
  acl    = "private"
}

resource "null_resource" "migrate_s3_data" {
  depends_on = [
    aws_s3_bucket_acl.kke_bucket_acl
  ]

  provisioner "local-exec" {
    command = "aws --endpoint-url=http://aws:4566 s3 sync s3://${aws_s3_bucket.wordpress_bucket.bucket} s3://${aws_s3_bucket.kke_bucket.bucket}"
  }
}