# AWS Security Group Creation with Variables in Terraform

## 📌 Task Description

The **Nautilus DevOps team** is enhancing infrastructure automation and needs to provision a Security Group using Terraform with specific configurations.

**Requirements:**

- Create an AWS Security Group using Terraform.
- The Security Group name **`datacenter-sg`** should be stored in a variable named **`KKE_sg`**.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define the input variable in `variables.tf` and provision the Security Group in `main.tf` referencing the variable for the Security Group name and Name tag.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Resources & Variables:**

- **Variables (`variables.tf`):**
  - `KKE_sg`: String variable with a default value of `"datacenter-sg"` representing the Security Group name
- **Resources (`main.tf`):**
  - AWS Security Group (`aws_security_group.datacenter_sg`): Name and Name tag set to `var.KKE_sg`, with description `"Security Group provisioned for datacenter"`

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Define the Input Variable in `variables.tf`:**
   Declare the `KKE_sg` variable with a default value of `"datacenter-sg"`:

   ```hcl
   variable "KKE_sg" {
     type        = string
     description = "Name of the AWS Security Group"
     default     = "datacenter-sg"
   }
   ```

3. **Define the Security Group Resource in `main.tf`:**
   Configure the `aws_security_group` resource referencing `var.KKE_sg` for the name and Name tag:

   ```hcl
   resource "aws_security_group" "datacenter_sg" {
     name        = var.KKE_sg
     description = "Security Group provisioned for datacenter"

     tags = {
       Name = var.KKE_sg
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
   Apply the configuration to provision the security group:

   ```bash
   terraform apply -auto-approve
   ```

7. **Verify the Security Group:**
   Confirm that the Security Group exists with the expected name and tags using the AWS CLI:
   ```bash
   aws ec2 describe-security-groups \
     --filters "Name=group-name,Values=datacenter-sg" \
     --query "SecurityGroups[*].[GroupId,GroupName,Description,Tags[?Key=='Name'].Value | [0]]" \
     --output table
   ```
