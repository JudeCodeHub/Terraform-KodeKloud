# AWS VPC Creation with Variables in Terraform

## 📌 Task Description

The **Nautilus DevOps team** is automating VPC creation using Terraform to manage networking efficiently. As part of this task, they need to create a VPC with specific requirements.

**Requirements:**
- Create an AWS VPC using Terraform.
- The VPC name **`xfusion-vpc`** should be stored in a variable named **`KKE_vpc`**.
- The VPC should have a CIDR block of **`10.0.0.0/16`**.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define the input variable in `variables.tf` and provision the VPC in `main.tf` referencing the variable for the VPC name tag.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Resources & Variables:**
- **Variables (`variables.tf`):**
  - `KKE_vpc`: String variable with a default value of `"xfusion-vpc"` representing the VPC name tag
- **Resources (`main.tf`):**
  - AWS VPC (`aws_vpc.xfusion_vpc`): CIDR block `10.0.0.0/16`, tagged with `Name = var.KKE_vpc`

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**
   ```bash
   cd /home/bob/terraform
   ```

2. **Define the Input Variable in `variables.tf`:**
   Declare the `KKE_vpc` variable with a default value of `"xfusion-vpc"`:
   ```hcl
   variable "KKE_vpc" {
     type        = string
     description = "Name tag for the VPC"
     default     = "xfusion-vpc"
   }
   ```

3. **Define the VPC Resource in `main.tf`:**
   Configure the `aws_vpc` resource with CIDR block `10.0.0.0/16` and reference `var.KKE_vpc` for the Name tag:
   ```hcl
   resource "aws_vpc" "xfusion_vpc" {
     cidr_block = "10.0.0.0/16"

     tags = {
       Name = var.KKE_vpc
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
   Apply the configuration to provision the VPC:
   ```bash
   terraform apply -auto-approve
   ```

7. **Verify the VPC:**
   Confirm the VPC exists with the expected CIDR block and Name tag using the AWS CLI:
   ```bash
   aws ec2 describe-vpcs \
     --filters "Name=tag:Name,Values=xfusion-vpc" \
     --query "Vpcs[*].[VpcId,CidrBlock,Tags[?Key=='Name'].Value | [0]]" \
     --output table
   ```

