# Provision CloudFormation Stack for DynamoDB Table Using Terraform

## 📌 Task Description

The **Nautilus DevOps team** wants to automate infrastructure provisioning by embedding and managing AWS CloudFormation stacks through Terraform. As part of this stack setup, they need to deploy a CloudFormation stack that provisions an Amazon DynamoDB table. Additionally, Terraform must ignore any out-of-band updates to stack parameters using a lifecycle rule.

**Requirements:**

- Create a CloudFormation stack named **`nautilus-dynamodb-stack`**.
- The stack must deploy a DynamoDB table named **`nautilus-cf-dynamodb-table`**.
- Use the **`main.tf`** file (do not create a separate `.tf` file) to provision the CloudFormation stack.
- Include a **`lifecycle`** block in `main.tf` to ignore changes to the **`parameters`** attribute (`ignore_changes = [parameters]`).
- Use the **`variables.tf`** file with the variable:
  - **`KKE_DYNAMODB_TABLE_NAME`**: DynamoDB table name.
- Use the **`terraform.tfvars`** file to assign the variable value.
- The **`locals.tf`** file defines:
  - **`cf_template_body`**: Local variable containing the CloudFormation JSON template.
- Create an **`outputs.tf`** file to output:
  - **`KKE_stack_name`**: CloudFormation stack name.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Declare `KKE_DYNAMODB_TABLE_NAME` in `variables.tf`, assign its value in `terraform.tfvars`, configure `aws_cloudformation_stack` with `ignore_changes = [parameters]` in `main.tf` using `local.cf_template_body`, and export `KKE_stack_name` in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`variables.tf`**:
  - `KKE_DYNAMODB_TABLE_NAME` (string): DynamoDB table name.
- **`terraform.tfvars`**:
  - Sets `KKE_DYNAMODB_TABLE_NAME = "nautilus-cf-dynamodb-table"`.
- **`locals.tf`**:
  - `cf_template_body` (string): CloudFormation JSON template defining the `AWS::DynamoDB::Table` resource with partition key `ID` (`S`) and provisioned throughput (5 RCU / 5 WCU).
- **`main.tf`**:
  - `aws_cloudformation_stack.nautilus_stack`: Provisions stack `nautilus-dynamodb-stack` using `local.cf_template_body` with `lifecycle { ignore_changes = [parameters] }`.
- **`outputs.tf`**:
  - `KKE_stack_name`: Exposes `aws_cloudformation_stack.nautilus_stack.name`.

**Working Directory:** `/home/bob/terraform`

---

## 💡 Background: `ignore_changes` on CloudFormation Parameters

When managing `aws_cloudformation_stack` resources with Terraform:

- CloudFormation stacks often process default parameters or have parameters updated externally by AWS services or CI/CD pipelines.
- Adding `lifecycle { ignore_changes = [parameters] }` instructs Terraform to ignore any drift or discrepancies between local state and remote AWS state specifically on stack parameters, preventing unnecessary stack updates or replacements.

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Define Variables in `variables.tf`:**

   Declare the DynamoDB table name variable:

   ```hcl
   variable "KKE_DYNAMODB_TABLE_NAME" {
     type        = string
     description = "DynamoDB table name"
   }
   ```

3. **Assign Variable Values in `terraform.tfvars`:**

   Specify the table name:

   ```hcl
   KKE_DYNAMODB_TABLE_NAME = "nautilus-cf-dynamodb-table"
   ```

4. **Define CloudFormation Template in `locals.tf`:**

   Define the CloudFormation JSON template body in `locals.tf`:

   ```hcl
   locals {
     cf_template_body = <<JSON
   {
     "AWSTemplateFormatVersion": "2010-09-09",
     "Resources": {
       "MyDynamoDBTable": {
         "Type": "AWS::DynamoDB::Table",
         "Properties": {
           "TableName": "nautilus-cf-dynamodb-table",
           "AttributeDefinitions": [
             {
               "AttributeName": "ID",
               "AttributeType": "S"
             }
           ],
           "KeySchema": [
             {
               "AttributeName": "ID",
               "KeyType": "HASH"
             }
           ],
           "ProvisionedThroughput": {
             "ReadCapacityUnits": 5,
             "WriteCapacityUnits": 5
           }
         }
       }
     }
   }
   JSON
   }
   ```

5. **Configure CloudFormation Stack in `main.tf`:**

   Define the `aws_cloudformation_stack` resource referencing `local.cf_template_body` with the lifecycle rule:

   ```hcl
   resource "aws_cloudformation_stack" "nautilus_stack" {
     name          = "nautilus-dynamodb-stack"
     template_body = local.cf_template_body

     lifecycle {
       ignore_changes = [parameters]
     }
   }
   ```

6. **Define Outputs in `outputs.tf`:**

   Export the stack name:

   ```hcl
   output "KKE_stack_name" {
     value       = aws_cloudformation_stack.nautilus_stack.name
     description = "CloudFormation stack name"
   }
   ```

7. **Initialize Terraform:**

   Initialize the working directory to download the AWS provider plugins:

   ```bash
   terraform init
   ```

8. **Validate Configuration & Review Execution Plan:**

   Validate syntax and inspect the execution plan:

   ```bash
   terraform validate
   terraform plan
   ```

9. **Apply the Configuration:**

   Provision the CloudFormation stack:

   ```bash
   terraform apply -auto-approve
   ```

10. **Verify Outputs & Resources:**

    Check the Terraform output values:

    ```bash
    terraform output
    ```

    Verify the CloudFormation stack status via AWS CLI:

    ```bash
    aws cloudformation describe-stacks \
      --stack-name nautilus-dynamodb-stack \
      --query "Stacks[*].[StackName,StackStatus,CreationTime]" \
      --output table
    ```

    Verify the DynamoDB table created by the stack:

    ```bash
    aws dynamodb describe-table \
      --table-name nautilus-cf-dynamodb-table \
      --query "Table.[TableName,TableStatus,ItemCount,TableArn]" \
      --output json
    ```
