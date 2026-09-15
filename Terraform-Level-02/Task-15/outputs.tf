output "kke_dynamodb_table" {
  value       = aws_dynamodb_table.datacenter.name
  description = "Name of the DynamoDB table"
}

output "kke_iam_role_name" {
  value       = aws_iam_role.datacenter_role.name
  description = "Name of the IAM role"
}

output "kke_iam_policy_name" {
  value       = aws_iam_policy.datacenter_policy.name
  description = "Name of the IAM policy"
}