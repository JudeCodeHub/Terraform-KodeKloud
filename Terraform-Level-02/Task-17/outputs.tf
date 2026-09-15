output "KKE_secret_name" {
  value       = aws_secretsmanager_secret.app_secret.name
  description = "The secret name"
}

output "KKE_role_name" {
  value       = aws_iam_role.app_role.name
  description = "The IAM role name"
}

output "KKE_policy_name" {
  value       = var.KKE_POLICY_NAME
  description = "The IAM policy name"
}