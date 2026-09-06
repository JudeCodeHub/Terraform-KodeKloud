# AWS IAM Policy Creation with Variables in Terraform

## 📌 Task Description

The **Nautilus DevOps team** is automating IAM policy creation using Terraform to enhance security and access management. As part of this task, they need to create an IAM policy with specific requirements.

**Requirements:**

- Create an AWS IAM Policy using Terraform.
- The IAM policy name **`iampolicy_anita`** should be stored in a variable named **`KKE_iampolicy`**.
- The configuration values should be stored in a **`variables.tf`** file.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define the input variable in `variables.tf` and provision the IAM policy in `main.tf` referencing the variable for the policy name and Name tag.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Resources & Variables:**

- **Variables (`variables.tf`):**
  - `KKE_iampolicy`: String variable with a default value of `"iampolicy_anita"` representing the IAM policy name
- **Resources (`main.tf`):**
  - AWS IAM Policy (`aws_iam_policy.iam_policy`): Configured with `name = var.KKE_iampolicy`, policy granting `ec2:Describe*` permissions, description `"IAM policy for anita"`, and tagged with `Name = var.KKE_iampolicy`

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Define the Input Variable in `variables.tf`:**
   Declare the `KKE_iampolicy` variable with a default value of `"iampolicy_anita"`:

   ```hcl
   variable "KKE_iampolicy" {
     type        = string
     description = "Name of the IAM Policy"
     default     = "iampolicy_anita"
   }
   ```

3. **Define the IAM Policy Resource in `main.tf`:**
   Configure the `aws_iam_policy` resource referencing `var.KKE_iampolicy` for the name and Name tag, allowing EC2 describe actions:

   ```hcl
   resource "aws_iam_policy" "iam_policy" {
     name        = var.KKE_iampolicy
     description = "IAM policy for anita"

     policy = jsonencode({
       Version = "2012-10-17"
       Statement = [
         {
           Effect   = "Allow"
           Action   = ["ec2:Describe*"]
           Resource = "*"
         }
       ]
     })

     tags = {
       Name = var.KKE_iampolicy
     }
   }
   ```

4. **Initialize Terraform:**
   Initialize the Terraform working directory to download the necessary provider plugins:

   ```bash
   terraform init
   ```

5. **Review the Execution Plan:**
   Check the planned changes before applying them:

   ```bash
   terraform plan
   ```

6. **Apply the Configuration:**
   Apply the configuration to create the IAM policy:

   ```bash
   terraform apply -auto-approve
   ```

7. **Verify the IAM Policy:**
   Confirm that the IAM policy exists with the expected configuration using the AWS CLI:
   ```bash
   aws iam list-policies \
     --query "Policies[?PolicyName=='iampolicy_anita']" \
     --output table
   ```
   Or retrieve details directly using its ARN:
   ```bash
   aws iam get-policy --policy-arn $(aws iam list-policies --query "Policies[?PolicyName=='iampolicy_anita'].Arn" --output text)
   ```
