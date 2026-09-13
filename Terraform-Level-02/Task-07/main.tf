resource "aws_kinesis_stream" "xfusion_stream" {
  name        = "xfusion-kinesis-stream"
  shard_count = 1

  shard_level_metrics = [
    "IncomingBytes",
    "IncomingRecords",
    "OutgoingBytes",
    "OutgoingRecords",
    "WriteProvisionedThroughputExceeded",
    "ReadProvisionedThroughputExceeded",
    "IteratorAgeMilliseconds"
  ]
}

resource "aws_cloudwatch_metric_alarm" "xfusion_kinesis_alarm" {
  alarm_name          = "xfusion-kinesis-alarm"
  alarm_description   = "Alerts when Kinesis write throughput exceeds provisioned capacity."
  namespace           = "AWS/Kinesis"
  metric_name         = "WriteProvisionedThroughputExceeded"
  dimensions = {
    StreamName = aws_kinesis_stream.xfusion_stream.name
  }

  statistic           = "Sum"
  period              = 60
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanThreshold"

  treat_missing_data = "notBreaching"
}