output "kke_sns_topic_name" {
  value       = aws_sns_topic.devops_sns.name
  description = "The name of the SNS topic"
}

output "kke_role_name" {
  value       = aws_iam_role.devops_role.name
  description = "The name of the IAM role"
}

output "kke_policy_name" {
  value       = aws_iam_policy.devops_policy.name
  description = "The name of the IAM policy"
}