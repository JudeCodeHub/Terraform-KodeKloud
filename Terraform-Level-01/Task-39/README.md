# AWS IAM Role Creation with Variables in Terraform

## 📌 Task Description

The **Nautilus DevOps team** is automating IAM role creation using Terraform to streamline permissions management. As part of this task, they need to create an IAM role with specific requirements.

**Requirements:**
- Create an AWS IAM Role using Terraform.
- The IAM role name **`iamrole_jim`** should be stored in a variable named **`KKE_iamrole`**.
- Configure the role with an assume role policy allowing EC2 service (`ec2.amazonaws.com`) to assume the role.
- The configuration values should be stored in a **`variables.tf`** file.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define the input variable in `variables.tf` and provision the IAM role in `main.tf` referencing the variable for the role name and Name tag.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Resources & Variables:**
- **Variables (`variables.tf`):**
  - `KKE_iamrole`: String variable with a default value of `"iamrole_jim"` representing the IAM role name
- **Resources (`main.tf`):**
  - AWS IAM Role (`aws_iam_role.iam_role`): Configured with `name = var.KKE_iamrole`, an EC2 assume role policy (`sts:AssumeRole`), and tagged with `Name = var.KKE_iamrole`

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**
   ```bash
   cd /home/bob/terraform
   ```

2. **Define the Input Variable in `variables.tf`:**
   Declare the `KKE_iamrole` variable with a default value of `"iamrole_jim"`:
   ```hcl
   variable "KKE_iamrole" {
     type        = string
     description = "Name of the IAM Role"
     default     = "iamrole_jim"
   }
   ```

3. **Define the IAM Role Resource in `main.tf`:**
   Configure the `aws_iam_role` resource referencing `var.KKE_iamrole` for the name and Name tag, and defining the EC2 assume role policy:
   ```hcl
   resource "aws_iam_role" "iam_role" {
     name = var.KKE_iamrole

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

     tags = {
       Name = var.KKE_iamrole
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
   Apply the configuration to create the IAM role:
   ```bash
   terraform apply -auto-approve
   ```

7. **Verify the IAM Role:**
   Confirm that the IAM role exists with the expected name and configuration using the AWS CLI:
   ```bash
   aws iam get-role --role-name iamrole_jim
   ```

