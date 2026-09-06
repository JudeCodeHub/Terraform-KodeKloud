# Copy File to S3 Bucket with Terraform

## 📌 Task Description

The **Nautilus DevOps team** is presently immersed in data migrations, transferring data from on-premise storage systems to AWS S3 buckets. They have recently received some data that they intend to copy to one of the S3 buckets.

**Requirements:**
- S3 bucket named **`nautilus-cp-30996`** already exists.
- Copy the file **`/tmp/nautilus.txt`** to S3 bucket **`nautilus-cp-30996`** using Terraform.
- The Terraform working directory is **`/home/bob/terraform`**.
- Update the **`main.tf`** file (do not create a separate .tf file) to accomplish this task.

👉 **Your task:** Copy the local file `/tmp/nautilus.txt` to the existing S3 bucket `nautilus-cp-30996` using Terraform by defining an `aws_s3_object` resource in `main.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Resources:**
- AWS S3 Bucket (`nautilus-cp-30996`) — pre-existing
- AWS S3 Object (`aws_s3_object`) — uploads `/tmp/nautilus.txt` to bucket `nautilus-cp-30996` with key `nautilus.txt`

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**
   ```bash
   cd /home/bob/terraform
   ```

2. **Update the Configuration File:**
   Update `main.tf` to reference the bucket and add the `aws_s3_object` resource:
   ```hcl
   resource "aws_s3_bucket" "my_bucket" {
     bucket = "nautilus-cp-30996"
     acl    = "private"

     tags = {
       Name = "nautilus-cp-30996"
     }
   }

   # Copy file to S3 bucket
   resource "aws_s3_object" "nautilus_file" {
     bucket = aws_s3_bucket.my_bucket.id
     key    = "nautilus.txt"
     source = "/tmp/nautilus.txt"
     etag   = filemd5("/tmp/nautilus.txt")
   }
   ```

3. **Initialize Terraform:**
   Initialize the Terraform working directory to download the required provider plugins:
   ```bash
   terraform init
   ```

4. **Import the Existing Bucket into Terraform State (if needed):**
   If the pre-existing S3 bucket is not already tracked in the Terraform state:
   ```bash
   terraform import aws_s3_bucket.my_bucket nautilus-cp-30996
   ```

5. **Review the Execution Plan:**
   Check the planned changes before applying them:
   ```bash
   terraform plan
   ```

6. **Apply the Configuration:**
   Apply the changes to upload the file to the S3 bucket:
   ```bash
   terraform apply -auto-approve
   ```

7. **Verify the File in the S3 Bucket:**
   Confirm that the file has been successfully uploaded to the S3 bucket:
   ```bash
   aws s3 ls s3://nautilus-cp-30996/
   ```
   Or check the object metadata:
   ```bash
   aws s3api head-object --bucket nautilus-cp-30996 --key nautilus.txt
   ```

