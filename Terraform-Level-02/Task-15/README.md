# Provision DynamoDB Table and IAM Role with Read-Only Access Using Terraform

## 📌 Task Description

The **Nautilus DevOps team** has been tasked with creating a secure Amazon DynamoDB table and enforcing fine-grained access control using IAM. This setup ensures that only trusted AWS services (such as EC2 instances) assume a specific role with strictly scoped, read-only permissions (`GetItem`, `Scan`, `Query`) restricted to this DynamoDB table.

**Requirements:**

- Create a DynamoDB Table named **`datacenter-table`** with minimal configuration (e.g., partition key `id` of type string and on-demand capacity).
- Create an IAM Role named **`datacenter-role`** that allows trusted services (`ec2.amazonaws.com`) to assume the role.
- Create an IAM Policy named **`datacenter-readonly-policy`** granting read-only access (**`dynamodb:GetItem`**, **`dynamodb:Scan`**, **`dynamodb:Query`**) scoped specifically to the ARN of the created DynamoDB table, and attach it to the role.
- Create the **`main.tf`** file (do not create a separate `.tf` file) to provision the DynamoDB table, IAM role, policy, and attachment.
- Create the **`variables.tf`** file with the following variables:
  - **`KKE_TABLE_NAME`**: Name of the DynamoDB table.
  - **`KKE_ROLE_NAME`**: Name of the IAM role.
  - **`KKE_POLICY_NAME`**: Name of the IAM policy.
- Use the **`terraform.tfvars`** file to assign the values for these variables.
- Create the **`outputs.tf`** file to export:
  - **`kke_dynamodb_table`**: Name of the DynamoDB table.
  - **`kke_iam_role_name`**: Name of the IAM role.
  - **`kke_iam_policy_name`**: Name of the IAM policy.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define variables in `variables.tf`, assign values in `terraform.tfvars`, configure the DynamoDB table and scoped read-only IAM resources in `main.tf`, and export their names in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`variables.tf`**:
  - `KKE_TABLE_NAME` (string): Stores the DynamoDB table name.
  - `KKE_ROLE_NAME` (string): Stores the IAM role name.
  - `KKE_POLICY_NAME` (string): Stores the IAM policy name.
- **`terraform.tfvars`**:
  - `KKE_TABLE_NAME  = "datacenter-table"`
  - `KKE_ROLE_NAME   = "datacenter-role"`
  - `KKE_POLICY_NAME = "datacenter-readonly-policy"`
- **`main.tf`**:
  - `aws_dynamodb_table.datacenter`: Provisions table `datacenter-table` with partition key `id` (`type = "S"`) and `billing_mode = "PAY_PER_REQUEST"`.
  - `aws_iam_role.datacenter_role`: Creates role `datacenter-role` with assume role policy for `ec2.amazonaws.com`.
  - `aws_iam_policy.datacenter_policy`: Creates policy `datacenter-readonly-policy` with read actions (`GetItem`, `Scan`, `Query`) restricted to `aws_dynamodb_table.datacenter.arn`.
  - `aws_iam_role_policy_attachment.datacenter_attach`: Attaches the read-only policy to `datacenter-role`.
- **`outputs.tf`**:
  - `kke_dynamodb_table`: Exposes `aws_dynamodb_table.datacenter.name`.
  - `kke_iam_role_name`: Exposes `aws_iam_role.datacenter_role.name`.
  - `kke_iam_policy_name`: Exposes `aws_iam_policy.datacenter_policy.name`.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Define Variables in `variables.tf`:**

   Declare variables for the table, role, and policy names:

   ```hcl
   variable "KKE_TABLE_NAME" {
     type        = string
     description = "Name of the DynamoDB table"
   }

   variable "KKE_ROLE_NAME" {
     type        = string
     description = "Name of the IAM role"
   }

   variable "KKE_POLICY_NAME" {
     type        = string
     description = "Name of the IAM policy"
   }
   ```

3. **Assign Variable Values in `terraform.tfvars`:**

   Specify the required values:

   ```hcl
   KKE_TABLE_NAME  = "datacenter-table"
   KKE_ROLE_NAME   = "datacenter-role"
   KKE_POLICY_NAME = "datacenter-readonly-policy"
   ```

4. **Configure DynamoDB Table and IAM Resources in `main.tf`:**

   Define the DynamoDB table with on-demand billing, the IAM role, and the scoped read-only policy:

   ```hcl
   resource "aws_dynamodb_table" "datacenter" {
     name         = var.KKE_TABLE_NAME
     billing_mode = "PAY_PER_REQUEST"
     hash_key     = "id"

     attribute {
       name = "id"
       type = "S"
     }
   }

   resource "aws_iam_role" "datacenter_role" {
     name = var.KKE_ROLE_NAME

     assume_role_policy = jsonencode({
       Version = "2012-10-17"
       Statement = [
         {
           Action = "sts:AssumeRole"
           Effect = "Allow"
           Principal = {
             Service = "ec2.amazonaws.com"
           }
         }
       ]
     })
   }

   resource "aws_iam_policy" "datacenter_policy" {
     name = var.KKE_POLICY_NAME

     policy = jsonencode({
       Version = "2012-10-17"
       Statement = [
         {
           Effect   = "Allow"
           Action   = [
             "dynamodb:GetItem",
             "dynamodb:Scan",
             "dynamodb:Query"
           ]
           Resource = aws_dynamodb_table.datacenter.arn
         }
       ]
     })
   }

   resource "aws_iam_role_policy_attachment" "datacenter_attach" {
     role       = aws_iam_role.datacenter_role.name
     policy_arn = aws_iam_policy.datacenter_policy.arn
   }
   ```

5. **Define Outputs in `outputs.tf`:**

   Export the resource names:

   ```hcl
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
   ```

6. **Initialize Terraform:**

   Initialize the working directory to download the AWS provider plugins:

   ```bash
   terraform init
   ```

7. **Validate Configuration & Review Execution Plan:**

   Validate syntax and inspect the execution plan:

   ```bash
   terraform validate
   terraform plan
   ```

8. **Apply the Configuration:**

   Provision the DynamoDB table and IAM resources:

   ```bash
   terraform apply -auto-approve
   ```

9. **Verify Outputs & Resources:**

   Check the Terraform output values:

   ```bash
   terraform output
   ```

   Verify the DynamoDB table via AWS CLI:

   ```bash
   aws dynamodb describe-table \
     --table-name datacenter-table \
     --query "Table.[TableName,TableStatus,BillingModeSummary.BillingMode,KeySchema]" \
     --output json
   ```

   Verify the IAM role:

   ```bash
   aws iam get-role --role-name datacenter-role
   ```

   Verify that the read-only policy is attached:

   ```bash
   aws iam list-attached-role-policies --role-name datacenter-role
   ```
