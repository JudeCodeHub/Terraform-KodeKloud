# Provision DynamoDB Table and Insert Items Using Terraform

## 📌 Task Description

The **Nautilus DevOps team** is developing a simple "To-Do" application using Amazon DynamoDB to store and manage tasks efficiently. The team needs to provision a DynamoDB table to hold tasks, each identified by a unique task ID. Each task item includes a description and a status indicating task progress (e.g., `'completed'` or `'in-progress'`).

**Requirements:**

- Create a DynamoDB table named **`datacenter-tasks`** with a primary key called **`taskId`** (String).
- Use **`PAY_PER_REQUEST`** (on-demand) billing mode.
- Insert the following task items into the table using the `aws_dynamodb_table_item` resource:
  - **Task 1**: `taskId: 1`, `description: Learn DynamoDB`, `status: completed`
  - **Task 2**: `taskId: 2`, `description: Build To-Do App`, `status: in-progress`
- Verify that Task 1 has status `completed` and Task 2 has status `in-progress`.
- Use the **`main.tf`** file (do not create a separate `.tf` file) to provision the DynamoDB table and insert the tasks.
- Create a **`variables.tf`** file with:
  - **`KKE_TABLE_NAME`**: Name of the DynamoDB table.
- Use the **`terraform.tfvars`** file to supply the table name.
- Use the **`outputs.tf`** file to export:
  - **`kke_dynamodb_table_name`**: Name of the DynamoDB table created.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Declare `KKE_TABLE_NAME` in `variables.tf`, assign its value in `terraform.tfvars`, configure `aws_dynamodb_table` and two `aws_dynamodb_table_item` resources in `main.tf`, and export `kke_dynamodb_table_name` in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`variables.tf`**:
  - `KKE_TABLE_NAME` (string): Variable storing the DynamoDB table name.
- **`terraform.tfvars`**:
  - Sets `KKE_TABLE_NAME = "datacenter-tasks"`.
- **`main.tf`**:
  - `aws_dynamodb_table.datacenter_tasks`: Provisions table `datacenter-tasks` with partition key `taskId` (`type = "S"`) and `billing_mode = "PAY_PER_REQUEST"`.
  - `aws_dynamodb_table_item.task_1`: Inserts Task 1 (`taskId = "1"`, `description = "Learn DynamoDB"`, `status = "completed"`).
  - `aws_dynamodb_table_item.task_2`: Inserts Task 2 (`taskId = "2"`, `description = "Build To-Do App"`, `status = "in-progress"`).
- **`outputs.tf`**:
  - `kke_dynamodb_table_name`: Exposes `aws_dynamodb_table.datacenter_tasks.name`.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Define Variables in `variables.tf`:**

   Declare the DynamoDB table name variable:

   ```hcl
   variable "KKE_TABLE_NAME" {
     type        = string
     description = "Name of the DynamoDB table"
   }
   ```

3. **Assign Variable Values in `terraform.tfvars`:**

   Assign the required table name:

   ```hcl
   KKE_TABLE_NAME = "datacenter-tasks"
   ```

4. **Configure DynamoDB Table and Items in `main.tf`:**

   Define the DynamoDB table and insert the task items using JSON-encoded attributes:

   ```hcl
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
   ```

5. **Define Outputs in `outputs.tf`:**

   Configure outputs to export the table name:

   ```hcl
   output "kke_dynamodb_table_name" {
     value       = aws_dynamodb_table.datacenter_tasks.name
     description = "Name of the DynamoDB table created"
   }
   ```

6. **Initialize Terraform:**

   Initialize the working directory to download the AWS provider plugins:

   ```bash
   terraform init
   ```

7. **Validate Configuration & Review Execution Plan:**

   Validate syntax and inspect planned actions:

   ```bash
   terraform validate
   terraform plan
   ```

8. **Apply the Configuration:**

   Provision the DynamoDB table and insert both task items:

   ```bash
   terraform apply -auto-approve
   ```

9. **Verify Outputs & Resources:**

   Check the Terraform output values:

   ```bash
   terraform output
   ```

   Verify the DynamoDB table details via AWS CLI:

   ```bash
   aws dynamodb describe-table \
     --table-name datacenter-tasks \
     --query "Table.[TableName,TableStatus,ItemCount,KeySchema]" \
     --output json
   ```

   Verify Task 1 status (`completed`):

   ```bash
   aws dynamodb get-item \
     --table-name datacenter-tasks \
     --key '{"taskId": {"S": "1"}}'
   ```

   Verify Task 2 status (`in-progress`):

   ```bash
   aws dynamodb get-item \
     --table-name datacenter-tasks \
     --key '{"taskId": {"S": "2"}}'
   ```

   Scan the entire table to confirm both items:

   ```bash
   aws dynamodb scan \
     --table-name datacenter-tasks \
     --query "Items[*].[taskId.S,description.S,status.S]" \
     --output table
   ```
