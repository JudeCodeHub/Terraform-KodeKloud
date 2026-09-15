output "kke_iam_role_name" {
  value       = aws_iam_role.xfusion_role.name
  description = "The name of the created IAM role"
}

output "kke_iam_policy_name" {
  value       = aws_iam_policy.xfusion_policy.name
  description = "The name of the created IAM policy"
}