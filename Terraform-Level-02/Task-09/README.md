# Protect S3 Bucket from Accidental Deletion Using Terraform Lifecycle Rules

## 📌 Task Description

To ensure secure and accidental-deletion-proof storage, the **Nautilus DevOps Team** must configure an Amazon S3 bucket using Terraform with strict lifecycle protections. The goal is to provision a bucket that is dynamically named via variables and protected from being destroyed by mistake using Terraform's `prevent_destroy` lifecycle rule.

**Requirements:**

- Create an S3 bucket named **`datacenter-s3-521165080`**.
- Apply the **`prevent_destroy`** lifecycle rule to protect the bucket against accidental destruction.
- Create the **`main.tf`** file (do not create a separate `.tf` file) to provision the S3 bucket with the `prevent_destroy` lifecycle rule.
- Use the **`variables.tf`** file to define:
  - **`KKE_BUCKET_NAME`**: Name of the bucket.
- Use the **`terraform.tfvars`** file to assign the name of the bucket.
- Use the **`outputs.tf`** file to export:
  - **`s3_bucket_name`**: Name of the created bucket.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Declare `KKE_BUCKET_NAME` in `variables.tf`, assign its value in `terraform.tfvars`, configure `aws_s3_bucket` with `lifecycle { prevent_destroy = true }` in `main.tf`, and export `s3_bucket_name` in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`variables.tf`**:
  - `KKE_BUCKET_NAME` (string): Variable holding the S3 bucket name.
- **`terraform.tfvars`**:
  - Assigns `KKE_BUCKET_NAME = "datacenter-s3-521165080"`.
- **`main.tf`**:
  - `aws_s3_bucket.kke_bucket`: Provisions the S3 bucket using `var.KKE_BUCKET_NAME` and sets `lifecycle { prevent_destroy = true }`.
- **`outputs.tf`**:
  - `s3_bucket_name`: Exposes `aws_s3_bucket.kke_bucket.bucket`.

**Working Directory:** `/home/bob/terraform`

---

## 💡 Background: `prevent_destroy` Lifecycle Meta-Argument

The **`prevent_destroy`** meta-argument is a safeguard provided by Terraform to prevent accidental deletion of critical infrastructure:

- When set to `true`, Terraform will reject any execution plan that would destroy the resource (e.g., via `terraform destroy` or during a replacement caused by modifying arguments that force recreation).
- This provides protection in production environments against inadvertent data loss.

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Define Variables in `variables.tf`:**

   Declare the bucket name variable:

   ```hcl
   variable "KKE_BUCKET_NAME" {
     description = "Name of the S3 bucket"
     type        = string
   }
   ```

3. **Assign Variable Values in `terraform.tfvars`:**

   Specify the bucket name value:

   ```hcl
   KKE_BUCKET_NAME = "datacenter-s3-521165080"
   ```

4. **Configure S3 Bucket with Lifecycle Protection in `main.tf`:**

   Define the S3 bucket resource with the `prevent_destroy` lifecycle rule:

   ```hcl
   resource "aws_s3_bucket" "kke_bucket" {
     bucket = var.KKE_BUCKET_NAME

     lifecycle {
       prevent_destroy = true
     }
   }
   ```

5. **Define Outputs in `outputs.tf`:**

   Export the bucket name output:

   ```hcl
   output "s3_bucket_name" {
     description = "Name of the created S3 bucket"
     value       = aws_s3_bucket.kke_bucket.bucket
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

   Provision the protected S3 bucket:

   ```bash
   terraform apply -auto-approve
   ```

9. **Verify Outputs & Resources:**

   Check the Terraform output values:

   ```bash
   terraform output
   ```

   Verify the S3 bucket via AWS CLI:

   ```bash
   aws s3 ls | grep datacenter-s3-521165080
   ```

   Confirm bucket status using `head-bucket`:

   ```bash
   aws s3api head-bucket --bucket datacenter-s3-521165080
   ```

10. **(Optional) Test Lifecycle Protection:**

    Attempting to destroy the resource will be blocked by Terraform:

    ```bash
    terraform destroy
    ```

    _Expected Output:_

    ```text
    Error: Instance cannot be destroyed

    Resource aws_s3_bucket.kke_bucket has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed.
    ```
