
resource "aws_s3_bucket" "xfusion_bucket" {
  bucket = "xfusion-lifecycle-745601953"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.xfusion_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.xfusion_bucket.id

  rule {
    id     = "xfusion-lifecycle-rule"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365
    }
  }
}