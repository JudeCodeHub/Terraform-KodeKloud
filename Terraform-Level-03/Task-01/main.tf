resource "aws_dynamodb_table" "datacenter_tasks" {
  name         = var.KKE_TABLE_NAME
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "taskId"

  attribute {
    name = "taskId"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "task_1" {
  table_name = aws_dynamodb_table.datacenter_tasks.name
  hash_key   = aws_dynamodb_table.datacenter_tasks.hash_key

  item = jsonencode({
    taskId      = { S = "1" }
    description = { S = "Learn DynamoDB" }
    status      = { S = "completed" }
  })
}

resource "aws_dynamodb_table_item" "task_2" {
  table_name = aws_dynamodb_table.datacenter_tasks.name
  hash_key   = aws_dynamodb_table.datacenter_tasks.hash_key

  item = jsonencode({
    taskId      = { S = "2" }
    description = { S = "Build To-Do App" }
    status      = { S = "in-progress" }
  })
}