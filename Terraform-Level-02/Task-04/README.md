# Provision Multiple EC2 Instances with Count & Variables in Terraform

## 📌 Task Description

The **Nautilus DevOps team** wants to provision multiple EC2 instances in AWS using Terraform. Each instance should follow a consistent naming convention and be deployed using a modular and scalable setup.

**Requirements:**

- Create **3 EC2 instances** using the **`count`** meta-argument.
- Name each EC2 instance with the prefix **`nautilus-instance`** followed by an index starting from 1 (e.g., `nautilus-instance-1`, `nautilus-instance-2`, `nautilus-instance-3`).
- Instances must be **`t2.micro`**.
- The key pair used must be **`nautilus-key`**.
- Create **`main.tf`** to provision these instances.
- Define the following in **`variables.tf`**:
  - `KKE_INSTANCE_COUNT`: Number of instances (`3`).
  - `KKE_INSTANCE_TYPE`: Type of instance (`t2.micro`).
  - `KKE_KEY_NAME`: Name of the key pair (`nautilus-key`).
  - `KKE_INSTANCE_PREFIX`: Prefix for instance naming (`nautilus-instance`).
- Use a **`locals.tf`** file to define a local variable named **`AMI_ID`** that retrieves the latest Amazon Linux 2 AMI using a data source.
- Use **`terraform.tfvars`** to assign values to the variables.
- In **`outputs.tf`**, define:
  - `kke_instance_names`: Names of the instances created.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Configure variables in `variables.tf` and `terraform.tfvars`, query the AMI in `locals.tf`, provision 3 instances using `count` in `main.tf`, and export their names in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`variables.tf`**:
  - `KKE_INSTANCE_COUNT` (number): Number of instances to deploy (`3`).
  - `KKE_INSTANCE_TYPE` (string): EC2 instance type (`t2.micro`).
  - `KKE_KEY_NAME` (string): Key pair name (`nautilus-key`).
  - `KKE_INSTANCE_PREFIX` (string): Naming prefix (`nautilus-instance`).
- **`terraform.tfvars`**:
  - Assigns explicit values for count, type, key, and prefix.
- **`locals.tf`**:
  - `data.aws_ami.amazon_linux_2`: Dynamically queries the latest Amazon Linux 2 AMI.
  - `locals { AMI_ID = ... }`: Maps the AMI ID from the data source to the local variable `AMI_ID`.
- **`main.tf`**:
  - `aws_instance.nautilus`: Provisions instances using `count = var.KKE_INSTANCE_COUNT` and `ami = local.AMI_ID`, tagged sequentially with `${var.KKE_INSTANCE_PREFIX}-${count.index + 1}`.
- **`outputs.tf`**:
  - `kke_instance_names`: Uses a list comprehension `[for instance in aws_instance.nautilus : instance.tags["Name"]]` to return all instance names.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Define Variables in `variables.tf`:**
   Declare the variables for count, instance type, key name, and prefix:

   ```hcl
   variable "KKE_INSTANCE_COUNT" {
     type    = number
     default = 3
   }

   variable "KKE_INSTANCE_TYPE" {
     type    = string
     default = "t2.micro"
   }

   variable "KKE_KEY_NAME" {
     type    = string
     default = "nautilus-key"
   }

   variable "KKE_INSTANCE_PREFIX" {
     type    = string
     default = "nautilus-instance"
   }
   ```

3. **Assign Variable Values in `terraform.tfvars`:**
   Supply the required values in `terraform.tfvars`:

   ```hcl
   KKE_INSTANCE_COUNT  = 3
   KKE_INSTANCE_TYPE   = "t2.micro"
   KKE_KEY_NAME        = "nautilus-key"
   KKE_INSTANCE_PREFIX = "nautilus-instance"
   ```

4. **Define AMI Data Source and Locals in `locals.tf`:**
   Query the latest Amazon Linux 2 AMI and store its ID in the local variable `AMI_ID`:

   ```hcl
   data "aws_ami" "amazon_linux_2" {
     most_recent = true
     owners      = ["amazon"]

     filter {
       name   = "name"
       values = ["amzn2-ami-hvm-*-x86_64-gp2"]
     }
   }

   locals {
     AMI_ID = data.aws_ami.amazon_linux_2.id
   }
   ```

5. **Define Provider and EC2 Resources in `main.tf`:**
   Configure the AWS provider and provision the EC2 instances referencing `local.AMI_ID` and the variables:

   ```hcl
   provider "aws" {
     region = "us-east-1"
   }

   resource "aws_instance" "nautilus" {
     count         = var.KKE_INSTANCE_COUNT
     ami           = local.AMI_ID
     instance_type = var.KKE_INSTANCE_TYPE
     key_name      = var.KKE_KEY_NAME

     tags = {
       Name = "${var.KKE_INSTANCE_PREFIX}-${count.index + 1}"
     }
   }
   ```

6. **Define Outputs in `outputs.tf`:**
   Configure the output to list the names of all created instances:

   ```hcl
   output "kke_instance_names" {
     value       = [for instance in aws_instance.nautilus : instance.tags["Name"]]
     description = "Names of the created EC2 instances"
   }
   ```

7. **Initialize Terraform:**
   Initialize the Terraform working directory to download the necessary provider plugins:

   ```bash
   terraform init
   ```

8. **Review the Execution Plan:**
   Verify that 3 instances and the expected output list are planned:

   ```bash
   terraform plan
   ```

9. **Apply the Configuration:**
   Apply the configuration to provision the instances:

   ```bash
   terraform apply -auto-approve
   ```

10. **Verify Outputs & Resources:**
    Check the Terraform output:

    ```bash
    terraform output
    ```

    Verify the created EC2 instances via the AWS CLI:

    ```bash
    aws ec2 describe-instances \
      --filters "Name=tag:Name,Values=nautilus-instance-*" "Name=instance-state-name,Values=pending,running" \
      --query "Reservations[].Instances[*].[InstanceId,InstanceType,KeyName,Tags[?Key=='Name'].Value | [0],State.Name]" \
      --output table
    ```
