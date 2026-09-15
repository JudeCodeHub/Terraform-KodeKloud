resource "aws_sns_topic" "nautilus_sns_topic" {
  name = "nautilus-sns-topic"
}

resource "aws_sqs_queue" "nautilus_sqs_queue" {
  name = "nautilus-sqs-queue"
}

resource "aws_sns_topic_subscription" "sns_to_sqs" {
  topic_arn = aws_sns_topic.nautilus_sns_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.nautilus_sqs_queue.arn
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.nautilus_sqs_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowSNSPublish"
        Effect    = "Allow"
        Principal = "*"
        Action    = "SQS:SendMessage"
        Resource  = aws_sqs_queue.nautilus_sqs_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.nautilus_sns_topic.arn
          }
        }
      }
    ]
  })
}