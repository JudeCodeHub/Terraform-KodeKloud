# AWS Elastic IP Allocation with Variables in Terraform

## 📌 Task Description

The **Nautilus DevOps team** is strategizing the migration of a portion of their infrastructure to the AWS cloud. As part of this phased migration approach, they need to allocate an Elastic IP address to support external access for specific workloads.

**Requirements:**

- Create an AWS Elastic IP using Terraform.
- The Elastic IP name **`datacenter-eip`** should be stored in a variable named **`KKE_eip`**.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define the input variable in `variables.tf` and allocate the Elastic IP in `main.tf` referencing the variable for the Name tag.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Resources & Variables:**

- **Variables (`variables.tf`):**
  - `KKE_eip`: String variable with a default value of `"datacenter-eip"` representing the Elastic IP name tag
- **Resources (`main.tf`):**
  - AWS Elastic IP (`aws_eip.datacenter_eip`): Allocated with `domain = "vpc"`, tagged with `Name = var.KKE_eip`

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Define the Input Variable in `variables.tf`:**
   Declare the `KKE_eip` variable with a default value of `"datacenter-eip"`:

   ```hcl
   variable "KKE_eip" {
     type        = string
     description = "Name tag for the Elastic IP"
     default     = "datacenter-eip"
   }
   ```

3. **Define the Elastic IP Resource in `main.tf`:**
   Configure the `aws_eip` resource with `domain = "vpc"` and reference `var.KKE_eip` for the Name tag:

   ```hcl
   resource "aws_eip" "datacenter_eip" {
     domain = "vpc"

     tags = {
       Name = var.KKE_eip
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
   Apply the configuration to allocate the Elastic IP:

   ```bash
   terraform apply -auto-approve
   ```

7. **Verify the Elastic IP:**
   Confirm that the Elastic IP exists with the expected Name tag using the AWS CLI:
   ```bash
   aws ec2 describe-addresses \
     --filters "Name=tag:Name,Values=datacenter-eip" \
     --query "Addresses[*].[AllocationId,PublicIp,Domain,Tags[?Key=='Name'].Value | [0]]" \
     --output table
   ```
