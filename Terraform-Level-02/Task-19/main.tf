resource "aws_sns_topic" "devops_sns" {
  name = "devops-sns-topic"
}

resource "aws_cloudwatch_metric_alarm" "devops_cpu_alarm" {
  alarm_name          = "devops-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.devops_sns.arn]
}