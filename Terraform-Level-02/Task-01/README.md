# Explicit Resource Dependency (VPC & Subnet) with Terraform

## 📌 Task Description

To ensure proper resource provisioning order, the **DevOps team** wants to explicitly define the dependency between an AWS VPC and a Subnet. The objective is to create a VPC and then a Subnet that explicitly depends on it using Terraform's `depends_on` meta-argument.

**Requirements:**

- Create a VPC named **`devops-vpc`**.
- Create a Subnet named **`devops-subnet`**.
- Ensure the Subnet uses the **`depends_on`** argument to explicitly depend on the VPC resource.
- Use **`main.tf`** to provision the VPC and Subnet.
- In **`variables.tf`**, define the following variables:
  - `KKE_VPC_NAME`: for the VPC name.
  - `KKE_SUBNET_NAME`: for the Subnet name.
- Use **`terraform.tfvars`** to input the values for the VPC and Subnet names.
- In **`outputs.tf`**, define the following outputs:
  - `kke_vpc_name`: The name of the VPC.
  - `kke_subnet_name`: The name of the Subnet.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define variables in `variables.tf`, assign values in `terraform.tfvars`, configure the VPC and explicitly dependent Subnet in `main.tf`, and expose the resource names via `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`variables.tf`**:
  - `KKE_VPC_NAME` (string): Variable holding the VPC name tag.
  - `KKE_SUBNET_NAME` (string): Variable holding the Subnet name tag.
- **`terraform.tfvars`**:
  - Sets `KKE_VPC_NAME = "devops-vpc"` and `KKE_SUBNET_NAME = "devops-subnet"`.
- **`main.tf`**:
  - `aws_vpc.main`: CIDR block `10.0.0.0/16`, DNS hostnames/support enabled, tagged with `var.KKE_VPC_NAME`.
  - `aws_subnet.main`: CIDR block `10.0.1.0/24`, associated with `aws_vpc.main.id`, explicitly dependent via `depends_on = [aws_vpc.main]`, tagged with `var.KKE_SUBNET_NAME`.
- **`outputs.tf`**:
  - `kke_vpc_name`: Exposes the VPC Name tag.
  - `kke_subnet_name`: Exposes the Subnet Name tag.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Define Variables in `variables.tf`:**
   Declare the variables for the VPC and Subnet names:

   ```hcl
   variable "KKE_VPC_NAME" {
     type        = string
     description = "The name of the VPC"
   }

   variable "KKE_SUBNET_NAME" {
     type        = string
     description = "The name of the Subnet"
   }
   ```

3. **Assign Variable Values in `terraform.tfvars`:**
   Supply the required values for the variables:

   ```hcl
   KKE_VPC_NAME    = "devops-vpc"
   KKE_SUBNET_NAME = "devops-subnet"
   ```

4. **Define Resources in `main.tf`:**
   Configure the VPC and Subnet resources, ensuring `depends_on = [aws_vpc.main]` is explicitly specified on the subnet:

   ```hcl
   resource "aws_vpc" "main" {
     cidr_block           = "10.0.0.0/16"
     enable_dns_hostnames = true
     enable_dns_support   = true

     tags = {
       Name = var.KKE_VPC_NAME
     }
   }

   resource "aws_subnet" "main" {
     vpc_id     = aws_vpc.main.id
     cidr_block = "10.0.1.0/24"
     depends_on = [aws_vpc.main]

     tags = {
       Name = var.KKE_SUBNET_NAME
     }
   }
   ```

5. **Define Outputs in `outputs.tf`:**
   Configure outputs to expose the provisioned names:

   ```hcl
   output "kke_vpc_name" {
     value       = aws_vpc.main.tags["Name"]
     description = "The name of the VPC"
   }

   output "kke_subnet_name" {
     value       = aws_subnet.main.tags["Name"]
     description = "The name of the Subnet"
   }
   ```

6. **Initialize Terraform:**
   Initialize the Terraform working directory to download the necessary provider plugins:

   ```bash
   terraform init
   ```

7. **Review the Execution Plan:**
   Verify the planned additions and output values before applying:

   ```bash
   terraform plan
   ```

8. **Apply the Configuration:**
   Apply the configuration to provision the VPC and Subnet:

   ```bash
   terraform apply -auto-approve
   ```

9. **Verify Outputs & Resources:**
   Check the Terraform output values:

   ```bash
   terraform output
   ```

   Verify the created VPC using the AWS CLI:

   ```bash
   aws ec2 describe-vpcs \
     --filters "Name=tag:Name,Values=devops-vpc" \
     --query "Vpcs[*].[VpcId,CidrBlock,Tags[?Key=='Name'].Value | [0]]" \
     --output table
   ```

   Verify the created Subnet using the AWS CLI:

   ```bash
   aws ec2 describe-subnets \
     --filters "Name=tag:Name,Values=devops-subnet" \
     --query "Subnets[*].[SubnetId,VpcId,CidrBlock,Tags[?Key=='Name'].Value | [0]]" \
     --output table
   ```
