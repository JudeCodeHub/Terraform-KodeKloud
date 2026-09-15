# Configure S3 Bucket Versioning and Lifecycle Rules in Terraform

## 📌 Task Description

The **Nautilus DevOps team** is implementing lifecycle policies to manage object storage efficiently in AWS. They want to create an S3 bucket with a specific lifecycle rule that transitions objects to Infrequent Access (IA) storage after 30 days and permanently deletes them after 365 days.

**Requirements:**

- Create an S3 bucket named **`xfusion-lifecycle-745601953`**.
- Enable **S3 Versioning** on the bucket.
- Add a lifecycle rule named **`xfusion-lifecycle-rule`** with:
  - Transition to **`STANDARD_IA`** storage class after **30 days**.
  - Expiration (deletion) of objects after **365 days**.
- Use the **`main.tf`** file (do not create a separate `.tf` file) to provision the S3 bucket, versioning, and lifecycle configuration.
- Use the **`outputs.tf`** file with the variable name **`KKE_bucket_name`** to output the created bucket name.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Provision the S3 bucket, enable versioning, configure the lifecycle rule in `main.tf`, and export the bucket name via `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`main.tf`**:
  - `aws_s3_bucket.xfusion_bucket`: Provisions the S3 bucket named `xfusion-lifecycle-745601953`.
  - `aws_s3_bucket_versioning.versioning`: Enables versioning on the bucket (`status = "Enabled"`).
  - `aws_s3_bucket_lifecycle_configuration.lifecycle`: Configures lifecycle rule `xfusion-lifecycle-rule` with a 30-day transition to `STANDARD_IA` and 365-day expiration.
- **`outputs.tf`**:
  - `KKE_bucket_name`: Exposes `aws_s3_bucket.xfusion_bucket.id`.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Configure S3 Bucket, Versioning, and Lifecycle Rules in `main.tf`:**

   Define the S3 bucket resource, attach the versioning configuration, and set up the lifecycle rule:

   ```hcl
   resource "aws_s3_bucket" "xfusion_bucket" {
     bucket = "xfusion-lifecycle-745601953"
   }

   resource "aws_s3_bucket_versioning" "versioning" {
     bucket = aws_s3_bucket.xfusion_bucket.id
     versioning_configuration {
       status = "Enabled"
     }
   }

   resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
     bucket = aws_s3_bucket.xfusion_bucket.id

     rule {
       id     = "xfusion-lifecycle-rule"
       status = "Enabled"

       transition {
         days          = 30
         storage_class = "STANDARD_IA"
       }

       expiration {
         days = 365
       }
     }
   }
   ```

3. **Define Outputs in `outputs.tf`:**

   Export the created bucket name:

   ```hcl
   output "KKE_bucket_name" {
     value       = aws_s3_bucket.xfusion_bucket.id
     description = "The name of the created S3 bucket"
   }
   ```

4. **Initialize Terraform:**

   Initialize the working directory to download the AWS provider plugins:

   ```bash
   terraform init
   ```

5. **Validate Configuration & Review Execution Plan:**

   Validate configuration syntax and inspect planned actions:

   ```bash
   terraform validate
   terraform plan
   ```

6. **Apply the Configuration:**

   Provision the bucket, versioning, and lifecycle policy:

   ```bash
   terraform apply -auto-approve
   ```

7. **Verify Outputs & Resources:**

   Check the Terraform output values:

   ```bash
   terraform output
   ```

   Verify bucket versioning status via AWS CLI:

   ```bash
   aws s3api get-bucket-versioning --bucket xfusion-lifecycle-745601953
   ```

   _Expected Output:_

   ```json
   {
     "Status": "Enabled"
   }
   ```

   Verify bucket lifecycle configuration:

   ```bash
   aws s3api get-bucket-lifecycle-configuration --bucket xfusion-lifecycle-745601953
   ```

   _Expected Output:_

   ```json
   {
     "Rules": [
       {
         "Expiration": {
           "Days": 365
         },
         "ID": "xfusion-lifecycle-rule",
         "Status": "Enabled",
         "Transitions": [
           {
             "Days": 30,
             "StorageClass": "STANDARD_IA"
           }
         ]
       }
     ]
   }
   ```
