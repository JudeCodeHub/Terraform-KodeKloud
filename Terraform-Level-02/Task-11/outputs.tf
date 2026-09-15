output "KKE_bucket_name" {
  value       = aws_s3_bucket.xfusion_bucket.id
  description = "The name of the created S3 bucket"
}