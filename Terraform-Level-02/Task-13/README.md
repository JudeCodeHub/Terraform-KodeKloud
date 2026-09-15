# Provision and Attach IAM Role and Policy Using Terraform

## 📌 Task Description

The **Nautilus DevOps team** is setting up IAM-based access control for internal AWS resources. They need to create an IAM Role and an IAM Policy using Terraform and attach the policy to the role so that EC2 services can list EC2 instances.

**Requirements:**

- Create an IAM Role named **`xfusion-role`**.
- Create an IAM Policy named **`xfusion-policy`** that allows listing EC2 instances (`ec2:DescribeInstances`).
- Attach the policy to the role.
- Create the **`main.tf`** file (do not create a separate `.tf` file) to provision the IAM role, policy, and attachment.
- Use the **`variables.tf`** file with the following variables:
  - **`KKE_ROLE_NAME`**: Name of the role.
  - **`KKE_POLICY_NAME`**: Name of the policy.
- Use the **`terraform.tfvars`** file to input the role and policy names.
- Use the **`outputs.tf`** file to output:
  - **`kke_iam_role_name`**: Name of the role created.
  - **`kke_iam_policy_name`**: Name of the policy created.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define variables in `variables.tf`, assign values in `terraform.tfvars`, configure the role, policy, and attachment in `main.tf`, and export their names in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`variables.tf`**:
  - `KKE_ROLE_NAME` (string): Name of the IAM role.
  - `KKE_POLICY_NAME` (string): Name of the IAM policy.
- **`terraform.tfvars`**:
  - `KKE_ROLE_NAME   = "xfusion-role"`
  - `KKE_POLICY_NAME = "xfusion-policy"`
- **`main.tf`**:
  - `aws_iam_role.xfusion_role`: Provisions the IAM role with an assume role trust policy for `ec2.amazonaws.com`.
  - `aws_iam_policy.xfusion_policy`: Configures an IAM policy allowing `ec2:DescribeInstances` on resource `*`.
  - `aws_iam_role_policy_attachment.attachment`: Attaches `aws_iam_policy.xfusion_policy` to `aws_iam_role.xfusion_role`.
- **`outputs.tf`**:
  - `kke_iam_role_name`: Exposes `aws_iam_role.xfusion_role.name`.
  - `kke_iam_policy_name`: Exposes `aws_iam_policy.xfusion_policy.name`.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Define Variables in `variables.tf`:**

   Declare the role and policy name variables:

   ```hcl
   variable "KKE_ROLE_NAME" {
     type        = string
     description = "The name of the IAM role"
   }

   variable "KKE_POLICY_NAME" {
     type        = string
     description = "The name of the IAM policy"
   }
   ```

3. **Assign Variable Values in `terraform.tfvars`:**

   Assign the required role and policy names:

   ```hcl
   KKE_ROLE_NAME   = "xfusion-role"
   KKE_POLICY_NAME = "xfusion-policy"
   ```

4. **Configure IAM Role, Policy, and Attachment in `main.tf`:**

   Define the IAM role with assume role policy, the IAM policy with DescribeInstances permission, and attach them together:

   ```hcl
   resource "aws_iam_role" "xfusion_role" {
     name = var.KKE_ROLE_NAME

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
   }

   resource "aws_iam_policy" "xfusion_policy" {
     name        = var.KKE_POLICY_NAME
     description = "Policy that allows listing EC2 instances"

     policy = jsonencode({
       Version = "2012-10-17"
       Statement = [
         {
           Action   = ["ec2:DescribeInstances"]
           Effect   = "Allow"
           Resource = "*"
         }
       ]
     })
   }

   resource "aws_iam_role_policy_attachment" "attachment" {
     role       = aws_iam_role.xfusion_role.name
     policy_arn = aws_iam_policy.xfusion_policy.arn
   }
   ```

5. **Define Outputs in `outputs.tf`:**

   Configure outputs to expose the role name and policy name:

   ```hcl
   output "kke_iam_role_name" {
     value       = aws_iam_role.xfusion_role.name
     description = "The name of the created IAM role"
   }

   output "kke_iam_policy_name" {
     value       = aws_iam_policy.xfusion_policy.name
     description = "The name of the created IAM policy"
   }
   ```

6. **Initialize Terraform:**

   Initialize the working directory to download the AWS provider plugins:

   ```bash
   terraform init
   ```

7. **Validate Configuration & Review Execution Plan:**

   Validate syntax and inspect the execution plan:

   ```bash
   terraform validate
   terraform plan
   ```

8. **Apply the Configuration:**

   Provision the IAM role, policy, and attachment:

   ```bash
   terraform apply -auto-approve
   ```

9. **Verify Outputs & Resources:**

   Check the Terraform output values:

   ```bash
   terraform output
   ```

   Verify the IAM role via AWS CLI:

   ```bash
   aws iam get-role --role-name xfusion-role
   ```

   Verify the IAM policy via AWS CLI:

   ```bash
   aws iam get-policy --policy-arn $(aws iam list-policies --query "Policies[?PolicyName=='xfusion-policy'].Arn | [0]" --output text)
   ```

   Verify that the policy is attached to the role:

   ```bash
   aws iam list-attached-role-policies --role-name xfusion-role
   ```

   _Expected Output:_

   ```json
   {
     "AttachedPolicies": [
       {
         "PolicyName": "xfusion-policy",
         "PolicyArn": "arn:aws:iam::...:policy/xfusion-policy"
       }
     ]
   }
   ```
