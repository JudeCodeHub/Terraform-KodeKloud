# Attach IAM Role to EC2 Instance for Secure S3 Access Using Terraform

## 📌 Task Description

The **Nautilus DevOps team** wants to set up EC2 instances that securely upload application logs to Amazon S3 using IAM roles, adhering to the principle of least privilege without embedding hardcoded AWS credentials on the instance.

**Requirements:**

- Create an S3 bucket named **`nautilus-logs-53650547`**.
- Create an IAM role named **`nautilus-role`** with trust policy allowing EC2 service (`ec2.amazonaws.com`) to assume the role.
- Create an IAM policy named **`nautilus-access-policy`** granting **`s3:PutObject`** permissions on the bucket (`arn:aws:s3:::nautilus-logs-53650547/*`).
- Attach the IAM policy to the IAM role.
- Create an IAM instance profile and attach the role to an EC2 instance named **`nautilus-ec2`** (`t2.micro` using Amazon Linux 2 AMI).
- Use **`main.tf`** (do not create a separate `.tf` file for provisioning) to provision the S3 bucket, IAM role, policy, attachment, instance profile, and EC2 instance.
- Use **`variables.tf`** to declare the following variables:
  - **`KKE_BUCKET_NAME`**: Name of the bucket.
  - **`KKE_POLICY_NAME`**: Name of the policy.
  - **`KKE_ROLE_NAME`**: Name of the role.
- Use **`terraform.tfvars`** to assign values to these variables.
- Create a **`data.tf`** file to fetch the latest Amazon Linux 2 AMI.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define variables in `variables.tf`, assign values in `terraform.tfvars`, query the AMI in `data.tf`, configure the complete IAM and EC2-to-S3 infrastructure in `main.tf`, and apply the configuration.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`variables.tf`**:
  - `KKE_BUCKET_NAME` (string): S3 bucket name.
  - `KKE_POLICY_NAME` (string): IAM policy name.
  - `KKE_ROLE_NAME` (string): IAM role name.
- **`terraform.tfvars`**:
  - `KKE_BUCKET_NAME = "nautilus-logs-53650547"`
  - `KKE_POLICY_NAME = "nautilus-access-policy"`
  - `KKE_ROLE_NAME   = "nautilus-role"`
- **`data.tf`**:
  - `data.aws_ami.amazon_linux_2`: Queries the most recent Amazon Linux 2 HVM EBS AMI owned by `amazon`.
- **`main.tf`**:
  - `aws_s3_bucket.nautilus_logs`: Provisions the S3 bucket for logs.
  - `aws_iam_role.nautilus_role`: Configures assume role policy for `ec2.amazonaws.com`.
  - `aws_iam_policy.nautilus_access_policy`: Grants `s3:PutObject` action scoped to `${aws_s3_bucket.nautilus_logs.arn}/*`.
  - `aws_iam_role_policy_attachment.nautilus_policy_attachment`: Attaches policy to role.
  - `aws_iam_instance_profile.nautilus_profile`: Wraps the role into an instance profile.
  - `aws_instance.nautilus_ec2`: Deploys `t2.micro` EC2 instance with `iam_instance_profile` associated.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Define Variables in `variables.tf`:**

   Declare variables for the bucket, policy, and role names:

   ```hcl
   variable "KKE_BUCKET_NAME" {
     description = "Name of the S3 bucket"
     type        = string
   }

   variable "KKE_POLICY_NAME" {
     description = "Name of the IAM policy"
     type        = string
   }

   variable "KKE_ROLE_NAME" {
     description = "Name of the IAM role"
     type        = string
   }
   ```

3. **Assign Variable Values in `terraform.tfvars`:**

   Assign the values according to task requirements:

   ```hcl
   KKE_BUCKET_NAME = "nautilus-logs-53650547"
   KKE_POLICY_NAME = "nautilus-access-policy"
   KKE_ROLE_NAME   = "nautilus-role"
   ```

4. **Fetch Latest Amazon Linux 2 AMI in `data.tf`:**

   Query the latest Amazon Linux 2 AMI:

   ```hcl
   data "aws_ami" "amazon_linux_2" {
     most_recent = true

     owners = ["amazon"]

     filter {
       name   = "name"
       values = ["amzn2-ami-hvm-*-x86_64-gp2"]
     }

     filter {
       name   = "virtualization-type"
       values = ["hvm"]
     }

     filter {
       name   = "root-device-type"
       values = ["ebs"]
     }
   }
   ```

5. **Configure S3 Bucket, IAM Role, and EC2 Instance in `main.tf`:**

   Define the S3 bucket, IAM role with assume role policy, IAM policy with `PutObject` permission, policy attachment, instance profile, and EC2 instance:

   ```hcl
   resource "aws_s3_bucket" "nautilus_logs" {
     bucket = var.KKE_BUCKET_NAME
   }

   resource "aws_iam_role" "nautilus_role" {
     name = var.KKE_ROLE_NAME

     assume_role_policy = jsonencode({
       Version = "2012-10-17"
       Statement = [
         {
           Effect = "Allow"
           Principal = {
             Service = "ec2.amazonaws.com"
           }
           Action = "sts:AssumeRole"
         }
       ]
     })
   }

   resource "aws_iam_policy" "nautilus_access_policy" {
     name = var.KKE_POLICY_NAME

     policy = jsonencode({
       Version = "2012-10-17"
       Statement = [
         {
           Effect = "Allow"
           Action = [
             "s3:PutObject"
           ]
           Resource = "${aws_s3_bucket.nautilus_logs.arn}/*"
         }
       ]
     })
   }

   resource "aws_iam_role_policy_attachment" "nautilus_policy_attachment" {
     role       = aws_iam_role.nautilus_role.name
     policy_arn = aws_iam_policy.nautilus_access_policy.arn
   }

   resource "aws_iam_instance_profile" "nautilus_profile" {
     name = "nautilus-instance-profile"
     role = aws_iam_role.nautilus_role.name
   }

   resource "aws_instance" "nautilus_ec2" {
     ami           = data.aws_ami.amazon_linux_2.id
     instance_type = "t2.micro"

     iam_instance_profile = aws_iam_instance_profile.nautilus_profile.name

     tags = {
       Name = "nautilus-ec2"
     }
   }
   ```

6. **Initialize Terraform:**

   Initialize the working directory to download the AWS provider plugins:

   ```bash
   terraform init
   ```

7. **Validate Configuration & Review Execution Plan:**

   Check configuration syntax and inspect the planned resources:

   ```bash
   terraform validate
   terraform plan
   ```

8. **Apply the Configuration:**

   Provision all resources in AWS:

   ```bash
   terraform apply -auto-approve
   ```

9. **Verify Outputs & Resources:**

   Verify the S3 bucket:

   ```bash
   aws s3 ls | grep nautilus-logs-53650547
   ```

   Verify the IAM role and attached policies:

   ```bash
   aws iam get-role --role-name nautilus-role
   aws iam list-attached-role-policies --role-name nautilus-role
   ```

   Verify the EC2 instance and associated instance profile:

   ```bash
   aws ec2 describe-instances \
     --filters "Name=tag:Name,Values=nautilus-ec2" "Name=instance-state-name,Values=pending,running" \
     --query "Reservations[].Instances[*].[InstanceId,InstanceType,IamInstanceProfile.Arn,Tags[?Key=='Name'].Value | [0],State.Name]" \
     --output table
   ```
