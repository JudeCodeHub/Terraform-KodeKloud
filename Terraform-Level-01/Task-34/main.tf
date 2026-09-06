resource "aws_s3_bucket" "my_bucket" {
  bucket = "nautilus-cp-30996"
  acl    = "private"

  tags = {
    Name = "nautilus-cp-30996"
  }
}

# Copy file to S3 bucket
resource "aws_s3_object" "nautilus_file" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "nautilus.txt"
  source = "/tmp/nautilus.txt"
  etag   = filemd5("/tmp/nautilus.txt")
}