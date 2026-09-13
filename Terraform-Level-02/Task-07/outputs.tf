output "kke_kinesis_stream_name" {
  description = "Name of the Kinesis Data Stream"
  value       = aws_kinesis_stream.xfusion_stream.name
}

output "kke_kinesis_alarm_name" {
  description = "Name of the CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.xfusion_kinesis_alarm.alarm_name
}