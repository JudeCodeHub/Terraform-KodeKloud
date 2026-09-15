# Configure SNS Topic Access Using IAM Roles and Policies with Terraform

## 📌 Task Description

To enable secure inter-service communication, the **Nautilus DevOps team** needs to configure access to an Amazon SNS topic using IAM roles and policies. The objective is to allow EC2 instances to publish messages to the topic using proper permissions and role assumptions adhering to the principle of least privilege.

**Requirements:**

- Create an SNS topic named **`devops-sns-topic`**.
- Create an IAM role named **`devops-sns-role`** with EC2 (`ec2.amazonaws.com`) as the trusted entity.
- Attach an IAM policy named **`devops-sns-policy`** that grants permission to publish messages (**`sns:Publish`**) to the SNS topic.
- Use the **`main.tf`** file (do not create a separate `.tf` file) to provision the SNS topic, IAM role, policy, and attachment.
- Create the **`locals.tf`** file with the following local names:
  - **`KKE_SNS_TOPIC_NAME`**: Name of the SNS topic created (`devops-sns-topic`).
  - **`KKE_ROLE_NAME`**: Name of the role created (`devops-sns-role`).
  - **`KKE_POLICY_NAME`**: Name of the policy created (`devops-sns-policy`).
- Create the **`outputs.tf`** file to output:
  - **`kke_sns_topic_name`**: The name of the SNS topic.
  - **`kke_role_name`**: The name of the role.
  - **`kke_policy_name`**: The name of the policy.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define local values in `locals.tf`, configure `aws_sns_topic`, `aws_iam_role`, `aws_iam_policy`, and `aws_iam_role_policy_attachment` in `main.tf`, and export the resource names in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`locals.tf`**:
  - `KKE_SNS_TOPIC_NAME`: `"devops-sns-topic"`
  - `KKE_ROLE_NAME`: `"devops-sns-role"`
  - `KKE_POLICY_NAME`: `"devops-sns-policy"`
- **`main.tf`**:
  - `aws_sns_topic.devops_sns`: Creates SNS topic using `local.KKE_SNS_TOPIC_NAME`.
  - `aws_iam_role.devops_role`: Configures IAM role using `local.KKE_ROLE_NAME` with an assume role trust policy for `ec2.amazonaws.com`.
  - `aws_iam_policy.devops_policy`: Configures IAM policy using `local.KKE_POLICY_NAME` granting `sns:Publish` permission restricted to `aws_sns_topic.devops_sns.arn`.
  - `aws_iam_role_policy_attachment.devops_attach`: Attaches `devops-sns-policy` to `devops-sns-role`.
- **`outputs.tf`**:
  - `kke_sns_topic_name`: Exposes `aws_sns_topic.devops_sns.name`.
  - `kke_role_name`: Exposes `aws_iam_role.devops_role.name`.
  - `kke_policy_name`: Exposes `aws_iam_policy.devops_policy.name`.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Define Local Values in `locals.tf`:**

   Define the topic, role, and policy names as locals:

   ```hcl
   locals {
     KKE_SNS_TOPIC_NAME = "devops-sns-topic"
     KKE_ROLE_NAME      = "devops-sns-role"
     KKE_POLICY_NAME    = "devops-sns-policy"
   }
   ```

3. **Configure SNS Topic and IAM Resources in `main.tf`:**

   Define the SNS topic, IAM role with assume role policy, IAM policy with `sns:Publish` permissions, and attach the policy to the role:

   ```hcl
   resource "aws_sns_topic" "devops_sns" {
     name = local.KKE_SNS_TOPIC_NAME
   }

   resource "aws_iam_role" "devops_role" {
     name = local.KKE_ROLE_NAME

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

   resource "aws_iam_policy" "devops_policy" {
     name = local.KKE_POLICY_NAME

     policy = jsonencode({
       Version = "2012-10-17"
       Statement = [
         {
           Effect   = "Allow"
           Action   = "sns:Publish"
           Resource = aws_sns_topic.devops_sns.arn
         }
       ]
     })
   }

   resource "aws_iam_role_policy_attachment" "devops_attach" {
     role       = aws_iam_role.devops_role.name
     policy_arn = aws_iam_policy.devops_policy.arn
   }
   ```

4. **Define Outputs in `outputs.tf`:**

   Export the resource names:

   ```hcl
   output "kke_sns_topic_name" {
     value       = aws_sns_topic.devops_sns.name
     description = "The name of the SNS topic"
   }

   output "kke_role_name" {
     value       = aws_iam_role.devops_role.name
     description = "The name of the IAM role"
   }

   output "kke_policy_name" {
     value       = aws_iam_policy.devops_policy.name
     description = "The name of the IAM policy"
   }
   ```

5. **Initialize Terraform:**

   Initialize the working directory to download the AWS provider plugins:

   ```bash
   terraform init
   ```

6. **Validate Configuration & Review Execution Plan:**

   Validate syntax and inspect the planned resources:

   ```bash
   terraform validate
   terraform plan
   ```

7. **Apply the Configuration:**

   Provision the SNS topic, IAM role, policy, and attachment:

   ```bash
   terraform apply -auto-approve
   ```

8. **Verify Outputs & Resources:**

   Check the Terraform output values:

   ```bash
   terraform output
   ```

   Verify the SNS topic via AWS CLI:

   ```bash
   aws sns list-topics --query "Topics[?contains(TopicArn, 'devops-sns-topic')].TopicArn | [0]" --output text
   ```

   Verify the IAM role:

   ```bash
   aws iam get-role --role-name devops-sns-role
   ```

   Verify that the policy is attached to the role:

   ```bash
   aws iam list-attached-role-policies --role-name devops-sns-role
   ```
