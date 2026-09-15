# Configure AWS Secrets Manager and IAM Role Access with Terraform

## 📌 Task Description

To enable secure retrieval of sensitive application credentials, the **Nautilus DevOps team** needs to configure access to a secret stored in AWS Secrets Manager using IAM roles and policies. The objective is to allow EC2 instances to retrieve database secrets securely using an IAM role with an attached inline policy scoped strictly to the secret ARN.

**Requirements:**

- Create a secret in AWS Secrets Manager named **`nautilus-app-secret`** with the secret string:
  ```json
  { "db_user": "admin", "db_pass": "supersecret" }
  ```
- Create an IAM role named **`nautilus-app-role`** with EC2 (`ec2.amazonaws.com`) as the trusted entity.
- Attach an **inline IAM policy** named **`nautilus-app-policy`** that grants permissions to retrieve the secret (`secretsmanager:GetSecretValue`, `secretsmanager:DescribeSecret`) from AWS Secrets Manager.
- Use the **`main.tf`** file (do not create a separate `.tf` file) to provision the Secret, Secret Version, IAM Role, and Inline Policy.
- Create the **`variables.tf`** file to define:
  - **`KKE_SECRET_NAME`**: The secret name.
  - **`KKE_SECRET_VALUE`**: The secret value string.
  - **`KKE_ROLE_NAME`**: The IAM role name.
  - **`KKE_POLICY_NAME`**: The IAM policy name.
- Use the **`terraform.tfvars`** file to supply the variable values.
- Create the **`outputs.tf`** file to export:
  - **`KKE_secret_name`**: The secret name.
  - **`KKE_role_name`**: The IAM role name.
  - **`KKE_policy_name`**: The IAM policy name.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define variables in `variables.tf`, assign values in `terraform.tfvars`, configure the secret and IAM role with inline policy in `main.tf`, and export their names in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`variables.tf`**:
  - `KKE_SECRET_NAME` (string): Name of the secret.
  - `KKE_SECRET_VALUE` (string): Value stored in the secret.
  - `KKE_ROLE_NAME` (string): Name of the IAM role.
  - `KKE_POLICY_NAME` (string): Name of the inline IAM policy.
- **`terraform.tfvars`**:
  - `KKE_SECRET_NAME  = "nautilus-app-secret"`
  - `KKE_SECRET_VALUE = "{\"db_user\":\"admin\",\"db_pass\":\"supersecret\"}"`
  - `KKE_ROLE_NAME    = "nautilus-app-role"`
  - `KKE_POLICY_NAME  = "nautilus-app-policy"`
- **`main.tf`**:
  - `aws_secretsmanager_secret.app_secret`: Provisions the secret container named `var.KKE_SECRET_NAME`.
  - `aws_secretsmanager_secret_version.app_secret_version`: Stores the secret string value `var.KKE_SECRET_VALUE`.
  - `aws_iam_role.app_role`: Creates the IAM role with trust policy for `ec2.amazonaws.com` and includes an `inline_policy` block named `var.KKE_POLICY_NAME` granting `secretsmanager:GetSecretValue` and `secretsmanager:DescribeSecret` on `aws_secretsmanager_secret.app_secret.arn`.
- **`outputs.tf`**:
  - `KKE_secret_name`: Exposes `aws_secretsmanager_secret.app_secret.name`.
  - `KKE_role_name`: Exposes `aws_iam_role.app_role.name`.
  - `KKE_policy_name`: Exposes `var.KKE_POLICY_NAME`.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Define Variables in `variables.tf`:**

   Declare the required variables:

   ```hcl
   variable "KKE_SECRET_NAME" {
     type        = string
     description = "The secret name"
   }

   variable "KKE_SECRET_VALUE" {
     type        = string
     description = "The secret value string"
   }

   variable "KKE_ROLE_NAME" {
     type        = string
     description = "The IAM role name"
   }

   variable "KKE_POLICY_NAME" {
     type        = string
     description = "The IAM policy name"
   }
   ```

3. **Assign Variable Values in `terraform.tfvars`:**

   Specify the secret string and resource names:

   ```hcl
   KKE_SECRET_NAME  = "nautilus-app-secret"
   KKE_SECRET_VALUE = "{\"db_user\":\"admin\",\"db_pass\":\"supersecret\"}"
   KKE_ROLE_NAME    = "nautilus-app-role"
   KKE_POLICY_NAME  = "nautilus-app-policy"
   ```

4. **Configure Secrets Manager and IAM Role in `main.tf`:**

   Define the secret, secret version, and IAM role with the inline policy:

   ```hcl
   resource "aws_secretsmanager_secret" "app_secret" {
     name = var.KKE_SECRET_NAME
   }

   resource "aws_secretsmanager_secret_version" "app_secret_version" {
     secret_id     = aws_secretsmanager_secret.app_secret.id
     secret_string = var.KKE_SECRET_VALUE
   }

   resource "aws_iam_role" "app_role" {
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

     inline_policy {
       name   = var.KKE_POLICY_NAME
       policy = jsonencode({
         Version = "2012-10-17"
         Statement = [
           {
             Effect   = "Allow"
             Action   = [
               "secretsmanager:GetSecretValue",
               "secretsmanager:DescribeSecret"
             ]
             Resource = aws_secretsmanager_secret.app_secret.arn
           }
         ]
       })
     }
   }
   ```

5. **Define Outputs in `outputs.tf`:**

   Configure outputs to expose the secret name, role name, and policy name:

   ```hcl
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
   ```

6. **Initialize Terraform:**

   Initialize the working directory to download the AWS provider plugins:

   ```bash
   terraform init
   ```

7. **Validate Configuration & Review Execution Plan:**

   Validate syntax and preview the plan:

   ```bash
   terraform validate
   terraform plan
   ```

8. **Apply the Configuration:**

   Provision the secret and IAM role with the inline policy:

   ```bash
   terraform apply -auto-approve
   ```

9. **Verify Outputs & Resources:**

   Check the Terraform output values:

   ```bash
   terraform output
   ```

   Verify the secret and its value via AWS CLI:

   ```bash
   aws secretsmanager get-secret-value --secret-id nautilus-app-secret
   ```

   Verify the IAM role:

   ```bash
   aws iam get-role --role-name nautilus-app-role
   ```

   Verify the inline policy attached to the role:

   ```bash
   aws iam get-role-policy --role-name nautilus-app-role --policy-name nautilus-app-policy
   ```
