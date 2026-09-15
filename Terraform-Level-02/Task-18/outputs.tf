output "KKE_instance_name" {
  value       = aws_instance.nautilus_ec2.tags["Name"]
  description = "The EC2 instance name"
}

output "KKE_alarm_name" {
  value       = aws_cloudwatch_metric_alarm.nautilus_alarm.alarm_name
  description = "The CloudWatch alarm name"
}