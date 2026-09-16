output "kke_dynamodb_table_name" {
  value       = aws_dynamodb_table.datacenter_tasks.name
  description = "Name of the DynamoDB table created"
}