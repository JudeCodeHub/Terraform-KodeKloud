output "kke_sns_topic_arn" {
  value       = aws_sns_topic.nautilus_sns_topic.arn
  description = "The ARN of the SNS topic"
}

output "kke_sqs_queue_url" {
  value       = aws_sqs_queue.nautilus_sqs_queue.url
  description = "The URL of the SQS queue"
}