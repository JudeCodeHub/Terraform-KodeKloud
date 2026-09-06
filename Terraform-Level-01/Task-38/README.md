# AWS IAM User Creation with Variables in Terraform

## 📌 Task Description

The **Nautilus DevOps team** is automating IAM user creation using Terraform for better identity management.

**Requirements:**
- Create an AWS IAM User using Terraform.
- The IAM User name **`iamuser_siva`** should be stored in a variable named **`KKE_user`**.
- The configuration values should be stored in a **`variables.tf`** file.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define the input variable in `variables.tf` and provision the IAM user in `main.tf` referencing the variable for the user name and Name tag.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Resources & Variables:**
- **Variables (`variables.tf`):**
  - `KKE_user`: String variable with a default value of `"iamuser_siva"` representing the IAM user name
- **Resources (`main.tf`):**
  - AWS IAM User (`aws_iam_user.iam_user`): Provisioned with `name = var.KKE_user` and tagged with `Name = var.KKE_user`

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**
   ```bash
   cd /home/bob/terraform
   ```

2. **Define the Input Variable in `variables.tf`:**
   Declare the `KKE_user` variable with a default value of `"iamuser_siva"`:
   ```hcl
   variable "KKE_user" {
     type        = string
     description = "Name for the IAM User"
     default     = "iamuser_siva"
   }
   ```

3. **Define the IAM User Resource in `main.tf`:**
   Configure the `aws_iam_user` resource referencing `var.KKE_user` for the name and Name tag:
   ```hcl
   resource "aws_iam_user" "iam_user" {
     name = var.KKE_user

     tags = {
       Name = var.KKE_user
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
   Apply the configuration to create the IAM user:
   ```bash
   terraform apply -auto-approve
   ```

7. **Verify the IAM User:**
   Confirm that the IAM user exists with the expected name using the AWS CLI:
   ```bash
   aws iam get-user --user-name iamuser_siva
   ```

