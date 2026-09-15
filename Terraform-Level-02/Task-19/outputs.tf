output "KKE_sns_topic_name" {
  value       = aws_sns_topic.devops_sns.name
  description = "The name of the SNS topic"
}

output "KKE_cloudwatch_alarm_name" {
  value       = aws_cloudwatch_metric_alarm.devops_cpu_alarm.alarm_name
  description = "The name of the CloudWatch alarm"
}