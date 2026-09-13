# Migrate Data Between S3 Buckets Using Terraform

## 📌 Task Description

As part of a data migration project, the team lead has tasked the **Nautilus DevOps Team** with migrating data from an existing Amazon S3 bucket to a new S3 bucket. The existing bucket contains crucial data that must be accurately transferred to the new bucket. The team is responsible for provisioning the new private S3 bucket using Terraform and ensuring that all data from the existing bucket is copied or synchronized to the new bucket completely and accurately, followed by thorough verification to ensure zero data loss.

**Requirements:**

- Create a new private S3 bucket named **`datacenter-sync-832943507`** and store this bucket name in a variable named **`KKE_BUCKET`**.
- Migrate all data from the existing **`datacenter-s3-832943507`** bucket to the new **`datacenter-sync-832943507`** bucket.
- Ensure that both buckets contain identical data after migration.
- Update the **`main.tf`** file (do not create a separate `.tf` file) to provision the new private S3 bucket and migrate the data.
- Use the **`variables.tf`** file with the variable:
  - **`KKE_BUCKET`**: The name for the new bucket created.
- Use the **`outputs.tf`** file with the outputs:
  - **`new_kke_bucket_name`**: The name of the new bucket created.
  - **`new_kke_bucket_acl`**: The ACL of the new bucket created.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define `KKE_BUCKET` in `variables.tf`, configure the new S3 bucket and ACL alongside a migration sync provisioner in `main.tf`, and export the bucket name and ACL in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud / LocalStack  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`variables.tf`**:
  - `KKE_BUCKET` (string): Stores the name of the new S3 bucket (`datacenter-sync-832943507`).
- **`main.tf`**:
  - `aws_s3_bucket.wordpress_bucket`: References the existing source bucket (`datacenter-s3-832943507`).
  - `aws_s3_bucket_acl.wordpress_bucket_acl`: Configures private ACL for the existing source bucket.
  - `aws_s3_bucket.kke_bucket`: Provisions the new destination bucket using `var.KKE_BUCKET`.
  - `aws_s3_bucket_acl.kke_bucket_acl`: Sets `acl = "private"` on the new bucket.
  - `null_resource.migrate_s3_data`: Runs a `local-exec` provisioner executing `aws s3 sync` between the source and target buckets after `aws_s3_bucket_acl.kke_bucket_acl` is created.
- **`outputs.tf`**:
  - `new_kke_bucket_name`: Exposes `aws_s3_bucket.kke_bucket.bucket`.
  - `new_kke_bucket_acl`: Exposes `aws_s3_bucket_acl.kke_bucket_acl.acl`.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Define Variables in `variables.tf`:**

   Declare the `KKE_BUCKET` variable with the required bucket name:

   ```hcl
   variable "KKE_BUCKET" {
     description = "Name of the new S3 bucket"
     type        = string
     default     = "datacenter-sync-832943507"
   }
   ```

3. **Configure S3 Resources and Migration in `main.tf`:**

   Define the source and destination S3 buckets, set their ACLs to private, and synchronize the data using `null_resource`:

   ```hcl
   resource "aws_s3_bucket" "wordpress_bucket" {
     bucket = "datacenter-s3-832943507"
   }

   resource "aws_s3_bucket_acl" "wordpress_bucket_acl" {
     bucket = aws_s3_bucket.wordpress_bucket.id
     acl    = "private"
   }

   resource "aws_s3_bucket" "kke_bucket" {
     bucket = var.KKE_BUCKET
   }

   resource "aws_s3_bucket_acl" "kke_bucket_acl" {
     bucket = aws_s3_bucket.kke_bucket.id
     acl    = "private"
   }

   resource "null_resource" "migrate_s3_data" {
     depends_on = [
       aws_s3_bucket_acl.kke_bucket_acl
     ]

     provisioner "local-exec" {
       command = "aws --endpoint-url=http://aws:4566 s3 sync s3://${aws_s3_bucket.wordpress_bucket.bucket} s3://${aws_s3_bucket.kke_bucket.bucket}"
     }
   }
   ```

4. **Define Outputs in `outputs.tf`:**

   Configure outputs to expose the new bucket name and ACL:

   ```hcl
   output "new_kke_bucket_name" {
     value = aws_s3_bucket.kke_bucket.bucket
   }

   output "new_kke_bucket_acl" {
     value = aws_s3_bucket_acl.kke_bucket_acl.acl
   }
   ```

5. **Initialize Terraform:**

   Initialize the working directory to download the required provider plugins:

   ```bash
   terraform init
   ```

6. **Validate Configuration & Review Execution Plan:**

   Validate the configuration syntax and review the planned execution:

   ```bash
   terraform validate
   terraform plan
   ```

7. **Apply the Configuration & Execute Migration:**

   Provision the new bucket and trigger the data migration:

   ```bash
   terraform apply -auto-approve
   ```

8. **Verify Outputs & Data Consistency:**

   Check the Terraform outputs:

   ```bash
   terraform output
   ```

   Verify and compare the contents of both buckets using the AWS CLI:

   ```bash
   # List objects in the source bucket
   aws --endpoint-url=http://aws:4566 s3 ls s3://datacenter-s3-832943507/ --recursive --human-readable --summarize

   # List objects in the new destination bucket
   aws --endpoint-url=http://aws:4566 s3 ls s3://datacenter-sync-832943507/ --recursive --human-readable --summarize
   ```

   Verify that the new bucket ACL is private:

   ```bash
   aws --endpoint-url=http://aws:4566 s3api get-bucket-acl --bucket datacenter-sync-832943507
   ```
