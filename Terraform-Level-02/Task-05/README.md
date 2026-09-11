# Provision EC2 Instance with Elastic IP (EIP) Using Terraform

## 📌 Task Description

The **Nautilus DevOps Team** has received a new request from the Development Team to set up a new EC2 instance. This instance will be used to host a new application that requires a stable IP address. To ensure that the instance has a consistent public IP, an Elastic IP address needs to be associated with it. This setup will help the Development Team to have a reliable and consistent access point for their application.

**Requirements:**

- Create an EC2 instance named **`nautilus-ec2`** using any Linux AMI like Ubuntu.
- Instance type must be **`t2.micro`**.
- Associate an Elastic IP address named **`nautilus-eip`** with this instance.
- Use the **`main.tf`** file (do not create a separate `.tf` file) to provision the EC2-Instance and Elastic IP.
- Use the **`outputs.tf`** file and output:
  - The instance name using variable **`KKE_instance_name`**.
  - The Elastic IP using variable **`KKE_eip`**.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Configure `main.tf` to fetch an Ubuntu AMI, create the EC2 instance, provision and associate an Elastic IP (EIP), and output the instance name and public Elastic IP in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`main.tf`**:
  - `data.aws_ami.ubuntu`: Queries the latest Ubuntu AMI from Canonical (`099720109477`).
  - `aws_instance.nautilus_ec2`: Provisions a `t2.micro` EC2 instance tagged with `Name = "nautilus-ec2"`.
  - `aws_eip.nautilus_eip`: Allocates an Elastic IP in the VPC domain (`domain = "vpc"`), associates it with `aws_instance.nautilus_ec2.id`, and tags it with `Name = "nautilus-eip"`.
- **`outputs.tf`**:
  - `KKE_instance_name`: Exports the EC2 instance tag name (`aws_instance.nautilus_ec2.tags["Name"]`).
  - `KKE_eip`: Exports the allocated Elastic IP address (`aws_eip.nautilus_eip.public_ip`).

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Configure Provider, EC2 Instance, and Elastic IP in `main.tf`:**

   Define the Ubuntu AMI data source, the EC2 instance, and the Elastic IP resource associated with the instance:

   ```hcl
   data "aws_ami" "ubuntu" {
     most_recent = true
     owners      = ["099720109477"] # Canonical

     filter {
       name   = "name"
       values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
     }

     filter {
       name   = "virtualization-type"
       values = ["hvm"]
     }
   }

   resource "aws_instance" "nautilus_ec2" {
     ami           = data.aws_ami.ubuntu.id
     instance_type = "t2.micro"

     tags = {
       Name = "nautilus-ec2"
     }
   }

   resource "aws_eip" "nautilus_eip" {
     instance = aws_instance.nautilus_ec2.id
     domain   = "vpc"

     tags = {
       Name = "nautilus-eip"
     }
   }
   ```

3. **Define Outputs in `outputs.tf`:**

   Configure the outputs to display the instance name and Elastic IP:

   ```hcl
   output "KKE_instance_name" {
     value       = aws_instance.nautilus_ec2.tags["Name"]
     description = "The name of the EC2 instance"
   }

   output "KKE_eip" {
     value       = aws_eip.nautilus_eip.public_ip
     description = "The public Elastic IP address assigned to the instance"
   }
   ```

4. **Initialize Terraform:**

   Initialize the working directory to download the AWS provider plugins:

   ```bash
   terraform init
   ```

5. **Validate Configuration & Review Execution Plan:**

   Validate the syntax and preview the resources to be created:

   ```bash
   terraform validate
   terraform plan
   ```

6. **Apply the Configuration:**

   Provision the EC2 instance and allocate/associate the Elastic IP:

   ```bash
   terraform apply -auto-approve
   ```

7. **Verify Outputs & Resources:**

   Check the Terraform output values:

   ```bash
   terraform output
   ```

   Verify the EC2 instance and its public IP association via AWS CLI:

   ```bash
   aws ec2 describe-instances \
     --filters "Name=tag:Name,Values=nautilus-ec2" "Name=instance-state-name,Values=pending,running" \
     --query "Reservations[].Instances[*].[InstanceId,InstanceType,PublicIpAddress,Tags[?Key=='Name'].Value | [0],State.Name]" \
     --output table
   ```

   Verify the Elastic IP allocation and association:

   ```bash
   aws ec2 describe-addresses \
     --filters "Name=tag:Name,Values=nautilus-eip" \
     --query "Addresses[*].[PublicIp,AllocationId,InstanceId,Tags[?Key=='Name'].Value | [0]]" \
     --output table
   ```
