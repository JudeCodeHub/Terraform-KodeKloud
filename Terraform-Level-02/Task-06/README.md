# Create AMI from Existing EC2 Instance and Launch New EC2 Instance Using Terraform

## 📌 Task Description

The **Nautilus DevOps team** needs to create an Amazon Machine Image (AMI) from an existing EC2 instance for backup and scaling purposes. Once the custom AMI is created, they need to launch a new EC2 instance from this AMI to ensure seamless redundancy and consistency.

**Requirements:**

- An existing EC2 instance named **`xfusion-ec2`** is present in the configuration.
- Create an AMI named **`xfusion-ec2-ami`** from this instance using the `aws_ami_from_instance` resource.
- Additionally, launch a new EC2 instance named **`xfusion-ec2-new`** using the newly created AMI.
- Update the **`main.tf`** file (do not create a different or separate `.tf` file) to provision the AMI and launch the new EC2 instance.
- Create an **`outputs.tf`** file to output the following values:
  - **`KKE_ami_id`**: The ID of the AMI created.
  - **`KKE_new_instance_id`**: The ID of the newly created EC2 instance.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Update `main.tf` to add the `aws_ami_from_instance` resource pointing to `aws_instance.ec2.id` and launch `aws_instance.xfusion_new` using that AMI, then export both IDs in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`main.tf`**:
  - `aws_instance.ec2`: Existing EC2 instance tagged `xfusion-ec2`.
  - `aws_ami_from_instance.xfusion_ami`: Custom AMI resource named `xfusion-ec2-ami` referencing `source_instance_id = aws_instance.ec2.id`.
  - `aws_instance.xfusion_new`: New `t2.micro` instance deployed using `ami = aws_ami_from_instance.xfusion_ami.id` with the same security group attached, tagged `xfusion-ec2-new`.
- **`outputs.tf`**:
  - `KKE_ami_id`: Exposes `aws_ami_from_instance.xfusion_ami.id`.
  - `KKE_new_instance_id`: Exposes `aws_instance.xfusion_new.id`.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Update `main.tf`:**

   Ensure the file includes the original EC2 instance, the custom AMI resource, and the new EC2 instance resource:

   ```hcl
   resource "aws_instance" "ec2" {
     ami           = "ami-0c101f26f147fa7fd"
     instance_type = "t2.micro"
     vpc_security_group_ids = [
       "sg-37bfa1b6ef0fc3e96"
     ]
     tags = {
       Name = "xfusion-ec2"
     }
   }

   resource "aws_ami_from_instance" "xfusion_ami" {
     name               = "xfusion-ec2-ami"
     source_instance_id = aws_instance.ec2.id
   }

   resource "aws_instance" "xfusion_new" {
     ami           = aws_ami_from_instance.xfusion_ami.id
     instance_type = "t2.micro"
     vpc_security_group_ids = [
       "sg-37bfa1b6ef0fc3e96"
     ]
     tags = {
       Name = "xfusion-ec2-new"
     }
   }
   ```

3. **Define Outputs in `outputs.tf`:**

   Create `outputs.tf` to export the AMI ID and new EC2 instance ID:

   ```hcl
   output "KKE_ami_id" {
     value = aws_ami_from_instance.xfusion_ami.id
   }

   output "KKE_new_instance_id" {
     value = aws_instance.xfusion_new.id
   }
   ```

4. **Initialize Terraform:**

   Initialize the working directory to download the required provider plugins:

   ```bash
   terraform init
   ```

5. **Validate Configuration & Review Execution Plan:**

   Validate the configuration and inspect the execution plan:

   ```bash
   terraform validate
   terraform plan
   ```

6. **Apply the Configuration:**

   Apply the configuration to create the custom AMI and launch the new instance:

   ```bash
   terraform apply -auto-approve
   ```

7. **Verify Outputs & Resources:**

   Check the Terraform output values:

   ```bash
   terraform output
   ```

   Verify the custom AMI creation status via AWS CLI:

   ```bash
   aws ec2 describe-images \
     --owners self \
     --filters "Name=name,Values=xfusion-ec2-ami" \
     --query "Images[*].[ImageId,Name,State]" \
     --output table
   ```

   Verify both EC2 instances (original and new):

   ```bash
   aws ec2 describe-instances \
     --filters "Name=tag:Name,Values=xfusion-ec2,xfusion-ec2-new" "Name=instance-state-name,Values=pending,running" \
     --query "Reservations[].Instances[*].[InstanceId,ImageId,InstanceType,Tags[?Key=='Name'].Value | [0],State.Name]" \
     --output table
   ```
