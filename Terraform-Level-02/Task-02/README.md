# Private VPC, Subnet, and Isolated EC2 Instance with Terraform

## 📌 Task Description

The **Nautilus DevOps team** is expanding their AWS infrastructure and requires the setup of a private Virtual Private Cloud (VPC) along with a subnet. This VPC and subnet configuration will ensure that resources deployed within them remain isolated from external networks and can only communicate within the VPC. Additionally, the team needs to provision an EC2 instance under the newly created private VPC. This instance should be accessible only from within the VPC, allowing for secure communication and resource management within the AWS environment.

**Requirements:**
- Create a VPC named **`nautilus-priv-vpc`** with the CIDR block **`10.0.0.0/16`**.
- Create a subnet named **`nautilus-priv-subnet`** inside the VPC with the CIDR block **`10.0.1.0/24`**, and the auto-assign public IP option must **not** be enabled (`map_public_ip_on_launch = false`).
- Create an EC2 instance named **`nautilus-priv-ec2`** inside the subnet with instance type **`t2.micro`**.
- Ensure the security group of the EC2 instance allows access **only from within the VPC's CIDR block**.
- Provision the VPC, subnet, and EC2 instance using **`main.tf`** (do not create a separate .tf file).
- In **`variables.tf`**, define the following variables:
  - `KKE_VPC_CIDR` for the VPC CIDR block.
  - `KKE_SUBNET_CIDR` for the subnet CIDR block.
- In **`outputs.tf`**, define the following outputs:
  - `KKE_vpc_name` for the name of the VPC.
  - `KKE_subnet_name` for the name of the subnet.
  - `KKE_ec2_private` for the name of the EC2 instance.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Configure the variables in `variables.tf`, provision the private VPC, subnet, security group, and EC2 instance in `main.tf`, and export the required resource names in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**
- **`variables.tf`**:
  - `KKE_VPC_CIDR` (string): CIDR block for the private VPC (`10.0.0.0/16`).
  - `KKE_SUBNET_CIDR` (string): CIDR block for the private subnet (`10.0.1.0/24`).
- **`main.tf`**:
  - `aws_vpc.nautilus_priv_vpc`: Private VPC using `var.KKE_VPC_CIDR`, DNS hostnames & support enabled, tagged `nautilus-priv-vpc`.
  - `aws_subnet.nautilus_priv_subnet`: Subnet associated with the VPC, using `var.KKE_SUBNET_CIDR`, `map_public_ip_on_launch = false`, tagged `nautilus-priv-subnet`.
  - `aws_security_group.nautilus_priv_sg`: Restricts ingress to traffic originating strictly from the VPC CIDR block (`aws_vpc.nautilus_priv_vpc.cidr_block`).
  - `data.aws_ami.amazon_linux`: Dynamically queries the latest Amazon Linux 2 AMI.
  - `aws_instance.nautilus_priv_ec2`: `t2.micro` instance deployed in `aws_subnet.nautilus_priv_subnet.id` with the private security group attached, tagged `nautilus-priv-ec2`.
- **`outputs.tf`**:
  - `KKE_vpc_name`: Exposes the VPC Name tag.
  - `KKE_subnet_name`: Exposes the Subnet Name tag.
  - `KKE_ec2_private`: Exposes the EC2 Instance Name tag.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**
   ```bash
   cd /home/bob/terraform
   ```

2. **Define Variables in `variables.tf`:**
   Declare the variables for VPC and Subnet CIDR blocks with default values:
   ```hcl
   variable "KKE_VPC_CIDR" {
     type        = string
     description = "CIDR block for the private VPC"
     default     = "10.0.0.0/16"
   }

   variable "KKE_SUBNET_CIDR" {
     type        = string
     description = "CIDR block for the private subnet"
     default     = "10.0.1.0/24"
   }
   ```

3. **Define Infrastructure in `main.tf`:**
   Configure the provider, private VPC, private subnet, security group, AMI data source, and EC2 instance:
   ```hcl
   provider "aws" {
     region = "us-east-1"
   }

   # Create the private VPC
   resource "aws_vpc" "nautilus_priv_vpc" {
     cidr_block           = var.KKE_VPC_CIDR
     enable_dns_hostnames = true
     enable_dns_support   = true

     tags = {
       Name = "nautilus-priv-vpc"
     }
   }

   # Create the private subnet (auto-assign public IP is false by default)
   resource "aws_subnet" "nautilus_priv_subnet" {
     vpc_id                  = aws_vpc.nautilus_priv_vpc.id
     cidr_block              = var.KKE_SUBNET_CIDR
     map_public_ip_on_launch = false

     tags = {
       Name = "nautilus-priv-subnet"
     }
   }

   # Create security group allowing access only from within the VPC CIDR
   resource "aws_security_group" "nautilus_priv_sg" {
     name        = "nautilus-priv-sg"
     description = "Allow inbound traffic only from within the VPC"
     vpc_id      = aws_vpc.nautilus_priv_vpc.id

     ingress {
       description = "Allow all traffic from VPC CIDR"
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       cidr_blocks = [aws_vpc.nautilus_priv_vpc.cidr_block]
     }

     egress {
       description = "Allow all outbound traffic"
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       cidr_blocks = ["0.0.0.0/0"]
     }

     tags = {
       Name = "nautilus-priv-sg"
     }
   }

   # Get latest Amazon Linux 2 AMI dynamically
   data "aws_ami" "amazon_linux" {
     most_recent = true
     owners      = ["amazon"]

     filter {
       name   = "name"
       values = ["amzn2-ami-hvm-*-x86_64-gp2"]
     }
   }

   # Create the EC2 instance inside the private subnet
   resource "aws_instance" "nautilus_priv_ec2" {
     ami                    = data.aws_ami.amazon_linux.id
     instance_type          = "t2.micro"
     subnet_id              = aws_subnet.nautilus_priv_subnet.id
     vpc_security_group_ids = [aws_security_group.nautilus_priv_sg.id]

     tags = {
       Name = "nautilus-priv-ec2"
     }
   }
   ```

4. **Define Outputs in `outputs.tf`:**
   Configure outputs to export the required names:
   ```hcl
   output "KKE_vpc_name" {
     value       = aws_vpc.nautilus_priv_vpc.tags["Name"]
     description = "Name of the VPC"
   }

   output "KKE_subnet_name" {
     value       = aws_subnet.nautilus_priv_subnet.tags["Name"]
     description = "Name of the subnet"
   }

   output "KKE_ec2_private" {
     value       = aws_instance.nautilus_priv_ec2.tags["Name"]
     description = "Name of the EC2 instance"
   }
   ```

5. **Initialize Terraform:**
   Initialize the Terraform working directory to download the AWS provider plugins:
   ```bash
   terraform init
   ```

6. **Review the Execution Plan:**
   Verify the planned infrastructure before applying:
   ```bash
   terraform plan
   ```

7. **Apply the Configuration:**
   Apply the configuration to provision the private network and EC2 instance:
   ```bash
   terraform apply -auto-approve
   ```

8. **Verify Outputs & Resources:**
   Check the Terraform output values:
   ```bash
   terraform output
   ```

   Verify the created VPC using the AWS CLI:
   ```bash
   aws ec2 describe-vpcs \
     --filters "Name=tag:Name,Values=nautilus-priv-vpc" \
     --query "Vpcs[*].[VpcId,CidrBlock,Tags[?Key=='Name'].Value | [0]]" \
     --output table
   ```

   Verify the Subnet and confirm `MapPublicIpOnLaunch` is `false`:
   ```bash
   aws ec2 describe-subnets \
     --filters "Name=tag:Name,Values=nautilus-priv-subnet" \
     --query "Subnets[*].[SubnetId,VpcId,CidrBlock,MapPublicIpOnLaunch,Tags[?Key=='Name'].Value | [0]]" \
     --output table
   ```

   Verify the Security Group rules:
   ```bash
   aws ec2 describe-security-groups \
     --filters "Name=group-name,Values=nautilus-priv-sg" \
     --query "SecurityGroups[*].[GroupId,GroupName,IpPermissions]" \
     --output json
   ```

   Verify the EC2 instance is running inside the private subnet without a public IP:
   ```bash
   aws ec2 describe-instances \
     --filters "Name=tag:Name,Values=nautilus-priv-ec2" \
     --query "Reservations[].Instances[*].[InstanceId,InstanceType,SubnetId,PrivateIpAddress,PublicIpAddress,State.Name]" \
     --output table
   ```

